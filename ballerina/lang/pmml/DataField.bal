package ballerina.lang.pmml;

import ballerina.lang.xmls;

function getDataFieldElements (xml pmml) (xml) {
    if (!isValid(pmml)) {
        throw invalidPMMLElementError();
    }

    xml dataDictionary = getDataDictionaryElement(pmml);
    xml dataFields = xmls:children(dataDictionary);
    return dataFields;
}

function getDataFieldElement (xml pmml, int elementNumber) (xml) {
    if (!isValid(pmml)) {
        throw invalidPMMLElementError();
    }

    xml dataFieldElements = getDataFieldElements(pmml);
    xml dataFieldElement = null;
    try {
        dataFieldElement = xmls:slice(xmls:elements(dataFieldElements), elementNumber, elementNumber + 1);
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

public function getNumberOfDataFields (xml pmml) (int) {
    if (!isValid(pmml)) {
        throw invalidPMMLElementError();
    }

    xml dataFieldElements = xmls:elements(getDataFieldElements(pmml));
    int index = 0;
    int numberOfDataFields = 0;
    while (true) {
        try {
            xml x = xmls:slice(dataFieldElements, index, index + 1);
            index = index + 1;
            numberOfDataFields = numberOfDataFields + 1;
        } catch (error e) {
            break;
        }
    }
    return numberOfDataFields;
}