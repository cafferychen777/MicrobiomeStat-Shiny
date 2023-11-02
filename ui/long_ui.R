library(shiny)
library(shinyjs)

long_ui <-
  fluidPage(
    fluidRow(
      # 第一列
      column(4,
             fileInput('long_dataFile', 'Choose mStat Data Object file', accept = c('.RData')),
             helpText("Learn how to construct the mStat object in R ",
                      a("here", href = "https://www.microbiomestat.wiki/setting-up-microbiomestat-installation-and-data-preparation/laying-the-foundation-creating-the-microbiomestat-data-object", target = "_blank"),
                      ". If you do not want to create it in R, you can upload the following files instead:"),
             conditionalPanel(
               condition = "input.dataFile == null",
               fileInput('long_countData', 'Count (feature.tab)', accept = c('.txt', '.csv')),
               fileInput('long_metadata', 'Metadata (meta.dat)', accept = c('.txt', '.csv')),
               fileInput('long_taxonomy', 'Taxonomy (feature.ann)', accept = c('.txt', '.csv')),
               fileInput('long_phyloTree', 'Phylogenetic Tree (tree) - Optional', accept = c('.tree', '.nwk')),
               helpText("Count, Metadata, and Taxonomy files should be formatted as text or CSV files. ",
                        "The Phylogenetic Tree file should be in Newick format with a .tree or .nwk extension.")
             ),
             selectInput('long_groupVar', 'Group Variable', choices = NULL),
             selectInput('long_visAdjVars', 'Visual Adjust Variables', choices = NULL, multiple = TRUE),
             selectInput('long_testAdjVars', 'Test Adjust Variables', choices = NULL, multiple = TRUE),
             selectInput('long_strataVar', 'Strata Variable', choices = NULL),
             selectInput('long_subjectVar', 'Subject Variable', choices = NULL)
      ),
      # 第二列
      column(4,
             selectInput('long_timeVar', 'Time Variable', choices = NULL),
             selectInput('long_t0Level', 'T0 Level', choices = NULL),
             selectInput('long_tsLevels', 'TS Levels', choices = NULL, multiple = TRUE),
             selectInput('long_alphaName', 'Alpha Diversity Index',
                         choices = c("shannon", "simpson", "observed_species", "chao1", "ace", "pielou"),
                         selected = c("shannon", "observed_species"),
                         multiple = TRUE),
             selectInput('long_alphaChangeFunc', 'Alpha Change Function', choices = c('log fold change', 'absolute change')),
             sliderInput('long_depth', 'Depth', min = 1, max = 1, value = 1),
             selectInput('long_distName', 'Distance Measure',
                         choices = c("BC", "Jaccard", "UniFrac",
                                     "GUniFrac", "WUniFrac", "JS"),
                         selected = c("BC", "Jaccard"),
                         multiple = TRUE
             ),
             numericInput('long_prevFilter', 'Prevalence Filter', value = 0.1, min = 0, max = 1),
             numericInput('long_abundFilter', 'Abundance Filter', value = 0.0001, min = 0, max = 1),
             selectInput('long_visFeatureLevel', 'Visual Feature Level', choices = c("original"), multiple = TRUE),
             selectInput('long_testFeatureLevel', 'Test Feature Level', choices = c("original"), multiple = TRUE),
             selectInput('long_featureDatType', 'Feature Data Type',
                         choices = c("count", "proportion", "other"), selected = "count")
      ),
      # 第三列
      column(4,
             selectInput('long_featureChangeFunc', 'Feature Change Function', choices = c('relative change', 'absolute change', 'log fold change')),
             checkboxInput('long_featureAnalysisRarafy', 'Rarefy Feature-Level Analysis', value = TRUE),
             numericInput('long_barAreaFeatureNo', 'Number of Features in Bar/Area Plot', value = 40),
             numericInput('long_heatmapFeatureNo', 'Number of Features in Heatmap', value = 40),
             numericInput('long_dotplotFeatureNo', 'Number of Features in Dotplot', value = 40),
             selectInput('long_featureMtMethod', 'Multiple Testing Method for Features',
                         choices = c("fdr", "none"), selected = "none"),
             numericInput('long_featureSigLevel', 'Feature Significance Level', value = 0.3, min = 0.01, max = 1, step = 0.01),
             selectInput('long_featureBoxAxisTransform', 'Feature Box Axis Transformation',
                         choices = c("identity", "sqrt", "log"), selected = "identity"),
             numericInput('long_baseSize', 'Base Font Size', value = 16),
             selectInput('long_themeChoice', 'Theme Choice',
                         choices = c("prism", "classic", "gray", "bw"), selected = "bw"),
             textInput('long_outputFile', 'Output File Name', value = 'MicrobiomeAnalysis_Report.pdf'),
             actionButton('long_runAnalysis', 'Run Analysis'),
             uiOutput("long_report_ready_message"),
             uiOutput("long_download_report_ui")
      )
    )
  )
