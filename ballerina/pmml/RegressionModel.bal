package ballerina.pmml;

import ballerina.math;

function executeRegressionModel (xml pmml, xml data) (any) {
    any result;
    // Check if the argument is a valid PMML element.
    if (!isValid(pmml)) {
        throw invalidPMMLElementError();
    }

    // Check if the data element is a valid one.
    checkDataElementValidity(data);

    xml modelElement = getModelElement(pmml);
    string functionName = modelElement@["functionName"];
    if (functionName == "regression") {
        if ((lengthof getRegressionTableElements(getModelElement(pmml)) == 1)) {
            result = executeLinearRegression(pmml, data);
        } else if ((lengthof getRegressionTableElements(getModelElement(pmml)) == 2)) {
            result = executeLogisticRegression(pmml, data);
        } else {
            throw generateError("more than 2 regression table elements found, use classification instead");
        }
    } else if (functionName == "classification") {
        result = executeClassification(pmml, data);
    } else {
        throw generateError("no valid 'functionName' attribute found");
    }
    return result;
}

function executeLinearRegression (xml pmml, xml data) (any) {
    xml regressionTable = getRegressionTableElements(getModelElement(pmml));
    float output = getYValue(regressionTable, data);

    string targetName;
    xml miningFields = getMiningFieldElements(getMiningSchemaElement(pmml));
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

function executeLogisticRegression (xml pmml, xml data) (float) {
    xml regressionTables = getRegressionTableElements(getModelElement(pmml));
    string normalizationMethod = getModelElement(pmml)@["normalizationMethod"];

    if (!(lengthof regressionTables == 2)) {
        throw generateError("there should be 2 regression table elements for logistic regression");
    }

    float[] values = [];
    float sumOfValues = 0;
    float sumOfValuesExp = 0;
    int i = 0;
    while (i < lengthof regressionTables) {
        xml regressionTable = regressionTables[i];
        values[i] = getYValue(regressionTable, data);
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

function executeClassification (xml pmml, xml data) (string) {
    // Get the normalization method.
    string normalizationMethod = getModelElement(pmml)@["normalizationMethod"];

    // Get the values from the regression table
    xml regressionTables = getRegressionTableElements(getModelElement(pmml));
    float[] values = [];
    float sumOfValues = 0;
    float sumOfValuesExp = 0;
    int i = 0;
    while (i < lengthof regressionTables) {
        xml regressionTable = regressionTables[i];
        values[i] = getYValue(regressionTable, data);
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
    xml regressionTableElement = modelElement.selectChildren("RegressionTable");
    if (regressionTableElement.isEmpty()) {
        throw generateError("no regression table element found");
    }
    return regressionTableElement;
}

function getYValue (xml regressionTable, xml data) (float) {
    var intercept, _ = <float>regressionTable@["intercept"];
    if (regressionTable.strip().children().isEmpty()) {
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
            var exponent, _ = <int>predictor@["exponent"];
            if (exponent == 0) {
                exponent = 1;
            }
            var coefficient, _ = <float>predictor@["coefficient"];
            var independent = 0.0;
            if (hasChildElement(data, name)) {
                independent, _ = <float>data.selectChildren(name).getTextValue();
            } else {
                throw generateError(name + " element was not found in the <data> element");
            }
            output = output + (coefficient * math:pow(independent, exponent));
        } else if (elementName.contains("CategoricalPredictor")) {
            string name = predictor@["name"];
            string value = predictor@["value"];
            var coefficient, _ = <float>predictor@["coefficient"];

            if (!hasChildElement(data, name)) {
                throw generateError(name + " element was not found in the data element");
            }
            string independent = data.selectChildren(name).getTextValue();

            if (independent == value) {
                output = output + coefficient;
            }
        } else if (elementName.contains("PredictorTerm")) {
            var coefficient, _ = <float>predictor@["coefficient"];
            xml fieldRefs = predictor.children().elements();
            float fieldRefTotalCoefficient = 1;

            int c = 0;
            while (c < lengthof fieldRefs) {
                xml fieldRef = fieldRefs[c];
                string field = fieldRef@["field"];

                if (!hasChildElement(data, field)) {
                    throw generateError(field + "element was not found in the <data> element");
                } else {
                    xml independentXML = data.selectChildren(field);
                    var independent, _ = <float>independentXML.getTextValue();
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
