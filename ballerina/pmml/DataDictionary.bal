package ballerina.pmml;

function getDataDictionaryElement (xml pmml) (xml) {
    // Gets the <DataDictionary> element from the <PMML>.
    xml dataDictionaryElement = pmml.selectChildren("DataDictionary");
    if (dataDictionaryElement.isEmpty()) {
        throw generateError("no <DataDictionary> element found");
    }
    return dataDictionaryElement;
}

function getDataFieldElements (xml dataDictionary) (xml) {
    // Gets the <DataField> elements from the <DataDictionary>.
    xml dataFields = dataDictionary.children().elements();
    if (dataFields.isEmpty()) {
        throw generateError("no <DataField> elements found");
    }
    return dataFields;
}

function getDataFieldElement (xml dataDictionary, int elementNumber) (xml) {
    // Gets a specific <DataField> element from the <DataDictionary>.
    xml dataFieldElements = getDataFieldElements(dataDictionary);
    xml dataField = dataFieldElements[elementNumber];
    if (dataField.isEmpty()) {
        throw generateError("the <DataField> with element number " + elementNumber + " was not found");
    }
    return dataField;
}

function getNumberOfDataFields (xml dataDictionary) (int) {
    // Gets the total number of <DataField> elements in the <DataDictionary>.
    xml dataFields = getDataFieldElements(dataDictionary);
    return lengthof dataFields;
}

function getDataFieldElementsWithoutTarget (xml dataDictionary, string targetName) (xml) {
    // Gets all the <DataField> elements excluding the "target" from the <DataDictionary>.
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
