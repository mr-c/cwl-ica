import {Any} from "../../../typescript/lib/mappings/v1.0";

function get_value_as_str(input_parameter: Any): string {
    if (input_parameter === undefined || input_parameter === null){
        return "";
    } else {
        return input_parameter.toString();
    }
}

function is_not_null(input_object: Any): string {
    if (input_object === undefined || input_object === null){
        return "false";
    } else {
        return "true";
    }
}
