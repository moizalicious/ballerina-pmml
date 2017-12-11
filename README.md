# PMML API For Ballerina

This repository holds the source code of an API for PMML in Ballerina. **Note that this is a proof-of-concept and does not work in all situations.**

The machine learning models the that are currently supported by this API are the following:
* Linear Regression
* Polynomial Regression
* Logistic Regression
* Classification

## Downloading & Adding The API To Your Ballerina Project
To download the API you can clone the repository or you can download the source from the following links:
* [zip (v1.0-beta)](https://github.com/moizalicious/ballerina-pmml/archive/v1.0-alpha.zip)
* [tar.gz (v1.0-beta)](https://github.com/moizalicious/ballerina-pmml/archive/v1.0-alpha.tar.gz)

Copy the `ballerina` directory to the project that you want to use the PMML API. Then in the `.bal` file import the API with `import ballerina.pmml;` Then you can use the public functions provided by the API to
