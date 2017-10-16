package ballerina.lang.pmml;

import ballerina.lang.errors;
import ballerina.lang.strings;

function executeModel (xml pmml, any[] data) {
    if (!isValid(pmml)) {
        throw invalidPMMLFileError();
    }


    // TODO make the identification of the errors better
    string modelType = getModelType(pmml);
    if (strings:contains(modelType, "GeneralRegressionModel")) {
        errors:Error err = {msg:"the model " + modelType + " is currently not supported"};
        throw err;
    } else if (strings:contains(modelType, "RegressionModel")) {
        executeRegressionModel(pmml, data);
    } else {
        errors:Error err = {msg:"the model " + modelType + " execution is currently not supported"};
        throw err;
    }
}
