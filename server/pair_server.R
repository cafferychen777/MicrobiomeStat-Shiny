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

server_pair <- function(input, output, session) {

  reportPath <- reactiveVal(NULL)

  observeEvent(c(input$pair_dataFile, input$pair_countData, input$pair_metadata, input$pair_taxonomy), {

    data.obj <- processDataFiles(input, "pair")

    if (!is.null(data.obj)) {
      updateDepthChoices(data.obj, session, "pair_")

      updateMetaDatChoices(data.obj, session, "pair_")

      updateChangeBaseChoices(data.obj, input, session, "pair_")

      updateFeatureAnnChoices(data.obj, session, "pair_")
    }
  })

  observeEvent(input$pair_runAnalysis, {
    req(input$pair_groupVar)

    data.obj <- processDataFiles(input, "pair")

    showModal(modalDialog(
      title = "Analysis Started",
      "The analysis has begun. Please be patient and wait.",
      footer = NULL,
      easyClose = FALSE
    ))

    # 根据input$single_featureDatType的值调整depth参数
    depth_value <- if (input$pair_featureDatType == "proportion") NULL else input$pair_depth

    reportFile <- mStat_generate_report_pair(data.obj = data.obj,
                                               group.var = input$pair_groupVar,
                                               vis.adj.vars = input$pair_visAdjVars,
                                               test.adj.vars = input$pair_testAdjVars,
                                               strata.var = input$pair_strataVar,
                                               subject.var = input$pair_subjectVar,
                                               time.var = input$pair_timeVar,
                                               change.base = input$pair_changeBase,
                                               alpha.name = input$pair_alphaName,
                                               alpha.change.func = input$pair_alphaChangeFunc,
                                               depth = depth_value,
                                               prev.filter = input$pair_prevFilter,
                                               abund.filter = input$pair_abundFilter,
                                               bar.area.feature.no = input$pair_barAreaFeatureNo,
                                               heatmap.feature.no = input$pair_heatmapFeatureNo,
                                               dotplot.feature.no = input$pair_dotplotFeatureNo,
                                               vis.feature.level = input$pair_visFeatureLevel,
                                               test.feature.level = input$pair_testFeatureLevel,
                                               feature.dat.type = input$pair_featureDatType,
                                               feature.change.func = input$pair_featureChangeFunc,
                                               feature.analysis.rarafy = input$pair_featureAnalysisRarafy,
                                               feature.mt.method = input$pair_featureMtMethod,
                                               feature.sig.level = input$pair_featureSigLevel,
                                               feature.box.axis.transform = input$pair_featureBoxAxisTransform,
                                               base.size = input$pair_baseSize,
                                               theme.choice = input$pair_themeChoice,
                                               output.file = input$pair_outputFile)

    reportPath(reportFile)

    output$pair_download_report_ui <- renderUI({
      tags$div(
        style = "color: green; margin-top: 20px; font-weight: bold;",
        "Your pair report is ready for download! ",
        downloadLink('pair_reportDownload', 'Click here to download')
      )
    })

    removeModal()

  })

  output$pair_reportDownload <- downloadHandler(
    filename = function() {
      paste0("MicrobiomeStat_Report_", Sys.Date(), ".pdf")
    },
    content = function(file) {
      file.copy(reportPath(), file)
    }
  )

  output$downloadData4 <- downloadHandler(
    filename = function() {
      "peerj32_feature_tab.csv"
    },
    content = function(file) {
      file.copy("data/peerj32_feature_tab.csv", file)
    }
  )

  output$downloadData5 <- downloadHandler(
    filename = function() {
      "peerj32_meta_dat.csv"
    },
    content = function(file) {
      file.copy("data/peerj32_meta_dat.csv", file)
    }
  )

  output$downloadData6 <- downloadHandler(
    filename = function() {
      "peerj32_feature_ann.csv"
    },
    content = function(file) {
      file.copy("data/peerj32_feature_ann.csv", file)
    }
  )

}
