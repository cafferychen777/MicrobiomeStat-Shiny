options(shiny.maxRequestSize = 300*1024^2)  # 设置最大请求大小为300MB
library(shiny)
library(shinyjs)
library(shinythemes)
library(shinyBS)

# 加载UI和服务器逻辑
source("ui/single_ui.R")  # 加载ui_single.R
source("server/single_server.R")  # 加载server_single.R
source("ui/pair_ui.R")  # 加载ui_pair.R
source("server/pair_server.R")  # 加载server_pair.R
source("ui/long_ui.R")  # 加载ui_long.R
source("server/long_server.R")  # 加载server_long.R
source("Global.R")

main_ui <- fluidPage(
  theme = shinytheme("yeti"),

  tags$style(HTML("
    .custom-title-panel {
      text-align: center;
      font-size: 24px;
      font-weight: bold;
      padding: 20px 0;
      background-color: #f7f7f7;
      border-bottom: 1px solid #ddd;
    }
    .nav.nav-tabs {
      display: flex;
      justify-content: center;
      flex-wrap: wrap;
    }
    .nav.nav-tabs > li {
      float: none;
    }
    .info-panel {
      background-color: #e9ecef;
      padding: 10px 15px;
      border-radius: 4px;
      text-align: center;
      margin-top: 20px;
      font-size: 16px;
    }
    .footer-powered {
      text-align: center;
      font-size: 16px;
      margin-top: 25px;
      color: #666;
    }
  ")),

  tags$script(HTML("
    $(document).on('click', '.custom-title-panel', function() {
      window.open('https://github.com/cafferychen777/MicrobiomeStat', '_blank');
    });
  ")),

  div(class = "custom-title-panel", "MicrobiomeStat Shiny App"),

  tabsetPanel(
    tabPanel("Cross-sectional", single_ui),
    tabPanel("Paired Samples", pair_ui),
    tabPanel("Longitudinal", long_ui)
  ),

  div(class = "info-panel",
      "For technical concerns or encountered anomalies, kindly raise them through our ",
      tags$a(href="https://github.com/cafferychen777/MicrobiomeStat/issues", target="_blank",
             icon("github", lib = "font-awesome"), " GitHub Issues Tracker"
      ),
      ". As an alternative approach, the corresponding R package is available for direct utilization."
  ),

  div(class = "footer-powered", "Powered By Chen Lab")
)





main_server <- function(input, output, session) {
  server_single(input, output, session)
  server_pair(input, output, session)
  server_long(input, output, session)
}

# 使用加载的UI和服务器逻辑运行Shiny应用
shinyApp(ui = main_ui, server = main_server)
