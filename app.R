options(shiny.maxRequestSize = 300*1024^2)  # 设置最大请求大小为300MB
library(shiny)
library(shinyjs)

# 加载UI和服务器逻辑
source("ui/single_ui.R")  # 加载ui_single.R
source("server/single_server.R")  # 加载server_single.R

# 使用加载的UI和服务器逻辑运行Shiny应用
shinyApp(ui = single_ui, server = server_single)
