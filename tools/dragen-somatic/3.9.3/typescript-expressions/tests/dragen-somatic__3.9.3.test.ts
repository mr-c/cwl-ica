// Standard typescript imports
import { readFileSync } from 'fs';

// CWL Types import
import {Dirent, File} from "../../../../../typescript/lib/mappings/v1.0";
import { FastqListRow } from "../../../../../schemas/fastq-list-row/1.0.0/fastq-list-row__1.0.0";

// Simple functions import
import {
    get_script_path,
    get_fastq_list_csv_path,
    get_tumor_fastq_list_csv_path,

} from "../dragen-somatic__3.9.3";

// Get normal names functions import
import {
    get_normal_name_from_fastq_list_rows,
    get_normal_name_from_fastq_list_csv,
    get_normal_output_prefix
} from "../dragen-somatic__3.9.3"

// Build fastq list csv functions
import {
    build_fastq_list_csv_header,
    get_fastq_list_row_as_csv_row,
    generate_fastq_list_csv
} from "../dragen-somatic__3.9.3"

// Mount points imports
import {
    generate_mount_points
} from "../dragen-somatic__3.9.3"

/*
INPUTS
*/
const FASTQ_LIST_CSV_FILE_PATH: string = "tests/data/fastq_list.csv"
const FASTQ_LIST_REORDERED_CSV_FILE_PATH: string = "tests/data/fastq_list.reordered.csv"
const TUMOR_FASTQ_LIST_CSV_FILE_PATH: string = "tests/data/tumor_fastq_list.csv"

const FASTQ_LIST_CSV_FILE: File = {
    class: "File",
    basename: "fastq_list.csv",
    location: FASTQ_LIST_CSV_FILE_PATH,
    contents: readFileSync(FASTQ_LIST_CSV_FILE_PATH, "utf8")
}

const FASTQ_LIST_REORDERED_CSV_FILE: File = {
    class: "File",
    basename: "fastq_list.csv",
    location: FASTQ_LIST_REORDERED_CSV_FILE_PATH,
    contents: readFileSync(FASTQ_LIST_REORDERED_CSV_FILE_PATH, "utf8")
}

const TUMOR_CSV_FILE: File = {
    class: "File",
    basename: "fastq_list.csv",
    location: TUMOR_FASTQ_LIST_CSV_FILE_PATH,
    contents: readFileSync(TUMOR_FASTQ_LIST_CSV_FILE_PATH, "utf8")
}

const FASTQ_LIST_ROWS: FastqListRow[] = [
  {
      "rgid": "AAAAAAAA.CCCCCCCC.4.MY_RUN_ID.MY_SAMPLE_ID",
      "rglb": "MY_LIBRARY_ID",
      "rgsm": "MY_SAMPLE_ID",
      "lane": 4,
      "read_1": {
          "class": "File",
          "location": "data/MY_SAMPLE_ID_L004_R1_001.fastq.gz"
      },
      "read_2": {
          "class": "File",
          "location": "data/MY_SAMPLE_ID_L004_R2_001.fastq.gz"
      }
  },
  {
      "rgid": "AAAAAAAA.CCCCCCCC.2.MY_RUN_ID.MY_SAMPLE_ID",
      "rglb": "MY_LIBRARY_ID",
      "lane": 2,
      "rgsm": "MY_SAMPLE_ID",
      "read_1": {
          "class": "File",
          "location": "data/MY_SAMPLE_ID_L002_R1_001.fastq.gz"
      },
      "read_2": {
          "class": "File",
          "location": "data/MY_SAMPLE_ID_L002_R2_001.fastq.gz"
      }
  }
]

const EXPECTED_FASTQ_LIST_CSV_OUTPUT: File = {
    class: "File",
    basename: "fastq_list.csv",
    contents: readFileSync(FASTQ_LIST_CSV_FILE_PATH, "utf8")
}

const TUMOR_FASTQ_LIST_ROWS: FastqListRow[] = [
    {
        "rgid": "TTTTTTTT.GGGGGGGG.4.MY_RUN_ID.MY_TUMOR_SAMPLE_ID",
        "rglb": "MY_TUMOR_LIBRARY_ID",
        "rgsm": "MY_TUMOR_SAMPLE_ID",
        "lane": 4,
        "read_1": {
            "class": "File",
            "location": "data/MY_TUMOR_SAMPLE_ID_L004_R1_001.fastq.gz"
        },
        "read_2": {
            "class": "File",
            "location": "data/MY_TUMOR_SAMPLE_ID_L004_R2_001.fastq.gz"
        }
    },
    {
        "rgid": "TTTTTTTT.GGGGGGGG.2.MY_RUN_ID.MY_TUMOR_SAMPLE_ID",
        "rglb": "MY_TUMOR_LIBRARY_ID",
        "lane": 2,
        "rgsm": "MY_TUMOR_SAMPLE_ID",
        "read_1": {
            "class": "File",
            "location": "data/MY_TUMOR_SAMPLE_ID_L002_R1_001.fastq.gz"
        },
        "read_2": {
            "class": "File",
            "location": "data/MY_TUMOR_SAMPLE_ID_L002_R2_001.fastq.gz"
        }
    }
]

const EXPECTED_TUMOR_FASTQ_LIST_CSV_OUTPUT: File = {
    class: "File",
    basename: "fastq_list.csv",
    contents: readFileSync(TUMOR_FASTQ_LIST_CSV_FILE_PATH, "utf8")
}

const HEADER_NAMES: Array<string> = [
    "rglb",
    "rgid",
    "rgsm",
    "read_1",
    "read_2"
]

const EXPECTED_OUTPUT_HEADER_NAMES: string = "RGLB,RGID,RGSM,Read1File,Read2File"

const MOUNT_POINTS_FASTQ_LIST_ROWS_INPUT = {
    fastq_list_rows: FASTQ_LIST_ROWS,
    tumor_fastq_list_rows: TUMOR_FASTQ_LIST_ROWS,
    fastq_list: null,
    tumor_fastq_list: null
}

const MOUNT_POINTS_FASTQ_LIST_CSV_INPUT = {
    fastq_list_rows: null,
    tumor_fastq_list_rows: null,
    fastq_list: FASTQ_LIST_CSV_FILE,
    tumor_fastq_list: TUMOR_CSV_FILE
}


describe('Test Simple Functions', function () {
    // Simple expected outputs
    const expected_get_script_path_output = "run-dragen-script.sh"
    const expected_get_fastq_list_csv_path_output = "fastq_list.csv"
    const expected_get_tumor_fastq_list_csv_path_output = "tumor_fastq_list.csv"

    // Get script path
    test("Test the get script path function", () => {
        expect(get_script_path()).toEqual(expected_get_script_path_output)
    })


    test("Test the get fastq list csv path function", () => {
        expect(get_fastq_list_csv_path()).toEqual(expected_get_fastq_list_csv_path_output)
    })

    test("Test the get tumor fastq list csv path function", () => {
        expect(get_tumor_fastq_list_csv_path()).toEqual(expected_get_tumor_fastq_list_csv_path_output)
    })

});

// Get normal names import
describe('Test the get normal name function suite', function () {
    const expected_rgsm_value = "MY_SAMPLE_ID"
    const fastq_list_as_input = {
        "fastq_list_rows": null,
        "fastq_list": FASTQ_LIST_CSV_FILE
    }
    const fastq_list_rows_as_input = {
        "fastq_list_rows": FASTQ_LIST_ROWS,
        "fastq_list": null
    }

    /*
    Testing from file
    */
    test("Test collecting normal name from the fastq list csv", () => {
        expect(get_normal_name_from_fastq_list_csv(FASTQ_LIST_CSV_FILE)).toEqual(expected_rgsm_value)
    })
    test("Test collecting normal name from the reordered fastq list csv", () => {
        expect(get_normal_name_from_fastq_list_csv(FASTQ_LIST_REORDERED_CSV_FILE)).toEqual(expected_rgsm_value)
    })
    test("Test the get normal output prefix function with fastq list rows as non null", () => {
        expect(get_normal_output_prefix(fastq_list_as_input)).toEqual(expected_rgsm_value)
    })

    /*
    Testing from schema
    */
    test("Test collecting normal name from the fastq list rows csv", () => {
        expect(get_normal_name_from_fastq_list_rows(FASTQ_LIST_ROWS)).toEqual(expected_rgsm_value)
    })
    test("Test the get normal output prefix function with fastq list rows as non null", () => {
        expect(get_normal_output_prefix(fastq_list_rows_as_input)).toEqual(expected_rgsm_value)
    })
});

// Test the fastq list csv builders
describe('Test the fastq list csv builder functions', function () {
    const expected_fastq_list_row_output = [
            "AAAAAAAA.CCCCCCCC.4.MY_RUN_ID.MY_SAMPLE_ID",  // rgid
            "MY_LIBRARY_ID",  // rglb
            "MY_SAMPLE_ID",  // rgsm
            "4",  // lane
            "data/MY_SAMPLE_ID_L004_R1_001.fastq.gz", // read 1 file location
            "data/MY_SAMPLE_ID_L004_R2_001.fastq.gz" // read 2 file location
        ].join(",") + "\n"

    /*
    Header builder test
    */
    test("Build the fastq list csv header test", () => {
        expect(build_fastq_list_csv_header(HEADER_NAMES)).toEqual(EXPECTED_OUTPUT_HEADER_NAMES + "\n")
    })

    /*
    Get the fastq list row as a csv row test
    */
    test("Create a single row of fastq list test", () => {
        expect(
            get_fastq_list_row_as_csv_row(
                FASTQ_LIST_ROWS[0], Object.getOwnPropertyNames(FASTQ_LIST_ROWS[0])
            )
        ).toEqual(expected_fastq_list_row_output)
    })

    /*
    Generate fastq list csv test
    */
    test("Test generated of the fastq list csv file", () => {
        expect(
            generate_fastq_list_csv(FASTQ_LIST_ROWS)
        ).toEqual(EXPECTED_FASTQ_LIST_CSV_OUTPUT)
    })
});

describe('Test generate mount points', function () {
    const expected_mount_points_object: Array<Object> = [ // Array<Dirent> but Dirent typing is broken
        {
            "entryname": "fastq_list.csv",
            "entry": EXPECTED_FASTQ_LIST_CSV_OUTPUT
        },
        {
            "entryname": "tumor_fastq_list.csv",
            "entry": EXPECTED_TUMOR_FASTQ_LIST_CSV_OUTPUT
        }
    ]

    const fastq_list_row_mount_points = generate_mount_points(MOUNT_POINTS_FASTQ_LIST_ROWS_INPUT)

    const fastq_list_csv_mount_points = generate_mount_points(MOUNT_POINTS_FASTQ_LIST_CSV_INPUT)

    test("Test the generate mount points of the tumor and normal fastq list rows", () => {
        expect(
            fastq_list_row_mount_points
        ).toMatchObject(expected_mount_points_object)
    })

    test("Test the generate mount points of the tumor and normal fastq list csv", () => {
        expect(
            fastq_list_csv_mount_points
        ).toMatchObject(expected_mount_points_object)
    })


});



