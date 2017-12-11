# PMML API For Ballerina
**A "proof-of-concept" API written in [Ballerina](https://ballerinalang.org/) for Ballerina to read and predict values using machine learning models defined with [PMML](http://dmg.org/pmml/pmml-v4-2-1.html)**

### Contents
1. [Introduction](#introduction)
2. [Downloading The API](#download)
3. [Using The API](#using)
4. [Making Changes](#changes)
5. [Additional Information](#additional)

## <a name="introduction"> Introduction </a>
**This is a PMML API (proof-of-concept) written to test the limits of Ballerina's built-in XML library.**

Ballerina is a general purpose, concurrent and strongly typed programming language offered by [WSO2](https://wso2.com/) with both textual and graphical syntaxes, optimized for integration.

This API does not fully support all features of PMML neither all versions. The API is only supported for PMML version 4.2 and the only PMML files that can be used are the ones that have one of the following types of machine learning models:
* Linear Regression
* Polynomial Regression
* Logistic Regression
* Classification

All of the above machine learning models can be defined by the `<RegressionModel>` element in PMML.

## <a name="download"> Downloading The API </a>
To download the API you can clone the repository or you can download the 
source from the following links:
* [zip (v1.0-alpha) Windows](https://github.com/moizalicious/ballerina-pmml/archive/v1.0-alpha.zip)
* [tar.gz (v1.0-alpha) Linux/MacOS](https://github.com/moizalicious/ballerina-pmml/archive/v1.0-alpha.tar.gz)

Copy the `ballerina` directory to the project that you want to use the PMML API. 
Then in the `.bal` file import the API with `import ballerina.pmml;` Then 
you can use the public functions provided by the API to 

## <a name="using"> Using The API </a>
Add the information about using the API with an example for classification in the iris data set.

## <a name="changes"> Making Changes </a>
Information on contributing to the API should be added here.

## <a name="additional"> Additional Information </a>
Mostly about what features the API does not have. Also a link to the developer documentation.

