#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.fastq_source_folder = "/home/ubuntu/Paired_230130_G4-015_0044_unfiltered_fastq"
params.file_name_root = "Paired_Undetermined_S0_"
params.samplesheet = "/home/ubuntu/G15_44_samplesheet.csv"
params.output_dir_name = "demuxed_file"
params.allowed_mismatches = 3
params.min_delta = 2
params.out = "/home/ubuntu/test/"

fastq_source_folder = Channel.fromPath(params.fastq_source_folder, type: "dir", checkIfExists: true).toList()
samplesheet = file(params.samplesheet)

workflow {
    sgdemux_folder(fastq_source_folder, params.file_name_root, samplesheet, params.output_dir_name, params.allowed_mismatches, params.min_delta)
}


process sgdemux_folder {

    //errorStrategy 'ignore'
    publishDir params.out, overwrite: true
    memory '40 GB'
    cpus 16
    input:
    path(fastq_source_folder)
    val(file_name_root)
    file(samplesheet)
    val(output_dir_name)
    val(allowed_mismatches)
    val(min_delta)

    output:
    path("demuxed_file")

    """
    mkdir ${output_dir_name}
    sgdemux --fastqs ${fastq_source_folder}/${file_name_root} --sample-metadata ${samplesheet} --output-dir ${output_dir_name} --allowed-mismatches ${allowed_mismatches} --min-delta ${min_delta}
    """
}


