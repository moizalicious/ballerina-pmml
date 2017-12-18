package ml.pmml;

public function predict (xml pmml, xml data) (any) {
    // Based on the ML model defined in the <PMML> element,
    // will be redirected to the necessary function.

    // Strip the elements of any whitespaces.
    pmml = pmml.strip();
    data = data.strip();

    // Check if the <PMML> element is usable in this API.
    var predictable, err = isPredictable(pmml);
    if (!predictable) {
        throw err;
    }

    // Gets the model type and based on that gets redirected to the specific function.
    any result;
    string modelType = getModelType(pmml);
    if (modelType.contains("GeneralRegressionModel")) {
        throw generateError("the model " + modelType + " is currently not supported");
    } else if (modelType.contains("RegressionModel")) {
        result = predictRegressionModel(pmml, data);
    } else {
        throw generateError("the model " + modelType + " is currently not supported");
    }

    return result;
}

function getModelElement (xml pmml) (xml) {
    // Gets the child element of the <PMML> element which defines the ML model it is using.
    xml modelElement;
    int index = 0;
    boolean modelFound = false;
    int modelFoundCount = 0;
    while (index < lengthof models) {
        if (hasChildElement(pmml, models[index]) && !modelFound) {
            modelElement = pmml.selectChildren(models[index]);
            modelFound = true;
            modelFoundCount = modelFoundCount + 1;
            if (!modelElement.isSingleton()) {
                throw generateError("there can be only one model element in the PMML");
            }
        }
        index = index + 1;
    }

    if (modelFoundCount > 1) {
        // If there are multiple model elements of the same type.
        throw generateError("there can be only one model element in the PMML");
    } else if (!modelFound) {
        // If no valid model element is found.
        throw generateError("no valid ML model found in the pmml");
    }

    return modelElement;
}

public function getModelType (xml pmml) (string) {
    // Gets the type of the ML model the <PMML> element is using.

    // Checks whether the pmml parameter has a valid argument.
    var valid, err = isValid(pmml);
    if (!valid) {
        throw err;
    }

    xml modelElement = getModelElement(pmml);
    string modelType = modelElement.getElementName();
    return modelType;
}
