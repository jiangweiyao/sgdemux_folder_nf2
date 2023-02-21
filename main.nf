#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { sgdemux_folder_pipeline } from './subworkflows/sgdemux_folder.nf2'
include { sgdemux_folder_lane_pipeline } from './subworkflows/sgdemux_folder_lane.nf2'

fastq_source_folder = Channel.fromPath(params.fastq_source_folder, type: "dir", checkIfExists: true).toList()
samplesheet = file(params.samplesheet)
lanes = Channel.from( 1, 2, 3, 4 )

workflow {
    if( params.lane_level) {
        sgdemux_folder_lane_pipeline(fastq_source_folder, params.file_name_root, samplesheet, params.output_dir_name, params.allowed_mismatches, params.min_delta, lanes)
    }
    else {
        sgdemux_folder_pipeline(fastq_source_folder, params.file_name_root, samplesheet, params.output_dir_name, params.allowed_mismatches, params.min_delta)
    }
}



