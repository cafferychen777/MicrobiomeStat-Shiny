# server_single.R
library(shiny)
library(pander)
library(forcats)
library(dplyr)
library(aplot)
library(ggplot2)
library(modeest)
library(tibble)
#library(MicrobiomeStat)

# 指定包含R脚本文件的目录
script_dir <- "/Users/apple/MicrobiomeStat/R"

# 使用list.files函数列出目录中的所有文件
script_files <- list.files(path = script_dir, pattern = "\\.[rR]$")

# 逐个源这些文件
for (script_file in script_files) {
  source(file.path(script_dir, script_file))
}

server_single <- function(input, output, session) {

  # 用于存储生成的报告的路径
  reportPath <- reactiveVal(NULL)

  observeEvent(c(input$dataFile, input$countData, input$metadata, input$taxonomy), {

    # 初始设定 data.obj 为 NULL
    data.obj <- NULL

    if(is.null(input$dataFile)) {
      if(!is.null(input$countData) && !is.null(input$metadata) && !is.null(input$taxonomy)) {
        countData <- as.matrix(read.table(input$countData$datapath, header = TRUE, row.names = 1, sep = ","))
        metadata <- read.table(input$metadata$datapath, header = TRUE, row.names = 1, sep = ",")
        if(!is.data.frame(metadata)) {
          metadata <- as.data.frame(metadata)
        }
        taxonomy <- as.matrix(read.table(input$taxonomy$datapath, header = TRUE, row.names = 1, sep = ","))
        if(!is.null(input$phyloTree)) {
          phyloTree <- read.tree(input$phyloTree$datapath)
        } else {
          phyloTree <- NULL
        }
        data.obj <- list(
          feature.tab = countData,
          meta.dat = metadata,
          feature.ann = taxonomy,
          tree = phyloTree
        )
      }
      else {
        # 如果没有提供必要的文件，可能需要显示一个错误消息
        showModal(modalDialog(
          title = "Error",
          "Please upload all required files.",
          easyClose = TRUE
        ))
      }
    } else {
      req(input$dataFile)  # 确保文件已上传

      # 读取上传的数据
      loadData <- load(file = input$dataFile$datapath)
      data.obj <- get(loadData)
    }

    if (!is.null(data.obj)) {
      # 确保data.obj包含feature.tab，并且它是一个矩阵
      if(!is.null(data.obj$feature.tab) && is.matrix(data.obj$feature.tab)) {

        # 计算 feature.tab 的 colSums 的最小值
        minDepth <- min(colSums(data.obj$feature.tab))

        # 更新 depth 的最小值
        updateNumericInput(session, 'depth', max = minDepth)

      } else {
        # 可选：如果data.obj不包含feature.tab或feature.tab不是矩阵，则显示错误消息
        showModal(modalDialog(
          title = "Error",
          "The uploaded data.obj file does not contain a valid feature.tab matrix.",
          easyClose = TRUE
        ))
      }

      # 确保data.obj包含meta.dat，并且它是一个数据框
      if(!is.null(data.obj$meta.dat) && is.data.frame(data.obj$meta.dat)) {

        # 获取meta.dat的列名
        colNames <- names(data.obj$meta.dat)

        # 更新selectInput元素的选项
        updateSelectInput(session, 'groupVar', choices = colNames)
        updateSelectInput(session, 'visAdjVars', choices = colNames)
        updateSelectInput(session, 'testAdjVars', choices = colNames)
        updateSelectInput(session, 'strataVar', choices = colNames)
        updateSelectInput(session, 'subjectVar', choices = colNames)
        updateSelectInput(session, 'timeVar', choices = colNames)

      } else {
        # 可选：如果data.obj不包含meta.dat或meta.dat不是数据框，则显示错误消息
        showModal(modalDialog(
          title = "Error",
          "The uploaded data.obj file does not contain a valid meta.dat data frame.",
          easyClose = TRUE
        ))
      }

      # 在 timeVar 选项更新后，更新 tLevel 的选项
      observeEvent(input$timeVar, {
        # 确保 data.obj 包含 meta.dat，并且它是一个数据框
        if(!is.null(data.obj$meta.dat) && is.data.frame(data.obj$meta.dat)) {
          # 获取 time.var 的唯一值
          timeVarValues <- unique(data.obj$meta.dat[[input$timeVar]])
          # 更新 tLevel 的选项
          updateSelectInput(session, 'tLevel', choices = timeVarValues)
        }
      })

      # 确保data.obj包含feature.ann，并且它是一个矩阵
      if(!is.null(data.obj$feature.ann) && is.matrix(data.obj$feature.ann)) {

        # 获取feature.ann的列名
        featureAnnColNames <- colnames(data.obj$feature.ann)

        # 添加"original"选项
        featureAnnChoices <- c("original", featureAnnColNames)

        # 更新selectInput元素的选项
        updateSelectInput(session, 'visFeatureLevel', choices = featureAnnChoices)
        updateSelectInput(session, 'testFeatureLevel', choices = featureAnnChoices)

      } else {
        # 可选：如果data.obj不包含feature.ann或feature.ann不是矩阵，则显示错误消息
        showModal(modalDialog(
          title = "Error",
          "The uploaded data.obj file does not contain a valid feature.ann matrix.",
          easyClose = TRUE
        ))
      }
    }




    # ...

  })

  # 在 server_single.R 文件中
  observeEvent(input$runAnalysis, {
    req(input$groupVar)  # 确保所有必要的字段已填写
    # ... 可以在这里添加其他的 req() 调用，以确保所有必要的输入字段都已填写

    # 初始设定 data.obj 为 NULL
    data.obj <- NULL

    if(is.null(input$dataFile)) {
      if(!is.null(input$countData) && !is.null(input$metadata) && !is.null(input$taxonomy)) {
        countData <- as.matrix(read.table(input$countData$datapath, header = TRUE, row.names = 1, sep = ","))
        metadata <- read.table(input$metadata$datapath, header = TRUE, row.names = 1, sep = ",")
        if(!is.data.frame(metadata)) {
          metadata <- as.data.frame(metadata)
        }
        taxonomy <- as.matrix(read.table(input$taxonomy$datapath, header = TRUE, row.names = 1, sep = ","))
        if(!is.null(input$phyloTree)) {
          phyloTree <- read.tree(input$phyloTree$datapath)
        } else {
          phyloTree <- NULL
        }
        data.obj <- list(
          feature.tab = countData,
          meta.dat = metadata,
          feature.ann = taxonomy,
          tree = phyloTree
        )
      }
      else {
        # 如果没有提供必要的文件，可能需要显示一个错误消息
        showModal(modalDialog(
          title = "Error",
          "Please upload all required files.",
          easyClose = TRUE
        ))
      }
    } else {
      req(input$dataFile)  # 确保文件已上传

      # 读取上传的数据
      loadData <- load(file = input$dataFile$datapath)
      data.obj <- get(loadData)
    }

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
