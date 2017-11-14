package ballerina.pmml;

function getMiningSchemaElement (xml pmml)(xml) {
    xml miningSchemaXML = getModelElement(pmml).selectChildren("MiningSchema");
    if (miningSchemaXML.isEmpty()) {
        throw generateError("no mining schema element found");
    }
    return miningSchemaXML;
}

function getMiningFieldElements (xml miningSchema)(xml) {
    xml miningFieldElements = miningSchema.selectChildren("MiningField");
    if (miningFieldElements.isEmpty()) {
        throw generateError("no mining field element found");
    }
    return miningFieldElements;
}