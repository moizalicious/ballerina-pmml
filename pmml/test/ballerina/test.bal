package pmml.test.ballerina;

import ballerina.pmml;
import ballerina.file;
import ballerina.io;

function main (string[] args) {
    file:File file = {path:"pmml/test/res/LinearRegression.xml"};
    io:ByteChannel byteChannel = file.openChannel("r");
    blob bytes;
    int numberOfBytes;
    bytes, numberOfBytes = byteChannel.readBytes(1000000);
    string s = bytes.toString("UTF-8");
    var pmml, _ = <xml> s;

    println("Is PMML valid: " + pmml:isValid(pmml));
    println("Version number: " + pmml:getVersion(pmml));
    println("Number of data fields: " + pmml:getNumberOfDataFields(pmml));
    println("Model Type: " + pmml:getModelType(pmml) + "\n");

    json data = {
                    age:20,
                    salary:10000,
                    car_location:"carpark"
                };
    pmml:executeModel(pmml, data);
}
