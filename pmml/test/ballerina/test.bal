package pmml.test.ballerina;

import ballerina.pmml;
import ballerina.file;
import ballerina.io;

function main (string[] args) {
    // Read PMML File and add it to an XML element.
    file:File file = {path:"pmml/test/res/RegressionOzone.pmml"};
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

    // TODO make sure the input has a root element `<data>` for the input. Name could change accordingly.
    // TODO add proper error messages for invalid data inputs.
    // TODO there cannot be multiple elements with the same name in this type of input
    // Execute the linear regression model.
    xml data = xml `<data>
                        <temp>29.21533723</temp>
                        <ibh>3.4234234234234</ibh>
                        <ibt>0.3745627113818</ibt>
                    </data>`;
    print("The output is: ");
    println(pmml:executeModel(pmml, data));

}
