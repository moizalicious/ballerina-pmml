package pmml.test.ballerina;

import ballerina.pmml;
import ballerina.file;
import ballerina.io;

function main (string[] args) {
    // Read PMML File and add it to an XML element.
    file:File file = {path:"pmml/test/res/InteractionTerms.pmml"};
    io:ByteChannel byteChannel = file.openChannel("r");
    blob bytes;
    int numberOfBytes;
    bytes, numberOfBytes = byteChannel.readBytes(1000000);
    string s = bytes.toString("UTF-8");
    var pmml, _ = <xml> s;

    // Test public functions of the API.
    println("Is PMML valid: " + pmml:isValid(pmml));
    println("Version number: " + pmml:getVersion(pmml));
    println("Model Type: " + pmml:getModelType(pmml) + "\n");

    // TODO complete all the error handling.
    // Execute the linear regression model.
    xml data = xml `<data>
                        <sex>male</sex>
                        <age>19</age>
                        <work>8</work>
                    </data>`;
    print("The output is: ");
    println(pmml:executeModel(pmml, data));

}
