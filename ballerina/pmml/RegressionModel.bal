package ballerina.pmml;

import ballerina.log;

public function executeRegressionModel (xml pmml, json data) {
    // TODO change the input or json data as a xml data (then convert it to json).
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
    // TODO rearrange all of this.
    // Get the data dictionary element.
    xml dataDictionaryElement = getDataDictionaryElement(pmml);

    // Get the model element.
    xml modelElement = getModelElement(pmml);

    // Get the number of data fields in the PMML.
    int numberOfFields = getNumberOfDataFields(pmml);

    // Obtain the <RegressionTable> element from the PMML.
    xml regressionTableElement = modelElement.selectChildren("RegressionTable");

    // Obtain the intercept value of the linear regression.
    var intercept, _ = <float>regressionTableElement@["intercept"];

    // Get the <MiningSchema> element.
    xml miningSchema = modelElement.selectChildren("MiningSchema");

    // Get all the <MiningField> elements from the mining schema.
    xml miningFields = miningSchema.children().elements();

    // Index is used for the while loops
    index = 0;

    // Identify the target field from the mining schema.
    string targetFieldName;
    while (true) {
        try {
            xml miningField = miningFields.slice(index, index + 1);
            if (miningField@["usageType"] == "target") {
                targetFieldName = miningField@["name"];
                break;
            }
            index = index + 1;
        } catch (error e) {
            break;
        }
    }


    // Obtain all the predictor elements from the DataFields and add it to the JSON.
    json dataFieldsJSON = [];
    index = 0;
    xml dataFieldElementsWithoutTarget = getDataFieldElementsWithoutTarget(pmml, targetFieldName).elements();
    while (true) {
        try {
            xml field = dataFieldElementsWithoutTarget.slice(index, index + 1);
            if (field@["name"] != targetFieldName) {
                json fieldJSON = {};
                fieldJSON.name = field@["name"];
                fieldJSON.optype = field@["optype"];
                fieldJSON.dataType = field@["dataType"];
                if (field@["optype"] == "categorical") {
                    fieldJSON.value = {};
                }
                dataFieldsJSON[index] = fieldJSON;
            }
            index = index + 1;
        } catch (error e) {
            if (e.msg.contains("Failed to slice xml: index out of range:")) {
                break;
            } else {
                throw e;
            }
        }
    }

    // Obtain all predictor elements and add it to a JSON array.
    xml regressionTableChildren = regressionTableElement.children().elements();
    json predictorElements = [];
    index = 0;
    while (true) {
        try {
            xml predictorElement = regressionTableChildren.slice(index, index + 1);
            json predictor = {};
            string predictorName = predictorElement.getElementName();
            if (predictorName.contains("NumericPredictor")) {

                predictor.name = predictorElement@["name"];
                predictor.optype = "continuous";

                var exponent, _ = <int>predictorElement@["exponent"];
                predictor.exponent = exponent;

                var coefficient, _ = <float>predictorElement@["coefficient"];
                predictor.coefficient = coefficient;

            } else if (predictorName.contains("CategoricalPredictor")) {

                predictor.name = predictorElement@["name"];
                predictor.optype = "categorical";
                predictor.value = predictorElement@["value"];

                var coefficient, _ = <float>predictorElement@["coefficient"];
                predictor.coefficient = coefficient;
            }
            predictorElements[index] = predictor;
            index = index + 1;
        } catch (error e) {
            // TODO add this condition for all the while searches of this type.
            if (e.msg.contains("Failed to slice xml: index out of range:")) {
                break;
            } else {
                log:error(e.msg);
            }
        }
    }

    // Add a loop inside a loop to merge the predictorElements and the dataFields together.
    index = 0;
    while (index < (lengthof dataFieldsJSON)) {
        int count = 0;
        while (count < (lengthof predictorElements)) {
            if (dataFieldsJSON[index].name.toString() == predictorElements[count].name.toString()) {
                string optypeStr = dataFieldsJSON[index].optype.toString();
                if (optypeStr == "continuous") {
                    dataFieldsJSON[index].exponent = predictorElements[count].exponent;
                    dataFieldsJSON[index].coefficient = predictorElements[count].coefficient;
                } else if (optypeStr == "categorical") {
                    string value = predictorElements[count].value.toString();
                    dataFieldsJSON[index].value[value] = predictorElements[count].coefficient;
                }
            }
            count = count + 1;
        }
        index = index + 1;
    }

    // Create empty JSON element to store the PMML data.
    json regressionModelJSON = {};
    // Add the intercept.
    regressionModelJSON.intercept = intercept;
    // Add empty predictor array
    regressionModelJSON.predictors = dataFieldsJSON;
    // Add the predictorElements to the regressionModelJSON JSON.
    //index = 0;
    //while (index < lengthof predictorElements) {
    //    regressionModelJSON.predictors[index] = predictorElements[index];
    //    index = index + 1;
    //}

    // Get the information of the target value and add it to the regressionModelJSON JSON. // TODO can merge with other code.
    xml dataFields = getDataFieldElements(pmml);
    xml dataField;
    string dataFieldName;
    index = 0;
    while (true) {
        try {
            dataField = dataFields.slice(index, index + 1);
            dataFieldName = dataField@["name"];
            if (dataFieldName == targetFieldName) {
                json targetJSON = {
                                      name:dataField@["name"],
                                      optype:dataField@["optype"],
                                      dataType:dataField@["dataType"]
                                  };
                regressionModelJSON.target = targetJSON;
                break;
            }
            index = index + 1;
        } catch (error e) {
            log:info(e.msg);
            break;
        }
    }

    log:info(regressionModelJSON);


    // TODO Create the linear regression equation using the found values and return the output.
    

}
