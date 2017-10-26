package ballerina.lang.pmml;

import ballerina.lang.strings;
import ballerina.lang.xmls;

public function executeModel (xml pmml, json data) {
    if (!isValid(pmml)) {
        throw invalidPMMLElementError();
    }

    // TODO make the identification of the models better
    string modelType = getModelType(pmml);
    if (strings:contains(modelType, "GeneralRegressionModel")) {
        throw generateError("the model " + modelType + " is currently not supported");
    } else if (strings:contains(modelType, "RegressionModel")) {
        executeRegressionModel(pmml, data);
    } else {
        throw generateError("the model " + modelType + " execution is currently not supported");
    }
}

function getModelElement (xml pmml) (xml) {
    if (!isValid(pmml)) {
        throw invalidPMMLElementError();
    }

    xml modelElement = null;
    int index = 0;
    boolean modelFound = false;
    while (index < lengthof models) {
        if (hasChildElement(pmml, models[index])) {
            modelFound = true;
            modelElement = xmls:selectChildren(pmml, models[index]);
            break;
        }
        index = index + 1;
    }
    if (!modelFound) {
        throw generateError("there is no ML model available in the pmml");
    }
    return modelElement;
}

public function getModelType (xml pmml) (string) {
    if (!isValid(pmml)) {
        throw invalidPMMLElementError();
    }

    xml modelElement = getModelElement(pmml);
    string modelType = xmls:getElementName(modelElement);
    return modelType;
}
