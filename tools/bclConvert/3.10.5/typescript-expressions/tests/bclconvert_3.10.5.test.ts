// Imports
import { readFileSync } from 'fs';
import {
    key_name_to_camelcase, convert_bool_to_string_int,
    create_nondata_samplesheet_section,
    build_bclconvert_data_header, create_samplesheet_bclconvert_data_section,
    get_bclconvert_data_row_as_csv_row, create_samplesheet, get_fastq_list_rows_from_file
} from "../bclconvert__3.10.5"
import {
    SampleSheetHeader
} from "../../../../../schemas/samplesheet-header/1.0.0/samplesheet-header__1.0.0";
import {BCLConvertDataRow} from "../../../../../schemas/bclconvert-data-row/3.10.5/bclconvert-data-row__3.10.5";
import {SampleSheetReads} from "../../../../../schemas/samplesheet-reads/1.0.0/samplesheet-reads__1.0.0";
import {BCLConvertSettings} from "../../../../../schemas/bclconvert-settings/3.10.5/bclconvert-settings__3.10.5";
import {SampleSheet} from "../../../../../schemas/samplesheet/1.0.0/samplesheet__1.0.0";
import {File} from "../../../../../typescript/lib/mappings/v1.0";
import {FastqListRow} from "../../../../../schemas/fastq-list-row/1.0.0/fastq-list-row__1.0.0";

// Inputs and outputs for Header section
// Input
const INPUT_HEADER_SECTION_NAME: string = "Header"
const INPUT_HEADER_SECTION_SCHEMA: SampleSheetHeader = {
    "iem_file_version": 2,
    "experiment_name": "Test Input Header Schema",
    "date": "2022-08-07",
    "workflow": "GenerateFastq",
    "application": "NovaSeq Fastq Only",
    "instrument_type": "NovaSeq",
    "assay": "Truseq Nano DNA",
    "index_adapters": "Truseq DNA CD Indexes",
    "chemistry": "Amplicon",
    "file_format_version": 2,
}

const EXPECTED_OUTPUT_HEADER_SECTION_STR: string =
    `[${INPUT_HEADER_SECTION_NAME}]\n` +
    "IEMFileVersion,2\n" +
    "ExperimentName,Test Input Header Schema\n" +
    "Date,2022-08-07\n" +
    "Workflow,GenerateFastq\n" +
    "Application,NovaSeq Fastq Only\n" +
    "InstrumentType,NovaSeq\n" +
    "Assay,Truseq Nano DNA\n" +
    "IndexAdapters,Truseq DNA CD Indexes\n" +
    "Chemistry,Amplicon\n" +
    "FileFormatVersion,2\n" +
    "\n"

// Inputs and outputs for Reads section
const INPUT_READS_SECTION_NAME = "Reads"
const INPUT_READS_SECTION_SCHEMA: SampleSheetReads = {
    read_1_cycles: 151,
    read_2_cycles: 151
}

const EXPECTED_READS_OUTPUT_SECTION_STR =
    `[${INPUT_READS_SECTION_NAME}]\n` +
    "Read1Cycles,151\n" +
    "Read2Cycles,151\n" +
    "\n"


// Inputs and outputs for BCLConvert Settings section
const INPUT_BCLCONVERT_SETTINGS_SECTION_NAME = "BCLConvert_Settings"
const INPUT_BCLCONVERT_SETTINGS_SECTION_SCHEMA: BCLConvertSettings = {
    adapter_read_1: null,
    adapter_read_2: null,
    adapter_behavior: "trim",
    adapter_stringency: 1,
    minimum_adapter_overlap: null,
    barcode_mismatches_index_1: null,
    barcode_mismatches_index_2: null,
    create_fastq_for_index_reads: false,
    minimum_trimmed_read_length: null,
    mask_short_reads: true,
    override_cycles: "Y151;I8;N8;Y151",
    trim_umi: false
}

const EXPECTED_BCLCONVERT_SETTINGS_SECTION_OUTPUT =
    `[${INPUT_BCLCONVERT_SETTINGS_SECTION_NAME}]\n` +
    "AdapterBehavior,trim\n" +
    "AdapterStringency,1\n" +
    "CreateFastqForIndexReads,0\n" +
    "MaskShortReads,1\n" +
    "OverrideCycles,Y151;I8;N8;Y151\n" +
    "TrimUMI,0\n" +
    "\n"

// Inputs and outputs for BCLConvert Data section
const INPUT_BCLCONVERT_DATA_SECTION_NAME = "BCLConvert_Data"
const INPUT_BCLCONVERT_DATA_SECTION_SCHEMA: Array<BCLConvertDataRow> = [
    {
        lane: 1,
        sample_id: "MySampleID",
        index: "AAAAAAAA",
        index2: "GGGGGGGG",
        sample_project: "MySampleProject",
        override_cycles: "Y151;I8;N8;Y151"
    },
    {
        lane: 2,
        sample_id: "MySampleID",
        index2: "GGGGGGGG",
        index: "AAAAAAAA",
        sample_project: "MySampleProject",
        override_cycles: "Y151;I8;N8;Y151"
    }
]

const INPUT_BCLCONVERT_DATA_HEADER_NAMES_ARRAY = [ "lane", "sample_id", "index", "index2", "sample_project", "override_cycles"]
const EXPECTED_BCLCONVERT_DATA_HEADER_OUTPUT_STR = "Lane,SampleID,index,index2,SampleProject,OverrideCycles\n"

const EXPECTED_DATA_ROW_1_STR = "1,MySampleID,AAAAAAAA,GGGGGGGG,MySampleProject,Y151;I8;N8;Y151\n"
const EXPECTED_DATA_ROW_2_STR = "2,MySampleID,AAAAAAAA,GGGGGGGG,MySampleProject,Y151;I8;N8;Y151\n"

const EXPECTED_BCLCONVERT_DATA_OUTPUT_STR =
    `[${INPUT_BCLCONVERT_DATA_SECTION_NAME}]\n` +
    EXPECTED_BCLCONVERT_DATA_HEADER_OUTPUT_STR +
    EXPECTED_DATA_ROW_1_STR +
    EXPECTED_DATA_ROW_2_STR + "\n"

// Test getting fastq list row input
const FASTQ_LIST_CSV_FILE_OUTPUT_FILE_PATH = "tests/data/fastq_list.csv"
const FASTQ_LIST_CSV_OUTPUT_FILE: File = {
    class: "File",
    basename: "fastq_list.csv",
    contents: readFileSync(FASTQ_LIST_CSV_FILE_OUTPUT_FILE_PATH, "utf8")
}
const EXPECTED_OUTPUT_FASTQ_LIST_ROWS: Array<FastqListRow> = [
    {
        rgid: "AAAAAAAA.CCCCCCCC.4.MY_RUN_ID.MY_SAMPLE_ID",
        rglb: "MY_LIBRARY_ID",
        rgsm: "MY_SAMPLE_ID",
        lane: 4,
        read_1: {
            "class": "File",
            "path": "My_Sample_Project/MY_SAMPLE_ID_L004_R1_001.fastq.gz"
        },
        read_2: {
            "class": "File",
            "path": "My_Sample_Project/MY_SAMPLE_ID_L004_R2_001.fastq.gz"
        }
    },
    {
        rgid: "AAAAAAAA.CCCCCCCC.2.MY_RUN_ID.MY_SAMPLE_ID",
        rglb: "MY_LIBRARY_ID",
        rgsm: "MY_SAMPLE_ID",
        lane: 2,
        read_1: {
            "class": "File",
            "path": "My_Sample_Project/MY_SAMPLE_ID_L002_R1_001.fastq.gz"
        },
        read_2: {
            "class": "File",
            "path": "My_Sample_Project/MY_SAMPLE_ID_L002_R2_001.fastq.gz"
        }
    }
]

// Test key_name_to_camelcase
describe('Test key name to camelcase function', function () {
    // Simple expected outputs
    const minimum_adapter_overlap_input = "minimum_adapter_overlap"
    const minimum_adapter_overlap_expected_output = "MinimumAdapterOverlap"

    const iem_input = "iem_file_version"
    const iem_expected_output = "IEMFileVersion"

    const sample_id_input = "sample_id"
    const sample_id_expected_output = "SampleID"

    const trim_umi_input = "trim_umi"
    const trim_umi_expected_output = "TrimUMI"

    // Get script path
    test("Test key name to camelcase function 1", () => {
        expect(
            key_name_to_camelcase(minimum_adapter_overlap_input)
        ).toEqual(
            minimum_adapter_overlap_expected_output
        )
    })

    test("Test key name to camelcase function 2", () => {
        expect(
            key_name_to_camelcase(iem_input)
        ).toEqual(
            iem_expected_output
        )
    })

    test("Test key name to camelcase function 3", () => {
        expect(
            key_name_to_camelcase(sample_id_input)
        ).toEqual(
            sample_id_expected_output
        )
    })

    test("Test key name to camelcase function 4", () => {
        expect(
            key_name_to_camelcase(trim_umi_input)
        ).toEqual(
            trim_umi_expected_output
        )
    })
});


// Test convert_bool_to_string_int
describe('Test convert bool to string int', function () {
    // Simple expected outputs
    const false_as_bool = false
    const false_as_string_int = "0"

    const true_as_bool = true
    const true_as_string_int = "1"

    // Get script path
    test("Test convert bool to string int 1", () => {
        expect(
            convert_bool_to_string_int(false_as_bool)
        ).toEqual(
            false_as_string_int
        )
    })

    test("Test convert bool to string int 2", () => {
        expect(
            convert_bool_to_string_int(true_as_bool)
        ).toEqual(
            true_as_string_int
        )
    })
});

// Test create_nondata_samplesheet_section
describe("Test creating samplesheet header with the create_non_data_section function", function () {


    test("Test create samplesheet header", () => {
        expect(
            create_nondata_samplesheet_section(INPUT_HEADER_SECTION_NAME, INPUT_HEADER_SECTION_SCHEMA)
        ).toEqual(
            EXPECTED_OUTPUT_HEADER_SECTION_STR
        )
    })


    test("Test expected reads samplesheet output", () => {
        expect(
            create_nondata_samplesheet_section(INPUT_READS_SECTION_NAME, INPUT_READS_SECTION_SCHEMA)
        ).toEqual(
            EXPECTED_READS_OUTPUT_SECTION_STR
        )
    })

    test("Test expected bclconvert settings samplesheet output", () => {
        expect(
            create_nondata_samplesheet_section(INPUT_BCLCONVERT_SETTINGS_SECTION_NAME, INPUT_BCLCONVERT_SETTINGS_SECTION_SCHEMA)
        ).toEqual(
            EXPECTED_BCLCONVERT_SETTINGS_SECTION_OUTPUT
        )
    })


})

describe("Test building the bclconvert data section", function () {


    test("Test build bclconvert data header", () => {
        expect(
            build_bclconvert_data_header(INPUT_BCLCONVERT_DATA_HEADER_NAMES_ARRAY)
        ).toEqual(
            EXPECTED_BCLCONVERT_DATA_HEADER_OUTPUT_STR
        )
    })

    test("Test get bclconvert data row as a csv row 1", () => {
        expect(
            get_bclconvert_data_row_as_csv_row(INPUT_BCLCONVERT_DATA_SECTION_SCHEMA[0], INPUT_BCLCONVERT_DATA_HEADER_NAMES_ARRAY)
        ).toEqual(EXPECTED_DATA_ROW_1_STR)
    })

    test("Test get bclconvert data row as a csv row 2", () => {
        expect(
            get_bclconvert_data_row_as_csv_row(INPUT_BCLCONVERT_DATA_SECTION_SCHEMA[1], INPUT_BCLCONVERT_DATA_HEADER_NAMES_ARRAY)
        ).toEqual(EXPECTED_DATA_ROW_2_STR)
    })

    // Test create_samplesheet_bclconvert_data_section
    test("Test create samplesheet bclconvert data section", () => {
        expect(
            create_samplesheet_bclconvert_data_section(INPUT_BCLCONVERT_DATA_SECTION_SCHEMA)
        ).toEqual(EXPECTED_BCLCONVERT_DATA_OUTPUT_STR)
    })
})


// Test create_samplesheet
describe('Test Create SampleSheet', function () {
    const samplesheet_input: SampleSheet = {
        header: INPUT_HEADER_SECTION_SCHEMA,
        reads: INPUT_READS_SECTION_SCHEMA,
        bclconvert_settings: INPUT_BCLCONVERT_SETTINGS_SECTION_SCHEMA,
        bclconvert_data: INPUT_BCLCONVERT_DATA_SECTION_SCHEMA
    }

    const expected_samplesheet_output_str =
        EXPECTED_OUTPUT_HEADER_SECTION_STR +
        EXPECTED_READS_OUTPUT_SECTION_STR +
        EXPECTED_BCLCONVERT_SETTINGS_SECTION_OUTPUT +
        EXPECTED_BCLCONVERT_DATA_OUTPUT_STR

    const expected_samplesheet_output_file: File = {
        class: "File",
        basename: "SampleSheet.csv",
        contents: expected_samplesheet_output_str
    }

    test("Test Create SampleSheet", () => {
        expect(
            create_samplesheet(samplesheet_input)
        ).toEqual(
            expected_samplesheet_output_file
        )
    })
});


// Test get_fastq_list_row_from_file
describe('Test get fastq list row from csv', function () {
    const fastq_list_rows: Array<FastqListRow> = get_fastq_list_rows_from_file(
        FASTQ_LIST_CSV_OUTPUT_FILE
    )

    test("Test Get Fastq List Row", () => {
        expect(
            fastq_list_rows
        ).toMatchObject(
            EXPECTED_OUTPUT_FASTQ_LIST_ROWS
        )
    })
});
