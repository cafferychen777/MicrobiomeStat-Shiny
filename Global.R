processDataFiles <- function(input, uiType) {
  data.obj <- NULL

  # 根据uiType确定正确的inputId
  dataFileId <- paste0(uiType, "_dataFile")
  countDataId <- paste0(uiType, "_countData")
  metadataId <- paste0(uiType, "_metadata")
  taxonomyId <- paste0(uiType, "_taxonomy")
  phyloTreeId <- paste0(uiType, "_phyloTree")

  if(is.null(input[[dataFileId]])) {
    if(!is.null(input[[countDataId]]) && !is.null(input[[metadataId]]) && !is.null(input[[taxonomyId]])) {
      message("Reading count data...")
      countData <- as.matrix(read.table(input[[countDataId]]$datapath, header = TRUE, row.names = 1, sep = ",", check.names = FALSE))

      message("Reading metadata...")
      metadata <- read.table(input[[metadataId]]$datapath, header = TRUE, row.names = 1, sep = ",")
      if(!is.data.frame(metadata)) {
        metadata <- as.data.frame(metadata)
      }

      message("Reading taxonomy data...")
      taxonomy <- as.matrix(read.table(input[[taxonomyId]]$datapath, header = TRUE, row.names = 1, sep = ","))

      if(!is.null(input[[phyloTreeId]])) {
        message("Reading phylogenetic tree...")
        phyloTree <- read.tree(input[[phyloTreeId]]$datapath)
      } else {
        phyloTree <- NULL
      }

      message("Creating data object...")
      data.obj <- list(
        feature.tab = countData,
        meta.dat = metadata,
        feature.ann = taxonomy,
        tree = phyloTree
      )

      mStat_validate_data(data.obj)

      message("Data object created successfully.")
    }

  } else {
    loadData <- load(file = input[[dataFileId]]$datapath)
    data.obj <- get(loadData)
  }

  return(data.obj)
}


updateDepthChoices <- function(data.obj, session, idPrefix = "") {
  if(!is.null(data.obj$feature.tab) && is.matrix(data.obj$feature.tab)) {
    # 计算 feature.tab 的 colSums 的最小值
    minDepth <- min(colSums(data.obj$feature.tab))

    # 更新 depth 的选项
    updateSliderInput(session, paste0(idPrefix, 'depth'), min = 1, max = minDepth, value = minDepth, step = 1)

  } else {
    # 可选：如果data.obj不包含feature.tab或feature.tab不是矩阵，则显示错误消息
    showModal(modalDialog(
      title = "Error",
      "The uploaded data.obj file does not contain a valid feature.tab matrix.",
      easyClose = TRUE
    ))
  }
}

updateMetaDatChoices <- function(data.obj, session, idPrefix = "") {
  if(!is.null(data.obj$meta.dat) && is.data.frame(data.obj$meta.dat)) {
    # 获取meta.dat的列名
    colNames <- names(data.obj$meta.dat)

    # 更新selectInput元素的选项
    updateSelectInput(session, paste0(idPrefix, 'groupVar'), choices = colNames)
    updateSelectInput(session, paste0(idPrefix, 'visAdjVars'), choices = colNames)
    updateSelectInput(session, paste0(idPrefix, 'testAdjVars'), choices = colNames)
    updateSelectInput(session, paste0(idPrefix, 'strataVar'), choices = colNames)
    updateSelectInput(session, paste0(idPrefix, 'subjectVar'), choices = colNames)
    updateSelectInput(session, paste0(idPrefix, 'timeVar'), choices = colNames)

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
updateFeatureAnnChoices <- function(data.obj, session, idPrefix = "") {
  # 确保data.obj包含feature.ann，并且它是一个矩阵
  if(!is.null(data.obj$feature.ann) && is.matrix(data.obj$feature.ann)) {

    # 获取feature.ann的列名
    featureAnnColNames <- colnames(data.obj$feature.ann)

    # 添加"original"选项
    featureAnnChoices <- c("original", featureAnnColNames)

    # 更新selectInput元素的选项
    updateSelectInput(session, paste0(idPrefix, 'visFeatureLevel'), choices = featureAnnChoices)
    updateSelectInput(session, paste0(idPrefix, 'testFeatureLevel'), choices = featureAnnChoices)

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
updateTLevelChoices <- function(data.obj, input, session, idPrefix = "") {
  observeEvent(input[[paste0(idPrefix, 'timeVar')]], {
    # 确保 data.obj 包含 meta.dat，并且它是一个数据框
    if(!is.null(data.obj$meta.dat) && is.data.frame(data.obj$meta.dat)) {
      # 获取 time.var 的唯一值
      timeVarValues <- unique(data.obj$meta.dat[[input[[paste0(idPrefix, 'timeVar')]]]])
      # 更新 tLevel 的选项
      updateSelectInput(session, paste0(idPrefix, 'tLevel'), choices = timeVarValues)
    }
  })
}


# 定义函数
updateChangeBaseChoices <- function(data.obj, input, session, idPrefix = "") {
  observeEvent(input[[paste0(idPrefix, 'timeVar')]], {
    # 确保 data.obj 包含 meta.dat，并且它是一个数据框
    if(!is.null(data.obj$meta.dat) && is.data.frame(data.obj$meta.dat)) {
      # 获取 time.var 的唯一值
      timeVarValues <- unique(data.obj$meta.dat[[input[[paste0(idPrefix, 'timeVar')]]]])
      # 更新 changeBase 的选项
      updateSelectInput(session, paste0(idPrefix, 'changeBase'), choices = timeVarValues)
    }
  })
}

# 定义函数
updateT0LevelChoices <- function(data.obj, input, session, idPrefix = "") {
  observeEvent(input[[paste0(idPrefix, 'timeVar')]], {
    # 确保 data.obj 包含 meta.dat，并且它是一个数据框
    if(!is.null(data.obj$meta.dat) && is.data.frame(data.obj$meta.dat)) {
      # 获取 time.var 的唯一值
      timeVarValues <- unique(data.obj$meta.dat[[input[[paste0(idPrefix, 'timeVar')]]]])
      # 更新 t0Level 的选项
      updateSelectInput(session, paste0(idPrefix, 't0Level'), choices = timeVarValues)
    }
  })
}

# 定义函数
updateTSLevelsChoices <- function(data.obj, input, session, idPrefix = "") {
  observeEvent(input[[paste0(idPrefix, 'timeVar')]], {
    # 确保 data.obj 包含 meta.dat，并且它是一个数据框
    if(!is.null(data.obj$meta.dat) && is.data.frame(data.obj$meta.dat)) {
      # 获取 time.var 的唯一值
      timeVarValues <- unique(data.obj$meta.dat[[input[[paste0(idPrefix, 'timeVar')]]]])
      # 更新 tsLevels 的选项
      updateSelectInput(session, paste0(idPrefix, 'tsLevels'), choices = timeVarValues)
    }
  })
}
