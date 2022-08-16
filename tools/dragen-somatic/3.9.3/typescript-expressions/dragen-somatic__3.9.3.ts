import {File, PrimitiveType, CommandInputParameter} from "../../../../typescript/lib/mappings/v1.0"
import {Dirent} from "../../../../typescript/lib/mappings/v1.0"
import {FastqListRow} from "../../../../schemas/fastq-list-row/1.0.0/fastq-list-row__1.0.0"


export function get_script_path(): string {
    /*
    Abstract script path, can then be referenced in baseCommand attribute too
    Makes things more readable.
    */
    return "run-dragen-script.sh";
}

export function get_fastq_list_csv_path(): string {
    /*
    The fastq list path must be placed in working directory
    */
    return "fastq_list.csv"
}

export function get_tumor_fastq_list_csv_path(): string {
    /*
    The tumor fastq list path must be placed in working directory
    */
    return "tumor_fastq_list.csv"
}

export function get_normal_name_from_fastq_list_rows(fastq_list_rows: Array<FastqListRow> | null): string | null {
    /*
    Get the normal sample name from the fastq list rows object
    */

    /*
    Check fastq list rows is defined
    */
    if (fastq_list_rows === undefined || fastq_list_rows === null) {
        return null;
    }

    /*
    Get RGSM value and return
    */
    return fastq_list_rows[0].rgsm
}

export function get_normal_name_from_fastq_list_csv(fastq_list_csv: File | null): string | null {
    /*
    Get the normal name from the fastq list csv...
    */

    /*
    Check file is defined
    */
    if (fastq_list_csv === undefined || fastq_list_csv === null) {
        return null;
    }

    /*
    Check contents are defined
    */
    if (fastq_list_csv.contents === null || fastq_list_csv.contents === undefined) {
        return null;
    }

    /*
    Split contents by line
    */
    let contents_by_line: Array<string> = [];
    fastq_list_csv.contents.split("\n").forEach(
        function (line_content) {
            let stripped_line_content = line_content.replace(/(\r\n|\n|\r)/gm,"")
            if (stripped_line_content !== ""){
                contents_by_line.push(stripped_line_content)
            }
        }
    )

    let column_names = contents_by_line[0].split(",")

    /*
    Get RGSM index value (which column is RGSM at?)
    */
    let rgsm_index = column_names.indexOf("RGSM")

    /*
    RGSM is not in index. Return null
    */
    if (rgsm_index === -1) {
        return null;
    }

    /*
    Get RGSM value of first row and return
    */
    return contents_by_line[1].split(",")[rgsm_index]
}

export function get_normal_output_prefix(inputs: { fastq_list_rows: FastqListRow[] | null;  fastq_list: File | null; }): string {
    /*
    Get the normal RGSM value and then add _normal to it
    */
    let normal_name = get_normal_name_from_fastq_list_csv(inputs.fastq_list)

    if ( normal_name !== null) {
        return normal_name
    }

    normal_name = get_normal_name_from_fastq_list_rows(inputs.fastq_list_rows)

    return <string>normal_name
}

export function build_fastq_list_csv_header(header_names: Array<string>): string {
    /*
    Convert lowercase labels to uppercase values
    i.e
    [ "rgid", "rglb", "rgsm", "lane", "read_1", "read_2" ]
    to
    "RGID,RGLB,RGSM,Lane,Read1File,Read2File"
    */
    let modified_header_names: Array<string> = []

    for (let header_name of header_names) {
        if (header_name.indexOf("rg") === 0) {
            /*
            rgid -> RGID
            */
            modified_header_names.push(header_name.toUpperCase())
        } else if (header_name.indexOf("read") === 0) {
            /*
            read_1 -> Read1File
            */
            modified_header_names.push("Read" + header_name.charAt(header_name.length - 1) + "File")
        } else {
            /*
            lane to Lane
            */
            modified_header_names.push(header_name[0].toUpperCase() + header_name.substr(1))
        }
    }

    /*
    Convert array to comma separated strings
    */
    return modified_header_names.join(",") + "\n"
}

export function get_fastq_list_row_as_csv_row(fastq_list_row: FastqListRow, row_order: Array<string>): string {
    let fastq_list_row_values_array: Array<string> = []

    // This for loop is here to ensure were assigning values in the same order as the header
    for (let item_index of row_order) {
        // Find matching attribute in this row
        for (let fastq_list_row_field_name of Object.getOwnPropertyNames(fastq_list_row)) {

            // @ts-ignore - probably need to be doing something better than Object.getOwnPropertyNames here
            let fastq_list_row_field_value = <PrimitiveType | File> fastq_list_row[fastq_list_row_field_name]

            if (fastq_list_row_field_value === null) {
                /*
                Item not found, add an empty attribute for this cell in the csv
                */
                fastq_list_row_values_array.push("")
                continue
            }

            // The header value matches the name in the item
            if (fastq_list_row_field_name === item_index) {
                /*
                If the field value has a class attribute then it's either read_1 or read_2
                */
                if (fastq_list_row_field_value.hasOwnProperty("class")){
                    let fastq_list_row_field_value_file = <File> fastq_list_row_field_value
                    /*
                    Assert that this is actually of class file
                    */
                    if ( fastq_list_row_field_value_file.class !== "File" ) {
                        fastq_list_row_values_array.push("")
                        continue
                    }
                    /*
                    Push the location attribute to the fastq list csv row
                    */
                    fastq_list_row_values_array.push(<string>fastq_list_row_field_value_file.location)
                } else {
                    /*
                    Push the string attribute to the fastq list csv row
                    */
                    fastq_list_row_values_array.push(fastq_list_row_field_value.toString())
                }
                break
            }
        }
    }

    /*
    Convert to string and return as string
    */
    return fastq_list_row_values_array.join(",") + "\n"
}

export function generate_fastq_list_csv(fastq_list_rows: FastqListRow[]): File {
    /*
    Fastq list rows generation
    */
    let fastq_csv_file: File = {
        class: "File",
        basename: get_fastq_list_csv_path()
    }

    /*
    Set the row order
    */
    let row_order: Array<string> = []

    /*
    Set the array order
    Make sure we iterate through all rows of the array
    */
    for (let fastq_list_row of fastq_list_rows) {
        for (let fastq_list_row_field_name of Object.getOwnPropertyNames(fastq_list_row)) {
            if (row_order.indexOf(fastq_list_row_field_name) === -1) {
                row_order.push(fastq_list_row_field_name)
            }
        }
    }

    /*
    Make header
    */
    fastq_csv_file.contents = build_fastq_list_csv_header(row_order)

    /*
    For each fastq list row,
    collect the values of each attribute but in the order of the header
    */
    for (let fastq_list_row of fastq_list_rows) {
        // Add csv row to file contents
        fastq_csv_file.contents += get_fastq_list_row_as_csv_row(fastq_list_row, row_order)
    }

    return fastq_csv_file
}

export function generate_mount_points(inputs: { fastq_list_rows: FastqListRow[] | null; tumor_fastq_list_rows: FastqListRow[] | null; fastq_list: File | null; tumor_fastq_list: File | null; }): Array<Dirent> {
    /*
    Create and add in the fastq list csv for the input fastqs
    */
    const e = [];

    if (inputs.fastq_list_rows !== null) {
        e.push({
            "entryname": get_fastq_list_csv_path(),
            "entry": generate_fastq_list_csv(inputs.fastq_list_rows)
        });
    }

    if (inputs.tumor_fastq_list_rows !== null) {
        e.push({
            "entryname": get_tumor_fastq_list_csv_path(),
            "entry": generate_fastq_list_csv(inputs.tumor_fastq_list_rows)
        });
    }

    if (inputs.fastq_list !== null) {
        e.push({
            "entryname": get_fastq_list_csv_path(),
            "entry": inputs.fastq_list
        });
    }

    if (inputs.tumor_fastq_list !== null) {
        e.push({
            "entryname": get_tumor_fastq_list_csv_path(),
            "entry": inputs.tumor_fastq_list
        });
    }

    /*
    Return file paths
    */
    // @ts-ignore  - Dirent not set up correctly
    return e;
}
