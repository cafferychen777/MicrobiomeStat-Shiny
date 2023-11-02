library(shiny)
library(shinyjs)

pair_ui <-
  fluidPage(
    fluidRow(
      column(4,  # 第一列
             fileInput('pair_dataFile', 'Choose mStat Data Object file', accept = c('.RData')),
             helpText("Learn how to construct the mStat object in R ",
                      a("here", href = "https://www.microbiomestat.wiki/setting-up-microbiomestat-installation-and-data-preparation/laying-the-foundation-creating-the-microbiomestat-data-object", target = "_blank"),
                      ". If you do not want to create it in R, you can upload the following files instead:"),
             conditionalPanel(
               condition = "input.pair_dataFile == null",
               fileInput('pair_countData', 'Count (feature.tab)', accept = c('.txt', '.csv')),
               fileInput('pair_metadata', 'Metadata (meta.dat)', accept = c('.txt', '.csv')),
               fileInput('pair_taxonomy', 'Taxonomy (feature.ann)', accept = c('.txt', '.csv')),
               fileInput('pair_phyloTree', 'Phylogenetic Tree (tree) - Optional', accept = c('.tree', '.nwk')),
               tags$div(style = "text-align: left;",
                        helpText(
                          "Count, Metadata, and Taxonomy files should be formatted as text or CSV files. ",
                          "The Phylogenetic Tree file should be in Newick format with a .tree or .nwk extension. ",
                          tags$br(),
                          "Example datasets: ",
                          downloadLink("downloadData4", "Download Count (feature.tab)"), ", ",
                          downloadLink("downloadData5", "Download Metadata (meta.dat)"), ", ",
                          downloadLink("downloadData6", "Download Taxonomy (feature.ann)")
                        )
               )
             ),
             selectInput('pair_groupVar', 'Group Variable', choices = NULL),
             selectInput('pair_visAdjVars', 'Visual Adjust Variables', choices = NULL, multiple = TRUE),
             selectInput('pair_testAdjVars', 'Test Adjust Variables', choices = NULL, multiple = TRUE),
             selectInput('pair_strataVar', 'Strata Variable', choices = NULL)
      ),
      column(4,  # 第二列
             selectInput('pair_subjectVar', 'Subject Variable', choices = NULL),
             selectInput('pair_timeVar', 'Time Variable', choices = NULL),
             selectInput('pair_changeBase', 'Change Base', choices = NULL),
             selectInput('pair_alphaName', 'Alpha Diversity Index',
                         choices = c("shannon", "simpson", "observed_species", "chao1", "ace", "pielou"),
                         selected = c("shannon", "observed_species"),
                         multiple = TRUE),
             selectInput('pair_alphaChangeFunc', 'Alpha Change Function', choices = c('log fold change', 'absolute change')),
             sliderInput('pair_depth', 'Depth', min = 1, max = 1, value = 1),
             selectInput('pair_distName', 'Distance Measure',
                         choices = c("BC", "Jaccard", "UniFrac",
                                     "GUniFrac", "WUniFrac", "JS"),
                         selected = c("BC", "Jaccard"),
                         multiple = TRUE),
             numericInput('pair_prevFilter', 'Prevalence Filter', value = 0.1, min = 0, max = 1),
             numericInput('pair_abundFilter', 'Abundance Filter', value = 0.0001, min = 0, max = 1),
             selectInput('pair_visFeatureLevel', 'Visual Feature Level', choices = c("original"), multiple = TRUE),
             selectInput('pair_testFeatureLevel', 'Test Feature Level', choices = c("original"), multiple = TRUE),
             selectInput('pair_featureDatType', 'Feature Data Type',
                         choices = c("count", "proportion", "other"), selected = "count")
      ),
      column(4,  # 第三列
             selectInput('pair_featureChangeFunc', 'Feature Change Function', choices = c('relative change', 'absolute change', 'log fold change')),
             checkboxInput('pair_featureAnalysisRarafy', 'Rarefy Feature-Level Analysis', value = TRUE),
             numericInput('pair_barAreaFeatureNo', 'Number of Features in Bar/Area Plot', value = 40),
             numericInput('pair_heatmapFeatureNo', 'Number of Features in Heatmap', value = 40),
             numericInput('pair_dotplotFeatureNo', 'Number of Features in Dotplot', value = 40),
             selectInput('pair_featureMtMethod', 'Multiple Testing Method for Features',
                         choices = c("fdr", "none"), selected = "none"),
             numericInput('pair_featureSigLevel', 'Feature Significance Level', value = 0.3, min = 0.01, max = 1, step = 0.01),
             selectInput('pair_featureBoxAxisTransform', 'Feature Box Axis Transformation',
                         choices = c("identity", "sqrt", "log"), selected = "identity"),
             numericInput('pair_baseSize', 'Base Font Size', value = 16),
             selectInput('pair_themeChoice', 'Theme Choice',
                         choices = c("prism", "classic", "gray", "bw"), selected = "bw"),
             textInput('pair_outputFile', 'Output File Name', value = 'MicrobiomeAnalysis_Report.pdf'),
             actionButton('pair_runAnalysis', 'Run Analysis'),
             uiOutput("pair_report_ready_message"),
             uiOutput("pair_download_report_ui")
      )
    )
  )
