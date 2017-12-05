package ballerina.pmml;

function getDataFieldElements (xml dataDictionary) (xml) {
    xml dataFields = dataDictionary.children().elements().strip();
    if (dataFields.isEmpty()) {
        throw generateError("no <DataField> elements found");
    }
    return dataFields;
}

function getDataFieldElement (xml dataDictionary, int elementNumber) (xml) {
    xml dataFieldElements = getDataFieldElements(dataDictionary);
    xml dataField = dataFieldElements[elementNumber];
    if (dataField.isEmpty()) {
        throw generateError("the <DataField> with element number " + elementNumber + " was not found");
    }
    return dataField;
}

function getNumberOfDataFields (xml dataDictionary) (int) {
    xml dataFields = getDataFieldElements(dataDictionary);
    return lengthof dataFields;
}

function getDataFieldElementsWithoutTarget (xml dataDictionary, string targetName) (xml) {
    int i = 0;
    xml dataFields = getDataFieldElements(dataDictionary);
    xml dataFieldsWithoutTarget;
    while (i < lengthof dataFields) {
        xml dataField = dataFields[i];
        if (dataField@["name"] != targetName) {
            dataFieldsWithoutTarget = dataFieldsWithoutTarget + dataField;
        }
        i = i + 1;
    }
    if (dataFieldsWithoutTarget.isEmpty()) {
        throw generateError("there is no <DataField> element which is not the target");
    }
    return dataFieldsWithoutTarget;
}
