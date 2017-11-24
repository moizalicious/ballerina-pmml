package ballerina.pmml;

import ballerina.log;
import ballerina.math;

function executeRegressionModel (xml pmml, xml data) (any) {
    // TODO add logistic regression.
    any result;
    // Check if the argument is a valid PMML element.
    if (!isValid(pmml)) {
        throw invalidPMMLElementError();
    }

    // TODO look for duplicate child elements.
    // Check whether the <data> element entered is valid.
    boolean isEmpty = data.isEmpty();
    boolean isSingleton = data.isSingleton();
    boolean isElement = (data.getItemType() == "element");
    if (!(!isEmpty && isSingleton && isElement)) {
        throw generateError("invalid data element entered");
    }

    xml modelElement = getModelElement(pmml);
    string functionName = modelElement@["functionName"];
    if (functionName == "regression") {
        if ((lengthof getRegressionTableElements(getModelElement(pmml)) == 1)) {
            result = executeLinearRegression(pmml, data);
        } else if ((lengthof getRegressionTableElements(getModelElement(pmml)) == 2)) {
            executeLogisticRegression(pmml, data); // TODO this should return a result.
        } else {
            throw generateError("more than 2 regression table elements found, use classification instead");
        }
    } else if (functionName == "classification") {
        result = executeClassification(pmml, data);// TODO this should return a result.
    } else {
        throw generateError("no valid 'functionName' attribute found");
    }
    return result;
}

function executeLinearRegression (xml pmml, xml data) (float) {
    // TODO handle errors.
    // TODO If output is an integer switch to integer.
    xml regressionTable = getRegressionTableElements(getModelElement(pmml));
    float output = getYValue(regressionTable, data);
    return output;
}

function calculateLinearRegressionOutput (json dataDictionary, json miningSchema, json regressionTable, json data) (float) {
    var output, _ = <float>regressionTable.intercept.toString();
    int i = 0;
    while (i < lengthof regressionTable.predictors) {
        if (regressionTable.predictors[i].predictorType.toString() == "numericPredictor") {
            string name = regressionTable.predictors[i].name.toString();
            var value, _ = <float>data[name].toString();
            var exponent, _ = <int>regressionTable.predictors[i].exponent.toString();
            var coefficient, _ = <float>regressionTable.predictors[i].coefficient.toString();
            output = output + (coefficient * math:pow(value, exponent));
        } else if (regressionTable.predictors[i].predictorType.toString() == "categoricalPredictor") {
            string name = regressionTable.predictors[i].name.toString();
            string regressionTableValue = regressionTable.predictors[i].value.toString();
            string dataValue = data[name].toString();
            int value = 0;
            if (dataValue == regressionTableValue) {
                value = 1;
            }
            var coefficient, _ = <float>regressionTable.predictors[i].coefficient.toString();
            output = output + (coefficient * value);
        }

        i = i + 1;
    }


    string targetFieldName = "";
    i = 0;
    while (i < lengthof miningSchema.miningFields) {
        if (miningSchema.miningFields[i].usageType.toString() == "target") {
            targetFieldName = miningSchema.miningFields[i].name.toString();
            break;
        }
        i = i + 1;
    }

    if (targetFieldName == "") {
        throw generateError("unable to find the target field");
    }

    i = 0;
    while (i < lengthof dataDictionary.dataFields) {
        if (dataDictionary.dataFields[i].name.toString() == targetFieldName) {
            if (dataDictionary.dataFields[i].dataType.toString() == "integer") {
                output = <int>output;
            }
        }

        i = i + 1;
    }
    log:printInfo("Output: " + output);
    return output;
}

function executeLogisticRegression (xml pmml, xml data) {
    // TODO complete.
}

function calculateLogisticRegressionOutput () {
    // TODO complete.
}

function executeClassification (xml pmml, xml data) (string) {
    // TODO handle errors.

    // Get the normalization method.
    string normalizationMethod = getModelElement(pmml)@["normalizationMethod"];

    // Get the values from the regression table
    xml regressionTables = getRegressionTableElements(getModelElement(pmml));
    float[] values = [];
    float sumOfValues = 0;
    int i = 0;
    while (i < lengthof regressionTables) {
        xml regressionTable = regressionTables[i];
        values[i] = getYValue(regressionTable, data);
        sumOfValues = sumOfValues + values[i];
        i = i + 1;
    }

    // TODO find the result category.
    float[] probabilities = [];
    i = 0;
    while (i < lengthof values) {
        if (normalizationMethod == "softmax") {
            probabilities[i] = math:exp(values[i]) / (math:exp(sumOfValues));
        } else if (normalizationMethod == "simplemax") {
            probabilities[i] = values[i] / sumOfValues;
        } else {
            throw generateError(normalizationMethod + " is not a valid normaliation method");
        }
        i = i + 1;
    }

    // Find the maximum probability.
    float max = 1E-100000;
    i = 0;
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
        } else {
            // TODO decide what to do.
            throw generateError("invaid element: " + predictor.getElementName());
        }
        i = i + 1;
    }
    return output;
}
