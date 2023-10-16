library(shiny)
library(shinyjs)

single_ui <- fluidPage(

  titlePanel("MicrobiomeStat Single Report"),

  sidebarLayout(

    sidebarPanel(

      fileInput('dataFile', 'Choose mStat Data Object file', accept = c('.RData')),
      helpText("If you do not have an mStat Data Object, you can provide the following inputs:"),
      conditionalPanel(
        condition = "input.dataFile == null",

        fileInput('countData', 'Count (feature.tab)', accept = c('.txt', '.csv')),
        fileInput('metadata', 'Metadata (meta.dat)', accept = c('.txt', '.csv')),
        fileInput('taxonomy', 'Taxonomy (feature.ann)', accept = c('.txt', '.csv')),
        fileInput('phyloTree', 'Phylogenetic Tree (tree) - Optional', accept = c('.tree', '.nwk')),
        helpText("Count, Metadata, and Taxonomy files should be formatted as text or CSV files. ",
                 "The Phylogenetic Tree file should be in Newick format with a .tree or .nwk extension.")
      ),
      selectInput('groupVar', 'Group Variable', choices = NULL),
      selectInput('visAdjVars', 'Visual Adjust Variables', choices = NULL, multiple = TRUE),
      selectInput('testAdjVars', 'Test Adjust Variables', choices = NULL, multiple = TRUE),
      selectInput('strataVar', 'Strata Variable', choices = NULL),
      selectInput('subjectVar', 'Subject Variable', choices = NULL),
      selectInput('timeVar', 'Time Variable', choices = NULL),
      selectInput('tLevel', 'Time Level', choices = NULL),
      selectInput('alphaName', 'Alpha Diversity Index',
                  choices = c("shannon", "simpson", "observed_species", "chao1", "ace", "pielou"),
                  selected = c("shannon", "observed_species"),
                  multiple = TRUE),
      numericInput('depth', 'Depth', value = NULL, min = 1),
      selectInput('distName', 'Distance Measure',
        choices = c("BC", "Jaccard", "UniFrac",
                    "GUniFrac", "WUniFrac", "JS"),
        selected = c("BC", "Jaccard"),
        multiple = TRUE
      ),
      numericInput('prevFilter', 'Prevalence Filter', value = 0.1, min = 0, max = 1),
      numericInput('abundFilter', 'Abundance Filter', value = 0.0001, min = 0, max = 1),
      selectInput('visFeatureLevel', 'Visual Feature Level', choices = c("original"), multiple = TRUE),
      selectInput('testFeatureLevel', 'Test Feature Level', choices = c("original"), multiple = TRUE),
      selectInput('featureDatType', 'Feature Data Type',
                  choices = c("count", "proportion", "other"), selected = "count"),
      checkboxInput('featureAnalysisRarafy', 'Rarefy Feature-Level Analysis', value = TRUE),
      numericInput('barAreaFeatureNo', 'Number of Features in Bar/Area Plot', value = 40),
      numericInput('heatmapFeatureNo', 'Number of Features in Heatmap', value = 40),
      numericInput('dotplotFeatureNo', 'Number of Features in Dotplot', value = 40),
      selectInput('featureMtMethod', 'Multiple Testing Method for Features',
                  choices = c("fdr", "none"), selected = "none"),
      numericInput('featureSigLevel', 'Feature Significance Level', value = 0.3, min = 0.01, max = 1, step = 0.01),
      selectInput('featureBoxAxisTransform', 'Feature Box Axis Transformation',
                  choices = c("identity", "sqrt", "log"), selected = "identity"),
      numericInput('baseSize', 'Base Font Size', value = 16),
      selectInput('themeChoice', 'Theme Choice',
                  choices = c("prism", "classic", "gray", "bw"), selected = "bw"),
      textInput('outputFile', 'Output File Name', value = 'report.pdf'),
      actionButton('runAnalysis', 'Run Analysis')

    ),

    mainPanel(

      downloadLink('reportDownload', 'Download your report here')

    )
  )
)
