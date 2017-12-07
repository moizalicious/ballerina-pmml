package ballerina.pmml;

public function isDataElementValid (xml data) (boolean isDataElementValid, error err) {
    // Checks whether the <data> element given by the user is valid.
    isDataElementValid = true;
    err = null;
    if (data.isEmpty()) {
        isDataElementValid = false;
        err = generateError("the <data> element cannot be empty");
    } else if (!data.isSingleton()) {
        isDataElementValid = false;
        err = generateError("the <data> element must be a single root element");
    } else if (data.getItemType() != "element") {
        isDataElementValid = false;
        err = generateError("the data input should be of 'element' type");
    } else if (data.getElementName() != "data") {
        isDataElementValid = false;
        err = generateError("the data input element should have a <data> root tag");
    } else {
        xml children = data.strip().children().elements();
        xml childrenCopy = children.copy();
        int i = 0;
        int c = 1;
        while (i < lengthof children - 1) {
            while (c < lengthof childrenCopy) {
                if (children[i].getElementName() == childrenCopy[c].getElementName()) {
                    isDataElementValid = false;
                    err = generateError("duplicate element <"
                                        + children[i].getElementName() + "> found in the <data> element");
                }
                c = c + 1;
            }
            i = i + 1;
        }
    }

    return isDataElementValid, err;
}
