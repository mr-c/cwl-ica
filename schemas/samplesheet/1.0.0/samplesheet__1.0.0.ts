import {SampleSheetHeader} from "../../samplesheet-header/1.0.0/samplesheet-header__1.0.0";
import {SampleSheetReads} from "../../samplesheet-reads/1.0.0/samplesheet-reads__1.0.0";
import {BCLConvertSettings} from "../../bclconvert-settings/3.10.5/bclconvert-settings__3.10.5";
import {BCLConvertDataRow} from "../../bclconvert-data-row/3.10.5/bclconvert-data-row__3.10.5";

export interface SampleSheet {
    /*
    Set the possible types for the samplesheet field
    */
    header: SampleSheetHeader
    reads: SampleSheetReads
    bclconvert_settings: BCLConvertSettings
    bclconvert_data: Array<BCLConvertDataRow>
}