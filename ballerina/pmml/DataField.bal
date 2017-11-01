package ballerina.pmml;

import ballerina.log;

function getDataFieldElements (xml pmml) (xml) {
    if (!isValid(pmml)) {
        throw invalidPMMLElementError();
    }

    xml dataDictionary = getDataDictionaryElement(pmml);
    xml dataFields = dataDictionary.children();
    return dataFields;
}

function getDataFieldElement (xml pmml, int elementNumber) (xml) {
    if (!isValid(pmml)) {
        throw invalidPMMLElementError();
    }

    xml dataFieldElements = getDataFieldElements(pmml);
    xml dataFieldElement = null;
    try {
        dataFieldElement = dataFieldElements.elements().slice(elementNumber, elementNumber + 1);
    } catch (error e) {
        throw generateError("The data field of index " + elementNumber + " does not exist");
    }
    return dataFieldElement;
}


function getDataFieldType (xml pmml, int elementNumber) (string) {
    xml dataFieldElement = getDataFieldElement(pmml, elementNumber);
    string optype = dataFieldElement@["optype"];
    return optype;
}

function getDataFieldName (xml dataFieldElement) {
    // TODO complete
}

public function getNumberOfDataFields (xml pmml) (int) {
    if (!isValid(pmml)) {
        throw invalidPMMLElementError();
    }

    // TODO the `.elements()` part should be in getDataFieldElements() function.
    xml dataFieldElements = getDataFieldElements(pmml).elements();
    index = 0;
    int numberOfDataFields = 0;
    while (true) {
        try {
            xml x = dataFieldElements.slice(index, index + 1);
            index = index + 1;
            numberOfDataFields = numberOfDataFields + 1;
        } catch (error e) {
            break;
        }
    }
    return numberOfDataFields;
}

function getDataFieldElementsWithoutTarget (xml pmml, string targetName) (xml) {
    // TODO complete
    int index = 0;
    xml dataFields = getDataFieldElements(pmml).elements();
    xml dataFieldsWithoutTarget;
    while (true) {
        try {
            xml dataField = dataFields.slice(index, index + 1);
            if (dataField@["name"] != targetName) {
                if (index == 0) {
                    dataFieldsWithoutTarget = dataField;
                } else {
                    dataFieldsWithoutTarget = dataFieldsWithoutTarget + dataField;
                }
            }
        } catch (error e) {
            if (e.msg.contains("Failed to slice xml: index out of range:")) {
                break;
            } else {
                throw e;
            }
        }
        index = index + 1;
    }
    return dataFieldsWithoutTarget;
}