"use strict";
exports.__esModule = true;
exports.get_bam_file_from_directory = void 0;
function get_bam_file_from_directory(input_dir, bam_nameroot) {
    /*
    Initialise the output file objects
    */
    var output_bam_obj = null;
    var output_bam_index_obj = null;
    /*
    Check the input directory has a listing
    */
    if (input_dir["class"] === undefined || input_dir["class"] !== "Directory") {
        throw new Error("Could not confirm that the first argument was a CWL Directory");
    }
    if (input_dir.listing === undefined || input_dir.listing.length === 0) {
        throw new Error("Could not collect listing from directory ".concat(input_dir.basename));
    }
    /*
    Check that the bam nameroot input is defined
    */
    if (bam_nameroot === undefined || bam_nameroot === null) {
        throw new Error("Did not receive a bam file nameroot as an input");
    }
    /*
    Assign listing as a variable
    */
    var input_listing = input_dir.listing;
    for (var _i = 0, input_listing_1 = input_listing; _i < input_listing_1.length; _i++) {
        var listing_item = input_listing_1[_i];
        if (listing_item["class"] == "File" && listing_item.basename == bam_nameroot + ".bam") {
            /*
            Got the bam file
            */
            output_bam_obj = listing_item;
            break;
        }
    }
    for (var _a = 0, input_listing_2 = input_listing; _a < input_listing_2.length; _a++) {
        var listing_item = input_listing_2[_a];
        if (listing_item["class"] == "File" && listing_item.basename == bam_nameroot + ".bam.bai") {
            /*
            Got the bam file
            */
            output_bam_index_obj = listing_item;
            break;
        }
    }
    if (output_bam_obj === null) {
        throw new Error("Could not find tha bam file ".concat(bam_nameroot, ".bam in the directory ").concat(input_dir));
    }
    if (output_bam_index_obj === null) {
        throw new Error("Could not find tha bam file index ".concat(bam_nameroot, ".bam.bai in the directory ").concat(input_dir));
    }
    output_bam_obj.secondaryFiles = [
        output_bam_index_obj
    ];
    return output_bam_obj;
}
exports.get_bam_file_from_directory = get_bam_file_from_directory;
