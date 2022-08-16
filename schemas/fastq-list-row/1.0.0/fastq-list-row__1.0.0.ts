import { PrimitiveType } from "../../../typescript/lib/mappings/v1.0"
import { File } from "../../../typescript/lib/mappings/v1.0"

export interface FastqListRow {
    /*
    Set the possible types for the samplesheet field
    */
    rgid: string
    rglb: string
    rgsm: string
    lane: number
    read_1: File
    read_2?: File
}

