package ballerina.pmml;

function getMiningSchemaElement (xml modelElement)(xml) {
    // Gets the <MiningSchema> element from the model element of the PMML.
    xml miningSchemaXML = modelElement.selectChildren("MiningSchema");
    if (miningSchemaXML.isEmpty()) {
        throw generateError("no <MiningSchema> element found");
    }
    return miningSchemaXML;
}

function getMiningFieldElements (xml miningSchema)(xml) {
    // Gets the <MiningField> elements from the <MiningSchema>
    xml miningFieldElements = miningSchema.selectChildren("MiningField");
    if (miningFieldElements.isEmpty()) {
        throw generateError("no <MiningField> element found");
    }
    return miningFieldElements;
}
