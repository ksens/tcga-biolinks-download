library(rvest)
library(magrittr)

# formulate TCGA list of subprojects (TCGA-BRCA, TCGA-LUAD etc. into a dataframe)
formulate_tcga_subproject_dataframe = function() {
  url = 'https://tcga-data.nci.nih.gov/docs/publications/tcga/'
  pg = read_html(url)
  xpath = '//*[@id="ext-comp-1003"]/table'
  tcga_subprojects = pg %>% 
    html_nodes(xpath=xpath) %>% extract2(1) %>% html_table(header=TRUE, trim=TRUE)
  head(tcga_subprojects)
  
  tcga_subprojects$description = tcga_subprojects$`Available Cancer Types`
  tcga_subprojects$name = paste0(
    "TCGA-",
    str_match(tcga_subprojects$description, "\\[(.*)\\]")[,2])
  
  tcga_subprojects
}