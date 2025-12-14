# Targets Examples

This directory contains example Targets pipelines and helper scripts for R-based data workflows.

## Files

- `_targets.R` - Main pipeline definition file (required for all Targets pipelines)
- `run_pipeline.R` - Script to run the pipeline from command line
- `inspect_pipeline.R` - Script to inspect pipeline status and dependencies
- `README.md` - This file

## Setup

1. Install Targets:
   ```r
   install.packages("targets")
   ```

2. Install optional dependencies:
   ```r
   install.packages(c("dplyr", "readr", "tarchetypes"))
   # Optional: for plotting
   install.packages("ggplot2")
   ```

3. Verify installation:
   ```r
   library(targets)
   packageVersion("targets")
   ```

## Running the Example

### Basic Usage

1. Copy `_targets.R` to your project directory (or work in this directory)

2. Run the pipeline in R:
   ```r
   library(targets)
   tar_make()
   ```

3. View the dependency graph:
   ```r
   tar_visnetwork()
   ```

4. Read a target:
   ```r
   tar_read(processed_data)
   ```

### Using Helper Scripts

**Run the pipeline:**
```bash
Rscript run_pipeline.R
```

**Run specific targets:**
```bash
Rscript run_pipeline.R processed_data summary_stats
```

**Inspect the pipeline:**
```bash
Rscript inspect_pipeline.R
```

## Understanding the Pipeline

### Pipeline Structure

The `_targets.R` file defines a pipeline with five targets:

1. **raw_data** - Generates or loads raw data
2. **processed_data** - Transforms the raw data
3. **summary_stats** - Calculates summary statistics
4. **save_results** - Saves processed data to a CSV file
5. **data_plot** - Creates a visualization (optional, requires ggplot2)

### Target Dependencies

Targets automatically tracks dependencies:
- `processed_data` depends on `raw_data`
- `summary_stats` depends on `processed_data`
- `save_results` depends on `processed_data`
- `data_plot` depends on `processed_data`

### Key Commands

```r
# Run the pipeline
tar_make()

# Run specific targets
tar_make(names = c("processed_data", "summary_stats"))

# View dependency graph
tar_visnetwork()

# Read a target
tar_read(processed_data)

# List all targets
tar_manifest()

# Check outdated targets
tar_outdated()

# View pipeline metadata
tar_meta()

# Load targets into environment
tar_load(processed_data, summary_stats)

# Clean pipeline (remove all targets)
tar_destroy()
```

## Pipeline Features

### Incremental Execution

Targets only runs targets that are out of date. If you modify `raw_data`, only downstream targets will be re-run.

### Dependency Tracking

Targets automatically infers dependencies from your code. If `processed_data` uses `raw_data`, the dependency is automatically tracked.

### File Tracking

The `save_results` target uses `format = "file"` to track file timestamps. If the file is modified externally, the target will be marked as outdated.

### Error Handling

The pipeline is configured with `error = "continue"` to continue execution even if one target fails.

## Customization

### Adding New Targets

Add targets to the `list()` in `_targets.R`:

```r
tar_target(
  name = new_target,
  command = {
    # Your code here
    processed_data %>% filter(value > 5)
  },
  packages = "dplyr"
)
```

### Using External Data Files

Modify the `raw_data` target to read from a file:

```r
tar_target(
  name = raw_data,
  command = {
    readr::read_csv("data/my_data.csv", show_col_types = FALSE)
  },
  format = "file"  # Track file timestamps
)
```

### Parallel Execution

Configure parallel execution:

```r
tar_option_set(
  workers = 4  # Number of parallel workers
)
```

## Troubleshooting

### Common Issues

1. **Package not found**: Ensure all required packages are installed and listed in `tar_option_set(packages = ...)`

2. **Target not found**: Check that the target name is spelled correctly and exists in `_targets.R`

3. **Dependency errors**: Use `tar_visnetwork()` to visualize dependencies and identify issues

4. **Outdated targets**: Use `tar_outdated()` to see which targets need to be updated

### Getting Help

- Check Targets logs in the `_targets/` directory
- Use `tar_meta(fields = error)` to view error messages
- Consult the [Targets Documentation](https://docs.ropensci.org/targets/)

## Additional Resources

- [Targets Documentation](https://docs.ropensci.org/targets/)
- [Targets Manual](https://books.ropensci.org/targets/)
- [Targets Tutorial](https://docs.ropensci.org/targets/articles/walkthrough.html)
- [Targets Examples](https://github.com/ropensci/targets/tree/main/examples)

