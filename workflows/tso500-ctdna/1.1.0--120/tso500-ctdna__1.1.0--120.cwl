cwlVersion: v1.1
class: Workflow

# Extensions
$namespaces:
    s: https://schema.org/
$schemas:
  - https://schema.org/version/latest/schemaorg-current-http.rdf

# Metadata
s:author:
    class: s:Person
    s:name: Alexis Lucattini
    s:email: Alexis.Lucattini@umccr.org
    s:identifier: https://orcid.org/0000-0001-9754-647X

# ID/Docs
id: tso500-ctdna--1.1.0--120
label: tso500-ctdna v(1.1.0--120)
doc: |
  Runs the TSO500 ctDNA workflow using the following docker container:
    * 239164580033.dkr.ecr.us-east-1.amazonaws.com/acadia-500-liquid-workflow-aws:ruo-1.1.0.120
  This container is accessible to ICA customers only.
  This CWL workflow is NOT generated by Illumina but the UMCCR team who bear no liability for misuse of this workflow.

  You will need to be familiar with schemas in CWL in order to run this workflow.

  This workflow completes the following steps:
  1. Updates the Data section of the samplesheet to include the Sample_Type and the Pair_ID
  2. Runs the DemultiplexWorkflow.wdl workflow through cromwell on the docker container listed above
  3. Runs the AnalysisWorkflow.wdl workflow through cromwell on the docker container listed above
  4. Runs the ReportingWorkflow.wdl workflow through cromwell on the docker container listed above

requirements:
    InlineJavascriptRequirement: {}
    ScatterFeatureRequirement: {}
    MultipleInputFeatureRequirement: {}
    StepInputExpressionRequirement: {}
    SchemaDefRequirement:
      types:
        - $import: ../../../schemas/tso500-sample/1.0.0/tso500-sample__1.0.0.yaml
        - $import: ../../../schemas/fastq-list-row/1.0.0/fastq-list-row__1.0.0.yaml

inputs:
  tso500_samples:
    label: tso500 samples
    doc: |
      A list of tso500 samples each element has the following attributes:
      * sample_id
      * sample_type
      * pair_id
    type: ../../../schemas/tso500-sample/1.0.0/tso500-sample__1.0.0.yaml#tso500-sample[]
  fastq_list_rows:
    label: fastq list rows
    doc: |
      A list of fastq list rows where each element has the following attributes
      * rgid  # Not used
      * rgsm
      * rglb  # Not used
      * read_1
      * read_2
    type: ../../../schemas/fastq-list-row/1.0.0/fastq-list-row__1.0.0.yaml#fastq-list-row[]
  samplesheet:
    # No input binding required, samplesheet is placed in input.json
    label: sample sheet
    doc: |
      The sample sheet file, expects a V2 samplesheet.
      Even though we don't demultiplex, we still need the information on Sample_Type and Pair_ID to determine which
      workflow (DNA / RNA) to run through, we gather this through the tso500_samples input schema and then append to the
      samplesheet. Please make sure that the sample_id in the tso500 sample schema match the Sample_ID in the
      "<samplesheet_prefix>_Data" column.
    type: File
  samplesheet_prefix:
    label: samplesheet prefix
    doc: |
      Points to the TSO500 section of the samplesheet.  If you are using a samplesheet from BCLConvert,
      please set this to "BCLConvert"
    type: string?
    default: "TSO500L"
  # Run Info file
  run_info_xml:
    # Bound in listing expression
    label: run info xml
    doc: |
      The run info xml file found inside the run folder
    type: File
  # Run Parameters File
  run_parameters_xml:
    # Bound in listing expression
    label: run parameters xml
    doc: |
      The run parameters xml file found inside the run folder
    type: File
  # Reference inputs
  resources_dir:
    # No input binding required, directory path is placed in input.json
    label: resources dir
    doc: |
      The directory of resources
    type: Directory
  dragen_license_key:
    label: dragen license key
    doc: |
      File containing the dragen license
    type: File?


steps:
  # Pre-step
  add_sample_type_and_pair_id_to_samplesheet_step:
    label: add sample type and pair id to samplesheet step
    doc: |
      Adds the sample_type and pair_id attribute from each of the tso500 samples to
      the samplesheet. Here the sample_id attribute of the tso500 sample must match
      that of the Sample_ID column in the sample sheet.  This tool also overwrites the Sample_Project attribute
      so that it matches the Sample_ID. This tool expects a v1 samplesheet as input
    in:
      samplesheet:
        source: samplesheet
      samplesheet_prefix:
        source: samplesheet_prefix
      tso500_samples:
        source: tso500_samples
    out:
      - id: tso500_samplesheet
    run: ../../../tools/custom-create-tso500-samplesheet/1.0.0/custom-create-tso500-samplesheet__1.0.0.cwl
  # Demux step
  run_tso500_ctdna_demultiplex_workflow_step:
    label: run tso500 ctdna demultiplex workflow step
    doc: |
      Runs the tso500 ctdna demultiplex workflow step. This involves making sure that the fastq list rows are mounted
      as per as the WDL task expects them to be (which is every sample in its own project). Then creating an
      input.json to match the inputs of the CWL with a WDL compatible input file and launching this through cromwell.
    in:
      tso500_samples:
        source: tso500_samples
      fastq_list_rows:
        source: fastq_list_rows
      samplesheet:
        source: add_sample_type_and_pair_id_to_samplesheet_step/tso500_samplesheet
      samplesheet_prefix:
        source: samplesheet_prefix
      run_info_xml:
        source: run_info_xml
      run_parameters_xml:
        source: run_parameters_xml
      resources_dir:
        source: resources_dir
    out:
      - id: output_dir
      - id: output_samplesheet
      - id: fastq_validation_dsdm
    run: ../../../tools/tso500-ctdna-demultiplex-workflow/1.1.0--120/tso500-ctdna-demultiplex-workflow__1.1.0--120.cwl
  # Analysis step
  run_tso500_ctdna_analysis_workflow_step:
    label: run tso500 ctdna analysis workflow step
    doc: |
      Run the tso500 ctdna analysis workflow step. This involves making sure that the fastq list rows are mounted as
      per the WDL task expects them to be (which is every sample in its own project). Then creating an
      input.json to match the inputs of the CWL with a WDL compatible input file and launching this through cromwell.
    in:
      tso500_samples:
        source: tso500_samples
      fastq_list_rows:
        source: fastq_list_rows
      resources_dir:
        source: resources_dir
      fastq_validation_dsdm:
        source: run_tso500_ctdna_demultiplex_workflow_step/fastq_validation_dsdm
      dragen_license_key:
        source: dragen_license_key
    out:
      - id: output_dir
      - id: contamination_dsdm
    run: ../../../tools/tso500-ctdna-analysis-workflow/1.1.0--120/tso500-ctdna-analysis-workflow__1.1.0--120.cwl
  # Reporting workflow
  run_tso500_ctdna_reporting_workflow_step:
    label: run tso500 ctdna reporting workflow step
    doc: |
      Run the tso500 ctdna repair workflow step
    in:
      analysis_folder:
        source: run_tso500_ctdna_analysis_workflow_step/output_dir
      run_parameters_xml:
        source: run_parameters_xml
      run_info_xml:
        source: run_info_xml
      resources_dir:
        source: resources_dir
      contamination_dsdm:
        source: run_tso500_ctdna_analysis_workflow_step/contamination_dsdm
      samplesheet:
        source: run_tso500_ctdna_demultiplex_workflow_step/output_samplesheet
      samplesheet_prefix:
        source: samplesheet_prefix
    out:
      - id: output_dir
      - id: results_dir
      - id: cleanup_dsdm
    run: ../../../tools/tso500-ctdna-reporting-workflow/1.1.0--120/tso500-ctdna-reporting-workflow__1.1.0--120.cwl


outputs:
  demultiplex_workflow_output:
    label: demultiplex workflow output
    doc: |
      Intermediate output files from the demultiplex workflow steps
    type: Directory
    outputSource: run_tso500_ctdna_demultiplex_workflow_step/output_dir
  analysis_workflow_output:
    label: analysis workflow output
    doc: |
      Intermediate output files from the analysis workflow steps
    type: Directory
    outputSource: run_tso500_ctdna_analysis_workflow_step/output_dir
  reporting_workflow_output:
    label: reporting workflow output
    doc: |
      Intermediate output files from the reporting workflow steps
    type: Directory
    outputSource: run_tso500_ctdna_reporting_workflow_step/output_dir
  results:
    label: results
    doc: |
      Results directory, output from the reporting workflow
    type: Directory
    outputSource: run_tso500_ctdna_reporting_workflow_step/results_dir


