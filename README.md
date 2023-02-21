# Nextflow Workflow (DSL2) for Demultiplexing G4 Fastq Files

This workflow can be used to demultiplex the raw output fastq files from the G4 instrument. The expected input is <unfiltered_fastq> directory from the run folder <i.e 230215_G4-015_0050_1_OM1167O/>. This workflow can either demultiplex each lane independently and put the outputs in different folders (for situations such as where different lanes use the same barcode for different samples). Or demultiplex and combine the output of the lanes together into a single folder (i.e. same samples are spread across the lanes. There is a 1 to 1 correspondence between barcode sequence and sample name). 

### Usage
The "params_lane.json" file in the repo contains example parameters for running the demux workflow at the lane level. The "params_folder.json" file contains example parameters for running the demux workflow combining the lanes.

#### Syntax
Example command to run the workflow is below. Including the "-profile docker" requires docker and will pull the latest docker image containing the sgdemux at the first run to run the workflow. Remove this option if you want to use the sgdemux on your system, and can be called using the `sgdemux` command.
```
nextflow run sgdemux_folder_nf2/main.nf -params-file sgdemux_folder_nf2/params_folder.json -profile docker
```


