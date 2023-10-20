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

  observeEvent(c(input$long_dataFile, input$long_countData, input$long_metadata, input$long_taxonomy), {

    data.obj <- processDataFiles(input, "long")

    if (!is.null(data.obj)) {
      updateDepthChoices(data.obj, session, "long_")

      updateMetaDatChoices(data.obj, session, "long_")

      updateT0LevelChoices(data.obj, input, session, "long_")

      updateTSLevelsChoices(data.obj, input, session, "long_")

      updateFeatureAnnChoices(data.obj, session, "long_")
    }
  })

  observeEvent(input$long_runAnalysis, {
    req(input$long_groupVar)

    data.obj <- processDataFiles(input, "long")

    showModal(modalDialog(
      title = "Analysis Started",
      "The analysis has begun. Please be patient and wait.",
      footer = NULL,
      easyClose = FALSE
    ))

    # 根据input$single_featureDatType的值调整depth参数
    depth_value <- if (input$long_featureDatType == "proportion") NULL else input$long_depth

    reportFile <- mStat_generate_report_long(data.obj = data.obj,
                                             group.var = input$long_groupVar,
                                             vis.adj.vars = input$long_visAdjVars,
                                             test.adj.vars = input$long_testAdjVars,
                                             strata.var = input$long_strataVar,
                                             subject.var = input$long_subjectVar,
                                             time.var = input$long_timeVar,
                                             t0.level = input$long_t0Level,
                                             ts.levels = input$long_tsLevels,
                                             alpha.name = input$long_alphaName,
                                             alpha.change.func = input$long_alphaChangeFunc,
                                             depth = depth_value,
                                             prev.filter = input$long_prevFilter,
                                             abund.filter = input$long_abundFilter,
                                             bar.area.feature.no = input$long_barAreaFeatureNo,
                                             heatmap.feature.no = input$long_heatmapFeatureNo,
                                             dotplot.feature.no = input$long_dotplotFeatureNo,
                                             vis.feature.level = input$long_visFeatureLevel,
                                             test.feature.level = input$long_testFeatureLevel,
                                             feature.dat.type = input$long_featureDatType,
                                             feature.change.func = input$long_featureChangeFunc,
                                             feature.analysis.rarafy = input$long_featureAnalysisRarafy,
                                             feature.mt.method = input$long_featureMtMethod,
                                             feature.sig.level = input$long_featureSigLevel,
                                             feature.box.axis.transform = input$long_featureBoxAxisTransform,
                                             base.size = input$long_baseSize,
                                             theme.choice = input$long_themeChoice,
                                             output.file = input$long_outputFile)

    reportPath(reportFile)

    output$long_download_report_ui <- renderUI({
      tags$div(
        style = "color: green; margin-top: 20px; font-weight: bold;",
        "Your long report is ready for download! ",
        downloadLink('long_reportDownload', 'Click here to download')
      )
    })

    removeModal()

  })

  output$long_reportDownload <- downloadHandler(
    filename = function() {
      paste0("MicrobiomeStat_Report_", Sys.Date(), ".pdf")
    },
    content = function(file) {
      file.copy(reportPath(), file)
    }
  )

}
