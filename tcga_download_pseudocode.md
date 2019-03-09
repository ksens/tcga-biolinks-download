list_project = list of all projects 

list_gene_exp_pipelines_38 = retrieve all gene expression pipelines at GRCh38 (legacy = FALSE)
list_gene_exp_pipelines_19 = retrieve all gene expression pipelines at GRCh19 (legacy = TRUE)

for project in list_project
	
	list_patient = retrieve patients in this project
	list_samples = retrieve samples in this project

	clinical_data_patient = retrieve clinical data for all samples
	clinical_data_sample = retrieve clinical data for all samples # potentially clinical data exists only per sample

	save project, list_patient, list_samples, clinical_data_patient, clinical_data_sample into uniquely named workspace object (name.Rda)

	for pipeline in list_gene_exp_pipelines_38

		gxp_pipeline_project = retrieve gene expression data for given pipeline in given project
									# if download is very large, might have to break this down by groups of samples at a time
									# and then reconstitute back in memory

		save project, pipeline, gxp_pipeline_project into uniquely named workspace object

	for pipeline in list_gene_exp_pipelines_19

		gxp_pipeline_project = retrieve gene expression data for given pipeline in given project

		save project, pipeline, gxp_pipeline_project into uniquely named workspace object


# Do not repeat the download if uniquely named workspace object already exists

