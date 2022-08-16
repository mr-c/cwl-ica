function get_dragen_bin_path() {
    /*
    Return the path of the dragen binary
    */
    return "/opt/edico/bin/dragen";
}
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
function get_ref_mount() {
    /*
    Return the path of where the reference data is to be staged
    */
    return get_scratch_mount() + "ref/";
}
function get_name_root_from_tarball(tar_file) {
    /*
    Get the name of the reference folder
    */
    var tar_ball_regex = /(\S+)\.tar(\.gz)?/g;
    var output_exec = tar_ball_regex.exec(tar_file);
    if (output_exec !== null) {
        return output_exec[1];
    }
    return null;
}
function get_ref_path(input_obj) {
    /*
    Return the path of where the reference data is staged + the reference name
    */
    return get_ref_mount() + get_name_root_from_tarball(input_obj.basename) + "/";
}
function get_dragen_eval_line() {
    /*
    ICA is inconsistent with cwl when it comes to handling @
    */
    return "eval \"" + get_dragen_bin_path() + "\" '\"\$@\"' \n";
}
