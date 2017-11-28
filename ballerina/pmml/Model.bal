package ballerina.pmml;

public function executeModel (xml pmml, xml data) (any) {
    pmml.strip();
    data.strip();

    if (!isValid(pmml)) {
        throw invalidPMMLElementError();
    }

    any result;
    string modelType = getModelType(pmml);
    if (modelType.contains("GeneralRegressionModel")) {
        throw generateError("the model " + modelType + " is currently not supported");
    } else if (modelType.contains("RegressionModel")) {
        result = executeRegressionModel(pmml, data);
    } else {
        throw generateError("the model " + modelType + " execution is currently not supported");
    }
    return result;
}

function getModelElement (xml pmml) (xml) {
    xml modelElement = null;
    int index = 0;
    boolean modelFound = false;
    while (index < lengthof models) {
        if (hasChildElement(pmml, models[index])) {
            modelFound = true;
            modelElement = pmml.selectChildren(models[index]);
            break;
        }
        index = index + 1;
    }
    if (!modelFound) {
        throw generateError("no valid model available in the pmml");
    }
    return modelElement;
}

public function getModelType (xml pmml) (string) {
    if (!isValid(pmml)) {
        throw invalidPMMLElementError();
    }

    xml modelElement = getModelElement(pmml);
    string modelType = modelElement.getElementName();
    return modelType;
}
