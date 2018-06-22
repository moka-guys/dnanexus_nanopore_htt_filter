#!/bin/bash

# -e = exit on error; -x = output each line that is executed to log; -o pipefail = throw an error if there's an error in pipeline
set -e -x -o pipefail

main() {

    # Download BAM and index
    dx-download-all-inputs 

    # Move BAM and index to home directory
    mv ${bam_path} ~/
    mv ${bai_path} ~/

    # Create output directories
    mkdir -p $HOME/out/filteredbam/bam/
    mkdir -p $HOME/out/filteredbai/bam/

    # samtools view can take a region in form of chr:coordinates and discard any reads that don't overlap with that region. 
    # First filter reads that don't overlap with region 500bp upstream of HTT CAG repeat region and output temporary bam
    dx-docker run -v ~:/data quay.io/biocontainers/samtools:1.5--2 /bin/bash -c "samtools view -bh /data/${bam_name} chr4:3076103-3076104 | \
    samtools sort - -o /data/temp.bam && samtools index /data/temp.bam"
    # Next take temp.bam output above and filter out reads that don't overlap with region 500bp downstream of HTT CAG repeat region
    dx-docker run -v ~:/data quay.io/biocontainers/samtools:1.5--2 /bin/bash -c "samtools view -bh /data/temp.bam chr4:3077165-3077166 | \
    samtools sort - -o /data/${bam_prefix}.filtered_htt_CAG_500bp_flank.bam && samtools index /data/${bam_prefix}.filtered_htt_CAG_500bp_flank.bam"

    # Move bam and bam index to output directories
    sudo mv $HOME/${bam_prefix}.filtered_htt_CAG_500bp_flank.bam $HOME/out/filteredbam/bam/
    sudo mv $HOME/${bam_prefix}.filtered_htt_CAG_500bp_flank.bam.bai $HOME/out/filteredbai/bam/

    # Upload output
    dx-upload-all-outputs
}
