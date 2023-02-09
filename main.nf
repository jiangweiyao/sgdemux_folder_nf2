#!/usr/bin/env nextflow

nextflow.enable.dsl=2


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
    path(params.output_dir_name)

    """
    mkdir ${output_dir_name}
    sgdemux --fastqs ${fastq_source_folder}/${file_name_root} --sample-metadata ${samplesheet} --output-dir ${output_dir_name} --allowed-mismatches ${allowed_mismatches} --min-delta ${min_delta}
    """
}


