package ballerina.pmml;

function checkDataElementValidity (xml data) {
    // Check whether the <data> element entered is valid.
    if (data.isEmpty()) {
        throw generateError("the <data> element cannot be empty");
    }

    if (!data.isSingleton()) {
        throw generateError("the <data> element must be a single root element");
    }

    if (data.getItemType() != "element") {
        throw generateError("the data input should be of 'element' type");
    }

    if (data.getElementName() != "data") {
        throw generateError("the data input element should have a <data> root tag");
    }

    xml children = data.strip().children().elements();
    xml childrenCopy = children.copy();
    int i = 0;
    int c = 1;
    while (i < lengthof children - 1) {
        while (c < lengthof childrenCopy) {
            if (children[i].getElementName() == childrenCopy[c].getElementName()) {
                throw generateError("duplicate element <" + children[i].getElementName() + "> found in the data input");
            }
            c = c + 1;
        }
        i = i + 1;
    }
}
