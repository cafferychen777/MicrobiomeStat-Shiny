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

  observeEvent(c(input$dataFile, input$countData, input$metadata, input$taxonomy), {

    data.obj <- processDataFiles(input)

    if (!is.null(data.obj)) {

      # 在server.R中调用函数
      updateDepthChoices(data.obj, session)

      # 在server.R中调用函数
      updateMetaDatChoices(data.obj, session)

      # 在server函数中调用函数
      updateTLevelChoices(data.obj, input, session)

      # 在server函数中调用函数
      updateFeatureAnnChoices(data.obj, session)

    }

  })

  # 在 server_single.R 文件中
  observeEvent(input$runAnalysis, {
    req(input$groupVar)

    data.obj <- processDataFiles(input)

    reportFile <- mStat_generate_report_single(data.obj = data.obj,
                                               group.var = input$groupVar,
                                               vis.adj.vars = input$visAdjVars,
                                               test.adj.vars = input$testAdjVars,
                                               strata.var = input$strataVar,
                                               subject.var = input$subjectVar,
                                               time.var = input$timeVar,
                                               t.level = input$tLevel,
                                               alpha.name = input$alphaName,
                                               depth = input$depth,
                                               prev.filter = input$prevFilter,
                                               abund.filter = input$abundFilter,
                                               bar.area.feature.no = input$barAreaFeatureNo,
                                               heatmap.feature.no = input$heatmapFeatureNo,
                                               dotplot.feature.no = input$dotplotFeatureNo,
                                               vis.feature.level = input$visFeatureLevel,
                                               test.feature.level = input$testFeatureLevel,
                                               feature.dat.type = input$featureDatType,
                                               feature.analysis.rarafy = input$featureAnalysisRarafy,
                                               feature.mt.method = input$featureMtMethod,
                                               feature.sig.level = input$featureSigLevel,
                                               feature.box.axis.transform = input$featureBoxAxisTransform,
                                               base.size = input$baseSize,
                                               theme.choice = input$themeChoice,
                                               output.file = input$outputFile)


    # 更新 reportPath，以便用户可以下载报告
    reportPath(reportFile)
  })

  # 提供一个下载链接，用户可以通过该链接下载报告
  output$reportDownload <- downloadHandler(
    filename = function() {
      paste0("MicrobiomeStat_Report_", Sys.Date(), ".pdf")
    },
    content = function(file) {
      file.copy(reportPath(), file)
    }
  )

}
