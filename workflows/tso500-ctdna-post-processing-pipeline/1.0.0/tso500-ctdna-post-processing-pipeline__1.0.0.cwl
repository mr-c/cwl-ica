cwlVersion: v1.1
class: Workflow

# Extensions
$namespaces:
    s: https://schema.org/
    ilmn-tes: http://platform.illumina.com/rdf/ica/
$schemas:
  - https://schema.org/version/latest/schemaorg-current-http.rdf

# Metadata
s:author:
    class: s:Person
    s:name: Yinan Wang
    s:email: ywang16@illumina.com

s:maintainer:
    class: s:Person
    s:name: Alexis Lucattini
    s:email: Alexis.Lucattini@umccr.org
    s:identifier: https://orcid.org/0000-0001-9754-647X

# ID/Docs
id: tso500-ctdna-post-processing-pipeline--1.0.0
label: tso500-ctdna-post-processing-pipeline v(1.0.0)
doc: |
    UMCCR CWL tso500-ctdna-post-processing-pipeline v1.0.0

    Original pipeline source can be found [here](https://github.com/YinanWang16/tso500-ctdna-post-processing/blob/main/cwl/workflows/umccr-cttso-post-processiong__v1.0.0.cwl).

    The workflow has 6 main steps

    * intermediate expressions - for collection of bam, vcf, csv and json files
    * Coverage analysis
      * Create csv of exons with a list of low level coverage
      * Summary report of coverage over exons
    * JSONising of dragen metrics
    * Compression of json files
    * Compression of vcf files
    * Creation of the output directory with the select files

requirements:
    InlineJavascriptRequirement: {}
    ScatterFeatureRequirement: {}
    MultipleInputFeatureRequirement: {}
    StepInputExpressionRequirement: {}
    SchemaDefRequirement:
      types:
        - $import: ../../../schemas/tso500-outputs-by-sample/1.0.0/tso500-outputs-by-sample__1.0.0.yaml
        - $import: ../../../schemas/custom-output-dir-entry/2.0.1/custom-output-dir-entry__2.0.1.yaml

inputs:
  tso500_outputs_by_sample:
    label: tso500 outputs by sample
    doc: |
      Directories and Files of UMCCR tso500 output
    type: ../../../schemas/tso500-outputs-by-sample/1.0.0/tso500-outputs-by-sample__1.0.0.yaml#tso500-outputs-by-sample
  tso_manifest_bed:
    label: tso manifest bed
    type: File
    doc: |
      TST500C_manifest.bed file from TSO500 resources

steps:
  ##############################
  # Pre steps / expression steps
  ##############################
  get_raw_bam_file_intermediate_step:
    label: get bam file intermediate step
    doc: |
      Get the raw bam file from the AlignCollapseFusionCaller directory for the sample
      Returns the bam file with the bam index as a secondary file
    in:
      input_dir:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.align_collapse_fusion_caller_dir;
           }
      bam_nameroot:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.sample_id;
          }
    out:
      - id: bam_file
    run: ../../../expressions/get-bam-file-from-directory/1.0.0/get-bam-file-from-directory__1.0.0.cwl
  get_vcf_files_intermediate_step:
    label: get vcf files intermediate step
    doc: |
      Get the vcf files from the results folder for a given sample. Returns the following files:
        * MergedSmallVariants.vcf
        * CopyNumberVariants.vcf
        * MergedSmallVariants.genome.vcf
    in:
      input_dir:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.results_dir;
          }
      file_basename_list:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return [
                     self.sample_id + "_MergedSmallVariants.vcf",
                     self.sample_id + "_CopyNumberVariants.vcf",
                     self.sample_id + "_MergedSmallVariants.genome.vcf"
                   ];
          }
    out:
      - id: output_files
    run: ../../../expressions/get-files-from-directory/1.0.0/get-files-from-directory__1.0.0.cwl
  get_align_collapse_fusion_caller_metrics_csv_files_intermediate_step:
    label: get align collapse fusion caller metrics csv files intermediates step
    doc: |
      Get the metrics csv files generated by dragen in the AlignCollapseFusionCaller folder
      Return a compressed json file as output
    in:
      input_dir:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.align_collapse_fusion_caller_dir;
          }
      file_basename_list:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return [
                     self.sample_id + ".mapping_metrics.csv",
                     self.sample_id + ".trimmer_metrics.csv",
                     self.sample_id + ".umi_metrics.csv",
                     self.sample_id + ".wgs_coverage_metrics.csv",
                     self.sample_id + ".sv_metrics.csv",
                     self.sample_id + ".time_metrics.csv"
                   ];
          }
    out:
      - id: output_files
    run: ../../../expressions/get-files-from-directory/1.0.0/get-files-from-directory__1.0.0.cwl
  get_tmb_json_intermediate_step:
    label: get tmb json intermediate step
    doc: |
      Get the tmb json file from the TMB directory
    in:
      input_dir:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.tmb_dir;
          }
      file_basename:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.sample_id + ".tmb.json";
          }
    out:
      - id: output_file
    run: ../../../expressions/get-file-from-directory/1.0.0/get-file-from-directory__1.0.0.cwl
  get_msi_json_intermediate_step:
    label: get msi json intermediate step
    doc: |
      Get the MSI json file from the MSI directory
    in:
      input_dir:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.msi_dir;
          }
      file_basename:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.sample_id + ".msi.json";
          }
    out:
      - id: output_file
    run: ../../../expressions/get-file-from-directory/1.0.0/get-file-from-directory__1.0.0.cwl
  get_tmb_trace_tsv_intermediate_step:
    label: get tmb trace tsv intermediate step
    doc: |
      Get the tmb trace tsv file from the TMB Directory
    in:
      input_dir:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.tmb_dir;
          }
      file_basename:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.sample_id + "_TMB_Trace.tsv";
          }
    out:
      - id: output_file
    run: ../../../expressions/get-file-from-directory/1.0.0/get-file-from-directory__1.0.0.cwl
  get_fragment_length_hist_csv_intermediate_step:
    label: get fragment length hist csv intermediate step
    doc: |
      Get the fragment length hist csv from the AlignCollapseFusionCaller directory
    in:
      input_dir:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.align_collapse_fusion_caller_dir;
          }
      file_basename:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.sample_id + ".fragment_length_hist.csv";
          }
    out:
      - id: output_file
    run: ../../../expressions/get-file-from-directory/1.0.0/get-file-from-directory__1.0.0.cwl
  get_fusion_csv_intermediate_step:
    label: get fusion csv intermediate step
    doc: |
      Get the fusions csv file from the results folder
    in:
      input_dir:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.results_dir;
          }
      file_basename:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.sample_id + "_Fusions.csv";
          }
    out:
      - id: output_file
    run: ../../../expressions/get-file-from-directory/1.0.0/get-file-from-directory__1.0.0.cwl
  get_sample_analysis_results_intermediate_step:
    label: get sample analysis results intermediate step
    doc: |
      Get the sample analysis results json file. We need to have this as an output of a step rather than
      a component of a schema for the downstream step
    in:
      input_file:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.sample_analysis_results_json;
          }
    out:
      - id: output_file
    run: ../../../expressions/parse-file/1.0.0/parse-file__1.0.0.cwl
  ##############################
  # End of expression steps
  ##############################

  ##############################
  # Dragen multiqc steps
  ##############################
  # Create dummy file
  create_dummy_file_step:
    label: Create dummy file
    doc: |
      Intermediate step for letting multiqc-interop be placed in stream mode
    in: { }
    out:
      - id: dummy_file_output
    run: ../../../tools/custom-touch-file/1.0.0/custom-touch-file__1.0.0.cwl
  run_dragen_multiqc_on_align_collapse_fusion_caller_dir_step:
    label: run dragen multiqc on align collapse fusion caller dir step
    doc: |
      Run the dragen and dragen fastqc modules on the align collapse fusion caller directory
    requirements:
      DockerRequirement:
        dockerPull: quay.io/umccr/multiqc:1.13dev--alexiswl--merge-docker-update-and-clean-names--a5e0179
    in:
      input_directories:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.align_collapse_fusion_caller_dir;
          }
      output_directory_name:
        source: tso500_outputs_by_sample
        valueFrom: "$(self.sample_id)_ctDNA_alignment_collapse_fusion_caller_multiqc"
      output_filename:
        source: tso500_outputs_by_sample
        valueFrom: "$(self.sample_id)__ctDNA_alignment_collapse_fusion_caller_multiqc.html"
      title:
        source: tso500_outputs_by_sample
        valueFrom: "UMCCR MultiQC ctDNA Alignment Collapse Fusion Caller for $(self.sample_id)"
      dummy_file:
        source: create_dummy_file_step/dummy_file_output
    out:
      - id: output_directory
    run: ../../../tools/multiqc/1.12.0/multiqc__1.12.0.cwl

  ################
  # Coverage steps
  ################
  mosdepth_step:
    label: mosdepth step
    doc: |
      Use the tso manifest input file and report the threshold of coverage over each region of interest
    in:
      by:
        source: tso_manifest_bed
      bam_sorted: get_raw_bam_file_intermediate_step/bam_file
      thresholds:
        valueFrom: |
          ${
            return [
                     100, 250, 500, 750, 1000,
                     1500, 2000, 2500, 3000,
                     4000, 5000, 8000, 10000
                   ];
          }
      no_per_base:
        valueFrom: |
          ${
            return true;
          }
      prefix:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.sample_id;
          }
    out:
      - id: thresholds_bed_gz
    run: ../../../tools/mosdepth/0.3.1/mosdepth__0.3.1.cwl
  make_exon_coverage_qc_step:
    label: make exon coverage qc step
    doc: |
      Provide which exons have an insufficient amount of coverage
    in:
      threshold_bed_file: mosdepth_step/thresholds_bed_gz
      prefix:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.sample_id;
          }
    out:
      - id: failed_coverage_txt
    run: ../../../tools/custom-tso500-make-exon-coverage-qc/1.0.0/custom-tso500-make-exon-coverage-qc__1.0.0.cwl
  make_per_coverage_threshold_qc_step:
    label: make per coverage threshold qc step
    doc: |
      For each region of coverage, summate how many regions had sufficient coverage of each coverage level
    in:
      threshold_bed_file: mosdepth_step/thresholds_bed_gz
      prefix:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.sample_id;
          }
    out:
      - id: target_region_coverage_metrics
    run: ../../../tools/custom-tso500-make-region-coverage-qc/1.0.0/custom-tso500-make-region-coverage-qc__1.0.0.cwl
  #######################
  # End of Coverage steps
  #######################

  ######################
  # Metrics to json step
  ######################
  dragen_metrics_to_json_step:
    label: dragen metrics to json step
    doc: |
      Collect all of the dragen metrics and convert to compressed json
    in:
      output_prefix:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.sample_id;
          }
      csv_metrics_files:
        source: get_align_collapse_fusion_caller_metrics_csv_files_intermediate_step/output_files
    out:
      - id: metrics_json_gz_out
    run: ../../../tools/custom-tso500-align-collapse-fusion-caller-csv-metrics-to-json/1.0.0/custom-tso500-align-collapse-fusion-caller-csv-metrics-to-json__1.0.0.cwl
  #############################
  # End of Metrics to json step
  #############################

  #####################################
  # Compress reporting jsons with gzips
  #####################################
  # Start by compressing jsons with gzip
  compress_reporting_jsons_with_gzip_step:
    label: compress reporting jsons with gzip step
    doc: |
      Compress the tmb, msi and sample analysis results jsons with gzip
    scatter: uncompressed_file
    # bgzip needs drastically less than usual given how small these files are!
    requirements:
      ResourceRequirement:
        ilmn-tes:resources:
          tier: standard
          type: standard
          size: medium
        coresMin: 1
        ramMin: 4000
    in:
      uncompressed_file:
        source:
          - get_tmb_json_intermediate_step/output_file
          - get_msi_json_intermediate_step/output_file
          - get_sample_analysis_results_intermediate_step/output_file
        linkMerge: merge_flattened
    out:
      - id: compressed_out_file
    run: ../../../tools/custom-gzip-file/1.0.0/custom-gzip-file__1.0.0.cwl

  # Gather compressed jsons
  gather_compressed_reporting_json_files_into_tar_step:
    label: gather compressed reporting json files into tar step
    doc: |
      Zip up the compressed jsons into a tar ball.
      This is to limit the number of input files / directories into the final collection step.
    # tar needs drastically less than usual given how small these files are!
    requirements:
      ResourceRequirement:
        ilmn-tes:resources:
          tier: standard
          type: standard
          size: medium
        coresMin: 1
        ramMin: 4000
    in:
      dir_name:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.sample_id;
          }
      file_list:
        source: compress_reporting_jsons_with_gzip_step/compressed_out_file
    out:
      - id: output_compressed_tar_file
    run: ../../../tools/custom-tar-file-list/1.0.0/custom-tar-file-list__1.0.0.cwl
  ###############################
  # End Compress jsons with gzips
  ###############################

  ####################################
  # Metrics csvs into compressed jsons
  ####################################
  # Two intermediate steps to print out '0' or '1' for the different skip_rows section for the json files.
  get_zero_val_for_skip_rows_parameter:
    label: get zero val for skip rows parameter
    doc: |
      Get a zero value for skip rows parameter
    in:
      input_int:
        valueFrom: |
          ${
            return 0;
          }
    out:
      - id: output_int
    run: ../../../expressions/parse-int/1.0.0/parse-int__1.0.0.cwl
  get_one_val_for_skip_rows_parameter:
    label: get one val for skip rows parameter
    doc: |
      Get a one value for skip rows parameter
    in:
      input_int:
        valueFrom: |
          ${
            return 1;
          }
    out:
      - id: output_int
    run: ../../../expressions/parse-int/1.0.0/parse-int__1.0.0.cwl

  convert_metric_csvs_into_json_gzip_step:
    label: convert metric csvs into json gzip step
    doc: |
      Convert the metric csv files into compressed jsons
    scatter: [tsv_file, skip_rows]
    scatterMethod: dotproduct
    in:
      tsv_file:
        source:
          - get_tmb_trace_tsv_intermediate_step/output_file
          - get_fragment_length_hist_csv_intermediate_step/output_file
          - get_fusion_csv_intermediate_step/output_file
          - make_exon_coverage_qc_step/failed_coverage_txt
          - make_per_coverage_threshold_qc_step/target_region_coverage_metrics
        linkMerge: merge_flattened
      skip_rows:
        source:
          - get_zero_val_for_skip_rows_parameter/output_int
          - get_zero_val_for_skip_rows_parameter/output_int
          - get_zero_val_for_skip_rows_parameter/output_int
          - get_one_val_for_skip_rows_parameter/output_int
          - get_zero_val_for_skip_rows_parameter/output_int
        #  source:
        #    - get_tmb_trace_tsv_intermediate_step/output_files
        #    - get_fragment_length_hist_csv_intermediate_step/output_files
        #    - get_fusion_csv_intermediate_step/output_files
        #    - make_exon_coverage_qc_step/failed_coverage_txt
        #    - make_per_coverage_threshold_qc_step/target_region_coverage_metrics
        #  valueFrom: |
        #    ${
        #      if ( self.basename.indexOf("_Failed_Exon_coverage_QC.txt") !== -1 ){
        #        /*
        #        This is the failed coverage txt file - it needs to have the first row skipped
        #        */
        #        return 1;
        #      } else {
        #        /*
        #        Otherwise no rows need to be skipped
        #        */
        #        return 0;
        #      }
        #    }
        # linkMerge: merge_flattened
    out:
      - id: json_gz_out
    run: ../../../tools/custom-tsv-to-json/1.0.0/custom-tsv-to-json__1.0.0.cwl

  # Gather compressed metrics into a tar ball
  gather_compressed_metric_json_files_into_tar_step:
    label: gather compressed metric json files into tar step
    doc: |
      Gather the compressed metric jsons files into a tar ball.
      This is to limit the number of input files / directories into the final collection step.
    # gzip needs drastically less than usual given how small these files are!
    requirements:
      ResourceRequirement:
        ilmn-tes:resources:
          tier: standard
          type: standard
          size: medium
        coresMin: 1
        ramMin: 4000
    in:
      dir_name:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.sample_id;
          }
      file_list:
        source: convert_metric_csvs_into_json_gzip_step/json_gz_out
    out:
      - id: output_compressed_tar_file
    run: ../../../tools/custom-tar-file-list/1.0.0/custom-tar-file-list__1.0.0.cwl
  ########################################
  # End Metrics csvs into compressed jsons
  ########################################

  ####################################
  # Compress and index vcf files steps
  ####################################
  # Compress all of the vcf files with bgzip
  compress_vcf_files_step:
    label: compress vcf files step
    doc: |
      Compress (and index) vcf files with bgzip
    scatter: uncompressed_vcf_file
    # bgzip needs drastically less than usual given how small these files are!
    requirements:
      ResourceRequirement:
        ilmn-tes:resources:
          tier: standard
          type: standard
          size: medium
        coresMin: 1
        ramMin: 4000
    in:
      uncompressed_vcf_file:
        source: get_vcf_files_intermediate_step/output_files
    out:
      - id: compressed_output_vcf_file
    run: ../../../tools/bgzip/1.12.0/bgzip__1.12.0.cwl
  # Index vcf files
  index_vcf_files_step:
    label: index vcf files step
    doc: |
      Add the tabix specific index to the vcf files
    scatter: vcf_file
    in:
      vcf_file:
        source: compress_vcf_files_step/compressed_output_vcf_file
    out:
      - id: vcf_file_indexed
    run: ../../../tools/tabix/0.2.6/tabix__0.2.6.cwl

  # Gather all of the vcf files
  gather_compressed_vcf_files_into_tar_step:
    label: gather compressed vcf files into tar step
    doc: |
      Gather the vcf files into a tar ball.
      This is to limit the number of input files / directories into the final collection step.
    # tar needs drastically less than usual given how small these files are!
    requirements:
      ResourceRequirement:
        ilmn-tes:resources:
          tier: standard
          type: standard
          size: medium
        coresMin: 1
        ramMin: 4000
    in:
      dir_name:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.sample_id;
          }
      vcf_file_list:
        source: index_vcf_files_step/vcf_file_indexed
    out:
      - id: output_compressed_tar_file
    run: ../../../tools/custom-tar-vcf-file-list/1.0.0/custom-tar-vcf-file-list__1.0.0.cwl
  ########################################
  # End compress and index vcf files steps
  ########################################

  ################################
  # Create custom output dir steps
  ################################
  # Create custom output entry list
  create_custom_output_entry_list_array_step:
    label: create custom output entry list array step
    doc: |
      Create the array of inputs to go into custom create directory.
    in:
      sample_id:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.sample_id;
          }
      align_collapse_fusion_caller_dir:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.align_collapse_fusion_caller_dir;
          }
      combined_variant_output_dir:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.combined_variant_output_dir;
          }
      merged_annotation_dir:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.merged_annotation_dir;
          }
      tmb_dir:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.tmb_dir;
          }
      variant_caller_dir:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.variant_caller_dir;
          }
      multiqc_dir:
        source: run_dragen_multiqc_on_align_collapse_fusion_caller_dir_step/output_directory
      coverage_qc_file:
        source: make_exon_coverage_qc_step/failed_coverage_txt
      dragen_metrics_compressed_json_file:
        source: dragen_metrics_to_json_step/metrics_json_gz_out
      fusion_csv:
        source: get_fusion_csv_intermediate_step/output_file
      vcf_tarball:
        source: gather_compressed_vcf_files_into_tar_step/output_compressed_tar_file
      compressed_metrics_tarball:
        source: gather_compressed_metric_json_files_into_tar_step/output_compressed_tar_file
      compressed_reporting_tarball:
        source: gather_compressed_reporting_json_files_into_tar_step/output_compressed_tar_file
    out:
      - id: tso500_output_dir_entry_list
    run: ../../../expressions/get-custom-output-dir-entry-for-tso500-post-processing/2.0.1/get-custom-output-dir-entry-for-tso500-post-processing__2.0.1.cwl

  # Create the output directory
  create_output_directory:
    label: create output directory
    doc: |
      Create the output directory containing all the files listed in the previous step.
    in:
      output_directory_name:
        source: tso500_outputs_by_sample
        valueFrom: |
          ${
            return self.sample_id;
          }
      custom_output_dir_entry_list:
        source: create_custom_output_entry_list_array_step/tso500_output_dir_entry_list
    out:
      - id: output_directory
    run: ../../../tools/custom-create-directory/2.0.1/custom-create-directory__2.0.1.cwl
  ####################################
  # End create custom output dir steps
  ####################################

outputs:
  post_processing_output_directory:
    label: tso500 post processing output directory
    doc: |
      Post processing output directory for tso500
    type: Directory
    outputSource: create_output_directory/output_directory
