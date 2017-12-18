package ml.pmml;

function generateError (string msg) (error) {
    // A Quick function to create an error variable using the string argument provided.
    error err = {msg:msg};
    return err;
}
