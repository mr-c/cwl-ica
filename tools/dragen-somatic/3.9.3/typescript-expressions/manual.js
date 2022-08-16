"use strict";
exports.__esModule = true;
function get_dragen_bin_path() {
    /*
    Return the path of the dragen binary
    */
    return "/opt/edico/bin/dragen";
}
exports.get_dragen_bin_path = get_dragen_bin_path;
function get_scratch_mount() {
    /*
    Return the path of the scratch directory space
    */
    return "/ephemeral/";
}
function get_intermediate_results_dir() {
    /*
    Place of the intermediate results files
    */
    return get_scratch_mount() + "intermediate-results/";
}
