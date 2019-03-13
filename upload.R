rm(list=ls())
library(revealgenomics)
library(TCGAbiolinks)
rg_connect()
# init_db(arrays_to_init = get_entity_names())

########## PROJECT #########
p = data.frame(name = 'TCGA', description = 'The Cancer Genome Atlas')
project_id = register_project(df = p)

######### DATASET ##########
# Parse TCGA project names (studies in our schema)
source('~/coding/downloads/tcga-biolinks-download/functions.R')
tcga_subprojects = formulate_tcga_subproject_dataframe()
tcga_subprojects$project_id = project_id
dataset_idx = register_dataset(df = tcga_subprojects)

all_datasets = get_datasets()
######## INDIVIDUAL ##########
download_path = '~/Downloads/'
for (idx in 1:nrow(dataset_idx)) {
  dataset = all_datasets[all_datasets$dataset_id == dataset_idx[idx, ]$dataset_id, ]
  message("==============================================")
  message("idx: ", idx, " of ", nrow(dataset_idx), " --- TCGA subproject: ", dataset$name)
  message("==============================================")
  
  tcga_proj = dataset$name
  
  ############### Individual data #########################  
  cat("\t********* Clinical data *********")
  load(file.path(download_path, paste0(proj, '-clinical_data.Rda')))
  
  clin1 = L1$clin1
  clin2 = L1$clin2
  
  common_cols = intersect(colnames(clin1), colnames(clin2))
  all.equal(clin1[, common_cols], clin2[, common_cols])
  
  clindf = merge(
    clin1,
    clin2[, c('bcr_patient_barcode', colnames(clin2)[!(colnames(clin2) %in% common_cols)])],
    by = 'bcr_patient_barcode',
    all = TRUE
  )
  
  clindf$name = clindf$bcr_patient_barcode
  clindf$dataset_id = dataset$dataset_id
  clindf$description = '...'
  
  cat("\tRemoving duplicates\n")
  clindf = unique(clindf)
  
  individual_idx = register_individual(df = clindf)
  individual_df = get_individuals(individual_id = individual_idx$individual_id)
  
  ############### Restore TCGA sample data object #########################  
  cat("\t********* Gene expression data *********")
  genexp_filename = file.path(download_path, paste0(proj, '-genexp_data_grch38.Rda'))
  load(genexp_filename)
  # df1 = as.data.frame(colData(data))
  # matrix_data = assay(data)
  
  ############### Biosample data ##############
  sample_df = as.data.frame(data@colData)
  
  stopifnot(all(sample_df$patient %in% individual_df$name))
  m1 = find_matches_and_return_indices(sample_df$patient, individual_df$name)
  stopifnot(length(m1$source_unmatched_idx) == 0)
  
  sample_df$individual_id = individual_df[m1$target_matched_idx, ]$individual_id
  sample_df$name = sample_df$sample
  sample_df$dataset_id = dataset$dataset_id
  sample_df$description = '...'
  
  biosample_idx = register_biosample(df = sample_df)
  
  ############### Feature data ##############
  gene_df = as.data.frame(data@rowRanges)
  
  ############### Expression data ##############
  matrix_data = data@assays$data[[1]]
}
