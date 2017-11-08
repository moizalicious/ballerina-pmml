package ballerina.pmml;

import ballerina.log;

public function executeRegressionModel (xml pmml, xml data) (float) {
    float result;
    // Check if the argument is a valid PMML element.
    if (!isValid(pmml)) {
        throw invalidPMMLElementError();
    }

    xml modelElement = getModelElement(pmml);
    string functionName = modelElement@["functionName"];
    if (functionName == "regression") {
        result = executeRegressionFunction(pmml, data);
    }
    return result;
}

function executeRegressionFunction (xml pmml, xml data) (float) {
    // Get the <RegressionModel> element from the pmml.
    xml modelElement = getModelElement(pmml);
    // Identify the target field using the <MiningSchema>.
    xml miningSchema = modelElement.selectChildren("MiningSchema");
    xml miningFields = miningSchema.children().elements();
    string targetFieldName;
    int i = 0;
    while (i < lengthof miningFields) {
        xml miningField = miningFields[i];
        if (miningField@["usageType"] == "target") {
            targetFieldName = miningField@["name"];
            break;
        }
        i = i + 1;
    }

    // Obtain all the <DataField> elements from the <DataDictionary> as a JSON.
    xml dataDictionaryElement = getDataDictionaryElement(pmml);
    json dataFieldsJSON = [];
    i = 0;
    xml dataFieldElementsWithoutTarget = getDataFieldElementsWithoutTarget(dataDictionaryElement, targetFieldName).elements();
    while (i < lengthof dataFieldElementsWithoutTarget) {
        xml field = dataFieldElementsWithoutTarget[i];
        if (field@["name"] != targetFieldName) {
            json fieldJSON = {};
            fieldJSON.name = field@["name"];
            fieldJSON.optype = field@["optype"];
            fieldJSON.dataType = field@["dataType"];
            if (field@["optype"] == "categorical") {
                fieldJSON.value = {};
            }
            dataFieldsJSON[i] = fieldJSON;
        }
        i = i + 1;
    }

    // Obtain the <RegressionTable> element from the <RegressionModel> element.
    xml regressionTableElement = modelElement.selectChildren("RegressionTable");
    // Obtain child elements from the <RegressionTable> element as a JSON array.
    xml regressionTableChildren = regressionTableElement.children().elements();
    json predictorElementsJSON = [];
    i = 0;
    while (i < lengthof regressionTableChildren) {
        xml predictorElement = regressionTableChildren[i];
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
        } else {
            throw generateError("no numeric/categorical predictor element found in the " + getModelType(pmml) + "element");
        }
        predictorElementsJSON[i] = predictor;
        i = i + 1;
    }

    // Add the information stored in the `predictorElementsJSON` variable to the `dataFieldsJSON` variable.
    i = 0;
    while (i < lengthof dataFieldsJSON) {
        int count = 0;
        while (count < (lengthof predictorElementsJSON)) {
            if (dataFieldsJSON[i].name.toString() == predictorElementsJSON[count].name.toString()) {
                string optypeStr = dataFieldsJSON[i].optype.toString();
                if (optypeStr == "continuous") {
                    dataFieldsJSON[i].exponent = predictorElementsJSON[count].exponent;
                    dataFieldsJSON[i].coefficient = predictorElementsJSON[count].coefficient;
                } else if (optypeStr == "categorical") {
                    string value = predictorElementsJSON[count].value.toString();
                    dataFieldsJSON[i].value[value] = predictorElementsJSON[count].coefficient;
                }
            }
            count = count + 1;
        }
        i = i + 1;
    }


    // Obtain the intercept value of the linear regression model.
    var intercept, _ = <float>regressionTableElement@["intercept"];
    // Create empty JSON element to store the PMML data of the entire <PMML> element.
    json regressionModelJSON = {};
    // Add the intercept to the regressionModelJSON variable.
    regressionModelJSON.intercept = intercept;
    // Add `dataFieldsJSON` to the `regressionModelJSON` variable.
    regressionModelJSON.predictors = dataFieldsJSON;

    // Get the information of the target value and add it to the regressionModelJSON JSON.
    xml dataFields = getDataFieldElements(dataDictionaryElement);
    xml dataField;
    string dataFieldName;
    i = 0;
    while (i < lengthof dataFields) {
        dataField = dataFields[i];
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
        i = i + 1;
    }

    // Convert the xml `data` variable to JSON to calculate the output.
    xmlOptions options = {};
    json dataJSON = data.children().elements().toJSON(options);


    log:printInfo(regressionModelJSON.toString());
    log:printInfo(dataJSON.toString());
    float output = calculateOutput(regressionModelJSON, dataJSON);
    return output;
}


function calculateOutput (json model, json data) (float) {
    // TODO make the exponents count
    // TODO add functionality for PMML 4.2, & 4.3.
    var output, _ = <float>model.intercept.toString();
    int numberOfPredictors = lengthof model.predictors;
    int i = 0;
    while (i < numberOfPredictors) {
        string name = model.predictors[i].name.toString();
        string opType = model.predictors[i].optype.toString();
        string valueStr = data[name].toString();
        var coefficient = 0.0;
        var value = 0.0;
        if (opType == "continuous") {
            coefficient, _ = <float>model.predictors[i].coefficient.toString();
            value, _ = <float>valueStr;
        } else if (opType == "categorical") {
            coefficient, _ = <float>model.predictors[i].value[valueStr].toString();
            value = 1;
        }
        output = output + (coefficient * value);

        i = i + 1;
    }
    string targetFieldDataType = model.target.dataType.toString();
    if (targetFieldDataType == "integer") {
        return <int>output;
    } else {
        return output;
    }
}