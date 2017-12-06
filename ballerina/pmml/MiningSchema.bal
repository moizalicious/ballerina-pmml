package ballerina.pmml;

function getMiningSchemaElement (xml modelElement)(xml) {
    xml miningSchemaXML = modelElement.selectChildren("MiningSchema");
    if (miningSchemaXML.isEmpty()) {
        throw generateError("no <MiningSchema> element found");
    }
    return miningSchemaXML;
}

function getMiningFieldElements (xml miningSchema)(xml) {
    xml miningFieldElements = miningSchema.selectChildren("MiningField");
    if (miningFieldElements.isEmpty()) {
        throw generateError("no <MiningField> element found");
    }
    return miningFieldElements;
}