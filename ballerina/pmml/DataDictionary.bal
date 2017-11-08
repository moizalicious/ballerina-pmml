package ballerina.pmml;

function getDataDictionaryElement (xml pmml) (xml) {
    xml dataDictionaryElement = pmml.selectChildren("DataDictionary").strip();
    return dataDictionaryElement;
}
