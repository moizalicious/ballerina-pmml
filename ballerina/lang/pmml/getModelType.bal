package ballerina.lang.pmml;

import ballerina.lang.xmls;

function getModelType (xml pmml)(string) {
    if (!isValid(pmml)) {
        throw invalidPMMLFileError();
    }

    xml modelElement = getModelElement(pmml);
    string modelType = xmls:getElementName(modelElement);
    return modelType;
}
