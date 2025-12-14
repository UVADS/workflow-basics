# A Simple Targets Pipeline
# 
# This pipeline demonstrates a basic ETL workflow with four targets:
# 1. raw_data: Generate or load raw data
# 2. processed_data: Transform the data
# 3. summary_stats: Calculate summary statistics
# 4. save_results: Save the processed data to a file
#
# Usage:
#   library(targets)
#   tar_make()  # Run the pipeline
#   tar_read(processed_data)  # Read a target

library(targets)
library(tarchetypes)

# Set pipeline options
tar_option_set(
  packages = c("dplyr", "readr"),
  error = "continue"  # Continue on errors
)

# Define helper functions (optional, can be in separate R/ folder)
generate_raw_data <- function(n = 10) {
  data.frame(
    id = 1:n,
    value = rnorm(n, mean = 5, sd = 2),
    category = sample(c("A", "B", "C"), n, replace = TRUE)
  )
}

process_data <- function(data) {
  data %>%
    dplyr::mutate(
      value_doubled = value * 2,
      value_squared = value^2,
      category_upper = toupper(category)
    )
}

calculate_summary <- function(data) {
  list(
    mean = mean(data$value),
    sd = sd(data$value),
    median = median(data$value),
    n = nrow(data),
    categories = table(data$category)
  )
}

# Define targets
list(
  # Target 1: Load or generate raw data
  tar_target(
    name = raw_data,
    command = {
      # Check if data file exists, otherwise generate sample data
      if (file.exists("data/raw_data.csv")) {
        readr::read_csv("data/raw_data.csv", show_col_types = FALSE)
      } else {
        message("No data file found. Generating sample data...")
        generate_raw_data(n = 20)
      }
    },
    packages = "readr"
  ),
  
  # Target 2: Process/transform the data
  tar_target(
    name = processed_data,
    command = {
      process_data(raw_data)
    },
    packages = "dplyr"
  ),
  
  # Target 3: Create summary statistics
  tar_target(
    name = summary_stats,
    command = {
      calculate_summary(processed_data)
    }
  ),
  
  # Target 4: Save processed data to file
  tar_target(
    name = save_results,
    command = {
      # Create results directory if it doesn't exist
      if (!dir.exists("results")) {
        dir.create("results", recursive = TRUE)
      }
      
      # Save processed data
      output_file <- "results/processed_data.csv"
      readr::write_csv(processed_data, output_file)
      
      # Return file path for tracking
      output_file
    },
    format = "file",
    packages = "readr"
  ),
  
  # Target 5: Create a simple plot (optional)
  tar_target(
    name = data_plot,
    command = {
      if (requireNamespace("ggplot2", quietly = TRUE)) {
        p <- ggplot2::ggplot(processed_data, ggplot2::aes(x = value, y = value_doubled)) +
          ggplot2::geom_point() +
          ggplot2::labs(title = "Value vs Doubled Value")
        
        # Save plot
        if (!dir.exists("results")) {
          dir.create("results", recursive = TRUE)
        }
        ggplot2::ggsave("results/plot.png", p, width = 6, height = 4)
        "results/plot.png"
      } else {
        message("ggplot2 not available, skipping plot")
        NULL
      }
    },
    format = "file",
    packages = "ggplot2"
  )
)

