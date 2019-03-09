# Goals

## Phase 1

Need to create a data download script using this R package http://bioconductor.org/packages/release/bioc/html/TCGAbiolinks.html. 

Need the script to download 
- clinical data (see section "Get clinical indexed data" at http://bioconductor.org/packages/release/bioc/vignettes/TCGAbiolinks/inst/doc/clinical.html)
- gene expression data (see section "Search and download data for two samples from database" at http://bioconductor.org/packages/release/bioc/vignettes/TCGAbiolinks/inst/doc/download_prepare.html)

This has to be done for:
- all projects (see section "project options" at http://bioconductor.org/packages/release/bioc/vignettes/TCGAbiolinks/inst/doc/query.html)
- for all "Gene Expression Quantification" pipelines at GRCh38 (get list of pipelines at section "Harmonized data options (legacy = FALSE)" at http://bioconductor.org/packages/release/bioc/vignettes/TCGAbiolinks/inst/doc/query.html)

## Phase 2

- unless the download format is extremely different, do the gene expression download for all "Gene Expression Quantification" pipelines at GRCh19 (get list of pipelines at section "Legacy archive data options (legacy = TRUE)" at http://bioconductor.org/packages/release/bioc/vignettes/TCGAbiolinks/inst/doc/query.html)

# Pseudocode

See file `tcga_download_pseudocode.md`

# Conditions

- Will continue to print a high level summary as the download is going on 
- Will not repeat downloads that have already been completed
