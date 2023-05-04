# Nextflow Workflow (DSL2) for Demultiplexing G4 FASTQ Files

## Purpose
This workflow can be used to demultiplex the raw output fastq files from the G4 instrument. The expected input is the `unfiltered_fastq` directory from the run folder `230215_G4-015_0050_1_OM1167O/`. This workflow can either demultiplex each lane independently and put the outputs in different folders (for situations such as where different lanes use the same barcode for different samples). Or demultiplex and combine the output of the lanes together into a single folder (i.e. same samples are spread across the lanes. There is a 1 to 1 correspondence between barcode sequence and sample name). 

Optionally, this workflow can run FastQC/MultiQC on the demultiplexed FASTQ files to generate FastQC/MultiQC reports. 

## Dependencies
1. [Nextflow](https://www.nextflow.io/)
2. [Docker](https://www.docker.com/) - if you select to use the -profile docker option. Otherwise, singular-demux (and FastQC/MultiQC if multiqc option is enabled) needs to be installed and available in the environment through a `sgdemux` command.

## Nextflow Tower Integration
This workflow can be used directly with Nextflow Tower. This repo has an included nextflow_schema.json for generating a GUI form for the input of parameters.


## Sample data
You can download a tarball file containing an unfiltered_fastq dataset and corresponding samplesheets [here](https://singular-public-repo.s3.us-west-1.amazonaws.com/example_raw_files/unfiltered_fastq.tar.gz). The file needs to be untar-ed before use.

## Syntax
Example command to run the workflow is below. Including the "-profile docker" requires docker and will pull the latest docker image containing the sgdemux at the first run to run the workflow. Remove this option if you want to use the sgdemux on your system, and can be called using the `sgdemux` command.
```
nextflow run sgdemux_folder_nf2/main.nf -params-file sgdemux_folder_nf2/params_folder.json -profile docker
```

## Parameters
Example input parameter files in json and yaml format are included in the repo. Below is the the content of the params_folder.yaml file.

```
fastq_source_folder: s3://singular-public-repo/example_raw_files/unfiltered_fastq/
file_name_root: Undetermined_
samplesheet: s3://singular-public-repo/example_raw_files/samplesheet.csv
output_dir_name: demuxed_file
allowed_mismatches: 3
min_delta: 1
out: s3://singulargenomics1/users/JYao/nf/temp_out/sgdemux11
lane_level: false
filter_control: true
nmask_threshold: 2
multiqc: true
```

### Here is the description of the parameters:
fastq_source_folder: 
- Location of the folder of the FASTQ files you wish to demultiplex. Typically the "unfiltered_fastqs" in the G4 output. 
- Can be a S3 or a local location. 
- Example: "s3://singular-public-repo/example_raw_files/unfiltered_fastq/"

file_name_root: 
- The root name of FASTQ files. The name in the "unfiltered_fastqs" folder for G4 output is Undetermined.  
- Example: "Undetermined"

samplesheet: 
- Location of the Singular Genomic style samplesheet for demultiplexing the samples. 
- Can be a S3 or a local location. 
- Example: "s3://singular-public-repo/example_raw_files/samplesheet.csv"

output_dir_name: 
- Name of the output folder containing the demultiplexed output. 
- Example: "demuxed_file"

out: 
- The location of the output files. 
- Can be a S3 or a local location. 
- Example: "/home/ubuntu/test_demux"

lane_level: 
- Whether to demultiplex at the Lane Level (True) or Flow Cell Level (False) 
- true or false

multiqc:
- Whether to send the demultiplexed files to FastQC and collect metrics in MultiQC.
- true or false

allowed_mismatches:
- The number of mismatches allowed (total) between the expected and observed barcode bases for assigning reads to sample.
- Integer. The default value on instrument is 3.

min_delta:
- The minimum number of mismatches where the best match for a read is better than the next-best match.
- Integer. The default value on instrument is 1.

nmask_threshold:
- Mask template bases to N in all input reads where the base quality score is below the specified value.
- Integer. The default value on instrument is 10. The default value for most applications is 2 or 0 (no masking).

filter_control:
- Filter out reads marked as control reads in their FASTQ headers.
- true or false


