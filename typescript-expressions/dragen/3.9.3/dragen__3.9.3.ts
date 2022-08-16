import {File} from "../../../typescript/lib/mappings/v1.0"

function get_dragen_bin_path(): string {
    /*
    Return the path of the dragen binary
    */
    return "/opt/edico/bin/dragen"
}

function get_scratch_mount(): string {
    /*
    Return the path of the scratch directory space
    */
    return "/ephemeral/"
}

function get_intermediate_results_dir(): string {
    /*
    Place of the intermediate results files
    */
    return get_scratch_mount() + "intermediate-results/"
}

function get_ref_mount(): string {
    /*
    Return the path of where the reference data is to be staged
    */
    return get_scratch_mount() + "ref/"
}

function get_name_root_from_tarball(tar_file: string): string | null {
    /*
    Get the name of the reference folder
    */
    const tar_ball_regex: RegExp = /(\S+)\.tar(\.gz)?/g
    let output_exec: RegExpExecArray | null = tar_ball_regex.exec(tar_file)
    if (output_exec !== null){
        return output_exec[1];
    }
    return null
}

function get_ref_path(input_obj: File): string {
    /*
    Return the path of where the reference data is staged + the reference name
    */
    return get_ref_mount() + get_name_root_from_tarball(<string>input_obj.basename) + "/"
}

function get_dragen_eval_line(): string {
    /*
    ICA is inconsistent with cwl when it comes to handling @
    */
    return "eval \"" + get_dragen_bin_path() + "\" '\"\$@\"' \n"
}
