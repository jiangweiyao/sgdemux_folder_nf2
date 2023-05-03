#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { sgdemux_folder_pipeline } from './subworkflows/sgdemux_folder.nf2'
include { sgdemux_folder_lane_pipeline } from './subworkflows/sgdemux_folder_lane.nf2'
include { fastqc_multiqc_pipeline } from './subworkflows/fastqc_multiqc.nf2'

fastq_source_folder = Channel.fromPath(params.fastq_source_folder, type: "dir", checkIfExists: true).toList()
samplesheet = file(params.samplesheet)
lanes = Channel.from( 1, 2, 3, 4 )

if(params.filter_control) {
    filter_control = "--filter-control-reads"
}
else {
    filter_control = " "
}

workflow {
    if( params.lane_level) {
        sgdemux_folder_lane_pipeline(fastq_source_folder, params.file_name_root, samplesheet, params.output_dir_name, params.allowed_mismatches, params.min_delta, lanes, filter_control, params.nmask_threshold)
        if( params.multiqc) {
            fastqc_multiqc_pipeline(sgdemux_folder_lane_pipeline.out)
        }
    }
    else {
        sgdemux_folder_pipeline(fastq_source_folder, params.file_name_root, samplesheet, params.output_dir_name, params.allowed_mismatches, params.min_delta, filter_control, params.nmask_threshold)
        if( params.multiqc) {
            fastqc_multiqc_pipeline(sgdemux_folder_pipeline.out)
        }
    }
}



