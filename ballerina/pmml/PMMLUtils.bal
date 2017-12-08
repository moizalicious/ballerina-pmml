package ballerina.pmml;

import ballerina.file;
import ballerina.io;

public function isValid (xml pmml) (boolean isValid, error err) {
    // Checks whether the given xml argument has a valid <PMML> element.
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
    // Checks whether the given <PMML> element can be predictable using the API.

    // Checks if the <PMML> element is a valid one.
    var valid, invalidPMMLError = isValid(pmml);
    if (!valid) {
        return valid, invalidPMMLError;
    }

    xmlns "http://www.dmg.org/PMML-4_2" as ns;
    string pmmlVersion = pmml@["version"];
    string elementName = pmml.getElementName();
    // Checks whether the version number is 4.2.
    if (pmmlVersion == "4.2") {
        // Checks whether the element name is {http://www.dmg.org/PMML-4_2}PMML.
        if (elementName == ns:PMML) {
            isPredictable = true;
            err = null;
        } else {
            isPredictable = false;
            err = generateError("incorrect namespace, "
                                + "please use \"http://www.dmg.org/PMML-4_2\" as standard");
        }
    } else {
        isPredictable = false;
        err = generateError("only PMML version 4.2 is currently supported");
    }

    return isPredictable, err;
}

function hasChildElement (xml x, string elementName) (boolean) {
    // Checks whether a given xml argument has child element of name `elementName`.
    xml element = x.selectChildren(elementName);
    if (!element.isEmpty()) {
        return true;
    } else {
        return false;
    }
}

function hasValidModelType (xml pmml) (boolean) {
    // Checks whether the given <PMML> element has a valid ML model element or not.
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
    // Gets the version attribute of the given <PMML> element.

    // Checks whether the given <PMML> element is a valid one.
    var valid, invalidPMMLError = isValid(pmml);
    if (!valid) {
        throw invalidPMMLError;
    }

    var pmmlVersion, typeConversionError = <float>pmml@["version"];
    if (typeConversionError != null) {
        throw typeConversionError;
    }

    return pmmlVersion;
}

public function readXMLFromFile (string filePath) (xml) {
    // Reads data from a file and converts it to an XML object.
    file:File file = {path:filePath};
    io:ByteChannel byteChannel = file.openChannel("r");
    blob bytes;
    int numberOfBytes;
    bytes, numberOfBytes = byteChannel.readBytes(1000000);
    string s = bytes.toString("UTF-8");
    var x, typeConversionError = <xml>s.trim();
    if (typeConversionError != null) {
        throw typeConversionError;
    }
    return x;
}
