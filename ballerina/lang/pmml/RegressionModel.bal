package ballerina.lang.pmml;

import ballerina.lang.xmls;
import ballerina.lang.errors;
import ballerina.lang.system;

function executeRegressionModel (xml pmml, any[] data) {
    // Check if the argument is a valid PMML element.
    if (!isValid(pmml)) {
        throw invalidPMMLFileError();
    }

    //TODO enter regression model handling here.
    xml dataDictionaryElement = getDataDictionaryElement(pmml);
    xml modelElement = getModelElement(pmml);
    string functionName = modelElement@["functionName"];
    if (functionName == "regression") {
        // Get the number of data fields in the PMML.
        int numberOfFields = getNumberOfDataFields(pmml);
        // Obtain the <RegressionTable> element from the PMML.
        xml regressionTableElement = xmls:selectChildren(modelElement, "RegressionTable");
        // Obtain the intercept value of the linear regression.
        var intercept, _ = <float>regressionTableElement@["intercept"];
        // Get the <MiningSchema> element.
        xml miningSchema = xmls:selectChildren(modelElement, "MiningSchema");
        // Get all the <MiningField> elements from the mining schema.
        xml miningFields = xmls:elements(xmls:children(miningSchema));
        string targetFieldName = "";
        int index = 0;
        // TODO Identify the targetField from the mining schema
        while (true) {
            try {
                xml miningField = xmls:slice(miningFields, index, index + 1);
                if (miningField@["usageType"] == "target") {
                    targetFieldName = miningField@["name"];
                    break;
                }
                index = index + 1;
            } catch (errors:Error e) {
                break;
            }
        }
        // Obtain all the <NumericalPredictor> child elements in the <RegressionTable>.
        index = 0;
        xml numericPredictors = xmls:selectChildren(regressionTableElement, "NumericPredictor");
        int numberOfNumericPredictors = 0;
        float[] numericPredictorCoefficients;
        // TODO check whether the numericalPredictors xml var is singleton
        while (true) {
            try {
                xml numericPredictor = xmls:slice(numericPredictors, index, index + 1);
                // TODO check the _ value for an error instead of ignoring it
                var coefficient, error = <float>numericPredictor@["coefficient"];
                if (error != null) {
                    numericPredictorCoefficients[index] = coefficient;
                    numberOfNumericPredictors = numberOfNumericPredictors + 1;
                    index = index + 1;
                } else {
                    throw error;
                }
            } catch (errors:Error e) {
                break;
            }
        }
        system:println(numberOfNumericPredictors);
        system:println(numericPredictorCoefficients);
        // TODO get the number of numerical predictors
        // TODO get the coefficents of all the numerical predictors.
    }
}