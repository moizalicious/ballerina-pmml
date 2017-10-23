package ballerina.lang.pmml;

import ballerina.lang.xmls;
import ballerina.lang.errors;
import ballerina.lang.system;

function executeRegressionModel (xml pmml, any[] data) {
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

function executeRegressionFunction (xml pmml, any[] data) {
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
    int index = 0;

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
        } catch (errors:Error e) {
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
        } catch (errors:Error e) {
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
        } catch (errors:Error e) {
            break;
        }
    }

    // TODO Create the linear regression equation using the found values and return the output.


    system:println(numericPredictors);
    system:println(categoricalPredictors);
}
