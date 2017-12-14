# Ballerina PMML API Dev Guide

### Contents
* [Private Functions of 'ballerina.pmml' Package](#private-functions-of-'ballerina.pmml'-package)
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
    * [Creating A Test Function](#creating-a-test-function)
    * [Running Tests](#running-tests)

### Private Functions of 'ballerina.pmml' Package

#### Data Dictionary
* File Information

##### <a name = "getDataDictionary"> getDataDictionary (xml pmml) (xml) <a/>
* Function Description

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

##### <a name = "getDataFieldElements"> getDataFieldElements (xml dataDictionary) (xml) <a/>
* Function Description

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

##### <a name = "getDataFieldElement"> getDataFieldElement (xml dataDictionary, int elementNumber) (xml) </a>
* Function Description

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

##### <a name = "getNumberOfDataFields"> getNumberOfDataFields (xml dataDictionary) (int) </a>
* Function Description

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

##### <a name = "getDataFieldElementsWithoutTarget"> getDataFieldElementsWithoutTarget (xml dataDictionary, string targetName) (xml) </a>
* Function Description

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

#### Errors
* File Information

##### <a name = "generateError"> generateError (string msg) (error) </a>
* Function Description

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

#### Global
* File Information

#### Mining Schema
* File Information

##### <a name = "getMiningSchemaElement"> getMiningSchemaElement (xml modelElement) (xml) </a>
* Function Description

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

##### <a name = "getMiningFieldElements"> getMiningFieldElements (xml miningSchema) (xml) </a>
* Function Description

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

#### Model
* File Information

##### <a name = "getModelElement"> getModelElement (xml pmml) (xml) </a>
* Function Description

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

#### PMML Utils
* File Information

##### <a name = "hasChildElement"> hasChildElement (xml x, string elementName) (boolean) </a>
* Function Description

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

##### <a name = "hasValidModelType"> hasValidModelType (xml pmml) (boolean) </a>
* Function Description

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

#### Regression Model
* File Information

##### <a name = "predictRegressionModel"> predictRegressionModel (xml pmml, xml data) (any) </a>
* Function Description

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

##### <a name = "predictLinearRegression"> predictLinearRegression (xml pmml, xml data) (any) </a>
* Function Description

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

##### <a name = "predictLogisticRegression"> predictLogisticRegression (xml pmml, xml data) (float) </a>
* Function Description

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

##### <a name = "predictClassification"> predictClassification (xml pmml, xml data) (string) </a>
* Function Description

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

##### <a name = "getRegressionTableElements"> getRegressionTableElements (xml modelElement) (xml) </a>
* Function Description

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

##### <a name = "getDependentValue"> getDependentValue (xml regressionTable, xml data) (float) </a>
* Function Description

**Parameters**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

**Returns**

| Parameter Name | Data Type | Description |
| --- | --- | --- |
||||

### Writing Test Cases

#### Creating A Test Function
Add information here

#### Running Tests
Add Information Here
