# Microbiome-Shiny

Welcome to the Microbiome-Shiny repository, the R Shiny interface for the MicrobiomeStat R package. This readme will guide you through the process of running this application. There are two ways to access the application: online access and local deployment.

## Online Access

To access the application online, visit the following link:

https://microbiomestat.shinyapps.io/MicrobiomeStat-Shiny/

## Local Deployment

If you want to run this application locally on your own machine, follow the steps below.

### Prerequisites

Before you start, you need to have R and RStudio installed on your machine. If you haven't installed them yet, you can download them from the following links:

- R: https://cran.r-project.org/
- RStudio: https://www.rstudio.com/products/rstudio/download/

### Running the Application Directly from GitHub

One of the easiest ways to run this application locally is by using the `shiny::runGitHub()` function, which will download the code from GitHub and start the application. You can do this by running the following command in your R console:

```r
shiny::runGitHub("MicrobiomeStat-Shiny", "cafferychen777")
```

Please note that this method requires internet connection to download the application from GitHub every time you run it. 

### Installation for Offline Use

If you want to run the application offline, you need to clone the repository and install the required packages. Follow the steps below:

1. **Clone the Repository**: Clone/download this repository to your local machine. If you have Git installed, you can use the following command in your terminal:

   ```
   git clone https://github.com/cafferychen777/MicrobiomeStat-Shiny.git
   ```

2. **Set your Working Directory**: Open RStudio and set your working directory to the cloned repository. You can do this by using the `setwd()` function in R. For example:

   ```r
   setwd("/path/to/cloned/repo/Microbiome-Shiny")
   ```

   Replace "/path/to/cloned/repo/Microbiome-Shiny" with the actual path to the cloned repository on your machine.

3. **Install Required Packages**: Install the necessary R packages. This includes `shiny`, `devtools`, `MicrobiomeStat`, and any other packages that the application depends on. You can install these packages using the `install.packages()` function. For example:

   ```r
   install.packages("devtools")
   devtools::install_github("cafferychen777/MicrobiomeStat")
   ```

   Here is a list of other required packages:

   ```r
   packages_to_install <- c(
     "rlang",
     "tibble",
     "ggplot2",
     "matrixStats",
     "lmerTest",
     "foreach",
     "modeest",
     "dplyr",
     "pheatmap",
     "tidyr",
     "ggh4x",
     "GUniFrac",
     "stringr",
     "rmarkdown",
     "knitr",
     "pander",
     "tinytex",
     "vegan",
     "scales",
     "ape",
     "ggrepel",      
     "parallel",     
     "ggprism",     
     "aplot",         
     "philentropy",  
     "forcats",       
     "yaml",          
     "biomformat",   
     "Biostrings",
     "shiny",
     "shinyjs",
     "shinythemes",
     "shinyBS"
   )
   
   # Installing packages
   install.packages(packages_to_install)
   ```

### Running the Shiny Application

Once you've installed all necessary packages, you can run the Shiny application by using the `runApp()` function from the `shiny` package. For example:

```r
shiny::runApp()
```

This will start the Shiny application in your local web browser.

## Current Features and Future Plans

The MicrobiomeStat Shiny application now supports cross-sectional design analysis, paired samples, and longitudinal data analysis. We have successfully completed the development of these comprehensive modules. We are continuously working to enhance the tool's capabilities and expand its range of features. Stay tuned for future updates and improvements.

## Troubleshooting

If you encounter any issues while running the Shiny application, make sure that you've correctly set your working directory and that all necessary packages are installed. If you still have problems, please open an issue in this repository and we'll try to help as soon as possible.

## Contributing

Contributions to Microbiome-Shiny are very welcome. If you have a feature request, bug report, or want to improve the application, please feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License. For full details of the license, please visit the [MIT License webpage](https://opensource.org/licenses/MIT).

Thank you for your interest in Microbiome-Shiny!
