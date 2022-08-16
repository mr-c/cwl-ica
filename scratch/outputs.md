# (typing.Dict,) Examples
#### samplesheet__1.0.0.yaml/bclconvert_data
```json
{   "items": {   "$import": "../../../schemas/bclconvert-data-row/3.10.5/bclconvert-data-row__3.10.5.yaml#bclconvert-data-row"},
    "type": "array"}
```
* Is optional?
* Optional = False
* Array True;
New input type detected post eval:
```
{"$import": "../../../schemas/bclconvert-data-row/3.10.5/bclconvert-data-row__3.10.5.yaml#bclconvert-data-row"}
```
Add extra interface: False
Import of interface required True
------------------

### End (typing.Dict,) EXAMPLES ###
# typing.List Examples
#### custom-output-dir-entry__2.0.0.yaml/copy_method
```json
[ordereddict([("type", "enum"), ("symbols", ["sub_dir", "top_dir"])])]
```
* Is optional?
* Optional = False
* Array False;
Add extra interface: False
Import of interface required False
------------------

#### samplesheet__1.0.0.yaml/header
```json
[ordereddict([("$import", "../../../schemas/samplesheet-header/1.0.0/samplesheet-header__1.0.0.yaml#samplesheet-header")])]
```
* Is optional?
* Optional = False
* Array False;
Add extra interface: False
Import of interface required True
------------------

#### samplesheet__1.0.0.yaml/reads
```json
[ordereddict([("$import", "../../../schemas/samplesheet-reads/1.0.0/samplesheet-reads__1.0.0.yaml#samplesheet-reads")])]
```
* Is optional?
* Optional = False
* Array False;
Add extra interface: False
Import of interface required True
------------------

#### samplesheet__1.0.0.yaml/bclconvert_settings
```json
[ordereddict([("$import", "../../../schemas/bclconvert-settings/3.10.5/bclconvert-settings__3.10.5.yaml#bclconvert-settings")])]
```
* Is optional?
* Optional = False
* Array False;
Add extra interface: False
Import of interface required True
------------------

#### settings-by-samples__1.0.0.yaml/settings
```json
["null", ordereddict([("type", "record"), ("name", "settings"), ("fields", ordereddict([("adapter_read_1", ordereddict([("label", "adapter read 1"), ("doc", "The sequence of the Read 1\nadapter to be masked or trimmed.\nTo trim multiple adapters, separate\nthe sequences with a plus sign (+)\nto indicate independent adapters\nthat must be independently\nassessed for masking or trimming\nfor each read.\nAllowed characters: A, T, C, G.\n"), ("type", "string?")])), ("adapter_read_2", ordereddict([("label", "adapter read 2"), ("doc", "The sequence of the Read 2\nadapter to be masked or trimmed.\nTo trim multiple adapters, separate\nthe sequences with a plus sign (+)\nto indicate independent adapters\nthat must be independently\nassessed for masking or trimming\nfor each read.\nAllowed characters: A, T, C, G.\n"), ("type", "string?")])), ("adapter_behavior", ordereddict([("label", "adapter behavior"), ("doc", "Defines whether the software\nmasks or trims Read 1 and/or\nRead 2 adapter sequence(s).\nWhen AdapterRead1 or\nAdapterRead2 is not specified, this\nsetting cannot be specified.\n• mask—The software masks the\nidentified Read 1 and/or Read 2\nsequence(s) with N.\n• trim—The software trims the\nidentified Read 1 and/or Read 2\nsequence(s)\n"), ("type", ["null", ordereddict([("type", "enum"), ("symbols", ["mask", "trim"])])])])), ("adapter_stringency", ordereddict([("label", "adapter stringency"), ("doc", "he minimum match rate that\ntriggers masking or trimming. This\nvalue is calculated as MatchCount\n/ (MatchCount+MismatchCount).\nAccepted values are 0.5–1. The\ndefault value of 0.9 indicates that\nonly reads with ≥ 90% sequence\nidentity with the adapter are\ntrimmed.\n"), ("type", "float?")])), ("minimum_adapter_overlap", ordereddict([("label", "minumum adapter overlap"), ("doc", "Do not trim any bases unless the\nadapter matches are greater than\nor equal to the user specified\nnumber of bases. At least one\nAdapterRead1 or\nAdapterRead2 must be specified\nto use\nMinimumAdapterOverlap.\nAllowed characters: 1, 2, 3.\n"), ("type", "int?")])), ("barcode_mismatches_index_1", ordereddict([("label", "barcode mismatches index 1"), ("doc", "The number of mismatches\nallowed for index1. Accepted\nvalues are 0, 1, or 2.\n"), ("type", "int?")])), ("barcode_mismatches_index_2", ordereddict([("label", "barcode mismatches index 2"), ("doc", "The number of mismatches\nallowed for index2. Accepted\nvalues are 0, 1, or 2.\n"), ("type", "int?")])), ("create_fastq_for_index_reads", ordereddict([("label", "create fastq for index reads"), ("doc", "Specifies whether software will\noutput fastqs for index reads. If\nindex reads are defined as a\nUMI then fastqs for the UMI will\nbe output (if TrimUMI is also set\nto 0). At least 1 index read must\nbe specified in the sample\nsheet.\n• 0—Fastq files will not be output\nfor index reads.\n• 1—Fastq files will be output for\nfastq reads.\n"), ("type", "boolean?")])), ("minimum_trimmed_read_length", ordereddict([("label", "minimum trimmed read length"), ("doc", "The minimum read length after\nadapter trimming. The software\ntrims adapter sequences from\nreads to the value of this\nparameter. Bases below the\nspecified value are masked with\nN.\n"), ("type", "int?")])), ("mask_short_reads", ordereddict([("label", "mask short reads"), ("doc", "The minimum read length\ncontaining A, T, C, G values after\nadapter trimming. Reads with\nless than this number of bases\nbecome completely masked. If\nthis value is less than 22, the\ndefault becomes the\nMinimumTrimmedReadLength.\n"), ("type", "int?")])), ("override_cycles", ordereddict([("label", "override cycles"), ("doc", "Specifies the sequencing and\nindexing cycles that should be\nused when processing the data.\nThe following format must be\nused:\n* Must be same number of\nsemicolon delimited fields in\nstring as sequencing and\nindexing reads specified in\nRunInfo.xml\n* Indexing reads are specified\nwith an I.\n* Sequencing reads are specified\nwith a Y. UMI cycles are\nspecified with an U.\n* Trimmed reads are specified\nwith N.\n* The number of cycles specified\nfor each read must sum to the\nnumber of cycles specified for\nthat read in the RunInfo.xml.\n* Only one Y or I sequence can\nbe specified per read.\nExample: Y151;I8;I8;Y151\n"), ("type", "string?")])), ("trim_umi", ordereddict([("label", "trim umi"), ("doc", "Specifies whether UMI cycles\nwill be excluded from fastq files.\nAt least one UMI is required to\nbe specified in the Sample\nSheet when this setting is\nprovided.\n• 0—UMI cycles will be output to\nfastq files.\n• 1— UMI cycles will not be\noutput to fastq files.\n"), ("type", "boolean?")]))]))])]
```
* Is optional?
* Optional = True
* Array False;
New input type detected post eval:
```
[{"fields": {"adapter_behavior": {"doc": "Defines whether the software\n"
                                         "masks or trims Read 1 and/or\n"
                                         "Read 2 adapter sequence(s).\n"
                                         "When AdapterRead1 or\n"
                                         "AdapterRead2 is not specified, this\n"
                                         "setting cannot be specified.\n"
                                         "• mask—The software masks the\n"
                                         "identified Read 1 and/or Read 2\n"
                                         "sequence(s) with N.\n"
                                         "• trim—The software trims the\n"
                                         "identified Read 1 and/or Read 2\n"
                                         "sequence(s)\n",
                                  "label": "adapter behavior",
                                  "type": ["null", ordereddict([("type", "enum"), ("symbols", ["mask", "trim"])])]},
             "adapter_read_1": {"doc": "The sequence of the Read 1\n"
                                       "adapter to be masked or trimmed.\n"
                                       "To trim multiple adapters, separate\n"
                                       "the sequences with a plus sign (+)\n"
                                       "to indicate independent adapters\n"
                                       "that must be independently\n"
                                       "assessed for masking or trimming\n"
                                       "for each read.\n"
                                       "Allowed characters: A, T, C, G.\n",
                                "label": "adapter read 1",
                                "type": "string?"},
             "adapter_read_2": {"doc": "The sequence of the Read 2\n"
                                       "adapter to be masked or trimmed.\n"
                                       "To trim multiple adapters, separate\n"
                                       "the sequences with a plus sign (+)\n"
                                       "to indicate independent adapters\n"
                                       "that must be independently\n"
                                       "assessed for masking or trimming\n"
                                       "for each read.\n"
                                       "Allowed characters: A, T, C, G.\n",
                                "label": "adapter read 2",
                                "type": "string?"},
             "adapter_stringency": {"doc": "he minimum match rate that\n"
                                           "triggers masking or trimming. "
                                           "This\n"
                                           "value is calculated as MatchCount\n"
                                           "/ (MatchCount+MismatchCount).\n"
                                           "Accepted values are 0.5–1. The\n"
                                           "default value of 0.9 indicates "
                                           "that\n"
                                           "only reads with ≥ 90% sequence\n"
                                           "identity with the adapter are\n"
                                           "trimmed.\n",
                                    "label": "adapter stringency",
                                    "type": "float?"},
             "barcode_mismatches_index_1": {"doc": "The number of mismatches\n"
                                                   "allowed for index1. "
                                                   "Accepted\n"
                                                   "values are 0, 1, or 2.\n",
                                            "label": "barcode mismatches index "
                                                     "1",
                                            "type": "int?"},
             "barcode_mismatches_index_2": {"doc": "The number of mismatches\n"
                                                   "allowed for index2. "
                                                   "Accepted\n"
                                                   "values are 0, 1, or 2.\n",
                                            "label": "barcode mismatches index "
                                                     "2",
                                            "type": "int?"},
             "create_fastq_for_index_reads": {"doc": "Specifies whether "
                                                     "software will\n"
                                                     "output fastqs for index "
                                                     "reads. If\n"
                                                     "index reads are defined "
                                                     "as a\n"
                                                     "UMI then fastqs for the "
                                                     "UMI will\n"
                                                     "be output (if TrimUMI is "
                                                     "also set\n"
                                                     "to 0). At least 1 index "
                                                     "read must\n"
                                                     "be specified in the "
                                                     "sample\n"
                                                     "sheet.\n"
                                                     "• 0—Fastq files will not "
                                                     "be output\n"
                                                     "for index reads.\n"
                                                     "• 1—Fastq files will be "
                                                     "output for\n"
                                                     "fastq reads.\n",
                                              "label": "create fastq for index "
                                                       "reads",
                                              "type": "boolean?"},
             "mask_short_reads": {"doc": "The minimum read length\n"
                                         "containing A, T, C, G values after\n"
                                         "adapter trimming. Reads with\n"
                                         "less than this number of bases\n"
                                         "become completely masked. If\n"
                                         "this value is less than 22, the\n"
                                         "default becomes the\n"
                                         "MinimumTrimmedReadLength.\n",
                                  "label": "mask short reads",
                                  "type": "int?"},
             "minimum_adapter_overlap": {"doc": "Do not trim any bases unless "
                                                "the\n"
                                                "adapter matches are greater "
                                                "than\n"
                                                "or equal to the user "
                                                "specified\n"
                                                "number of bases. At least "
                                                "one\n"
                                                "AdapterRead1 or\n"
                                                "AdapterRead2 must be "
                                                "specified\n"
                                                "to use\n"
                                                "MinimumAdapterOverlap.\n"
                                                "Allowed characters: 1, 2, "
                                                "3.\n",
                                         "label": "minumum adapter overlap",
                                         "type": "int?"},
             "minimum_trimmed_read_length": {"doc": "The minimum read length "
                                                    "after\n"
                                                    "adapter trimming. The "
                                                    "software\n"
                                                    "trims adapter sequences "
                                                    "from\n"
                                                    "reads to the value of "
                                                    "this\n"
                                                    "parameter. Bases below "
                                                    "the\n"
                                                    "specified value are "
                                                    "masked with\n"
                                                    "N.\n",
                                             "label": "minimum trimmed read "
                                                      "length",
                                             "type": "int?"},
             "override_cycles": {"doc": "Specifies the sequencing and\n"
                                        "indexing cycles that should be\n"
                                        "used when processing the data.\n"
                                        "The following format must be\n"
                                        "used:\n"
                                        "* Must be same number of\n"
                                        "semicolon delimited fields in\n"
                                        "string as sequencing and\n"
                                        "indexing reads specified in\n"
                                        "RunInfo.xml\n"
                                        "* Indexing reads are specified\n"
                                        "with an I.\n"
                                        "* Sequencing reads are specified\n"
                                        "with a Y. UMI cycles are\n"
                                        "specified with an U.\n"
                                        "* Trimmed reads are specified\n"
                                        "with N.\n"
                                        "* The number of cycles specified\n"
                                        "for each read must sum to the\n"
                                        "number of cycles specified for\n"
                                        "that read in the RunInfo.xml.\n"
                                        "* Only one Y or I sequence can\n"
                                        "be specified per read.\n"
                                        "Example: Y151;I8;I8;Y151\n",
                                 "label": "override cycles",
                                 "type": "string?"},
             "trim_umi": {"doc": "Specifies whether UMI cycles\n"
                                 "will be excluded from fastq files.\n"
                                 "At least one UMI is required to\n"
                                 "be specified in the Sample\n"
                                 "Sheet when this setting is\n"
                                 "provided.\n"
                                 "• 0—UMI cycles will be output to\n"
                                 "fastq files.\n"
                                 "• 1— UMI cycles will not be\n"
                                 "output to fastq files.\n",
                          "label": "trim umi",
                          "type": "boolean?"}},
  "name": "settings",
  "type": "record"}]
```
Add extra interface: True
Import of interface required False
------------------

#### tso500-sample__1.0.0.yaml/sample_type
```json
[ordereddict([("type", "enum"), ("symbols", ["DNA", "RNA"])])]
```
* Is optional?
* Optional = False
* Array False;
Add extra interface: False
Import of interface required False
------------------

### End typing.List EXAMPLES ###
# <class "str"> Examples
#### bclconvert-data-row__3.10.5.yaml/lane
```json
"int"
```
* Is optional?
* Optional = False
* Array False;
------------------

#### bclconvert-data-row__3.10.5.yaml/sample_id
```json
"string"
```
* Is optional?
* Optional = False
* Array False;
------------------

#### bclconvert-data-row__3.10.5.yaml/index2
```json
"string?"
```
* Is optional?
* Optional = True
* Array False;
New input type detected post eval:
```
"string"
```
------------------

#### bclconvert-settings__3.10.5.yaml/minimum_adapter_overlap
```json
"int?"
```
* Is optional?
* Optional = True
* Array False;
New input type detected post eval:
```
"int"
```
------------------

#### bclconvert-settings__3.10.5.yaml/create_fastq_for_index_reads
```json
"boolean?"
```
* Is optional?
* Optional = True
* Array False;
New input type detected post eval:
```
"boolean"
```
------------------

#### custom-output-dir-entry__2.0.0.yaml/dir
```json
"Directory?"
```
* Is optional?
* Optional = True
* Array False;
New input type detected post eval:
```
"Directory"
```
------------------

#### custom-output-dir-entry__2.0.0.yaml/files_list_str
```json
"string[]?"
```
* Is optional?
* Optional = True
* Array True;
New input type detected post eval:
```
"string"
```
------------------

#### custom-output-dir-entry__2.0.0.yaml/file_list
```json
"File[]?"
```
* Is optional?
* Optional = True
* Array True;
New input type detected post eval:
```
"File"
```
------------------

#### custom-output-dir-entry__2.0.0.yaml/tarball
```json
"File?"
```
* Is optional?
* Optional = True
* Array False;
New input type detected post eval:
```
"File"
```
------------------

#### fastq-list-row__1.0.0.yaml/read_1
```json
"File"
```
* Is optional?
* Optional = False
* Array False;
------------------

#### settings-by-samples__1.0.0.yaml/samples
```json
"string[]"
```
* Is optional?
* Optional = False
* Array True;
New input type detected post eval:
```
"string"
```
------------------

#### tso500-outputs-by-sample__1.0.0.yaml/results_dir
```json
"Directory"
```
* Is optional?
* Optional = False
* Array False;
------------------

### End <class "str"> EXAMPLES ###
This is the output from the schema_to_json script for ../schemas/bclconvert-data-row/3.10.5/bclconvert-data-row__3.10.5.yaml
```json
{"fields": [{"doc": "index\n",
             "label": "index",
             "name": "#bclconvert-data-row__3.10.5.yaml/bclconvert-data-row/index",
             "type": "string"},
            {"doc": "index2\n",
             "label": "index2",
             "name": "#bclconvert-data-row__3.10.5.yaml/bclconvert-data-row/index2",
             "type": ["null", "string"]},
            {"doc": "lane\n",
             "label": "lane",
             "name": "#bclconvert-data-row__3.10.5.yaml/bclconvert-data-row/lane",
             "type": "int"},
            {"doc": "Per-sample override cycles settings\n",
             "label": "override cycles",
             "name": "#bclconvert-data-row__3.10.5.yaml/bclconvert-data-row/override_cycles",
             "type": "string"},
            {"doc": "sample_id\n",
             "label": "sample_id",
             "name": "#bclconvert-data-row__3.10.5.yaml/bclconvert-data-row/sample_id",
             "type": "string"},
            {"doc": "sample_project\n",
             "label": "sample_project",
             "name": "#bclconvert-data-row__3.10.5.yaml/bclconvert-data-row/sample_project",
             "type": "string"}],
 "id": "#bclconvert-data-row__3.10.5.yaml",
 "name": "#bclconvert-data-row__3.10.5.yaml/bclconvert-data-row",
 "type": "record"}
```
This is the output from the schema_to_json script for ../schemas/bclconvert-settings/3.10.5/bclconvert-settings__3.10.5.yaml
```json
{"fields": [{"doc": "adapter_behavior\n",
             "label": "adapter_behavior",
             "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/adapter_behavior",
             "type": ["null", "string"]},
            {"doc": "adapter_read_1\n",
             "label": "adapter_read_1",
             "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/adapter_read_1",
             "type": ["null", "string"]},
            {"doc": "adapter_read_2\n",
             "label": "adapter_read_2",
             "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/adapter_read_2",
             "type": ["null", "string"]},
            {"doc": "adapter_stringency\n",
             "label": "adapter_stringency",
             "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/adapter_stringency",
             "type": ["null", "string"]},
            {"doc": "barcode_mismatches_index_1\n",
             "label": "barcode_mismatches_index_1",
             "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/barcode_mismatches_index_1",
             "type": ["null", "int"]},
            {"doc": "barcode_mismatches_index_2\n",
             "label": "barcode_mismatches_index_2",
             "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/barcode_mismatches_index_2",
             "type": ["null", "int"]},
            {"doc": "create_fastq_for_index_reads\n",
             "label": "create_fastq_for_index_reads",
             "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/create_fastq_for_index_reads",
             "type": ["null", "boolean"]},
            {"doc": "mask_short_reads\n",
             "label": "mask_short_reads",
             "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/mask_short_reads",
             "type": ["null", "string"]},
            {"doc": "minimum_adapter_overlap\n",
             "label": "minimum_adapter_overlap",
             "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/minimum_adapter_overlap",
             "type": ["null", "int"]},
            {"doc": "minimum_trimmed_read_length\n",
             "label": "minimum_trimmed_read_length",
             "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/minimum_trimmed_read_length",
             "type": ["null", "int"]},
            {"doc": "override_cycles\n",
             "label": "override_cycles",
             "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/override_cycles",
             "type": ["null", "string"]},
            {"doc": "trim_umi\n",
             "label": "trim_umi",
             "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/trim_umi",
             "type": ["null", "boolean"]}],
 "id": "#bclconvert-settings__3.10.5.yaml",
 "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings",
 "type": "record"}
```
This is the output from the schema_to_json script for ../schemas/contig/1.0.0/contig__1.0.0.yaml
```json
{"fields": [{"doc": "The name of the chromosome\n",
             "label": "chromosome",
             "name": "#contig__1.0.0.yaml/contig/chromosome",
             "type": "string"},
            {"doc": "The end position of the chromosome of the region\n",
             "label": "end position",
             "name": "#contig__1.0.0.yaml/contig/end",
             "type": ["null", "int"]},
            {"doc": "The start position of the chromosome of the region\n",
             "label": "start position",
             "name": "#contig__1.0.0.yaml/contig/start",
             "type": ["null", "int"]}],
 "id": "#contig__1.0.0.yaml",
 "name": "#contig__1.0.0.yaml/contig",
 "type": "record"}
```
This is the output from the schema_to_json script for ../schemas/custom-output-dir-entry/2.0.0/custom-output-dir-entry__2.0.0.yaml
```json
{"fields": [{"doc": "The name of the collection,\n"
                    "This is required if "file_list" is set AND "copy_method" "
                    "is set to "sub_dir"\n",
             "label": "collection name",
             "name": "#custom-output-dir-entry__2.0.0.yaml/custom-output-dir-entry/collection_name",
             "type": ["null", "string"]},
            {"doc": "Do you want these files / directories as a sub directory "
                    "or in the top directory?\n",
             "label": "copy method",
             "name": "#custom-output-dir-entry__2.0.0.yaml/custom-output-dir-entry/copy_method",
             "type": [{"symbols": ["#custom-output-dir-entry__2.0.0.yaml/custom-output-dir-entry/copy_method/sub_dir",
                                   "#custom-output-dir-entry__2.0.0.yaml/custom-output-dir-entry/copy_method/top_dir"],
                       "type": "enum"}]},
            {"doc": "A directory object, when using this field, one may also "
                    "specify the files_str method to pull out only\n"
                    "certain files from the directory, file_str may reference "
                    "a file in a subfolder, and the subfolder structure will\n"
                    "be maintained even if copy_method is set to "top_dir"\n",
             "label": "dir",
             "name": "#custom-output-dir-entry__2.0.0.yaml/custom-output-dir-entry/dir",
             "type": ["null", "Directory"]},
            {"doc": "A list of files, will be placed into the top directory "
                    "unless "collection_name" is specified and\n"
                    "copy method is set to "sub_dir"\n",
             "label": "file list",
             "name": "#custom-output-dir-entry__2.0.0.yaml/custom-output-dir-entry/file_list",
             "type": ["null", {"items": "File", "type": "array"}]},
            {"doc": "A list of files for "dir". If not specified the entire "
                    "directory will be copied over.\n",
             "label": "files list str",
             "name": "#custom-output-dir-entry__2.0.0.yaml/custom-output-dir-entry/files_list_str",
             "type": ["null", {"items": "string", "type": "array"}]},
            {"doc": "A compressed tarball with all files / directories "
                    "residing in a folder of the same name (not a tarbomb!).\n"
                    "Set \"copy_method\" to "top_dir" to \"tarbomb\" these "
                    "files into the top output directory folder.\n"
                    "Set "collection_name" if you would like to rename the "
                    "output folder that these files / directories reside "
                    "under.\n"
                    "If "files_list_str" is set, then only the files in said "
                    "list are extracted from the tarball, the subdirectory\n"
                    "must be specified in the list.\n",
             "label": "tarball",
             "name": "#custom-output-dir-entry__2.0.0.yaml/custom-output-dir-entry/tarball",
             "type": ["null", "File"]}],
 "id": "#custom-output-dir-entry__2.0.0.yaml",
 "name": "#custom-output-dir-entry__2.0.0.yaml/custom-output-dir-entry",
 "type": "record"}
```
This is the output from the schema_to_json script for ../schemas/custom-output-dir-entry/2.0.1/custom-output-dir-entry__2.0.1.yaml
```json
{"fields": [{"doc": "The name of the collection,\n"
                    "This is required if "file_list" is set AND "copy_method" "
                    "is set to "sub_dir"\n",
             "label": "collection name",
             "name": "#custom-output-dir-entry__2.0.1.yaml/custom-output-dir-entry/collection_name",
             "type": ["null", "string"]},
            {"doc": "Do you want these files / directories as a sub directory "
                    "or in the top directory?\n",
             "label": "copy method",
             "name": "#custom-output-dir-entry__2.0.1.yaml/custom-output-dir-entry/copy_method",
             "type": [{"symbols": ["#custom-output-dir-entry__2.0.1.yaml/custom-output-dir-entry/copy_method/sub_dir",
                                   "#custom-output-dir-entry__2.0.1.yaml/custom-output-dir-entry/copy_method/top_dir"],
                       "type": "enum"}]},
            {"doc": "A directory object, when using this field, one may also "
                    "specify the files_str method to pull out only\n"
                    "certain files from the directory, file_str may reference "
                    "a file in a subfolder, and the subfolder structure will\n"
                    "be maintained even if copy_method is set to "top_dir"\n",
             "label": "dir",
             "name": "#custom-output-dir-entry__2.0.1.yaml/custom-output-dir-entry/dir",
             "type": ["null", "Directory"]},
            {"doc": "A list of files, will be placed into the top directory "
                    "unless "collection_name" is specified and\n"
                    "copy method is set to "sub_dir"\n",
             "label": "file list",
             "name": "#custom-output-dir-entry__2.0.1.yaml/custom-output-dir-entry/file_list",
             "type": ["null", {"items": "File", "type": "array"}]},
            {"doc": "A list of files for "dir". If not specified the entire "
                    "directory will be copied over.\n",
             "label": "files list str",
             "name": "#custom-output-dir-entry__2.0.1.yaml/custom-output-dir-entry/files_list_str",
             "type": ["null", {"items": "string", "type": "array"}]},
            {"doc": "A compressed tarball with all files / directories "
                    "residing in a folder of the same name (not a tarbomb!).\n"
                    "Set \"copy_method\" to "top_dir" to \"tarbomb\" these "
                    "files into the top output directory folder.\n"
                    "Set "collection_name" if you would like to rename the "
                    "output folder that these files / directories reside "
                    "under.\n"
                    "If "files_list_str" is set, then only the files in said "
                    "list are extracted from the tarball, the subdirectory\n"
                    "must be specified in the list.\n",
             "label": "tarball",
             "name": "#custom-output-dir-entry__2.0.1.yaml/custom-output-dir-entry/tarball",
             "type": ["null", "File"]}],
 "id": "#custom-output-dir-entry__2.0.1.yaml",
 "name": "#custom-output-dir-entry__2.0.1.yaml/custom-output-dir-entry",
 "type": "record"}
```
This is the output from the schema_to_json script for ../schemas/fastq-list-row/1.0.0/fastq-list-row__1.0.0.yaml
```json
{"fields": [{"doc": "The lane that the sample was run on\n",
             "label": "lane",
             "name": "#fastq-list-row__1.0.0.yaml/fastq-list-row/lane",
             "type": "int"},
            {"doc": "The path to R1 of a sample\n",
             "label": "read 1",
             "name": "#fastq-list-row__1.0.0.yaml/fastq-list-row/read_1",
             "streamable": True,
             "type": "File"},
            {"doc": "The path to R2 of a sample\n",
             "label": "read 2",
             "name": "#fastq-list-row__1.0.0.yaml/fastq-list-row/read_2",
             "streamable": True,
             "type": ["null", "File"]},
            {"doc": "The read-group id of the sample.\nOften an index\n",
             "label": "rgid",
             "name": "#fastq-list-row__1.0.0.yaml/fastq-list-row/rgid",
             "type": "string"},
            {"doc": "The read-group library of the sample.\n",
             "label": "rglb",
             "name": "#fastq-list-row__1.0.0.yaml/fastq-list-row/rglb",
             "type": "string"},
            {"doc": "The read-group sample name\n",
             "label": "rgsm",
             "name": "#fastq-list-row__1.0.0.yaml/fastq-list-row/rgsm",
             "type": "string"}],
 "id": "#fastq-list-row__1.0.0.yaml",
 "name": "#fastq-list-row__1.0.0.yaml/fastq-list-row",
 "type": "record"}
```
This is the output from the schema_to_json script for ../schemas/predefined-mount-path/1.0.0/predefined-mount-path__1.0.0.yaml
```json
{"fields": [{"doc": "The file object\n",
             "label": "file obj",
             "name": "#predefined-mount-path__1.0.0.yaml/predefined-mount-path/file_obj",
             "type": "File"},
            {"doc": "The predefined mount path to the file\n"
                    "This will match the file in the csv\n",
             "label": "mount path",
             "name": "#predefined-mount-path__1.0.0.yaml/predefined-mount-path/mount_path",
             "type": "string"}],
 "id": "#predefined-mount-path__1.0.0.yaml",
 "name": "#predefined-mount-path__1.0.0.yaml/predefined-mount-path",
 "type": "record"}
```
This is the output from the schema_to_json script for ../schemas/samplesheet/1.0.0/samplesheet__1.0.0.yaml
```json
{"fields": [{"doc": "The array of bclconvert data objects\n",
             "label": "BCLConvert Data section",
             "name": "#samplesheet__1.0.0.yaml/samplesheet/bclconvert_data",
             "type": {"items": {"fields": [{"doc": "index\n",
                                            "label": "index",
                                            "name": "#bclconvert-data-row__3.10.5.yaml/bclconvert-data-row/index",
                                            "type": "string"},
                                           {"doc": "index2\n",
                                            "label": "index2",
                                            "name": "#bclconvert-data-row__3.10.5.yaml/bclconvert-data-row/index2",
                                            "type": ["null", "string"]},
                                           {"doc": "lane\n",
                                            "label": "lane",
                                            "name": "#bclconvert-data-row__3.10.5.yaml/bclconvert-data-row/lane",
                                            "type": "int"},
                                           {"doc": "Per-sample override cycles "
                                                   "settings\n",
                                            "label": "override cycles",
                                            "name": "#bclconvert-data-row__3.10.5.yaml/bclconvert-data-row/override_cycles",
                                            "type": "string"},
                                           {"doc": "sample_id\n",
                                            "label": "sample_id",
                                            "name": "#bclconvert-data-row__3.10.5.yaml/bclconvert-data-row/sample_id",
                                            "type": "string"},
                                           {"doc": "sample_project\n",
                                            "label": "sample_project",
                                            "name": "#bclconvert-data-row__3.10.5.yaml/bclconvert-data-row/sample_project",
                                            "type": "string"}],
                                "id": "#bclconvert-data-row__3.10.5.yaml",
                                "name": "#bclconvert-data-row__3.10.5.yaml/bclconvert-data-row",
                                "type": "record"},
                      "type": "array"}},
            {"doc": "The bclconvert settings used for demux\n",
             "label": "BCLConvert Settings section",
             "name": "#samplesheet__1.0.0.yaml/samplesheet/bclconvert_settings",
             "type": [{"fields": [{"doc": "adapter_behavior\n",
                                   "label": "adapter_behavior",
                                   "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/adapter_behavior",
                                   "type": ["null", "string"]},
                                  {"doc": "adapter_read_1\n",
                                   "label": "adapter_read_1",
                                   "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/adapter_read_1",
                                   "type": ["null", "string"]},
                                  {"doc": "adapter_read_2\n",
                                   "label": "adapter_read_2",
                                   "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/adapter_read_2",
                                   "type": ["null", "string"]},
                                  {"doc": "adapter_stringency\n",
                                   "label": "adapter_stringency",
                                   "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/adapter_stringency",
                                   "type": ["null", "string"]},
                                  {"doc": "barcode_mismatches_index_1\n",
                                   "label": "barcode_mismatches_index_1",
                                   "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/barcode_mismatches_index_1",
                                   "type": ["null", "int"]},
                                  {"doc": "barcode_mismatches_index_2\n",
                                   "label": "barcode_mismatches_index_2",
                                   "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/barcode_mismatches_index_2",
                                   "type": ["null", "int"]},
                                  {"doc": "create_fastq_for_index_reads\n",
                                   "label": "create_fastq_for_index_reads",
                                   "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/create_fastq_for_index_reads",
                                   "type": ["null", "boolean"]},
                                  {"doc": "mask_short_reads\n",
                                   "label": "mask_short_reads",
                                   "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/mask_short_reads",
                                   "type": ["null", "string"]},
                                  {"doc": "minimum_adapter_overlap\n",
                                   "label": "minimum_adapter_overlap",
                                   "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/minimum_adapter_overlap",
                                   "type": ["null", "int"]},
                                  {"doc": "minimum_trimmed_read_length\n",
                                   "label": "minimum_trimmed_read_length",
                                   "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/minimum_trimmed_read_length",
                                   "type": ["null", "int"]},
                                  {"doc": "override_cycles\n",
                                   "label": "override_cycles",
                                   "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/override_cycles",
                                   "type": ["null", "string"]},
                                  {"doc": "trim_umi\n",
                                   "label": "trim_umi",
                                   "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings/trim_umi",
                                   "type": ["null", "boolean"]}],
                       "id": "#bclconvert-settings__3.10.5.yaml",
                       "name": "#bclconvert-settings__3.10.5.yaml/bclconvert-settings",
                       "type": "record"}]},
            {"doc": "The samplesheet header object\n",
             "label": "samplesheet header",
             "name": "#samplesheet__1.0.0.yaml/samplesheet/header",
             "type": [{"fields": [{"doc": "application\n",
                                   "label": "application",
                                   "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header/application",
                                   "type": "string"},
                                  {"doc": "assay\n",
                                   "label": "assay",
                                   "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header/assay",
                                   "type": "string"},
                                  {"doc": "chemistry\n",
                                   "label": "chemistry",
                                   "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header/chemistry",
                                   "type": "string"},
                                  {"doc": "date\n",
                                   "label": "date",
                                   "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header/date",
                                   "type": "string"},
                                  {"doc": "experiment name\n",
                                   "label": "experiment name",
                                   "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header/experiment_name",
                                   "type": "string"},
                                  {"doc": "file format version\n",
                                   "label": "file format version",
                                   "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header/file_format_version",
                                   "type": "int"},
                                  {"doc": "iem file version\n",
                                   "label": "iem file version",
                                   "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header/iem_file_version",
                                   "type": "int"},
                                  {"doc": "index adapters\n",
                                   "label": "index adapters",
                                   "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header/index_adapters",
                                   "type": "string"},
                                  {"doc": "instrument type\n",
                                   "label": "instrument type",
                                   "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header/instrument_type",
                                   "type": "string"},
                                  {"doc": "workflow\n",
                                   "label": "workflow",
                                   "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header/workflow",
                                   "type": "string"}],
                       "id": "#samplesheet-header__1.0.0.yaml",
                       "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header",
                       "type": "record"}]},
            {"doc": "The reads\n",
             "label": "reads",
             "name": "#samplesheet__1.0.0.yaml/samplesheet/reads",
             "type": [{"fields": [{"doc": "read 1 cycles\n",
                                   "label": "read 1 cycles",
                                   "name": "#samplesheet-reads__1.0.0.yaml/samplesheet-reads/read_1_cycles",
                                   "type": "int"},
                                  {"doc": "read 2 cycles\n",
                                   "label": "read 2 cycles",
                                   "name": "#samplesheet-reads__1.0.0.yaml/samplesheet-reads/read_2_cycles",
                                   "type": ["null", "int"]}],
                       "id": "#samplesheet-reads__1.0.0.yaml",
                       "name": "#samplesheet-reads__1.0.0.yaml/samplesheet-reads",
                       "type": "record"}]}],
 "id": "#samplesheet__1.0.0.yaml",
 "name": "#samplesheet__1.0.0.yaml/samplesheet",
 "type": "record"}
```
This is the output from the schema_to_json script for ../schemas/samplesheet-header/1.0.0/samplesheet-header__1.0.0.yaml
```json
{"fields": [{"doc": "application\n",
             "label": "application",
             "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header/application",
             "type": "string"},
            {"doc": "assay\n",
             "label": "assay",
             "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header/assay",
             "type": "string"},
            {"doc": "chemistry\n",
             "label": "chemistry",
             "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header/chemistry",
             "type": "string"},
            {"doc": "date\n",
             "label": "date",
             "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header/date",
             "type": "string"},
            {"doc": "experiment name\n",
             "label": "experiment name",
             "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header/experiment_name",
             "type": "string"},
            {"doc": "file format version\n",
             "label": "file format version",
             "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header/file_format_version",
             "type": "int"},
            {"doc": "iem file version\n",
             "label": "iem file version",
             "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header/iem_file_version",
             "type": "int"},
            {"doc": "index adapters\n",
             "label": "index adapters",
             "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header/index_adapters",
             "type": "string"},
            {"doc": "instrument type\n",
             "label": "instrument type",
             "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header/instrument_type",
             "type": "string"},
            {"doc": "workflow\n",
             "label": "workflow",
             "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header/workflow",
             "type": "string"}],
 "id": "#samplesheet-header__1.0.0.yaml",
 "name": "#samplesheet-header__1.0.0.yaml/samplesheet-header",
 "type": "record"}
```
This is the output from the schema_to_json script for ../schemas/samplesheet-reads/1.0.0/samplesheet-reads__1.0.0.yaml
```json
{"fields": [{"doc": "read 1 cycles\n",
             "label": "read 1 cycles",
             "name": "#samplesheet-reads__1.0.0.yaml/samplesheet-reads/read_1_cycles",
             "type": "int"},
            {"doc": "read 2 cycles\n",
             "label": "read 2 cycles",
             "name": "#samplesheet-reads__1.0.0.yaml/samplesheet-reads/read_2_cycles",
             "type": ["null", "int"]}],
 "id": "#samplesheet-reads__1.0.0.yaml",
 "name": "#samplesheet-reads__1.0.0.yaml/samplesheet-reads",
 "type": "record"}
```
This is the output from the schema_to_json script for ../schemas/settings-by-samples/1.0.0/settings-by-samples__1.0.0.yaml
```json
{"fields": [{"doc": "The name for this combination of settings and sample "
                    "ids.\n"
                    "Will be used as the midfix for the name of the sample "
                    "sheet.\n"
                    "Will be used as the output directory in the bclconvert "
                    "workflow\n",
             "label": "batch name",
             "name": "#settings-by-samples__1.0.0.yaml/settings-by-samples/batch_name",
             "type": "string"},
            {"doc": "The list of Sample_IDs with these BClConvert settings\n",
             "label": "samples",
             "name": "#settings-by-samples__1.0.0.yaml/settings-by-samples/samples",
             "type": {"items": "string", "type": "array"}},
            {"doc": "Additional bcl convert settings\n",
             "label": "settings by override cylces",
             "name": "#settings-by-samples__1.0.0.yaml/settings-by-samples/settings",
             "type": ["null",
                      {"fields": [{"doc": "Defines whether the software\n"
                                          "masks or trims Read 1 and/or\n"
                                          "Read 2 adapter sequence(s).\n"
                                          "When AdapterRead1 or\n"
                                          "AdapterRead2 is not specified, "
                                          "this\n"
                                          "setting cannot be specified.\n"
                                          "• mask—The software masks the\n"
                                          "identified Read 1 and/or Read 2\n"
                                          "sequence(s) with N.\n"
                                          "• trim—The software trims the\n"
                                          "identified Read 1 and/or Read 2\n"
                                          "sequence(s)\n",
                                   "label": "adapter behavior",
                                   "name": "#settings-by-samples__1.0.0.yaml/settings-by-samples/settings/settings/adapter_behavior",
                                   "type": ["null",
                                            {"symbols": ["#settings-by-samples__1.0.0.yaml/settings-by-samples/settings/settings/adapter_behavior/mask",
                                                         "#settings-by-samples__1.0.0.yaml/settings-by-samples/settings/settings/adapter_behavior/trim"],
                                             "type": "enum"}]},
                                  {"doc": "The sequence of the Read 1\n"
                                          "adapter to be masked or trimmed.\n"
                                          "To trim multiple adapters, "
                                          "separate\n"
                                          "the sequences with a plus sign (+)\n"
                                          "to indicate independent adapters\n"
                                          "that must be independently\n"
                                          "assessed for masking or trimming\n"
                                          "for each read.\n"
                                          "Allowed characters: A, T, C, G.\n",
                                   "label": "adapter read 1",
                                   "name": "#settings-by-samples__1.0.0.yaml/settings-by-samples/settings/settings/adapter_read_1",
                                   "type": ["null", "string"]},
                                  {"doc": "The sequence of the Read 2\n"
                                          "adapter to be masked or trimmed.\n"
                                          "To trim multiple adapters, "
                                          "separate\n"
                                          "the sequences with a plus sign (+)\n"
                                          "to indicate independent adapters\n"
                                          "that must be independently\n"
                                          "assessed for masking or trimming\n"
                                          "for each read.\n"
                                          "Allowed characters: A, T, C, G.\n",
                                   "label": "adapter read 2",
                                   "name": "#settings-by-samples__1.0.0.yaml/settings-by-samples/settings/settings/adapter_read_2",
                                   "type": ["null", "string"]},
                                  {"doc": "he minimum match rate that\n"
                                          "triggers masking or trimming. This\n"
                                          "value is calculated as MatchCount\n"
                                          "/ (MatchCount+MismatchCount).\n"
                                          "Accepted values are 0.5–1. The\n"
                                          "default value of 0.9 indicates "
                                          "that\n"
                                          "only reads with ≥ 90% sequence\n"
                                          "identity with the adapter are\n"
                                          "trimmed.\n",
                                   "label": "adapter stringency",
                                   "name": "#settings-by-samples__1.0.0.yaml/settings-by-samples/settings/settings/adapter_stringency",
                                   "type": ["null", "float"]},
                                  {"doc": "The number of mismatches\n"
                                          "allowed for index1. Accepted\n"
                                          "values are 0, 1, or 2.\n",
                                   "label": "barcode mismatches index 1",
                                   "name": "#settings-by-samples__1.0.0.yaml/settings-by-samples/settings/settings/barcode_mismatches_index_1",
                                   "type": ["null", "int"]},
                                  {"doc": "The number of mismatches\n"
                                          "allowed for index2. Accepted\n"
                                          "values are 0, 1, or 2.\n",
                                   "label": "barcode mismatches index 2",
                                   "name": "#settings-by-samples__1.0.0.yaml/settings-by-samples/settings/settings/barcode_mismatches_index_2",
                                   "type": ["null", "int"]},
                                  {"doc": "Specifies whether software will\n"
                                          "output fastqs for index reads. If\n"
                                          "index reads are defined as a\n"
                                          "UMI then fastqs for the UMI will\n"
                                          "be output (if TrimUMI is also set\n"
                                          "to 0). At least 1 index read must\n"
                                          "be specified in the sample\n"
                                          "sheet.\n"
                                          "• 0—Fastq files will not be output\n"
                                          "for index reads.\n"
                                          "• 1—Fastq files will be output for\n"
                                          "fastq reads.\n",
                                   "label": "create fastq for index reads",
                                   "name": "#settings-by-samples__1.0.0.yaml/settings-by-samples/settings/settings/create_fastq_for_index_reads",
                                   "type": ["null", "boolean"]},
                                  {"doc": "The minimum read length\n"
                                          "containing A, T, C, G values after\n"
                                          "adapter trimming. Reads with\n"
                                          "less than this number of bases\n"
                                          "become completely masked. If\n"
                                          "this value is less than 22, the\n"
                                          "default becomes the\n"
                                          "MinimumTrimmedReadLength.\n",
                                   "label": "mask short reads",
                                   "name": "#settings-by-samples__1.0.0.yaml/settings-by-samples/settings/settings/mask_short_reads",
                                   "type": ["null", "int"]},
                                  {"doc": "Do not trim any bases unless the\n"
                                          "adapter matches are greater than\n"
                                          "or equal to the user specified\n"
                                          "number of bases. At least one\n"
                                          "AdapterRead1 or\n"
                                          "AdapterRead2 must be specified\n"
                                          "to use\n"
                                          "MinimumAdapterOverlap.\n"
                                          "Allowed characters: 1, 2, 3.\n",
                                   "label": "minumum adapter overlap",
                                   "name": "#settings-by-samples__1.0.0.yaml/settings-by-samples/settings/settings/minimum_adapter_overlap",
                                   "type": ["null", "int"]},
                                  {"doc": "The minimum read length after\n"
                                          "adapter trimming. The software\n"
                                          "trims adapter sequences from\n"
                                          "reads to the value of this\n"
                                          "parameter. Bases below the\n"
                                          "specified value are masked with\n"
                                          "N.\n",
                                   "label": "minimum trimmed read length",
                                   "name": "#settings-by-samples__1.0.0.yaml/settings-by-samples/settings/settings/minimum_trimmed_read_length",
                                   "type": ["null", "int"]},
                                  {"doc": "Specifies the sequencing and\n"
                                          "indexing cycles that should be\n"
                                          "used when processing the data.\n"
                                          "The following format must be\n"
                                          "used:\n"
                                          "* Must be same number of\n"
                                          "semicolon delimited fields in\n"
                                          "string as sequencing and\n"
                                          "indexing reads specified in\n"
                                          "RunInfo.xml\n"
                                          "* Indexing reads are specified\n"
                                          "with an I.\n"
                                          "* Sequencing reads are specified\n"
                                          "with a Y. UMI cycles are\n"
                                          "specified with an U.\n"
                                          "* Trimmed reads are specified\n"
                                          "with N.\n"
                                          "* The number of cycles specified\n"
                                          "for each read must sum to the\n"
                                          "number of cycles specified for\n"
                                          "that read in the RunInfo.xml.\n"
                                          "* Only one Y or I sequence can\n"
                                          "be specified per read.\n"
                                          "Example: Y151;I8;I8;Y151\n",
                                   "label": "override cycles",
                                   "name": "#settings-by-samples__1.0.0.yaml/settings-by-samples/settings/settings/override_cycles",
                                   "type": ["null", "string"]},
                                  {"doc": "Specifies whether UMI cycles\n"
                                          "will be excluded from fastq files.\n"
                                          "At least one UMI is required to\n"
                                          "be specified in the Sample\n"
                                          "Sheet when this setting is\n"
                                          "provided.\n"
                                          "• 0—UMI cycles will be output to\n"
                                          "fastq files.\n"
                                          "• 1— UMI cycles will not be\n"
                                          "output to fastq files.\n",
                                   "label": "trim umi",
                                   "name": "#settings-by-samples__1.0.0.yaml/settings-by-samples/settings/settings/trim_umi",
                                   "type": ["null", "boolean"]}],
                       "name": "#settings-by-samples__1.0.0.yaml/settings-by-samples/settings/settings",
                       "type": "record"}]}],
 "id": "#settings-by-samples__1.0.0.yaml",
 "name": "#settings-by-samples__1.0.0.yaml/settings-by-samples",
 "type": "record"}
```
This is the output from the schema_to_json script for ../schemas/tso500-outputs-by-sample/1.0.0/tso500-outputs-by-sample__1.0.0.yaml
```json
{"fields": [{"doc": "Intermediate output directory for align collapse fusion "
                    "caller step\n",
             "label": "align collapse fusion caller dir",
             "name": "#tso500-outputs-by-sample__1.0.0.yaml/tso500-outputs-by-sample/align_collapse_fusion_caller_dir",
             "type": ["null", "Directory"]},
            {"doc": "Intermediate output directory for annotation step\n",
             "label": "annotation dir",
             "name": "#tso500-outputs-by-sample__1.0.0.yaml/tso500-outputs-by-sample/annotation_dir",
             "type": ["null", "Directory"]},
            {"doc": "Intermediate output directory for cnv caller step\n",
             "label": "cnv caller dir",
             "name": "#tso500-outputs-by-sample__1.0.0.yaml/tso500-outputs-by-sample/cnv_caller_dir",
             "type": ["null", "Directory"]},
            {"doc": "Intermediate output directory for combined variant output "
                    "dir\n",
             "label": "combined variant output dir",
             "name": "#tso500-outputs-by-sample__1.0.0.yaml/tso500-outputs-by-sample/combined_variant_output_dir",
             "type": ["null", "Directory"]},
            {"doc": "Intermediate output directory for contamination step\n",
             "label": "contamination dir",
             "name": "#tso500-outputs-by-sample__1.0.0.yaml/tso500-outputs-by-sample/contamination_dir",
             "type": ["null", "Directory"]},
            {"doc": "Intermediate output directory for dna fusion filtering "
                    "step\n",
             "label": "dna fusion filtering dir",
             "name": "#tso500-outputs-by-sample__1.0.0.yaml/tso500-outputs-by-sample/dna_fusion_filtering_dir",
             "type": ["null", "Directory"]},
            {"doc": "Intermediate output directory for dna qc metrics step\n",
             "label": "dna qc metrics dir",
             "name": "#tso500-outputs-by-sample__1.0.0.yaml/tso500-outputs-by-sample/dna_qc_metrics_dir",
             "type": ["null", "Directory"]},
            {"doc": "Intermediate output directory for max somatic vaf step\n",
             "label": "max somatic vaf dir",
             "name": "#tso500-outputs-by-sample__1.0.0.yaml/tso500-outputs-by-sample/max_somatic_vaf_dir",
             "type": ["null", "Directory"]},
            {"doc": "Intermediate output directory for merged annotation "
                    "step\n",
             "label": "merged annotation dir",
             "name": "#tso500-outputs-by-sample__1.0.0.yaml/tso500-outputs-by-sample/merged_annotation_dir",
             "type": ["null", "Directory"]},
            {"doc": "Intermediate output directory for msi step\n",
             "label": "msi dir",
             "name": "#tso500-outputs-by-sample__1.0.0.yaml/tso500-outputs-by-sample/msi_dir",
             "type": ["null", "Directory"]},
            {"doc": "Intermediate output directory for phased variants step\n",
             "label": "phased variants dir",
             "name": "#tso500-outputs-by-sample__1.0.0.yaml/tso500-outputs-by-sample/phased_variants_dir",
             "type": ["null", "Directory"]},
            {"doc": "Results directory for the given sample\n",
             "label": "results_dir",
             "name": "#tso500-outputs-by-sample__1.0.0.yaml/tso500-outputs-by-sample/results_dir",
             "type": "Directory"},
            {"doc": "The sample analysis results json file\n",
             "label": "sample analysis results json",
             "name": "#tso500-outputs-by-sample__1.0.0.yaml/tso500-outputs-by-sample/sample_analysis_results_json",
             "type": ["null", "File"]},
            {"doc": "ID of the sample, matches the Sample_ID column in the "
                    "sample sheet\n",
             "label": "sample id",
             "name": "#tso500-outputs-by-sample__1.0.0.yaml/tso500-outputs-by-sample/sample_id",
             "type": "string"},
            {"doc": "Name of the sample, matches the rgsm value of the fastq "
                    "list row\n",
             "label": "sample name",
             "name": "#tso500-outputs-by-sample__1.0.0.yaml/tso500-outputs-by-sample/sample_name",
             "type": "string"},
            {"doc": "Intermediate output directory for small variants filter "
                    "step\n",
             "label": "small variant filter dir",
             "name": "#tso500-outputs-by-sample__1.0.0.yaml/tso500-outputs-by-sample/small_variant_filter_dir",
             "type": ["null", "Directory"]},
            {"doc": "Intermediate output directory for stitched realigned "
                    "step\n",
             "label": "stitched realigned dir",
             "name": "#tso500-outputs-by-sample__1.0.0.yaml/tso500-outputs-by-sample/stitched_realigned_dir",
             "type": ["null", "Directory"]},
            {"doc": "Intermediate output directory for tmb step\n",
             "label": "tmb dir",
             "name": "#tso500-outputs-by-sample__1.0.0.yaml/tso500-outputs-by-sample/tmb_dir",
             "type": ["null", "Directory"]},
            {"doc": "Intermediate output directory for variant caller step\n",
             "label": "variant caller dir",
             "name": "#tso500-outputs-by-sample__1.0.0.yaml/tso500-outputs-by-sample/variant_caller_dir",
             "type": ["null", "Directory"]},
            {"doc": "Intermediate output directory for variant matching step\n",
             "label": "variant matching dir",
             "name": "#tso500-outputs-by-sample__1.0.0.yaml/tso500-outputs-by-sample/variant_matching_dir",
             "type": ["null", "Directory"]}],
 "id": "#tso500-outputs-by-sample__1.0.0.yaml",
 "name": "#tso500-outputs-by-sample__1.0.0.yaml/tso500-outputs-by-sample",
 "type": "record"}
```
This is the output from the schema_to_json script for ../schemas/tso500-sample/1.0.0/tso500-sample__1.0.0.yaml
```json
{"fields": [{"doc": "The "pair id" of the sample.\n"
                    "If a sample has a complementary DNA or RNA sample, the "
                    "pair ids of the two samples should have the same\n"
                    "unique pair id.\n",
             "label": "pair id",
             "name": "#tso500-sample__1.0.0.yaml/tso500-sample/pair_id",
             "type": "string"},
            {"doc": "The id of the tso500 sample - this must match the "
                    "Sample_ID column in the samplesheet.\n"
                    "This is used to recreate the fastq files.\n",
             "label": "sample id",
             "name": "#tso500-sample__1.0.0.yaml/tso500-sample/sample_id",
             "type": "string"},
            {"doc": "This must match the rgsm value in the fastq list rows.\n"
                    "It does not need to match the Sample_Name column in the "
                    "sample sheet\n",
             "label": "sample name",
             "name": "#tso500-sample__1.0.0.yaml/tso500-sample/sample_name",
             "type": "string"},
            {"doc": "The "type" of the sample\n",
             "label": "sample type",
             "name": "#tso500-sample__1.0.0.yaml/tso500-sample/sample_type",
             "type": [{"symbols": ["#tso500-sample__1.0.0.yaml/tso500-sample/sample_type/DNA",
                                   "#tso500-sample__1.0.0.yaml/tso500-sample/sample_type/RNA"],
                       "type": "enum"}]}],
 "id": "#tso500-sample__1.0.0.yaml",
 "name": "#tso500-sample__1.0.0.yaml/tso500-sample",
 "type": "record"}
```
This is the output from the schema_to_json script for ../schemas/umccrise-input/1.2.1--0/umccrise-input__1.2.1--0.yaml
```json
{"fields": [{"doc": "optional tumor BAM\n",
             "label": "exome",
             "name": "#umccrise-input__1.2.1--0.yaml/umccrise-input/exome",
             "secondaryFiles": [{"pattern": ".bai", "required": False}],
             "type": ["null", "File"]},
            {"doc": "optional normal BAM\n",
             "label": "exome normal",
             "name": "#umccrise-input__1.2.1--0.yaml/umccrise-input/exome_normal",
             "secondaryFiles": [{"pattern": ".bai", "required": False}],
             "type": ["null", "File"]},
            {"doc": "germline variant calls, optional\n",
             "label": "germline vcf",
             "name": "#umccrise-input__1.2.1--0.yaml/umccrise-input/germline_vcf",
             "secondaryFiles": [{"pattern": ".tbi", "required": True}],
             "type": ["null", "File"]},
            {"doc": "WGS normal BAM, required\n",
             "label": "normal",
             "name": "#umccrise-input__1.2.1--0.yaml/umccrise-input/normal",
             "secondaryFiles": [{"pattern": ".bai", "required": True}],
             "type": "File"},
            {"doc": "optional WTS BAM, however required for neoantigens\n",
             "label": "rna",
             "name": "#umccrise-input__1.2.1--0.yaml/umccrise-input/rna",
             "secondaryFiles": [{"pattern": ".bai", "required": False}],
             "type": ["null", "File"]},
            {"doc": "optional path to RNAseq bcbio workflow, required for "
                    "neoantigens\n",
             "label": "rna bcbio",
             "name": "#umccrise-input__1.2.1--0.yaml/umccrise-input/rna_bcbio",
             "type": ["null", "Directory"]},
            {"doc": "sample name in the RNAseq bcbio workflow above, required "
                    "for neoantigens\n",
             "label": "rna sample",
             "name": "#umccrise-input__1.2.1--0.yaml/umccrise-input/rna_sample",
             "type": ["null", "string"]},
            {"doc": "The name of the sample\n",
             "label": "sample",
             "name": "#umccrise-input__1.2.1--0.yaml/umccrise-input/sample",
             "type": "string"},
            {"doc": "tumor/normal somatic VCF calls, optional. If not "
                    "provided, SAGE will be run\n",
             "label": "somatic vcf",
             "name": "#umccrise-input__1.2.1--0.yaml/umccrise-input/somatic_vcf",
             "secondaryFiles": [{"pattern": ".tbi", "required": True}],
             "type": ["null", "File"]},
            {"doc": "SV calls, optional\n",
             "label": "sv vcf",
             "name": "#umccrise-input__1.2.1--0.yaml/umccrise-input/sv_vcf",
             "secondaryFiles": [{"pattern": ".tbi", "required": True}],
             "type": ["null", "File"]},
            {"doc": "WGS tumor BAM, required\n",
             "label": "wgs",
             "name": "#umccrise-input__1.2.1--0.yaml/umccrise-input/wgs",
             "secondaryFiles": [{"pattern": ".bai", "required": True}],
             "type": "File"}],
 "id": "#umccrise-input__1.2.1--0.yaml",
 "name": "#umccrise-input__1.2.1--0.yaml/umccrise-input",
 "type": "record"}
```
This is the output from the schema_to_json script for ../schemas/umccrise-input/1.2.2--0/umccrise-input__1.2.2--0.yaml
```json
{"fields": [{"doc": "optional tumor BAM\n",
             "label": "exome",
             "name": "#umccrise-input__1.2.2--0.yaml/umccrise-input/exome",
             "secondaryFiles": [{"pattern": ".bai", "required": False}],
             "type": ["null", "File"]},
            {"doc": "optional normal BAM\n",
             "label": "exome normal",
             "name": "#umccrise-input__1.2.2--0.yaml/umccrise-input/exome_normal",
             "secondaryFiles": [{"pattern": ".bai", "required": False}],
             "type": ["null", "File"]},
            {"doc": "germline variant calls, optional\n",
             "label": "germline vcf",
             "name": "#umccrise-input__1.2.2--0.yaml/umccrise-input/germline_vcf",
             "secondaryFiles": [{"pattern": ".tbi", "required": True}],
             "type": ["null", "File"]},
            {"doc": "WGS normal BAM, required\n",
             "label": "normal",
             "name": "#umccrise-input__1.2.2--0.yaml/umccrise-input/normal",
             "secondaryFiles": [{"pattern": ".bai", "required": True}],
             "type": "File"},
            {"doc": "optional WTS BAM, however required for neoantigens\n",
             "label": "rna",
             "name": "#umccrise-input__1.2.2--0.yaml/umccrise-input/rna",
             "secondaryFiles": [{"pattern": ".bai", "required": False}],
             "type": ["null", "File"]},
            {"doc": "optional path to RNAseq bcbio workflow, required for "
                    "neoantigens\n",
             "label": "rna bcbio",
             "name": "#umccrise-input__1.2.2--0.yaml/umccrise-input/rna_bcbio",
             "type": ["null", "Directory"]},
            {"doc": "sample name in the RNAseq bcbio workflow above, required "
                    "for neoantigens\n",
             "label": "rna sample",
             "name": "#umccrise-input__1.2.2--0.yaml/umccrise-input/rna_sample",
             "type": ["null", "string"]},
            {"doc": "The name of the sample\n",
             "label": "sample",
             "name": "#umccrise-input__1.2.2--0.yaml/umccrise-input/sample",
             "type": "string"},
            {"doc": "tumor/normal somatic VCF calls, optional. If not "
                    "provided, SAGE will be run\n",
             "label": "somatic vcf",
             "name": "#umccrise-input__1.2.2--0.yaml/umccrise-input/somatic_vcf",
             "secondaryFiles": [{"pattern": ".tbi", "required": True}],
             "type": ["null", "File"]},
            {"doc": "SV calls, optional\n",
             "label": "sv vcf",
             "name": "#umccrise-input__1.2.2--0.yaml/umccrise-input/sv_vcf",
             "secondaryFiles": [{"pattern": ".tbi", "required": True}],
             "type": ["null", "File"]},
            {"doc": "WGS tumor BAM, required\n",
             "label": "wgs",
             "name": "#umccrise-input__1.2.2--0.yaml/umccrise-input/wgs",
             "secondaryFiles": [{"pattern": ".bai", "required": True}],
             "type": "File"}],
 "id": "#umccrise-input__1.2.2--0.yaml",
 "name": "#umccrise-input__1.2.2--0.yaml/umccrise-input",
 "type": "record"}
```
## This is the end of the packed schema examples
