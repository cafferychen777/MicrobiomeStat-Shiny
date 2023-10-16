# Microbiome-Shiny

Welcome to the Microbiome-Shiny repository, the R Shiny interface for the MicrobiomeStat R package. This readme will guide you through the process of running this application locally on your own machine.

## Prerequisites

Before you start, you need to have R and RStudio installed on your machine. If you haven't installed them yet, you can download them from the following links:

- R: https://cran.r-project.org/
- RStudio: https://www.rstudio.com/products/rstudio/download/

## Installation

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
      "Biostrings"    
    )
    
    # Installing packages
    install.packages(packages_to_install)
    ```

## Running the Shiny Application

Once you've installed all necessary packages, you can run the Shiny application by using the `runApp()` function from the `shiny` package. For example:

```r
shiny::runApp()
```

This will start the Shiny application in your local web browser.

## Current Features and Future Plans

Currently, the MicrobiomeStat Shiny application supports cross-sectional design analysis and visualization. We are actively working on expanding the tool's capabilities. In the near future, we plan to add support for paired samples and longitudinal data analysis.

## Troubleshooting

If you encounter any issues while running the Shiny application, make sure that you've correctly set your working directory and that all necessary packages are installed. If you still have problems, please open an issue in this repository and we'll try to help as soon as possible.

## Contributing

Contributions to Microbiome-Shiny are very welcome. If you have a feature request, bug report, or want to improve the application, please feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Thank you for your interest in Microbiome-Shiny!