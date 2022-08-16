export function get_dragen_bin_path(): string {
    /*
    Return the path of the dragen binary
    */
    return "/opt/edico/bin/dragen";
}

function get_scratch_mount(): string {
    /*
    Return the path of the scratch directory space
    */
    return "/ephemeral/";
}

function get_intermediate_results_dir(): string {
    /*
    Place of the intermediate results files
    */
    return get_scratch_mount() + "intermediate-results/"
}