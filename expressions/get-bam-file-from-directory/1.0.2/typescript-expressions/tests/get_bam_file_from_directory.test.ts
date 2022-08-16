import { Directory } from "../../../../../rabix-cwl-ts/src/mappings/v1.0"
import { File } from "../../../../../rabix-cwl-ts/src/mappings/v1.0"
import {
    get_bam_file_from_directory
} from "../get_bam_file_from_directory";

// Test the get bam file from directory
const INPUT_BAM_FILE_NAMEROOT = "footest"
const INPUT_BAM_FILE_NAMEEXT = ".bam"
const INPUT_BAM_FILE_BASENAME = INPUT_BAM_FILE_NAMEROOT + INPUT_BAM_FILE_NAMEEXT
const INPUT_OUTPUT_DIRECTORY_LOCATION = "outputs/output-directory"

// When in the top directory
const INPUT_SHALLOW_LISTING: Directory = {
    class: "Directory",
    location: `${INPUT_OUTPUT_DIRECTORY_LOCATION}`,
    listing: [
        {
            class: "File",
            basename: "index.html",
            nameroot: "index",
            nameext: ".html",
            location: `${INPUT_OUTPUT_DIRECTORY_LOCATION}/index.html`
        },
        {
            class: "File",
            basename: INPUT_BAM_FILE_BASENAME,
            nameroot: INPUT_BAM_FILE_NAMEROOT,
            nameext: INPUT_BAM_FILE_NAMEEXT,
            location: `${INPUT_OUTPUT_DIRECTORY_LOCATION}/${INPUT_BAM_FILE_BASENAME}`
        },
        {
            class: "File",
            basename: `${INPUT_BAM_FILE_BASENAME}.bai`,
            nameroot: INPUT_BAM_FILE_BASENAME,
            nameext: ".bai",
            location: `${INPUT_OUTPUT_DIRECTORY_LOCATION}/${INPUT_BAM_FILE_BASENAME}.bai`
        },
        {
            class: "File",
            basename: "logs.txt",
            nameroot: "logs",
            nameext: ".txt",
            location: `${INPUT_OUTPUT_DIRECTORY_LOCATION}/logs.txt`
        }
    ]
}

const EXPECTED_SHALLOW_LISTING_OUTPUT_BAM_FILE: File = {
    class: "File",
    basename: INPUT_BAM_FILE_BASENAME,
    nameroot: INPUT_BAM_FILE_NAMEROOT,
    nameext: INPUT_BAM_FILE_NAMEEXT,
    location: `${INPUT_OUTPUT_DIRECTORY_LOCATION}/${INPUT_BAM_FILE_BASENAME}`,
    secondaryFiles: [
        {
            class: "File",
            basename: `${INPUT_BAM_FILE_BASENAME}.bai`,
            nameroot: INPUT_BAM_FILE_BASENAME,
            nameext: ".bai",
            location: `${INPUT_OUTPUT_DIRECTORY_LOCATION}/${INPUT_BAM_FILE_BASENAME}.bai`
        }
    ]
}


describe('Test Shallow Directory Listing', function () {
    // Get script path
    test("Test the get bam file from directory function non-recursively", () => {
        expect(
            get_bam_file_from_directory(INPUT_SHALLOW_LISTING, INPUT_BAM_FILE_NAMEROOT)
        ).toMatchObject(EXPECTED_SHALLOW_LISTING_OUTPUT_BAM_FILE)
    })
});

