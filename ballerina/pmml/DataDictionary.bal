package ballerina.pmml;

function getDataDictionaryElement (xml pmml) (xml) {
    // TODO use xml.select(string qname)(xml) for getting XML elements
    if (!isValid(pmml)) {
        throw invalidPMMLElementError();
    }

    xml dataDictionaryElement = pmml.selectChildren("DataDictionary");
    return dataDictionaryElement;
}
