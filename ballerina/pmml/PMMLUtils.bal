package ballerina.pmml;

public function isValid (xml pmml) (boolean isValid, error err) {

    if (pmml.isEmpty()) {
        // Check whether the pmml parameter is empty.
        isValid = false;
        err = generateError("the PMML element cannot be empty empty");
    } else if (pmml.getItemType() != "element") {
        // Check if the PMML is of the xml element type.
        isValid = false;
        err = generateError("the PMML item has to be of element type");
    } else if (!pmml.isSingleton()) {
        // Check if the pmml element is a singleton element.
        isValid = false;
        err = generateError("the <PMML> element must be a singleton element");
    } else if (!pmml.getElementName().contains("PMML")) {
        // Check whether the element name of the pmml element is <PMML>.
        isValid = false;
        err = generateError("the root element name should be <PMML>");
    } else if (pmml@["version"] == null) {
        // Check whether the version number has been defined.
        isValid = false;
        err = generateError("the <PMML> element must have a 'version' attribute");
    } else if (!hasValidModelType(pmml)) {
        // Check whether the element has a valid sub-element or the ML model.
        isValid = false;
        err = generateError("no valid ML model element found in the <PMML> element");
    } else {
        isValid = true;
        err = null;
    }
    // Return 'true' when the pmml element is valid.
    return isValid, err;
}

public function isPredictable (xml pmml) (boolean isPredictable, error err) {
    var valid, e = isValid(pmml);
    if (!valid) {
        return valid, e;
    }

    xmlns "http://www.dmg.org/PMML-4_2" as ns;
    string pmmlVersion = pmml@["version"];
    string elementName = pmml.getElementName();
    // Check whether the XML is a valid PMML element.
    if (pmmlVersion == "4.2") {
        if (elementName == ns:PMML) {
            isPredictable = true;
            err = null;
        } else {
            isPredictable  = false;
            err = generateError("invorrect namespace, "
                                + "please use \"http://www.dmg.org/PMML-4_2\" standard");
        }
    } else {
        isPredictable = false;
        err = generateError("only version 4.2 is currently supported");
    }

    return isPredictable, err;
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

public function getVersion (xml pmml) (float) {
    var valid, err = isValid(pmml);
    if (!valid) {
        throw err;
    }

    var pmmlVersion, _ = <float>pmml@["version"];
    return pmmlVersion;
}
