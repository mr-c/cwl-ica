export interface SampleSheetHeader {
    /*
    Set the possible types for the samplesheet field
    */
    iem_file_version: number
    experiment_name: string
    date: string
    workflow: string
    application: string
    instrument_type: string
    assay: string
    index_adapters: string
    chemistry: string
    file_format_version: number
}