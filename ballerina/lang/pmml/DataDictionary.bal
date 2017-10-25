package ballerina.lang.pmml;

import ballerina.lang.xmls;

function getDataDictionaryElement (xml pmml) (xml) {
    if (!isValid(pmml)) {
        throw invalidPMMLElementError();
    }

    xml dataDictionaryElement = xmls:selectChildren(pmml, "DataDictionary");
    return dataDictionaryElement;
}