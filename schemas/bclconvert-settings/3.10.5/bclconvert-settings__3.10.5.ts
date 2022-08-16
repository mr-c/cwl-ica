export interface BCLConvertSettings {
    /*
    Set the possible types for the samplesheet field
    */
    adapter_read_1: string | null
    adapter_read_2: string | null
    adapter_behavior: string | null
    adapter_stringency: number | null
    minimum_adapter_overlap: number | null
    barcode_mismatches_index_1: number | null
    barcode_mismatches_index_2: number | null
    create_fastq_for_index_reads: boolean | null
    minimum_trimmed_read_length: number | null
    mask_short_reads: boolean | null
    override_cycles: string | null
    trim_umi: boolean | null
}