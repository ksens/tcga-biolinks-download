rm(list=ls())
library(stringr)
library(TCGAbiolinks)
source('~/coding/downloads/tcga-biolinks-download/functions.R')

tcga_subprojects = formulate_tcga_subproject_dataframe()
workflow_types = c(
  "HTSeq - FPKM-UQ",
  "HTSeq - FPKM",
  "HTSeq - Counts"
)
for (workflow_type in workflow_types) {
  message("==============================================")
  message("workflow type: ", workflow_type)
  message("==============================================")
  
  for (idx in 1:length(tcga_subprojects$name)) {
    proj = tcga_subprojects$name[idx]
    message("==============================================")
    message("idx: ", idx, " of ", nrow(tcga_subprojects), " --- TCGA subproject: ", proj)
    message("==============================================")
    
    genexp_filename = paste0(
      '~/Downloads/', 
      proj, '--', 
      gsub(" ", "", workflow_type), 
      '--genexp_data_grch38.Rda')
    
    if (!file.exists(genexp_filename)) {
      # load(paste0('~/Downloads/', proj, '-clinical_data.Rda'))
      
      query <- GDCquery(project = proj,
                        data.category = "Transcriptome Profiling",
                        data.type = "Gene Expression Quantification",
                        workflow.type = workflow_type)
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
    
}
