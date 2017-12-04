package ballerina.pmml;

function getMiningSchemaElement (xml pmml)(xml) {
    xml miningSchemaXML = getModelElement(pmml).selectChildren("MiningSchema").strip();
    if (miningSchemaXML.isEmpty()) {
        throw generateError("no <MiningSchema> element found");
    }
    return miningSchemaXML;
}

function getMiningFieldElements (xml miningSchema)(xml) {
    xml miningFieldElements = miningSchema.selectChildren("MiningField").strip();
    if (miningFieldElements.isEmpty()) {
        throw generateError("no <MiningField> element found");
    }
    return miningFieldElements;
}