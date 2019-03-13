rm(list=ls())
library(stringr)
library(TCGAbiolinks)
source('~/coding/downloads/tcga-biolinks-download/functions.R')

tcga_subprojects = formulate_tcga_subproject_dataframe()
download_location = '/data/tcga_downloads/'
for (idx in 1:length(tcga_subprojects$name)) {
  proj = tcga_subprojects$name[idx]
  
  message("==============================================")
  message("idx: ", idx, " of ", nrow(tcga_subprojects), " --- TCGA subproject: ", proj)
  message("==============================================")
  
  filename = paste0(download_location, proj, '-clinical_data.Rda')
  
  if (!file.exists(filename)) {
    L1 = tryCatch({
      cat("\tDownloading clinical table 1\n")
      clin1 <- GDCquery_clinic(project = proj, type = "clinical")
      
      cat("\tDownloading clinical table 2\n")
      query <- GDCquery(project = proj, 
                        data.category = "Clinical", 
                        file.type = "xml")
      GDCdownload(query)
      clin2 <- GDCprepare_clinic(query, clinical.info = "patient")
      list(
        clin1 = clin1,
        clin2 = clin2
      )
    }, error = function(e) {
      cat("Faced error. Saving empty list\n")
      list(
        clin1 = data.frame(),
        clin2 = data.frame()
      )
    })
    save(list = 'L1',
         file = filename
    )
  } else {
    cat("Skipping since already downloaded\n")
  }
}
