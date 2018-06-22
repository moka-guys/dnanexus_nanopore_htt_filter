# dnanexus_nanopore_htt_filter v1.0

## What does this app do?
This app takes a BAM with Oxford Nanopore long reads aligned to HTT gene, and filters out any reads that don't cover the whole CAG triplet repeat expansion region with 500bp padding 

## What are typical use cases for this app?
This app is used as part of the Oxford Nanopore HTT repeat counting workflow. It removes uninformative reads from BAMs prior to read depth normalisation.

## What data are required for this app to run?
The app requires a sorted indexed BAM file containing Oxford Nanopore reads aligned to hg19 reference sequence.

## What does this app output?
The app outputs 2 files:
1. sorted BAM file (filtered)
2. BAM index file (filtered)

## How does this app work?
The app uses samtools v1.5 (docker image: [quay.io/biocontainers/samtools:1.5--2] (https://quay.io/repository/biocontainers/samtools?tab=info)) to remove any reads that don't overlap with the region 500bp upstream of the HTT CAG repeat region and outputs a temporary BAM.
This temporary BAM is re-run through samtools to remove any reads that don't overlap the region 500bp downstream of the HTT CAG repeat region.

## What are the limitations of this app
This app should only be used for Oxford Nanopore data as part of the HTT repeat counting workflow.

## This app was made by Viapath Genome Informatics 