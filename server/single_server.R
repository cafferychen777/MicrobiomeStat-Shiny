# server_single.R
library(shiny)
library(pander)
library(forcats)
library(dplyr)
library(aplot)
library(ggplot2)
library(modeest)
library(tibble)
library(lmerTest)
library(foreach)
library(MicrobiomeStat)

server_single <- function(input, output, session) {

  # 用于存储生成的报告的路径
  reportPath <- reactiveVal(NULL)

  observeEvent(c(input$single_dataFile, input$single_countData, input$single_metadata, input$single_taxonomy), {

    data.obj <- processDataFiles(input, "single")

    if (!is.null(data.obj)) {

      updateDepthChoices(data.obj, session, "single_")

      updateMetaDatChoices(data.obj, session, "single_")

      updateFeatureAnnChoices(data.obj, session, "single_")

      updateTLevelChoices(data.obj, input, session, "single_")

    }

  })

  # 在 server_single.R 文件中
  observeEvent(input$single_runAnalysis, {

    req(input$single_groupVar)

    data.obj <- processDataFiles(input, "single")

    showModal(modalDialog(
      title = "Analysis Started",
      "The analysis has begun. Please be patient and wait.",
      footer = NULL,
      easyClose = FALSE  # 该选项禁止用户轻松关闭模态窗口，例如点击外部
    ))

    # 根据input$single_featureDatType的值调整depth参数
    depth_value <- if (input$single_featureDatType == "proportion") NULL else input$single_depth

    reportFile <- mStat_generate_report_single(data.obj = data.obj,
                                               group.var = input$single_groupVar,
                                               vis.adj.vars = input$single_visAdjVars,
                                               test.adj.vars = input$single_testAdjVars,
                                               strata.var = input$single_strataVar,
                                               subject.var = input$single_subjectVar,
                                               time.var = input$single_timeVar,
                                               t.level = input$single_tLevel,
                                               alpha.name = input$single_alphaName,
                                               depth = depth_value,
                                               prev.filter = input$single_prevFilter,
                                               abund.filter = input$single_abundFilter,
                                               bar.area.feature.no = input$single_barAreaFeatureNo,
                                               heatmap.feature.no = input$single_heatmapFeatureNo,
                                               dotplot.feature.no = input$single_dotplotFeatureNo,
                                               vis.feature.level = input$single_visFeatureLevel,
                                               test.feature.level = input$single_testFeatureLevel,
                                               feature.dat.type = input$single_featureDatType,
                                               feature.analysis.rarafy = input$single_featureAnalysisRarafy,
                                               feature.mt.method = input$single_featureMtMethod,
                                               feature.sig.level = input$single_featureSigLevel,
                                               feature.box.axis.transform = input$single_featureBoxAxisTransform,
                                               base.size = input$single_baseSize,
                                               theme.choice = input$single_themeChoice,
                                               output.file = input$single_outputFile)

    reportPath(reportFile)

    output$single_download_report_ui <- renderUI({
      tags$div(
        style = "color: green; margin-top: 20px; font-weight: bold;",
        "Your single report is ready for download! ",
        downloadLink('single_reportDownload', 'Click here to download')
      )
    })

    removeModal()

  })

  output$single_reportDownload <- downloadHandler(
    filename = function() {
      paste0("MicrobiomeStat_Report_", Sys.Date(), ".pdf")
    },
    content = function(file) {
      file.copy(reportPath(), file)
    }
  )

  output$downloadData1 <- downloadHandler(
    filename = function() {
      "peerj32_feature_tab.csv"
    },
    content = function(file) {
      file.copy("data/peerj32_feature_tab.csv", file)
    }
  )

  output$downloadData2 <- downloadHandler(
    filename = function() {
      "peerj32_meta_dat.csv"
    },
    content = function(file) {
      file.copy("data/peerj32_meta_dat.csv", file)
    }
  )

  output$downloadData3 <- downloadHandler(
    filename = function() {
      "peerj32_feature_ann.csv"
    },
    content = function(file) {
      file.copy("data/peerj32_feature_ann.csv", file)
    }
  )

}
