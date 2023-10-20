library(shiny)
library(shinyjs)

single_ui <-
  fluidPage(
    fluidRow(
      column(4,  # 第一列
             fileInput('single_dataFile', 'Choose mStat Data Object file', accept = c('.RData')),
             helpText("Learn how to construct the mStat object in R ",
                      a("here", href = "https://www.microbiomestat.wiki/setting-up-microbiomestat-installation-and-data-preparation/laying-the-foundation-creating-the-microbiomestat-data-object", target = "_blank"),
                      ". If you do not want to create it in R, you can upload the following files instead:"),
             conditionalPanel(
               condition = "input.single_dataFile == null",
               fileInput('single_countData', 'Count (feature.tab)', accept = c('.txt', '.csv')),
               fileInput('single_metadata', 'Metadata (meta.dat)', accept = c('.txt', '.csv')),
               fileInput('single_taxonomy', 'Taxonomy (feature.ann)', accept = c('.txt', '.csv')),
               fileInput('single_phyloTree', 'Phylogenetic Tree (tree) - Optional', accept = c('.tree', '.nwk')),
               helpText("Count, Metadata, and Taxonomy files should be formatted as text or CSV files. ",
                        "The Phylogenetic Tree file should be in Newick format with a .tree or .nwk extension.")
             ),
             selectInput('single_groupVar', 'Group Variable', choices = NULL),
             selectInput('single_visAdjVars', 'Visual Adjust Variables', choices = NULL, multiple = TRUE),
             selectInput('single_testAdjVars', 'Test Adjust Variables', choices = NULL, multiple = TRUE),
             selectInput('single_strataVar', 'Strata Variable', choices = NULL)
      ),
      column(4,  # 第二列
             selectInput('single_subjectVar', 'Subject Variable', choices = NULL),
             selectInput('single_timeVar', 'Time Variable', choices = NULL),
             selectInput('single_tLevel', 'Time Level', choices = NULL),
             selectInput('single_alphaName', 'Alpha Diversity Index',
                         choices = c("shannon", "simpson", "observed_species", "chao1", "ace", "pielou"),
                         selected = c("shannon", "observed_species"),
                         multiple = TRUE),
             sliderInput('single_depth', 'Depth', min = 1, max = 1, value = 1, step = 1),
             selectInput('single_distName', 'Distance Measure',
                         choices = c("BC", "Jaccard", "UniFrac",
                                     "GUniFrac", "WUniFrac", "JS"),
                         selected = c("BC", "Jaccard"),
                         multiple = TRUE
             ),
             numericInput('single_prevFilter', 'Prevalence Filter', value = 0.1, min = 0, max = 1),
             numericInput('single_abundFilter', 'Abundance Filter', value = 0.0001, min = 0, max = 1),
             selectInput('single_visFeatureLevel', 'Visual Feature Level', choices = c("original"), multiple = TRUE),
             selectInput('single_testFeatureLevel', 'Test Feature Level', choices = c("original"), multiple = TRUE),
             selectInput('single_featureDatType', 'Feature Data Type',
                         choices = c("count", "proportion", "other"), selected = "count")
      ),
      column(4,  # 第三列
             checkboxInput('single_featureAnalysisRarafy', 'Rarefy Feature-Level Analysis', value = TRUE),
             numericInput('single_barAreaFeatureNo', 'Number of Features in Bar/Area Plot', value = 40),
             numericInput('single_heatmapFeatureNo', 'Number of Features in Heatmap', value = 40),
             numericInput('single_dotplotFeatureNo', 'Number of Features in Dotplot', value = 40),
             selectInput('single_featureMtMethod', 'Multiple Testing Method for Features',
                         choices = c("fdr", "none"), selected = "none"),
             numericInput('single_featureSigLevel', 'Feature Significance Level', value = 0.3, min = 0.01, max = 1, step = 0.01),
             selectInput('single_featureBoxAxisTransform', 'Feature Box Axis Transformation',
                         choices = c("identity", "sqrt", "log"), selected = "identity"),
             numericInput('single_baseSize', 'Base Font Size', value = 16),
             selectInput('single_themeChoice', 'Theme Choice',
                         choices = c("prism", "classic", "gray", "bw"), selected = "bw"),
             textInput('single_outputFile', 'Output File Name', value = 'report.pdf'),
             actionButton('single_runAnalysis', 'Run Analysis'),
             uiOutput("single_report_ready_message"),
             uiOutput("single_download_report_ui")
      )
    )
  )
