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

# Check for errors
if (length(tar_meta(fields = error)$error) > 0) {
  cat("\nWARNING: Some targets had errors. Check tar_meta() for details.\n")
  print(tar_meta(fields = error))
} else {
  cat("\nPipeline completed successfully!\n")
}

# Display pipeline status
cat("\nPipeline status:\n")
print(tar_progress())

