library(shiny)
library(pander)
library(forcats)
library(dplyr)
library(aplot)
library(ggplot2)
library(modeest)
library(tibble)
library(foreach)
library(lmerTest)
library(MicrobiomeStat)

server_long <- function(input, output, session) {
  reportPath <- reactiveVal(NULL)
  observeEvent(c(input$dataFile, input$countData, input$metadata, input$taxonomy), {
    data.obj <- processDataFiles(input)
    if (!is.null(data.obj)) {
      updateDepthChoices(data.obj, session)
      updateMetaDatChoices(data.obj, session)
      updateT0LevelChoices(data.obj, input, session)
      updateTSLevelsChoices(data.obj, input, session)
      updateFeatureAnnChoices(data.obj, session)
    }
  })

  observeEvent(input$runAnalysis, {
    req(input$groupVar)
    data.obj <- processDataFiles(input)
    depth <- if (input$depth == "NULL") NULL else as.numeric(input$depth)
    reportFile <- mStat_generate_report_long(data.obj = data.obj,
                                             group.var = input$groupVar,
                                             vis.adj.vars = input$visAdjVars,
                                             test.adj.vars = input$testAdjVars,
                                             strata.var = input$strataVar,
                                             subject.var = input$subjectVar,
                                             time.var = input$timeVar,
                                             t0.level = input$t0Level,
                                             ts.levels = input$tsLevels,
                                             alpha.name = input$alphaName,
                                             alpha.change.func = input$alphaChangeFunc,
                                             depth = depth,
                                             prev.filter = input$prevFilter,
                                             abund.filter = input$abundFilter,
                                             bar.area.feature.no = input$barAreaFeatureNo,
                                             heatmap.feature.no = input$heatmapFeatureNo,
                                             dotplot.feature.no = input$dotplotFeatureNo,
                                             vis.feature.level = input$visFeatureLevel,
                                             test.feature.level = input$testFeatureLevel,
                                             feature.dat.type = input$featureDatType,
                                             feature.change.func = input$featureChangeFunc,
                                             feature.analysis.rarafy = input$featureAnalysisRarafy,
                                             feature.mt.method = input$featureMtMethod,
                                             feature.sig.level = input$featureSigLevel,
                                             feature.box.axis.transform = input$featureBoxAxisTransform,
                                             base.size = input$baseSize,
                                             theme.choice = input$themeChoice,
                                             output.file = input$outputFile)

    reportPath(reportFile)
  })

  output$reportDownload <- downloadHandler(
    filename = function() {
      paste0("MicrobiomeStat_Report_", Sys.Date(), ".pdf")
    },
    content = function(file) {
      file.copy(reportPath(), file)
    }
  )

}
