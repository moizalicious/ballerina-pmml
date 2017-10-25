package pmml.test.ballerina;

import ballerina.lang.system;
import ballerina.lang.files;
import ballerina.lang.blobs;
import ballerina.lang.xmls;
import ballerina.lang.pmml;

function main (string[] args) {
    files:File file = {path:"pmml/test/res/LinearRegression.xml"};
    files:open(file, "r");
    var content, _ = files:read(file, 100000);
    string s = blobs:toString(content, "utf-8");
    xml pmml = xmls:parse(s);

    system:println("Is PMML valid: " + pmml:isValid(pmml));
    system:println("Version number: " + pmml:getVersion(pmml));
    system:println("Number of data fields: " + pmml:getNumberOfDataFields(pmml));
    system:println("Model Type: " + pmml:getModelType(pmml) + "\n");

    any[] data = [19, 20000, "carpark"];
    pmml:executeModel(pmml, data);
}
