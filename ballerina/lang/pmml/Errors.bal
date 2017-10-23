package ballerina.lang.pmml;

import ballerina.lang.errors;

function invalidPMMLElementError () (errors:Error) {
    errors:Error err = {msg:"not a valid pmml element"};
    return err;
}

function generateError (string msg) (errors:Error) {
    errors:Error err = {msg:msg};
    return err;
}
