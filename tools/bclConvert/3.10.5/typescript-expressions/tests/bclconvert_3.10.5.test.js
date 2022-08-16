"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
// Imports
var bclconvert__3_10_5_1 = require("../bclconvert__3.10.5");
// Test key_name_to_camelcase
describe('Test key name to camelcase function', function () {
    // Simple expected outputs
    var minimum_adapter_overlap_input = "minimum_adapter_overlap";
    var minimum_adapter_overlap_expected_output = "MinimumAdapterOverlap";
    var iem_input = "iem_file_version";
    var iem_expected_output = "IEMFileVersion";
    var sample_id_input = "sample_id";
    var sample_id_expected_output = "SampleID";
    // Get script path
    test("Test key name to camelcase function 1", function () {
        expect(bclconvert__3_10_5_1.key_name_to_camelcase(minimum_adapter_overlap_input)).toEqual(minimum_adapter_overlap_expected_output);
    });
    test("Test key name to camelcase function 2", function () {
        expect(bclconvert__3_10_5_1.key_name_to_camelcase(iem_input)).toEqual(iem_expected_output);
    });
    test("Test key name to camelcase function 3", function () {
        expect(bclconvert__3_10_5_1.key_name_to_camelcase(sample_id_input)).toEqual(sample_id_expected_output);
    });
});
// Test convert_bool_to_string_int
describe('Test convert bool to string int', function () {
    // Simple expected outputs
    var false_as_bool = false;
    var false_as_int = 0;
    var true_as_bool = true;
    var true_as_int = 1;
    // Get script path
    test("Test convert bool to string int 1", function () {
        expect(bclconvert__3_10_5_1.convert_bool_to_string_int(false_as_bool)).toEqual(false_as_int);
    });
    test("Test convert bool to string int 2", function () {
        expect(bclconvert__3_10_5_1.convert_bool_to_string_int(true_as_bool)).toEqual(true_as_int);
    });
});
// Test create_nondata_samplesheet_section
describe("Test creating samplesheet header with the create_non_data_section function", function () {
    // Input
    var input_header_schema = {
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
    };
    var expected_output_header_str = "[Header]\n" +
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
        "\n";
    test("Test create samplesheet header", function () {
        expect(create(bclconvert__3_10_5_1.create_nondata_samplesheet_section(input_header_schema))).toEqual(expected_output_header_str);
    });
});
// Test build_bclconvert_data_header
// Test get_bclconvert_data_row_as_csv_row
// Test create_samplesheet_bclconvert_data_section
// Test create_samplesheet
// Test get_fastq_list_row_from_file
