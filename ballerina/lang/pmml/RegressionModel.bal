package ballerina.lang.pmml;

import ballerina.lang.xmls;
import ballerina.lang.system;
import ballerina.lang.strings;

function executeRegressionModel (xml pmml, json data) {
    // Check if the argument is a valid PMML element.
    if (!isValid(pmml)) {
        throw invalidPMMLElementError();
    }

    xml modelElement = getModelElement(pmml);
    string functionName = modelElement@["functionName"];
    if (functionName == "regression") {
        executeRegressionFunction(pmml, data);
    }
}

function executeRegressionFunction (xml pmml, json data) {
    // Get the data dictionary element.
    xml dataDictionaryElement = getDataDictionaryElement(pmml);

    // Get the model element.
    xml modelElement = getModelElement(pmml);

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

    // Index is used for the while loops
    index = 0;

    // Identify the target field from the mining schema.
    string targetFieldName;
    while (true) {
        try {
            xml miningField = xmls:slice(miningFields, index, index + 1);
            if (miningField@["usageType"] == "target") {
                targetFieldName = miningField@["name"];
                break;
            }
            index = index + 1;
        } catch (error e) {
            break;
        }
    }

    // Obtain all the <NumericalPredictor> child elements as an array in the <RegressionTable>.
    index = 0;
    xml numericPredictorElements = xmls:selectChildren(regressionTableElement, "NumericPredictor");
    any[][] numericPredictors = [];
    while (true) {
        try {
            xml numericPredictorElement = xmls:slice(numericPredictorElements, index, index + 1);

            string name = numericPredictorElement@["name"];
            var exponent, _ = <int>numericPredictorElement@["exponent"];
            var coefficient, _ = <float>numericPredictorElement@["coefficient"];

            numericPredictors[index] = [name, exponent, coefficient];
            index = index + 1;
        } catch (error e) {
            break;
        }
    }

    // Obtain all the <CategoricalPredictor> child elements as an array in the <RegressionTable>.
    index = 0;
    xml categoricalPredictorElements = xmls:selectChildren(regressionTableElement, "CategoricalPredictor");
    any[][] categoricalPredictors = [];
    while (true) {
        try {
            xml categoricalPredictorElement = xmls:slice(categoricalPredictorElements, index, index + 1);

            string name = categoricalPredictorElement@["name"];
            string value = categoricalPredictorElement@["value"];
            var coefficient, _ = <float>categoricalPredictorElement@["coefficient"];

            categoricalPredictors[index] = [name, value, coefficient];
            index = index + 1;
        } catch (error e) {
            break;
        }
    }

    // TODO Obtain all predictor elements and add it to a JSON array.
    index = 0;
    xml regressionTableChildren = xmls:elements(xmls:children(regressionTableElement));
    json[] predictorElements = [];
    while (true) {
        try {
            xml predictorElement = xmls:slice(regressionTableChildren, index, index + 1);
            json predictor = {};
            string predictorName = xmls:getElementName(predictorElement);
            if (strings:contains(predictorName, "NumericPredictor")) {
                predictor.optype = "continuous";
                predictor.name = predictorElement@["name"];
                predictor.exponent = predictorElement@["exponent"];
                predictor.coefficient = predictorElement@["coefficient"];
            } else if (strings:contains(predictorName, "CategoricalPredictor")) {
                predictor.optype = "categorical";
                predictor.name = predictorElement@["name"];
                predictor.value = predictorElement@["value"];
                predictor.coefficient = predictorElement@["coefficient"];
            }
            predictorElements[index] = predictor;
            index = index + 1;
        } catch (error e) {
            break;
        }
    }

    // TODO make this into a loop for getting the data and not hardcoding it.
    system:println(predictorElements);
    json pmmlData = {};
    pmmlData.intercept = intercept;
    pmmlData.predictors = [];
    pmmlData.predictors[0] = predictorElements[0];
    pmmlData.predictors[1] = predictorElements[1];
    pmmlData.predictors[2] = predictorElements[2];
    pmmlData.predictors[3] = predictorElements[3];
    system:println(pmmlData);
    system:println(lengthof pmmlData.predictors);

    // TODO add all the values obtained from the PMML and add it to a JSON
    // TODO Create the linear regression equation using the found values and return the output.
}
