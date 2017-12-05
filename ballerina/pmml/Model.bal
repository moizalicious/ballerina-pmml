package ballerina.pmml;

public function executeModel (xml pmml, xml data) (any) {
    // TODO remove the strips from all the other functions that are private.
    pmml = pmml.strip();
    data = data.strip();

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
        throw generateError("the model " + modelType + " is currently not supported");
    }

    return result;
}

function getModelElement (xml pmml) (xml) {
    xml modelElement;
    int index = 0;
    boolean modelFound = false;
    while (index < lengthof models) {
        // TODO if there are 2 or more model elements, an error should be shown.
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
