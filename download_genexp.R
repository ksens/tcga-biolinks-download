rm(list=ls())
library(stringr)
library(TCGAbiolinks)
source('~/coding/downloads/tcga-biolinks-download/functions.R')

tcga_subprojects = formulate_tcga_subproject_dataframe()

idx = 1
for (idx in 1:length(tcga_subprojects$name)) {
  proj = tcga_subprojects$name[idx]
  
  
  message("==============================================")
  message("idx: ", idx, " of ", nrow(tcga_subprojects), " --- TCGA subproject: ", proj)
  message("==============================================")
  
  genexp_filename = paste0('~/Downloads/', proj, '-clinical_data.Rda')
  
  if (!file.exists(genexp_filename)) {
    # load(paste0('~/Downloads/', proj, '-clinical_data.Rda'))
    
    query <- GDCquery(project = proj,
                      data.category = "Transcriptome Profiling",
                      data.type = "Gene Expression Quantification",
                      workflow.type = "HTSeq - FPKM-UQ")
    GDCdownload(query)
    data <- GDCprepare(query)
    
    # df1 = as.data.frame(colData(data))
    # matrix_data = assay(data)
    save(list = 'data',
         file = genexp_filename
    )
  } else {
    cat("Skipping since already downloaded\n")
  }
}
