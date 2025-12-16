---
layout: default
title: Targets
parent: Quickstart
nav_order: 6
---
# Targets
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .no_toc .text-delta }
- TOC
{:toc}
</details>

## What is Targets?

Targets is an R package for creating reproducible data analysis pipelines. It was created by Will Landau and provides a Make-like workflow system specifically designed for R. Targets tracks dependencies between analysis steps, automatically skips up-to-date targets, and provides tools for debugging and monitoring pipeline execution.

Targets is particularly well-suited for:

- **Data Analysis**: Reproducible data analysis workflows, statistical pipelines
- **Research**: Scientific computing workflows, research reproducibility
- **Reporting**: Automated report generation, data processing pipelines
- **R-based Workflows**: Any workflow that primarily uses R for data processing

Key features of Targets include:

- **R-native**: Workflows are defined as R code using target objects
- **Dependency tracking**: Automatically tracks dependencies between targets
- **Incremental execution**: Only runs targets that are out of date
- **Reproducibility**: Ensures consistent results through dependency management
- **Debugging tools**: Built-in tools for inspecting and debugging pipelines
- **Parallel execution**: Can run independent targets in parallel
- **Integration**: Works seamlessly with other R packages (dplyr, ggplot2, etc.)

## Setup

**Requirements**

Targets requires:
- R version 4.0.0 or later
- Common R packages (available via `targets::tar_option_set()`)
Install Targets from CRAN:

```r
install.packages("targets")
```

Or install the development version from GitHub:

```r
# Install remotes if not already installed
install.packages("remotes")

# Install targets
remotes::install_github("ropensci/targets")
```

**Verify Installation**

Verify that Targets is installed correctly:

```r
library(targets)
packageVersion("targets")
```

**Additional Packages for Examples**

The example scripts in this repository require additional packages:

```r
install.packages(c("tarchetypes", "visNetwork"))
```

- **`tarchetypes`**: Provides additional target types and utilities used in the examples
- **`visNetwork`**: Required for `tar_visnetwork()` to visualize the dependency graph

{: .note }
These packages are required to run the examples in the `examples/targets/` directory. If you're creating your own pipeline from scratch, you may not need them unless you use specific features (e.g., `tar_visnetwork()` for visualization).

**Once Targets is installed, you can:**
- Create your first pipeline (see "Getting Started" section below)
- Check out the [example scripts](https://github.com/UVADS/workflow-basics/tree/main/examples/targets) in the GitHub repository.

## Getting Started

### Understanding Targets

Targets workflows are built around the concept of **targets** - named objects that represent steps in your analysis pipeline.

**Key Concepts:**

- **Target**: A named object that represents a step in the pipeline (e.g., a data file, a processed dataset, a plot)
- **Target script**: An R script (`_targets.R`) that defines all targets and their dependencies
- **Dependency graph**: Targets automatically builds a dependency graph to determine execution order
- **Storage**: Targets stores results in a `_targets/` directory for caching and reproducibility

Targets automatically
- Tracks dependencies between targets,
- Skips targets that are up-to-date,
- Runs targets in the correct order,
- Caches results for reproducibility.

### A simple Workflow

Assuming that you're in the top level directory of the cloned GitHub repo, change to the examples folder with this command:

```bash
cd examples/targets
```

Here's a basic Targets pipeline that processes data:

Create a file named `_targets.R`:

```r
library(targets)
library(tarchetypes)

# Set options
tar_option_set(
  packages = c("dplyr", "readr")
)

# Define targets
list(
  # Target 1: Load raw data
  tar_target(
    name = raw_data,
    command = {
      # Simulate loading data
      data.frame(
        id = 1:10,
        value = rnorm(10, mean = 5, sd = 2)
      )
    }
  ),
  
  # Target 2: Process data
  tar_target(
    name = processed_data,
    command = {
      raw_data %>%
        dplyr::mutate(value_doubled = value * 2)
    },
    packages = "dplyr"
  ),
  
  # Target 3: Create summary
  tar_target(
    name = summary_stats,
    command = {
      list(
        mean = mean(processed_data$value),
        sd = sd(processed_data$value),
        n = nrow(processed_data)
      )
    }
  ),
  
  # Target 4: Save results
  tar_target(
    name = save_results,
    command = {
      write.csv(processed_data, "results/processed_data.csv", row.names = FALSE)
      "results/processed_data.csv"
    },
    format = "file"
  )
)
```

**Executing the pipeline:**

```r
library(targets)

# Load the pipeline
tar_make()

# View the pipeline (opens interactive HTML graph in browser/viewer)
tar_visnetwork()

# Read a target
tar_read(processed_data)
```

For convenience, you can run the pipeline or specific target using the provided `run_pipeline.R` script from the command line:

```bash
# Run all targets
Rscript run_pipeline.R

# Run a specific target
Rscript run_pipeline.R processed_data
```

**Expected output**

```r
Running all targets...
+ raw_data dispatched
No data file found. Generating sample data...
✔ raw_data completed [109ms, 380 B]
+ processed_data dispatched
✔ processed_data completed [14ms, 652 B]
+ data_plot dispatched
✔ data_plot completed [1.2s, 46.44 kB]
+ summary_stats dispatched
✔ summary_stats completed [1ms, 210 B]
+ save_results dispatched
✔ save_results completed [321ms, 1.29 kB]
✔ ended pipeline [2s, 5 completed, 0 skipped]

Pipeline completed successfully!

Pipeline status:
# A tibble: 5 × 2
  name           progress 
  <chr>          <chr>    
1 raw_data       completed
2 processed_data completed
3 data_plot      completed
4 summary_stats  completed
5 save_results   completed
```

![View of task dependencies]({{ "/assets/images/targets/targets-dag.png" | relative_url }})

**Data storage and caching:**

Targets stores all computed results, metadata, and dependency information in a `_targets/` directory at the root of your project (the same directory where your `_targets.R` file is located). This directory contains:

- **Computed target values**: Cached results of each target for fast retrieval
- **Metadata**: Information about when each target was built, its dependencies, and execution status
- **Dependency graph**: Internal representation of the pipeline structure

When you run `tar_make()`, Targets checks this cache to determine which targets need to be rebuilt (only those that have changed inputs or dependencies). This makes subsequent runs much faster and ensures reproducibility. The `_targets/` directory should typically be added to `.gitignore` since it contains generated files.

**Key points:**
- Targets are defined using `tar_target()`
- Dependencies are automatically inferred from code
- Use `tar_make()` to run the pipeline
- Use `tar_read()` to access target results
- Use `tar_visnetwork()` to visualize the dependency graph (opens interactive HTML in browser/viewer)

### Inspecting and Managing the Pipeline

Beyond the basic commands shown above, Targets provides several useful functions for inspecting and managing your pipeline:

```r
# Export the dependency graph as a static image (optional)
# First install: install.packages(c("htmlwidgets", "webshot2"))
library(htmlwidgets)
library(webshot2)
vis <- tar_visnetwork()
htmlwidgets::saveWidget(vis, "pipeline_graph.html")
webshot2::webshot("pipeline_graph.html", "pipeline_graph.png")

# Alternative: Simple text-based diagram
tar_man()

# List all targets
tar_manifest()

# Check which targets are out of date
tar_outdated()

# View pipeline metadata
tar_meta()
```


### All Example Scripts

You can find the example scripts and notebooks in the [examples folder](https://github.com/UVADS/workflow-basics/tree/main/examples/targets) in the Git repository.

In addition, take a look at the examples in the [Additional Resources](#additional-resources)

## Advanced Topics

### Dynamic Targets

Create targets dynamically based on data:

```r
tar_target(
  name = file_list,
  command = list.files("data/", pattern = "*.csv")
),

tar_target(
  name = data_files,
  command = read.csv(file_list, stringsAsFactors = FALSE),
  pattern = map(file_list),
  iteration = "list"
)
```

### Branching

Create branches for parallel processing:

```r
tar_target(
  name = analysis,
  command = process_data(data),
  pattern = map(data),
  iteration = "list"
)
```

### Format Options

Specify storage formats for targets:

```r
tar_target(
  name = data_file,
  command = "data.csv",
  format = "file"  # Tracks file timestamps
)

tar_target(
  name = large_data,
  command = big_data_frame,
  format = "fst"  # Efficient storage for large data frames
)
```

### Custom Storage

Configure custom storage backends:

```r
tar_option_set(
  storage = "worker",
  retrieval = "worker",
  memory = "transient"
)
```

### Pipeline Configuration

Configure pipeline behavior:

```r
tar_option_set(
  packages = c("dplyr", "ggplot2"),
  error = "continue",  # Continue on errors
  memory = "persistent"  # Keep targets in memory
)
```

### Debugging

Debug pipeline issues:

```r
# Run a specific target
tar_make(names = "processed_data")

# Inspect a target
tar_load(processed_data)
head(processed_data)

# View error messages
tar_meta(fields = error)
```

## Additional Resources

### Official Documentation

- [Targets Documentation](https://docs.ropensci.org/targets/) - Comprehensive guides, API reference, and tutorials
- [Targets GitHub Repository](https://github.com/ropensci/targets) - Source code and issues

### Learning Resources

- [Targets Tutorial](https://docs.ropensci.org/targets/articles/walkthrough.html) - Step-by-step tutorial
- [Targets Examples](https://github.com/ropensci/targets/tree/main/examples) - Example pipelines
- [Targets Best Practices](https://books.ropensci.org/targets/practices.html) - Best practices guide

### Community

- [rOpenSci Community](https://ropensci.org/community/) - Community forum and discussions
- [Stack Overflow](https://stackoverflow.com/questions/tagged/r-targets) - Q&A with targets tag
- [Targets Discussions](https://github.com/ropensci/targets/discussions) - GitHub discussions

### Related Tools

- [tarchetypes](https://docs.ropensci.org/tarchetypes/) - Additional target types and utilities
- [crew](https://wlandau.github.io/crew/) - Parallel computing backend for targets
- [stantargets](https://wlandau.github.io/stantargets/) - Targets integration for Stan models
