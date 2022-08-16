function get_value_as_str(input_parameter) {
    if (input_parameter === undefined || input_parameter === null) {
        return "";
    }
    else {
        return input_parameter.toString();
    }
}
function is_not_null(input_object) {
    if (input_object === undefined || input_object === null) {
        return "false";
    }
    else {
        return "true";
    }
}
