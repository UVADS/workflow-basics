#!/usr/bin/env Rscript
# Script to run a Targets pipeline
# Usage: Rscript run_pipeline.R [target_name]
# Example: Rscript run_pipeline.R processed_data

# Get command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Load targets library
library(targets)

# Check if _targets.R exists
if (!file.exists("_targets.R")) {
  stop("Error: _targets.R file not found in current directory")
}

# Load the pipeline
tar_config_set(store = "_targets")

# Run the pipeline
if (length(args) > 0) {
  # Run specific target(s)
  target_names <- args
  cat("Running specific targets:", paste(target_names, collapse = ", "), "\n")
  tar_make(names = target_names)
} else {
  # Run all targets
  cat("Running all targets...\n")
  tar_make()
}

# Check for errors (safely)
tryCatch({
  meta <- tar_meta(fields = "error")
  if (!is.null(meta) && nrow(meta) > 0 && any(!is.na(meta$error))) {
    cat("\nWARNING: Some targets had errors. Check tar_meta() for details.\n")
    print(meta[!is.na(meta$error), ])
  } else {
    cat("\nPipeline completed successfully!\n")
  }
}, error = function(e) {
  cat("\nPipeline execution completed. Check tar_meta() manually for details.\n")
})

# Display pipeline status (safely)
tryCatch({
  cat("\nPipeline status:\n")
  progress <- tar_progress()
  if (!is.null(progress) && nrow(progress) > 0) {
    print(progress)
  } else {
    cat("No progress information available.\n")
  }
}, error = function(e) {
  cat("\nCould not retrieve pipeline progress.\n")
})

