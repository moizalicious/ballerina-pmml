package ballerina.lang.pmml;

import ballerina.lang.xmls;
import ballerina.lang.strings;
import ballerina.utils.logger;
import ballerina.lang.jsons;

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

    // Obtain all predictor elements and add it to a JSON array.
    xml regressionTableChildren = xmls:elements(xmls:children(regressionTableElement));
    json predictorElements = [];
    index = 0;
    while (true) {
        try {
            xml predictorElement = xmls:slice(regressionTableChildren, index, index + 1);
            json predictor = {};
            string predictorName = xmls:getElementName(predictorElement);
            if (strings:contains(predictorName, "NumericPredictor")) {

                predictor.name = predictorElement@["name"];
                predictor.optype = "continuous";

                var exponent, _ = <int>predictorElement@["exponent"];
                predictor.exponent = exponent;

                var coefficient, _ = <float>predictorElement@["coefficient"];
                predictor.coefficient = coefficient;

            } else if (strings:contains(predictorName, "CategoricalPredictor")) {

                predictor.name = predictorElement@["name"];
                predictor.optype = "categorical";
                // TODO find a way to add all the values as an json for each categorical data field.
                predictor.value = predictorElement@["value"];

                var coefficient, _ = <float>predictorElement@["coefficient"];
                predictor.coefficient = coefficient;
            }
            predictorElements[index] = predictor;
            index = index + 1;
        } catch (error e) {
            // TODO add this condition for all the while searches of this type.
            if (strings:contains(e.msg, "Failed to slice xml: index out of range:")) {
                break;
            } else {
                logger:error(e.msg);
            }
        }
    }

    // Create empty JSON element to store the PMML data.
    json pmmlData = {};
    // Add the intercept.
    pmmlData.intercept = intercept;
    // Add empty predictor array
    pmmlData.predictors = [];
    // Add the predictorElements to the pmmlData JSON.
    index = 0;
    while (index < lengthof predictorElements) {
        pmmlData.predictors[index] = predictorElements[index];
        index = index + 1;
    }

    // Get the information of the target value and add it to the pmmlData JSON.
    xml dataFields = getDataFieldElements(pmml);
    xml dataField;
    string dataFieldName;
    index = 0;
    while (true) {
        try {
            dataField = xmls:slice(dataFields, index, index + 1);
            dataFieldName = dataField@["name"];
            if (dataFieldName == targetFieldName) {
                json targetJSON = {
                                      name:dataField@["name"],
                                      optype:dataField@["optype"],
                                      dataType:dataField@["dataType"]
                                  };
                pmmlData.target = targetJSON;
                break;
            }
            index = index + 1;
        } catch (error e) {
            logger:info(e.msg);
            break;
        }
    }

    logger:info(pmmlData);
    logger:info(lengthof pmmlData.predictors);

    xmls:Options options = {attributePrefix:"", preserveNamespaces:false};
    json test = xmls:toJSON(pmml, options);
    logger:info(test);
    // TODO Create the linear regression equation using the found values and return the output.
    //index = 0;
    //while (index < lengthof pmmlData.predictors) {
    //    string optype = jsons:toString(pmmlData.predictors[index].optype);
    //    logger:info(optype);
    //    if (optype == "continuous") {
    //        string name = jsons:toString(pmmlData.predictors[index].name);
    //        logger:info(name);
    //        var value, _ = <float>jsons:toString(data[name]);
    //        logger:info(value);
    //    } else if (optype == "categorical") {
    //        string name = jsons:toString(pmmlData.predictors[index].name);
    //        logger:info(name);
    //        string value = jsons:toString(data[name]);
    //        logger:info(value);
    //    } else {
    //        // TODO add error message here.
    //    }
    //    index = index + 1;
    //}

}
