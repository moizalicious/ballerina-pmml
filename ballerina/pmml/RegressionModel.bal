package ballerina.pmml;

import ballerina.math;

function predictRegressionModel (xml pmml, xml data) (any) {
    // Handles all ML models of <RegressionModel> type.

    // Check if the argument is a valid PMML element.
    var predictable, unusablePMMLError = isPredictable(pmml);
    if (!predictable) {
        throw unusablePMMLError;
    }

    // Check if the data element is a valid one.
    var dataElementValid, invalidDataElementError = isDataElementValid(data);
    if (!dataElementValid) {
        throw invalidDataElementError;
    }

    any result;
    xml modelElement = getModelElement(pmml);
    string functionName = modelElement@["functionName"];
    if (functionName == "regression") {
        if ((lengthof getRegressionTableElements(getModelElement(pmml)) == 1)) {
            result = predictLinearRegression(pmml, data);
        } else if ((lengthof getRegressionTableElements(getModelElement(pmml)) == 2)) {
            result = predictLogisticRegression(pmml, data);
        } else {
            throw generateError("more than 2 regression table elements found, use classification instead");
        }
    } else if (functionName == "classification") {
        result = predictClassification(pmml, data);
    } else {
        throw generateError("no valid 'functionName' attribute found");
    }

    return result;
}

function predictLinearRegression (xml pmml, xml data) (any) {
    // Executes linear regression in the <PMML> element.
    xml regressionTable = getRegressionTableElements(getModelElement(pmml));
    float output = getDependentValue(regressionTable, data);

    string targetName;
    xml miningFields = getMiningFieldElements(
                       getMiningSchemaElement(
                       getModelElement(pmml)
                       )
                       );
    int i = 0;
    while (i < lengthof miningFields) {
        xml miningField = miningFields[i];
        if (miningField@["usageType"] == "target") {
            targetName = miningField@["name"];
        }
        i = i + 1;
    }

    if (targetName == "") {
        throw generateError("no target/predicted field provided in the PMML file");
    }

    xml dataFields = getDataFieldElements(getDataDictionaryElement(pmml));
    i = 0;
    while (i < lengthof dataFields) {
        xml dataField = dataFields[i];
        if (dataField@["name"] == targetName) {
            if (dataField@["dataType"] == "integer") {
                return <int>output;
            } else if (dataField@["dataType"] != "double") {
                throw generateError("invalid data type entered for " + targetName);
            }
        }
        i = i + 1;
    }
    return output;
}

function predictLogisticRegression (xml pmml, xml data) (float) {
    // Execute logistic regression in the <PMML> element.
    xml regressionTables = getRegressionTableElements(getModelElement(pmml));
    string normalizationMethod = getModelElement(pmml)@["normalizationMethod"];
    if (normalizationMethod == null) {
        throw generateError("the 'normalizationMethod' attribute is not defined");
    }

    if (!(lengthof regressionTables == 2)) {
        throw generateError("there should be 2 regression table elements for logistic regression");
    }

    float[] values = [];
    float sumOfValues = 0;
    float sumOfValuesExp = 0;
    int i = 0;
    while (i < lengthof regressionTables) {
        xml regressionTable = regressionTables[i];
        values[i] = getDependentValue(regressionTable, data);
        sumOfValues = sumOfValues + values[i];
        sumOfValuesExp = sumOfValuesExp + math:exp(values[i]);
        i = i + 1;
    }

    float[] probabilities = [];
    i = 0;
    while (i < lengthof values) {
        if (normalizationMethod == "softmax") {
            probabilities[i] = math:exp(values[i]) / sumOfValuesExp;
        } else if (normalizationMethod == "simplemax") {
            probabilities[i] = values[i] / sumOfValues;
        }
        i = i + 1;
    }

    float probability = 0;
    i = 0;
    while (i < lengthof regressionTables) {
        xml regressionTable = regressionTables[i];
        if (regressionTable@["targetCategory"] == "yes") {
            probability = probabilities[i];
            break;
        }

        i = i + 1;
    }

    return probability;
}

function predictClassification (xml pmml, xml data) (string) {
    // Execute classification in the <PMML> element.

    // Get the normalization method.
    string normalizationMethod = getModelElement(pmml)@["normalizationMethod"];
    if (normalizationMethod == null) {
        throw generateError("the 'normalizationMethod' is not defined");
    }

    // Get the values from the regression table
    xml regressionTables = getRegressionTableElements(getModelElement(pmml));
    float[] values = [];
    float sumOfValues = 0;
    float sumOfValuesExp = 0;
    int i = 0;
    while (i < lengthof regressionTables) {
        xml regressionTable = regressionTables[i];
        values[i] = getDependentValue(regressionTable, data);
        sumOfValues = sumOfValues + values[i];
        sumOfValuesExp = sumOfValuesExp + math:exp(values[i]);
        i = i + 1;
    }

    // Find the result category.
    float[] probabilities = [];
    i = 0;
    while (i < lengthof values) {
        if (normalizationMethod == "softmax") {
            probabilities[i] = math:exp(values[i]) / sumOfValuesExp;
        } else if (normalizationMethod == "simplemax") {
            probabilities[i] = values[i] / sumOfValues;
        } else {
            throw generateError(normalizationMethod + " is not a valid normaliation method");
        }
        i = i + 1;
    }

    // Find the maximum probability.
    float max = probabilities[0];
    i = 1;
    while (i < lengthof probabilities) {
        if (probabilities[i] > max) {
            max = probabilities[i];
        }
        i = i + 1;
    }

    // Get the target category.
    string targetCategory;
    i = 0;
    while (i < lengthof probabilities) {
        if (probabilities[i] == max) {
            xml regressionTable = regressionTables[i];
            targetCategory = regressionTable@["targetCategory"];
        }
        i = i + 1;
    }

    return targetCategory;
}

function getRegressionTableElements (xml modelElement) (xml) {
    // Gets the <RegressionTable> elements from the respective ML model element.
    xml regressionTableElement = modelElement.selectChildren("RegressionTable");
    if (regressionTableElement.isEmpty()) {
        throw generateError("no regression table element found");
    }

    return regressionTableElement;
}

function getDependentValue (xml regressionTable, xml data) (float) {
    // Calculates the dependent values using a single <RegressionTable>
    // element and the independent values provided by the user.

    var intercept, typeConversionError = <float>regressionTable@["intercept"];
    if (typeConversionError != null) {
        throw typeConversionError;
    }
    if (regressionTable.children().isEmpty()) {
        return intercept;
    }

    float output = intercept;
    int i = 0;
    xml predictors = regressionTable.strip().children().elements();
    while (i < lengthof predictors) {
        xml predictor = predictors[i];
        string elementName = predictor.getElementName();
        if (elementName.contains("NumericPredictor")) {
            string name = predictor@["name"];
            if (name == null) {
                throw generateError("the 'name' attribute is not defined");
            }
            var exponent, exponentConversionError = <int>predictor@["exponent"];
            if (exponentConversionError != null) {
                if (exponentConversionError.msg == "'null' cannot be converted to 'int'") {
                    exponent = 1;
                } else {
                    throw exponentConversionError;
                }
            }
            if (exponent == 0) {
                throw generateError("exponent cannot be 0");
            }
            var coefficient, coefficientConversionError = <float>predictor@["coefficient"];
            if (coefficientConversionError != null) {
                throw coefficientConversionError;
            }
            var independent = 0.0;
            TypeConversionError independentConversionError;
            if (hasChildElement(data, name)) {
                independent, independentConversionError = <float>data.selectChildren(name).getTextValue();
                if (independentConversionError != null) {
                    throw independentConversionError;
                }
            } else {
                throw generateError(name + " element was not found in the <data> element");
            }
            output = output + (coefficient * math:pow(independent, exponent));
        } else if (elementName.contains("CategoricalPredictor")) {
            string name = predictor@["name"];
            if (name == null) {
                throw generateError("the 'name' attribute is not defined");
            }
            string value = predictor@["value"];
            if (value == null) {
                throw generateError("the 'value' attribute is not defined");
            }
            var coefficient, coefficientConversionError = <float>predictor@["coefficient"];
            if (coefficientConversionError != null) {
                throw coefficientConversionError;
            }

            if (!hasChildElement(data, name)) {
                throw generateError(name + " element was not found in the data element");
            }
            string independent = data.selectChildren(name).getTextValue();

            if (independent == value) {
                output = output + coefficient;
            }
        } else if (elementName.contains("PredictorTerm")) {
            var coefficient, coefficientConversionError = <float>predictor@["coefficient"];
            if (coefficientConversionError != null) {
                throw coefficientConversionError;
            }
            xml fieldRefs = predictor.children().elements();
            float fieldRefTotalCoefficient = 1;

            int c = 0;
            while (c < lengthof fieldRefs) {
                xml fieldRef = fieldRefs[c];
                string field = fieldRef@["field"];
                if (field == null) {
                    throw generateError("the 'field' attribute is not defined");
                }

                if (!hasChildElement(data, field)) {
                    throw generateError(field + "element was not found in the <data> element");
                } else {
                    xml independentXML = data.selectChildren(field);
                    var independent, independentConversionError = <float>independentXML.getTextValue();
                    if (independentConversionError != null) {
                        throw generateError("categorical values in pmml <PredictorTerm> elements are currently not available");
                    }
                    fieldRefTotalCoefficient = fieldRefTotalCoefficient * independent;
                }
                c = c + 1;
            }
            output = output + (coefficient * fieldRefTotalCoefficient);
        } else {
            throw generateError("invaid element: " + predictor.getElementName());
        }
        i = i + 1;
    }

    return output;
}
