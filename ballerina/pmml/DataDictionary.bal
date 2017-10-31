package ballerina.pmml;

function getDataDictionaryElement (xml pmml) (xml) {
    if (!isValid(pmml)) {
        throw invalidPMMLElementError();
    }

    xml dataDictionaryElement = pmml.selectChildren("DataDictionary");
    return dataDictionaryElement;
}
