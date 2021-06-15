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
    s:name: Sehrish Kanwal
    s:email: sehrish.kanwal@umccr.org

# ID/Docs
id: dragen-transcriptome-pipeline--3.7.5
label: dragen-transcriptome-pipeline v(3.7.5)
doc: |
  Workflow takes in dragen param along with object store version of a fastq_list.csv equivalent.
  See the fastq_list_row schema definitions for more information.
  More information on the documentation can be found [here](https://sapac.support.illumina.com/content/dam/illumina-support/help/Illumina_DRAGEN_Bio_IT_Platform_v3_7_1000000141465/Content/SW/Informatics/Dragen/GPipelineVarCal_fDG.htm)

requirements:
    InlineJavascriptRequirement: {}
    ScatterFeatureRequirement: {}
    MultipleInputFeatureRequirement: {}
    StepInputExpressionRequirement: {}
    SchemaDefRequirement:
      types:
        - $import: ../../../schemas/fastq-list-row/1.0.0/fastq-list-row__1.0.0.yaml
        - $import: ../../../schemas/predefined-mount-path/1.0.0/predefined-mount-path__1.0.0.yaml

inputs:
  fastq_list_rows:
    label: Row of fastq lists
    doc: |
      The row of fastq lists.
      Each row has the following attributes:
        * RGID
        * RGLB
        * RGSM
        * Lane
        * Read1File
        * Read2File (optional)
    type: ../../../schemas/fastq-list-row/1.0.0/fastq-list-row__1.0.0.yaml#fastq-list-row[]
  reference_tar:
    label: reference tar
    doc: |
      Path to ref data tarball
    type: File
  # Transcript annotation file
  annotation_file:
    label: annotation file
    doc: |
      Path to annotation transcript file.
    type: File
  # Output naming options
  output_file_prefix:
    label: output file prefix
    doc: |
      The prefix given to all output files
    type: string
  output_directory:
    label: output directory
    doc: |
      The directory where all output files are placed
    type: string
  # Alignment options
  enable_map_align_output:
    label: enable map align output
    doc: |
      Do you wish to have the output bam files present
    type: boolean?
  enable_duplicate_marking:
    label: enable duplicate marking
    doc: |
      Mark identical alignments as duplicates
    type: boolean?
    transcript-dragen:
    type: File
    doc: |
      Transcript file for annotation
  # Quantification options
  enable_rna_quantification:
    label: enable rna quantification
    type: boolean?
    doc: |
      Optional - Enable the quantification module - defaults to true
  # Fusion calling options
  enable_rna_gene_fusion:
    label: enable rna gene fusion
    type: boolean?
    doc: |
      Optional - Enable the DRAGEN Gene Fusion module - defaults to true
  # Arriba fusion calling options
  contigs:
    label: contigs
    type: string?
    doc: |
      Optional - List of interesting contigs
      If not specified, defaults to 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,X,Y
  blacklist:
    label: blacklist
    type: File
    doc: |
      File with blacklist range
  referenceFasta:
    label: referenceFasta
    type: File
    doc: |
      FastA file with genome sequence
  # Arriba drawing options
  cytobands:
    label: cytobands
    type: File
    doc: |
      Coordinates of the Giemsa staining bands.
  proteinDomains:
    label: protein domains
    type: File
    doc: |
      GFF3 file containing the genomic coordinates of protein domains

steps:
   # Create fastq_list.csv
  create_fastq_list_csv_step:
    label: create fastq list csv step
    doc: |
      Create the fastq list csv to then run the germline tool.
      Takes in an array of fastq_list_row schema.
      Returns a csv file along with predefined_mount_path schema
    in:
      fastq_list_rows:
        source: fastq_list_rows
    out:
      - fastq_list_csv_out
      - predefined_mount_paths_out
    run: ../../../tools/custom-create-csv-from-fastq-list-rows/1.0.0/custom-create-csv-from-fastq-list-rows__1.0.0.cwl
  # Run dragen transcriptome workflow
  run_dragen_transcriptome_step:
    label: run dragen transcriptome step
    doc: |
      Runs the dragen transcriptome workflow on the FPGA.
      Takes in a fastq list and corresponding mount paths from the predefined_mount_paths.
      All other options avaiable at the top of the workflow
    in:
      # Input fastq files to dragen
      # fastqlist also contains the metadata
      fastq_list:
        source: create_fastq_list_csv_step/fastq_list_csv_out
      fastq_list_mount_paths:
        source: create_fastq_list_csv_step/predefined_mount_paths_out
      reference_tar:
        source: reference_tar
      output_file_prefix:
        source: output_file_prefix
      output_directory:
        source: output_directory
      enable_map_align_output:
        source: enable_map_align_output
      enable_duplicate_marking:
        source: enable_duplicate_marking)
      annotation_file:
        source: annotation_file
      enable_rna_quantification:
        source: enable_rna_quantification
      enable_rna_gene_fusion:
        source: enable_rna_gene_fusion
    out:
      - dragen_transcriptome_directory
      - dragen_bam_out
    run: ../../../tools/dragen-transcriptome/3.7.5/dragen-transcriptome__3.7.5.cwl
  # Step-2: Call Arriba fusion calling step
  arriba_fusion_step:
    in: 
      bam_file:
        source: dragen_step/dragen_bam_out
      annotation:
        source: transcript-dragen
      reference: 
        source: referenceFasta-arribaFusion
      contigs:
        source: contigs-arribaFusion
      blacklist: 
        source: blacklist-arribaFusion
    out:
      - fusions
      - discardedFusions
    run: ../../tools/arriba/2.0.0/arriba-fusion.cwl
  # Step-3: Call Arriba drawing script
  arriba_drawing_step:
    in:
      annotation:
        source: transcript-dragen
      fusions: 
        source: arriba_fusion_step/fusions
      bam_file:
        source: dragen_step/dragen_bam_out
      cytobands:
        source: cytobands-arribaDrawing
      proteinDomains:
        source: proteinDomains-arribaDrawing
    out: 
      - outPDF
    run:  ../../tools/arriba/2.0.0/arriba-drawing.cwl

outputs:
  dragen-output:
    type: Directory
    outputSource: dragen_step/dragen_transcriptome_directory
  arriba-fusion-output:
    type: File
    outputSource: arriba_fusion_step/fusions
  arriba-discardedFusion-output:
    type: File
    outputSource: arriba_fusion_step/discardedFusions
  arriba-pdf:
    type: File
    outputSource: arriba_drawing_step/outPDF
