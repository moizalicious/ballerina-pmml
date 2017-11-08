package pmml.test.ballerina;

import ballerina.pmml;
import ballerina.file;
import ballerina.io;

function main (string[] args) {
    // Read PMML File and add it to an XML element.
    file:File file = {path:"pmml/test/res/LinearRegression2.xml"};
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
    // Execute the linear regression model.
    xml data = xml `<data>
                        <latitude>1</latitude>
                        <longitude>1</longitude>
                        <zon_winds>1</zon_winds>
                        <mer_winds>1</mer_winds>
                        <humidity>1</humidity>
                        <s_s_temp>1</s_s_temp>
                    </data>`;
    println("Predicted Result Is: " + pmml:executeModel(pmml, data));

}
