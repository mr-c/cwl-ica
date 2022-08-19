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
        - $import: ../../../schemas/tso500-outputs-by-sample/1.0.0/tso500-outputs-by-sample__1.0.0.yaml

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
  coerce_valid_index:
    label: coerce valid index
    doc: |
      Coerce a valid index for ctTSO sample
    type: boolean?
    default: false
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
      coerce_valid_index:
        source: coerce_valid_index
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
      # Intermediate outputs
      - id: fastq_validation_dir
      - id: resource_verification_dir
      - id: samplesheet_validation_dir
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
      # Intermediate output dirs
      - id: align_collapse_fusion_caller_dir
      - id: annotation_dir
      - id: cnv_caller_dir
      - id: contamination_dir
      - id: dna_fusion_filtering_dir
      - id: dna_qc_metrics_dir
      - id: max_somatic_vaf_dir
      - id: merged_annotation_dir
      - id: msi_dir
      - id: phased_variants_dir
      - id: small_variant_filter_dir
      - id: stitched_realigned_dir
      - id: tmb_dir
      - id: variant_caller_dir
      - id: variant_matching_dir
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
      - id: results_dsdm
      # Intermediate outputs
      - id: cleanup_dir
      - id: combined_variant_output_dir
      - id: metrics_output_dir
      - id: sample_analysis_results_dir
    run: ../../../tools/tso500-ctdna-reporting-workflow/1.1.0--120/tso500-ctdna-reporting-workflow__1.1.0--120.cwl
  get_cttso_outputs_by_sample:
    label: get cttso outputs by sample
    doc: |
      Get the CTTSO outputs per sample, contains all intermediate dirs and results dir
      along with the sampleanalysis results json file
    in:
      tso500_samples:
        source: tso500_samples
      analysis_output_dir:
        source: run_tso500_ctdna_analysis_workflow_step/output_dir
      reporting_output_dir:
        source: run_tso500_ctdna_reporting_workflow_step/output_dir
      results_output_dir:
        source: run_tso500_ctdna_reporting_workflow_step/results_dir
    out:
      - id: outputs_by_sample
    run: ../../../expressions/get-tso500-outputs-per-sample/1.0.0/get-tso500-outputs-per-sample__1.0.0.cwl
  validate_dsdm_json:
    label: validate dsdm jsons
    doc: |
      Return false if any sample has failed
    in:
      dsdm_json:
        source: run_tso500_ctdna_reporting_workflow_step/results_dsdm
    out:
      - id: passing
    run: ../../../expressions/validate-dsdm-json/1.0.0/validate-dsdm-json__1.0.0.cwl
  assert_all_samples_passing:
    label: assert all samples passing
    doc: |
      Ensure array of booleans are all passing.
    in:
      boolean_val:
        source: validate_dsdm_json/passing
    out:
      - id: assertion
    run: ../../../expressions/assert-true/1.0.0/assert-true__1.0.0.cwl


outputs:
  # Top output directories
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
  # Sub demux output directories
  fastq_validation_demux_dir:
    label: fastq_validation_demux
    doc: |
      fastq_validation_demux_dir intermediate output directory
    type: Directory?
    outputSource: run_tso500_ctdna_demultiplex_workflow_step/fastq_validation_dir
  resource_verification_demux_dir:
    label: resource_verification_demux
    doc: |
      resource_verification_demux_dir intermediate output directory
    type: Directory?
    outputSource: run_tso500_ctdna_demultiplex_workflow_step/resource_verification_dir
  samplesheet_validation_demux_dir:
    label: samplesheet_validation_demux
    doc: |
      samplesheet_validation_demux_dir intermediate output directory
    type: Directory?
    outputSource: run_tso500_ctdna_demultiplex_workflow_step/samplesheet_validation_dir
  # Sub analysis output directories
  align_collapse_fusion_caller_analysis_dir:
    label: align_collapse_fusion_caller_analysis_dir
    doc: |
      Intermediate output for align_collapse_fusion_caller_analysis step of the analysis workflow
    type: Directory?
    outputSource: run_tso500_ctdna_analysis_workflow_step/align_collapse_fusion_caller_dir
  annotation_analysis_dir:
    label: annotation_analysis_dir
    doc: |
      Intermediate output for annotation_analysis step of the analysis workflow
    type: Directory?
    outputSource: run_tso500_ctdna_analysis_workflow_step/annotation_dir
  cnv_caller_analysis_dir:
    label: cnv_caller_analysis_dir
    doc: |
      Intermediate output for cnv_caller_analysis step of the analysis workflow
    type: Directory?
    outputSource: run_tso500_ctdna_analysis_workflow_step/cnv_caller_dir
  contamination_analysis_dir:
    label: contamination_analysis_dir
    doc: |
      Intermediate output for contamination_analysis step of the analysis workflow
    type: Directory?
    outputSource: run_tso500_ctdna_analysis_workflow_step/contamination_dir
  dna_fusion_filtering_analysis_dir:
    label: dna_fusion_filtering_analysis_dir
    doc: |
      Intermediate output for dna_fusion_filtering_analysis step of the analysis workflow
    type: Directory?
    outputSource: run_tso500_ctdna_analysis_workflow_step/dna_fusion_filtering_dir
  dna_qc_metrics_analysis_dir:
    label: dna_qc_metrics_analysis_dir
    doc: |
      Intermediate output for dna_qc_metrics_analysis step of the analysis workflow
    type: Directory?
    outputSource: run_tso500_ctdna_analysis_workflow_step/dna_qc_metrics_dir
  max_somatic_vaf_analysis_dir:
    label: max_somatic_vaf_analysis_dir
    doc: |
      Intermediate output for max_somatic_vaf_analysis step of the analysis workflow
    type: Directory?
    outputSource: run_tso500_ctdna_analysis_workflow_step/max_somatic_vaf_dir
  merged_annotation_analysis_dir:
    label: merged_annotation_analysis_dir
    doc: |
      Intermediate output for merged_annotation_analysis step of the analysis workflow
    type: Directory?
    outputSource: run_tso500_ctdna_analysis_workflow_step/merged_annotation_dir
  msi_analysis_dir:
    label: msi_analysis_dir
    doc: |
      Intermediate output for msi_analysis step of the analysis workflow
    type: Directory?
    outputSource: run_tso500_ctdna_analysis_workflow_step/msi_dir
  phased_variants_analysis_dir:
    label: phased_variants_analysis_dir
    doc: |
      Intermediate output for phased_variants_analysis step of the analysis workflow
    type: Directory?
    outputSource: run_tso500_ctdna_analysis_workflow_step/phased_variants_dir
  small_variant_filter_analysis_dir:
    label: small_variant_filter_analysis_dir
    doc: |
      Intermediate output for small_variant_filter_analysis step of the analysis workflow
    type: Directory?
    outputSource: run_tso500_ctdna_analysis_workflow_step/small_variant_filter_dir
  stitched_realigned_analysis_dir:
    label: stitched_realigned_analysis_dir
    doc: |
      Intermediate output for stitched_realigned_analysis step of the analysis workflow
    type: Directory?
    outputSource: run_tso500_ctdna_analysis_workflow_step/stitched_realigned_dir
  tmb_analysis_dir:
    label: tmb_analysis_dir
    doc: |
      Intermediate output for tmb_analysis step of the analysis workflow
    type: Directory?
    outputSource: run_tso500_ctdna_analysis_workflow_step/tmb_dir
  variant_caller_analysis_dir:
    label: variant_caller_analysis_dir
    doc: |
      Intermediate output for variant_caller_analysis step of the analysis workflow
    type: Directory?
    outputSource: run_tso500_ctdna_analysis_workflow_step/variant_caller_dir
  variant_matching_analysis_dir:
    label: variant_matching_analysis_dir
    doc: |
      Intermediate output for variant_matching_analysis step of the analysis workflow
    type: Directory?
    outputSource: run_tso500_ctdna_analysis_workflow_step/variant_matching_dir
  # Sub reporting output dirs
  cleanup_dir:
    label: cleanup_dir
    doc: |
      Intermediate output for cleanup_dir
    type: Directory?
    outputSource: run_tso500_ctdna_reporting_workflow_step/cleanup_dir
  combined_variant_output_dir:
    label: combined_variant_output_dir
    doc: |
      Intermediate output for combined_variant_output_dir
    type: Directory?
    outputSource: run_tso500_ctdna_reporting_workflow_step/combined_variant_output_dir
  metrics_output_dir:
    label: metrics_output_dir
    doc: |
      Intermediate output for metrics_output_dir
    type: Directory?
    outputSource: run_tso500_ctdna_reporting_workflow_step/metrics_output_dir
  sample_analysis_results_dir:
    label: sample_analysis_results_dir
    doc: |
      Intermediate output for sample_analysis_results_dir
    type: Directory?
    outputSource: run_tso500_ctdna_reporting_workflow_step/sample_analysis_results_dir
  # Per sample outputs
  outputs_by_sample:
    label: outputs by sample
    doc: |
      The sample output directories from the analysis step
    type: ../../../schemas/tso500-outputs-by-sample/1.0.0/tso500-outputs-by-sample__1.0.0.yaml#tso500-outputs-by-sample[]
    outputSource: get_cttso_outputs_by_sample/outputs_by_sample

