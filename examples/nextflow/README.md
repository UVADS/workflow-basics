---
layout: default
title: Nextflow Examples
parent: Examples
nav_order: 2
---

# Nextflow Examples

This directory contains example Nextflow workflows and configuration files.

## Files

- `simple_pipeline.nf` - A basic ETL pipeline workflow demonstrating process chaining
- `nextflow.config` - Configuration file with execution profiles and settings
- `README.md` - This file

## Setup

1. Install Nextflow:
   ```bash
   # Using conda
   conda install -c bioconda nextflow
   
   # Or download directly
   curl -s https://get.nextflow.io | bash
   chmod +x nextflow
   sudo mv nextflow /usr/local/bin/
   ```

2. Verify installation:
   ```bash
   nextflow -version
   ```

3. Ensure Java is installed (Java 8+ required):
   ```bash
   java -version
   ```

## Running the Example

### Basic Execution

Run the simple pipeline:
```bash
nextflow run simple_pipeline.nf --input data.txt
```

If no input file is specified, the workflow will create a sample data file automatically.

### With Custom Parameters

```bash
nextflow run simple_pipeline.nf \
    --input mydata.txt \
    --output results \
    --work work_dir
```

### Using Execution Profiles

The `nextflow.config` file includes several execution profiles:

**Local execution (default):**
```bash
nextflow run simple_pipeline.nf -profile local
```

**SLURM cluster:**
```bash
nextflow run simple_pipeline.nf -profile slurm
```

**Docker containers:**
```bash
nextflow run simple_pipeline.nf -profile docker
```

**Apptainer containers (recommended):**
```bash
nextflow run simple_pipeline.nf -profile apptainer
```

**Singularity containers (legacy, still supported):**
```bash
nextflow run simple_pipeline.nf -profile singularity
```

## Understanding the Workflow

### Process Structure

The `simple_pipeline.nf` workflow consists of three processes:

1. **extract** - Reads input data and extracts a sample
2. **transform** - Transforms the data (multiplies numbers by 2)
3. **load** - Generates summary statistics

### Process Chaining

Processes are connected using channels:
```nextflow
extract(input_ch)
transform(extract.out.extracted)
load(transform.out.transformed)
```

### Input/Output

- Inputs are declared with the `input:` block
- Outputs are declared with the `output:` block and `emit:` keyword
- Data flows through channels between processes

## Configuration

The `nextflow.config` file provides:

- **Execution profiles** for different environments (local, SLURM, PBS, Docker, Apptainer/Singularity)
- **Resource defaults** (CPU, memory, time limits)
- **Error handling** settings
- **Reporting** configuration (HTML reports, timeline, trace)

Customize the configuration by editing `nextflow.config` or override settings via command-line parameters.

## Workflow Features

### Resume Execution

If a workflow fails, you can resume it:
```bash
nextflow run simple_pipeline.nf -resume
```

This will skip successfully completed processes.

### Viewing Results

Results are published to the output directory (default: `results/`). The workflow also generates:

- **HTML Report** - `results/report.html` - Visual workflow execution report
- **Timeline** - `results/timeline.html` - Timeline visualization
- **Trace** - `results/trace.txt` - Detailed execution trace

### Monitoring Execution

Nextflow provides real-time execution monitoring:
- Progress information in the terminal
- Execution logs in the work directory
- HTML reports for detailed analysis

## Advanced Usage

### Creating Custom Profiles

Add custom profiles to `nextflow.config`:

```nextflow
profiles {
    myprofile {
        process.executor = 'local'
        process.cpus = 8
        process.memory = '32 GB'
    }
}
```

Use with:
```bash
nextflow run simple_pipeline.nf -profile myprofile
```

### Using Containers

Enable container execution:

```bash
# Docker
nextflow run simple_pipeline.nf -with-docker

# Apptainer (recommended)
nextflow run simple_pipeline.nf -with-apptainer

# Singularity (legacy, still supported)
nextflow run simple_pipeline.nf -with-singularity
```

### Custom Work Directory

Specify a custom work directory:
```bash
nextflow run simple_pipeline.nf -w /path/to/work
```

## Troubleshooting

### Common Issues

1. **Java not found**: Install Java 8 or later
2. **Permission denied**: Ensure Nextflow is executable (`chmod +x nextflow`)
3. **Process failures**: Check logs in the `work/` directory
4. **Memory issues**: Adjust `process.memory` in config or use `-with-memory`

### Getting Help

- Check Nextflow logs in the work directory
- Review the HTML report for detailed error information
- Consult the [Nextflow Documentation](https://www.nextflow.io/docs/latest/)

## Additional Resources

For comprehensive documentation, tutorials, and additional resources, see the [Nextflow documentation page]({{ "/docs/quickstart/nextflow/" | relative_url }}).

