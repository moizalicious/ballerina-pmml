# Ballerina PMML API Dev Guide

### Contents
* [Private Functions of the 'ml.pmml' Package](#privateFunctions)
    * [Data Dictionary](#data-dictionary)
        * [getDataDictionary (xml pmml) (xml)](#getDataDictionary)
        * [getDataFieldElements (xml dataDictionary) (xml)](#getDataFieldElements)
        * [getDataFieldElement (xml dataDictionary, int elementNumber) (xml)](#getDataFieldElement)
        * [getNumberOfDataFields (xml dataDictionary) (int)](#getNumberOfDataFields)
        * [getDataFieldElementsWithoutTarget (xml dataDictionary, string targetName) (xml)](#getDataFieldElementsWithoutTarget)
    * [Errors](#errors)
        * [generateError (string msg) (error)](#generateError)
    * [Global](#global)
    * [Mining Schema](#mining-schema)
        * [getMiningSchemaElement (xml modelElement) (xml)](#getMiningSchemaElement)
        * [getMiningFieldElements (xml miningSchema) (xml)](#getMiningFieldElements)
    * [Model](#model)
        * [getModelElement (xml pmml) (xml)](#getModelElement)
    * [PMML Utils](#pmml-utils)
        * [hasChildElement (xml x, string elementName) (boolean)](#hasChildElement)
        * [hasValidModelType (xml pmml) (boolean)](#hasValidModelType)
    * [Regression Model](#regression-model)
        * [predictRegressionModel (xml pmml, xml data) (any)](#predictRegressionModel)
        * [predictLinearRegression (xml pmml, xml data) (any)](#predictLinearRegression)
        * [predictLogisticRegression (xml pmml, xml data) (float)](#predictLogisticRegression)
        * [predictClassification (xml pmml, xml data) (string)](#predictClassification)
        * [getRegressionTableElements (xml modelElement) (xml)](#getRegressionTableElements)
        * [getDependentValue (xml regressionTable, xml data) (float)](#getDependentValue)
* [Writing Test Cases](#writing-test-cases)
    * [Running Tests](#running-tests)
    * [Creating A Test Function](#creating-a-test-function)

### <a name = "privateFunctions"> Private Functions of the 'ml.pmml' Package </a>

#### Data Dictionary
Contains all functions concerning the `<DataDictionary>` and `<DataField>` elements.

##### <a name = "getDataDictionary"> getDataDictionary (xml pmml) (xml) <a/>
* Obtains and returns the `<DataDictionary>` element from the PMML argument.

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
| pmml | **xml** | The `<PMML>` Element |

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
|  | **xml** | The `<DataDictionary>` element |

##### <a name = "getDataFieldElements"> getDataFieldElements (xml dataDictionary) (xml) <a/>
* Obtains and returns the `<DataField>` elements that are inside the `<DataDictionary>`.

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
| dataDictionary | **xml** | The `<DataDictionary>` element of the PMML |

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
|  | **xml** | All `<DataField>` elements in one  |

##### <a name = "getDataFieldElement"> getDataFieldElement (xml dataDictionary, int elementNumber) (xml) </a>
* Obtains and returns a particular `<DataFields>` element from the `<DataDictionary>`.

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
| dataDictionary | **xml** | The `<DataDictionary>` element |
| elementNumber | **int** | The specific `<DataFieldElement>` that is required (starts from 0) |

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
|  | **xml** | The `<DataField>` element |

##### <a name = "getNumberOfDataFields"> getNumberOfDataFields (xml dataDictionary) (int) </a>
* Obtains and returns the number of `<DataField>` elements in the `<DataDictionary>`.

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
| dataDictionary | **xml** | The `<DataDictionary>` element |

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
|  | **int** | The number of `<DataField>` elements |

##### <a name = "getDataFieldElementsWithoutTarget"> getDataFieldElementsWithoutTarget (xml dataDictionary, string targetName) (xml) </a>
* Obtains all the `<DataField>` elements in the `<DataDictionary>` excluding the target which is defined in the PMML.

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
| dataDictionary | **xml** | The `<DataDictionary>` element |
| targetName | **string** | The element name of the target field defined in the PMML |

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
|  | **xml** | The `<DataField>` elements in the `<DataDictionary>` besides the target |

#### Errors
Contains all functions regarding errors in the API. Used to create user defined errors specificaly for the API.

##### <a name = "generateError"> generateError (string msg) (error) </a>
* Used to immediately generate an error in one function call.

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
| msg | **string** | The message that is used to create a new error |

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
|  | **error** | The error generated based on the argument in the 'msg' parameter |

#### Global
Contains all package level variables and constants that are used throughout the internal structure of the API.

* **string[] models** - Holds the element names of all the machine learning models that are supported in PMML version 4.2.

#### Mining Schema
Contains all the functions regarding the `<MiningSchema>` and `<MiningField>` elements.

##### <a name = "getMiningSchemaElement"> getMiningSchemaElement (xml modelElement) (xml) </a>
* Obtains and returns the `<MiningSchema>` element from the model element (i.e the XML element that defines the machine learning model used in the PMML).

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
| modelElement | **xml** | The XML element that defines the machine learning model of the `<PMML>` element |

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
|  | **xml** | The `<MiningSchema>` element |

##### <a name = "getMiningFieldElements"> getMiningFieldElements (xml miningSchema) (xml) </a>
* Obtains and returns all of the `<MiningField>` elements that are in the `<MiningSchema>`.

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
| miningSchema | **xml** | The `<MiningSchema>` element |

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
|  | **xml** | All the `<MiningField>` elements in the `<MiningSchema>` |

#### Model
Contains functions regarding all the machine learning model elements in general that is defined in the PMML.

##### <a name = "getModelElement"> getModelElement (xml pmml) (xml) </a>
* Obtains and returns the element that defines the machine learning model in the `<PMML>` element.

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
| pmml | **xml** | The `<PMML>` element |

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
|  | **xml** | The element that defines the machine learning model used in the `<PMML>` element |

#### PMML Utils
Contains all utility like functions that are needed throughout the API.

##### <a name = "hasChildElement"> hasChildElement (xml x, string elementName) (boolean) </a>
* Checks whether a given XML parameter has a child element of a given element name.

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
| x | **xml** | The given XML argument |
| elementName | **string** | The element name of the child element to be found |

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
|  | **boolean** | Returns **true** if a child element of 'elementName' is found |

##### <a name = "hasValidModelType"> hasValidModelType (xml pmml) (boolean) </a>
* Checks whether a given `<PMML>` element has a valid machine learning model element as it's child element.

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
| pmml | **xml** | The `<PMML>` element |

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
|  | **boolean** | Returns **true** if the `<PMML>` element has a valid machine learning model element |

#### Regression Model
Contains all the functions that are concerned with handling machine learning models defined in the `<RegressionModel>` element.

##### <a name = "predictRegressionModel"> predictRegressionModel (xml pmml, xml data) (any) </a>
* Reads the given `<PMML>` element to find out which type of machine learning model it is using (can be one of 4 types - Linear Regression, Polynomial Regression, Logistic Regression and Classification).

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
| pmml | **xml** | The `<PMML>` element |
| data | **xml** | The independent data values entered by the user |

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
|  | **any** | The result predicted from the data and PMML |

##### <a name = "predictLinearRegression"> predictLinearRegression (xml pmml, xml data) (any) </a>
* Handles linear regression and polynomial regression and returns the predicted result.

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
| pmml | **xml** | The `<PMML>` element |
| data | **xml** | The independent data values entered by the user |

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
|  | **any** | The result predicted from the data and PMML |

##### <a name = "predictLogisticRegression"> predictLogisticRegression (xml pmml, xml data) (float) </a>
* Handles logistic regression and returns the predicted result.

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
| pmml | **xml** | The `<PMML>` element |
| data | **xml** | The independent data values entered by the user |

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
|  | **float** | The result predicted from the data and PMML |

##### <a name = "predictClassification"> predictClassification (xml pmml, xml data) (string) </a>
* Handles classification and returns the predicted result.

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
| pmml | **xml** | The `<PMML>` element |
| data | **xml** | The independent data values entered by the user |

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
|  | **string** | The result predicted from the data and PMML |

##### <a name = "getRegressionTableElements"> getRegressionTableElements (xml modelElement) (xml) </a>
* Obtains and returns the all the `<RegressionTable>` elements that are in the `<RegressionModel>` element.

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
| modelElement | **xml** | The `<RegressionTable>` element |

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
|  | **xml** | All the `<RegressionTable>` elements |

##### <a name = "getDependentValue"> getDependentValue (xml regressionTable, xml data) (float) </a>
* Calculates the predicted value for a specific `<RegressionTable>` element using the independent data provided.

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
| regressionTable | **xml** | The `<RegressionTable>` element |
| data | **xml** | The independent values |

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
|  | **float** | The calculated outcome |

### Writing Test Cases

#### Running Tests
The API has functions that you can use to see whether everything works. To do that open the terminal in you project folder and type the following command to run the test functions,
> ~$ ballerina test ml/pmml/test

#### Creating A Test Function
All the test functions are written in `ml/pmml/test/Tests.bal`. You can edit this file and add your own test functions if you like. After writing your own functions, run the above command to run your tests. *To learn more about the ballerina test API checkout the [Ballerina API Documentation](https://ballerinalang.org/docs/api/0.95.4/).*
