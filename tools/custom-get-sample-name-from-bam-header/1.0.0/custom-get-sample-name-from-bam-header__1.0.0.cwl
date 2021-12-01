cwlVersion: v1.1
class: CommandLineTool

# Extensions
$namespaces:
    s: https://schema.org/
    ilmn-tes: http://platform.illumina.com/rdf/ica/
$schemas:
  - https://schema.org/version/latest/schemaorg-current-http.rdf

# Metadata
s:author:
    class: s:Person
    s:name: Alexis Lucattini
    s:email: Alexis.Lucattini@umccr.org
    s:identifier: https://orcid.org/0000-0001-9754-647X

# ID/Docs
id: custom-get-sample-name-from-bam-header--1.0.0
label: custom-get-sample-name-from-bam-header v(1.0.0)
doc: |
    Documentation for custom-get-sample-name-from-bam-header
    v1.0.0

# ILMN Resources Guide: https://support-docs.illumina.com/SW/ICA/Content/SW/ICA/RequestResources.htm
hints:
    ResourceRequirement:
        ilmn-tes:resources:
            tier: standard
            type: standard
            size: small
        coresMin: 2
        ramMin: 4000
    DockerRequirement:
        dockerPull: quay.io/biocontainers/samtools:1.14--hb421002_0

requirements:
  InitialWorkDirRequirement:
    listing:
      - entryname: get_sample_name.sh
        entry: |
          #!/usr/bin/env bash

          samtools view -H "$(inputs.bam_file.path)" | \\
          grep '^@RG' | \\
          tr \$'\\t' '\\n' | \\
          grep 'SM:' | \\
          cut -d':' -f2 > sample_name.txt 2>/dev/null

baseCommand: [ "bash", "get_sample_name.sh" ]

inputs:
  bam_file:
    label: bam file
    doc: |
      The bam file to stream in
    type: File
    secondaryFiles:
      - pattern: ".bai"
        required: false
    streamable: true

outputs:
  sample_name:
    type: string
    outputBinding:
      glob: "sample_name.txt"
      loadContents: true
      outputEval: |
        ${
            /*
            Load inputs initialise output variables
            */
            return self[0].contents.split("\n")[0];
        }

successCodes:
  - 0
