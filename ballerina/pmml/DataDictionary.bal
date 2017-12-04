package ballerina.pmml;

function getDataDictionaryElement (xml pmml) (xml) {
    xml dataDictionaryElement = pmml.selectChildren("DataDictionary").strip();
    if (dataDictionaryElement.isEmpty()) {
        throw generateError("no <DataDictionary> element found");
    }
    return dataDictionaryElement;
}
