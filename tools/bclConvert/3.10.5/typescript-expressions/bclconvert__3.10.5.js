"use strict";
exports.__esModule = true;
exports.get_fastq_list_rows_from_file = exports.create_samplesheet = exports.create_samplesheet_bclconvert_data_section = exports.get_bclconvert_data_row_as_csv_row = exports.build_bclconvert_data_header = exports.create_nondata_samplesheet_section = exports.convert_bool_to_string_int = exports.key_name_to_camelcase = void 0;
/*
Create a BCLConvert file using Object Orientation
*/
function key_name_to_camelcase(key_name) {
    /*
    Convert index_adapters to IndexAdapters etc
    */
    // Initialise variables
    var key_name_as_array = key_name.split("_");
    var key_name_as_camel_case_array = [];
    // Known regex replacements
    var key_name_iem_regex = /^Iem$/;
    var key_name_iem_replacement = "IEM";
    var key_name_id_regex = /^Id$/;
    var key_name_id_replacement = "ID";
    var umi_regex = /^Umi$/;
    var umi_regex_replacement = "UMI";
    for (var _i = 0, key_name_as_array_1 = key_name_as_array; _i < key_name_as_array_1.length; _i++) {
        var word = key_name_as_array_1[_i];
        var new_word = word.substring(0, 1).toUpperCase() + word.substring(1);
        // Replace strings
        new_word = new_word.replace(key_name_iem_regex, key_name_iem_replacement);
        new_word = new_word.replace(key_name_id_regex, key_name_id_replacement);
        new_word = new_word.replace(umi_regex, umi_regex_replacement);
        // Push new word to new word list
        key_name_as_camel_case_array.push(new_word);
    }
    return key_name_as_camel_case_array.join("");
}
exports.key_name_to_camelcase = key_name_to_camelcase;
function convert_bool_to_string_int(setting_value) {
    /*
    Convert boolean value to a number
    Settings such as CreateFastqForIndexReads require a number as a value
    */
    if (setting_value === undefined || setting_value === null) {
        return null;
    }
    if (setting_value) {
        return "1";
    }
    else {
        return "0";
    }
}
exports.convert_bool_to_string_int = convert_bool_to_string_int;
function create_nondata_samplesheet_section(section_name, section_object) {
    /*
    Create key value pairs for a given section of the samplesheet
    */
    var section_contents = "[".concat(section_name, "]\n");
    for (var _i = 0, _a = Object.getOwnPropertyNames(section_object); _i < _a.length; _i++) {
        var samplesheet_section_key = _a[_i];
        var new_key_name = key_name_to_camelcase(samplesheet_section_key);
        var object_value = section_object[samplesheet_section_key];
        // Check object value exists
        if (object_value === undefined || object_value === null) {
            continue;
        }
        // If object type is a boolean, convert to a "stringint"
        if (typeof object_value === "boolean") {
            object_value = convert_bool_to_string_int(object_value);
        }
        // Otherwise add content to list
        section_contents += "".concat(new_key_name, ",").concat(object_value, "\n");
    }
    // Extra line for good measure
    section_contents += "\n";
    return section_contents;
}
exports.create_nondata_samplesheet_section = create_nondata_samplesheet_section;
function build_bclconvert_data_header(header_names) {
    /*
    Convert lowercase labels to uppercase values
    i.e
    [ "lane", "sample_id", "index", "index2", "sample_project", "override_cycles" ]
    to
    "Lane,SampleID,index,index2,SampleProject,OverrideCycles"
    */
    var modified_header_names = [];
    for (var _i = 0, header_names_1 = header_names; _i < header_names_1.length; _i++) {
        var header_name = header_names_1[_i];
        if (header_name.indexOf("index") === 0) {
            /*
            index -> index, index2 -> index2
            */
            modified_header_names.push(header_name);
        }
        else {
            /*
            lane -> Lane, sample_id -> SampleID, override_cycles -> OverrideCycles
            */
            modified_header_names.push(key_name_to_camelcase(header_name));
        }
    }
    /*
    Convert array to comma separated strings
    */
    return modified_header_names.join(",") + "\n";
}
exports.build_bclconvert_data_header = build_bclconvert_data_header;
function get_bclconvert_data_row_as_csv_row(bclconvert_data_row, row_order) {
    var bclconvert_data_values_array = [];
    // This for loop is here to ensure were assigning values in the same order as the header
    for (var _i = 0, row_order_1 = row_order; _i < row_order_1.length; _i++) {
        var item_index = row_order_1[_i];
        // Find matching attribute in this row
        for (var _a = 0, _b = Object.getOwnPropertyNames(bclconvert_data_row); _a < _b.length; _a++) {
            var bclconvert_data_field_name = _b[_a];
            // @ts-ignore - probably need to be doing something better than Object.getOwnPropertyNames here
            var bclconvert_data_row_field_value = bclconvert_data_row[bclconvert_data_field_name];
            if (bclconvert_data_row_field_value === null) {
                /*
                Item not found, add an empty attribute for this cell in the csv
                */
                bclconvert_data_values_array.push("");
                continue;
            }
            // The header value matches the name in the item
            if (bclconvert_data_field_name === item_index) {
                /*
                If the field value has a class attribute then it's either read_1 or read_2
                */
                bclconvert_data_values_array.push(bclconvert_data_row_field_value.toString());
                break;
            }
        }
    }
    /*
    Convert to string and return as string
    */
    return bclconvert_data_values_array.join(",") + "\n";
}
exports.get_bclconvert_data_row_as_csv_row = get_bclconvert_data_row_as_csv_row;
function create_samplesheet_bclconvert_data_section(samplesheet_bclconvert_data) {
    /*
    Add in header
    */
    var bclconvert_data_contents = "[BCLConvert_Data]\n";
    /*
    Use similar logic to creating the fastq list row,
    Dont assume order or even attributes, just build based on the contents we have
    */
    /*
    Set the row order
    */
    var row_order = [];
    /*
    Set the array order
    Make sure we iterate through all rows of the array
    */
    for (var _i = 0, samplesheet_bclconvert_data_1 = samplesheet_bclconvert_data; _i < samplesheet_bclconvert_data_1.length; _i++) {
        var bclconvert_data_row = samplesheet_bclconvert_data_1[_i];
        for (var _a = 0, _b = Object.getOwnPropertyNames(bclconvert_data_row); _a < _b.length; _a++) {
            var bclconvert_data_field_name = _b[_a];
            if (row_order.indexOf(bclconvert_data_field_name) === -1) {
                row_order.push(bclconvert_data_field_name);
            }
        }
    }
    /*
    Make header
    */
    bclconvert_data_contents += build_bclconvert_data_header(row_order);
    for (var _c = 0, samplesheet_bclconvert_data_2 = samplesheet_bclconvert_data; _c < samplesheet_bclconvert_data_2.length; _c++) {
        var bclconvert_data_row = samplesheet_bclconvert_data_2[_c];
        // Add csv row to file contents
        bclconvert_data_contents += get_bclconvert_data_row_as_csv_row(bclconvert_data_row, row_order);
    }
    /*
    For good measure
    */
    bclconvert_data_contents += "\n";
    return bclconvert_data_contents;
}
exports.create_samplesheet_bclconvert_data_section = create_samplesheet_bclconvert_data_section;
function create_samplesheet(samplesheet) {
    /*
    Build a samplesheet from scratch
    */
    /*
    Initialise the samplesheet object
    */
    var samplesheet_obj = {
        "class": "File",
        "basename": "SampleSheet.csv"
    };
    /*
    Create the header
    */
    samplesheet_obj.contents = create_nondata_samplesheet_section("Header", samplesheet.header);
    /*
    Create the reads section
    */
    samplesheet_obj.contents += create_nondata_samplesheet_section("Reads", samplesheet.reads);
    /*
    Create the BCLConvert settings section
    */
    samplesheet_obj.contents += create_nondata_samplesheet_section("BCLConvert_Settings", samplesheet.bclconvert_settings);
    /*
    Create the BCLConvert data section
    */
    samplesheet_obj.contents += create_samplesheet_bclconvert_data_section(samplesheet.bclconvert_data);
    return samplesheet_obj;
}
exports.create_samplesheet = create_samplesheet;
function get_fastq_list_rows_from_file(fastq_list_csv) {
    /*
    Load inputs initialise output variables
    */
    var output_array = [];
    var lines = fastq_list_csv.contents.split("\n");
    /*
    Generate output object by iterating through fastq_list csv
    */
    var is_first_line = true;
    for (var _i = 0, lines_1 = lines; _i < lines_1.length; _i++) {
        var line = lines_1[_i];
        if (is_first_line) {
            is_first_line = false;
            if (line.trim().indexOf("RGID,RGLB,RGSM,Lane,Read1File") !== 0) {
                throw new Error("Could not confirm that the first line was at least started in the order of RGID,RGLB,RGSM,Lane,Read1File");
            }
            continue;
        }
        if (line.trim() === "") {
            /*
            Empty blank line at the end of the file
            */
            continue;
        }
        var _a = line.trim().split(","), rgid = _a[0], rglb = _a[1], rgsm = _a[2], lane = _a[3], read_1_path = _a[4], read_2_path = _a[5];
        /*
        Initialise the output row as a dict
        */
        var output_fastq_list_row = {
            rgid: rgid,
            rglb: rglb,
            rgsm: rgsm,
            lane: Number(lane),
            read_1: {
                "class": "File",
                "path": read_1_path
            }
        };
        if (read_2_path !== undefined && read_2_path != null && read_2_path !== "") {
            /*
            read 2 path exists
            */
            output_fastq_list_row["read_2"] = {
                "class": "File",
                "path": read_2_path
            };
        }
        /*
        Append to row
        */
        output_array.push(output_fastq_list_row);
    }
    return output_array;
}
exports.get_fastq_list_rows_from_file = get_fastq_list_rows_from_file;
