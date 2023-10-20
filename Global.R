# 创建一个函数来处理用户上传的数据文件
processDataFiles <- function(input) {
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
  } else {
    loadData <- load(file = input$dataFile$datapath)
    data.obj <- get(loadData)
  }

  return(data.obj)
}

# 在Global.R中定义函数
updateDepthChoices <- function(data.obj, session) {
  if(!is.null(data.obj$feature.tab) && is.matrix(data.obj$feature.tab)) {
    # 计算 feature.tab 的 colSums 的最小值
    minDepth <- min(colSums(data.obj$feature.tab))

    # 更新 depth 的选项
    updateSelectInput(session, 'depth', choices = 1:minDepth)

  } else {
    # 可选：如果data.obj不包含feature.tab或feature.tab不是矩阵，则显示错误消息
    showModal(modalDialog(
      title = "Error",
      "The uploaded data.obj file does not contain a valid feature.tab matrix.",
      easyClose = TRUE
    ))
  }
}

# 在Global.R中定义函数
updateMetaDatChoices <- function(data.obj, session) {
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
}

# 定义函数
updateTLevelChoices <- function(data.obj, input, session) {
  observeEvent(input$timeVar, {
    # 确保 data.obj 包含 meta.dat，并且它是一个数据框
    if(!is.null(data.obj$meta.dat) && is.data.frame(data.obj$meta.dat)) {
      # 获取 time.var 的唯一值
      timeVarValues <- unique(data.obj$meta.dat[[input$timeVar]])
      # 更新 tLevel 的选项
      updateSelectInput(session, 'tLevel', choices = timeVarValues)
    }
  })
}

# 定义函数
updateFeatureAnnChoices <- function(data.obj, session) {
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

# 定义函数
updateChangeBaseChoices <- function(data.obj, input, session) {
  observeEvent(input$timeVar, {
    # 确保 data.obj 包含 meta.dat，并且它是一个数据框
    if(!is.null(data.obj$meta.dat) && is.data.frame(data.obj$meta.dat)) {
      # 获取 time.var 的唯一值
      timeVarValues <- unique(data.obj$meta.dat[[input$timeVar]])
      # 更新 changeBase 的选项
      updateSelectInput(session, 'changeBase', choices = timeVarValues)
    }
  })
}

# 定义函数
updateT0LevelChoices <- function(data.obj, input, session) {
  observeEvent(input$timeVar, {
    # 确保 data.obj 包含 meta.dat，并且它是一个数据框
    if(!is.null(data.obj$meta.dat) && is.data.frame(data.obj$meta.dat)) {
      # 获取 time.var 的唯一值
      timeVarValues <- unique(data.obj$meta.dat[[input$timeVar]])
      # 更新 t0Level 的选项
      updateSelectInput(session, 't0Level', choices = timeVarValues)
    }
  })
}

# 定义函数
updateTSLevelsChoices <- function(data.obj, input, session) {
  observeEvent(input$timeVar, {
    # 确保 data.obj 包含 meta.dat，并且它是一个数据框
    if(!is.null(data.obj$meta.dat) && is.data.frame(data.obj$meta.dat)) {
      # 获取 time.var 的唯一值
      timeVarValues <- unique(data.obj$meta.dat[[input$timeVar]])
      # 更新 tsLevels 的选项
      updateSelectInput(session, 'tsLevels', choices = timeVarValues)
    }
  })
}





