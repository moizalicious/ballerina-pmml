package ballerina.pmml;

public function getVersion (xml pmml) (float) {
    //if (!isValid(pmml)) {
    //    throw invalidPMMLElementError();
    //}

    var pmmlVersion, _ = <float>pmml@["version"];
    return pmmlVersion;
}

public function isValid(xml pmml)(boolean) {
    // TODO complete
    return true;
}

public function isPredictable (xml pmml) (boolean) {
    // TODO fix to suit the API
    // Get XML information.
    boolean isEmpty = pmml.isEmpty();
    string itemType = pmml.getItemType();
    boolean isSingleton = pmml.isSingleton();
    string elementName = pmml.getElementName();
    xmlns "http://www.dmg.org/PMML-4_2" as ns2;
    string pmmlVersion = pmml@["version"];
    // Check whether the pmml has a valid ML model element
    boolean isValidModelType = hasValidModelType(pmml);
    // Check whether the XML is a valid PMML element.
    if (!isEmpty && (itemType == "element") && isSingleton && isValidModelType) {
        if (elementName == ns2:PMML) {
            if (pmmlVersion == "4.2") {
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    } else {
        return false;
    }
}

function hasChildElement (xml x, string elementName) (boolean) {
    xml element = x.selectChildren(elementName);
    if (!element.isEmpty()) {
        return true;
    } else {
        return false;
    }
}

function hasValidModelType (xml pmml) (boolean) {
    int index = 0;
    while (index < lengthof models) {
        if (hasChildElement(pmml, models[index])) {
            return true;
        }
        index = index + 1;
    }
    return false;
}
