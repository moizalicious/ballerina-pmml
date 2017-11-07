package ballerina.pmml;

function getDataDictionaryElement (xml pmml) (xml) {
    // TODO use xml.select(string qname)(xml) for getting XML elements
    xml dataDictionaryElement = pmml.selectChildren("DataDictionary").strip();
    return dataDictionaryElement;
}
