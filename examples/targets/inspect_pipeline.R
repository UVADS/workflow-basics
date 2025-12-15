#!/usr/bin/env Rscript
# Script to inspect a Targets pipeline
# Usage: Rscript inspect_pipeline.R

library(targets)

# Check if my_targets.R exists
if (!file.exists("my_targets.R")) {
  stop("Error: my_targets.R file not found in current directory")
}

# Load the pipeline
tar_config_set(store = "_targets")

cat("=========================================\n")
cat("Targets Pipeline Inspection\n")
cat("=========================================\n\n")

# List all targets
cat("All targets:\n")
manifest <- tar_manifest()
print(manifest)
cat("\n")

# Show dependency graph
cat("Dependency graph (saved to pipeline_graph.html):\n")
tryCatch({
  tar_visnetwork()
  cat("Graph visualization opened in browser or saved.\n\n")
}, error = function(e) {
  cat("Could not generate graph visualization.\n\n")
})

# Check which targets are outdated
cat("Outdated targets:\n")
outdated <- tar_outdated()
if (length(outdated) > 0) {
  print(outdated)
} else {
  cat("All targets are up to date.\n")
}
cat("\n")

# Show pipeline progress
cat("Pipeline progress:\n")
progress <- tar_progress()
print(progress)
cat("\n")

# Show metadata
cat("Target metadata:\n")
meta <- tar_meta()
print(head(meta, 10))
if (nrow(meta) > 10) {
  cat(sprintf("... and %d more rows\n", nrow(meta) - 10))
}
cat("\n")

cat("=========================================\n")
cat("Inspection complete\n")
cat("=========================================\n")

