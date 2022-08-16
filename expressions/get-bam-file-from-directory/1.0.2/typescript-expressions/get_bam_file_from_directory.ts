import {
    File, Directory
} from "../../../../rabix-cwl-ts/src/mappings/v1.0"

export function get_bam_file_from_directory(input_dir: Directory, bam_nameroot: string): File {
    /*
    Initialise the output file objects
    */
    let output_bam_obj: File | null = null
    let output_bam_index_obj: File | null = null

    /*
    Check the input directory has a listing
    */
    if (input_dir.class === undefined || input_dir.class !== "Directory"){
        throw new Error("Could not confirm that the first argument was a CWL Directory")
    }
    if (input_dir.listing === undefined || input_dir.listing.length === 0){
        throw new Error(`Could not collect listing from directory ${input_dir.basename}`)
    }

    /*
    Check that the bam nameroot input is defined
    */
    if (bam_nameroot === undefined || bam_nameroot === null){
        throw new Error("Did not receive a bam file nameroot as an input")
    }

    /*
    Assign listing as a variable
    */
    const input_listing: (Directory | File)[] = input_dir.listing

    for (const listing_item of input_listing){
        if (listing_item.class == "File" && listing_item.basename == bam_nameroot + ".bam"){
            /*
            Got the bam file
            */
            output_bam_obj = listing_item
            break
        }
    }

    for (const listing_item of input_listing){
        if (listing_item.class == "File" && listing_item.basename == bam_nameroot + ".bam.bai"){
            /*
            Got the bam file
            */
            output_bam_index_obj = listing_item
            break
        }
    }

    if (output_bam_obj === null){
        throw new Error(`Could not find tha bam file ${bam_nameroot}.bam in the directory ${input_dir}`)
    }

    if (output_bam_index_obj === null){
        throw new Error(`Could not find tha bam file index ${bam_nameroot}.bam.bai in the directory ${input_dir}`)
    }

    output_bam_obj.secondaryFiles = [
        output_bam_index_obj
    ]

    return output_bam_obj
}