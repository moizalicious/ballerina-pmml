package ballerina.lang.pmml;

import ballerina.lang.errors;

function invalidPMMLFileError () (errors:Error) {
    errors:Error err = {msg:"not a valid pmml element"};
    return err;
}
