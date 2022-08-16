export interface BCLConvertDataRow {
    /*
    Set the possible types for the samplesheet field
    */
    lane: number
    sample_id: string
    index: string
    index2?: string
    sample_project: string
    override_cycles: string
}