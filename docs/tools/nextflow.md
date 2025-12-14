---
layout: default
title: Nextflow
parent: Tools
nav_order: 2
---
# Nextflow
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .no_toc .text-delta }
- TOC
{:toc}
</details>

## What is Nextflow?

Nextflow is an open-source workflow management system that enables scalable and reproducible scientific workflows. It was created by the Centre for Genomic Regulation (CRG) and is particularly popular in bioinformatics, genomics, and data science. Nextflow uses a domain-specific language (DSL) based on Groovy to define workflows as code.

Nextflow is particularly well-suited for:

- **Bioinformatics**: Genomics pipelines, sequence analysis, variant calling
- **Data Science**: Large-scale data processing, ETL workflows
- **Scientific Computing**: Reproducible research workflows, computational experiments
- **HPC Workflows**: Workflows that need to run on high-performance computing clusters

Key features of Nextflow include:

- **Reproducibility**: Built-in support for containers (Docker, Apptainer/Singularity) and Conda environments
- **Portability**: Workflows can run on multiple execution platforms (local, HPC, cloud)
- **Scalability**: Automatic parallelization and distributed execution
- **Resume capability**: Can resume failed workflows from the last successful step
- **Rich ecosystem**: Large collection of pre-built workflows and modules
- **DSL-based**: Workflows defined in a readable, maintainable language

## Setup

### Installation

Install Nextflow using one of the following methods:

**Using conda:**
```bash
conda install -c bioconda nextflow
```

**Using Homebrew (macOS):**
```bash
brew install nextflow
```

**Manual installation:**
```bash
curl -s https://get.nextflow.io | bash
```

Or download directly:
```bash
wget -qO- https://get.nextflow.io | bash
chmod +x nextflow
sudo mv nextflow /usr/local/bin/
```

**Using Docker:**
```bash
docker pull nextflow/nextflow
```

### Verify Installation

Verify that Nextflow is installed correctly:

```bash
nextflow -version
```

### Requirements

Nextflow requires:
- Java 8 or later (Java 11+ recommended)
- Bash shell
- Common Unix utilities (curl, wget)

Check Java version:
```bash
java -version
```

### Configuration

Nextflow configuration is typically stored in `~/.nextflow/config` or `nextflow.config` in your project directory. The configuration file allows you to:

- Define execution profiles (local, HPC, cloud)
- Configure compute resources
- Set up container engines (Docker, Apptainer/Singularity)
- Configure data storage and caching

**Once Nextflow is installed, you can:**
- Create your first workflow (see "Getting Started" section below)
- Run example workflows from the Nextflow community
- Check out the example scripts in the examples folder

## Getting Started

### Understanding Nextflow Workflows

Nextflow workflows are defined using a domain-specific language (DSL) based on Groovy. Key concepts include:

- **Process**: A process is a task that executes a command or script. Processes are the building blocks of workflows.
- **Channel**: Channels are asynchronous queues that connect processes and pass data between them.
- **Workflow**: A workflow defines the execution flow by connecting processes through channels.
- **Operators**: Operators transform and manipulate channels (e.g., `map`, `filter`, `collect`).

Processes are defined with:
- Input channels
- Output channels
- Script/command to execute
- Resource requirements (CPU, memory, etc.)

### A simple Workflow

Here's a basic Nextflow workflow that processes data:

```nextflow
#!/usr/bin/env nextflow

// Define workflow parameters
params.input = "data.txt"
params.output = "results"

// Print workflow information
workflow {
    println "Running simple data processing workflow"
    println "Input: ${params.input}"
    println "Output: ${params.output}"
}

// Process 1: Extract data
process extract {
    input:
    path input_file
    
    output:
    path "extracted.txt"
    
    script:
    """
    echo "Extracting data from ${input_file}"
    head -n 10 ${input_file} > extracted.txt
    """
}

// Process 2: Transform data
process transform {
    input:
    path input_file
    
    output:
    path "transformed.txt"
    
    script:
    """
    echo "Transforming data"
    awk '{print \$1 * 2}' ${input_file} > transformed.txt
    """
}

// Process 3: Load data
process load {
    input:
    path input_file
    
    output:
    path "loaded.txt"
    
    script:
    """
    echo "Loading data"
    wc -l ${input_file} > loaded.txt
    """
}

// Define the workflow
workflow {
    // Create input channel
    input_ch = Channel.fromPath(params.input)
    
    // Chain processes
    extract(input_ch)
    transform(extract.out)
    load(transform.out)
    
    // Print results
    load.out.view()
}
```

Save this file as `simple_pipeline.nf`. Run it with:

```bash
nextflow run simple_pipeline.nf --input data.txt
```

**Key points:**
- Processes are defined with `process` keyword
- Inputs and outputs are declared with `input:` and `output:` blocks
- The `script:` block contains the command to execute
- Workflow connects processes using channels
- Parameters can be passed via command line with `--param value`

### Channels and Operators

Channels are fundamental to Nextflow workflows:

```nextflow
// Create channels
ch1 = Channel.from(1, 2, 3, 4, 5)
ch2 = Channel.fromPath("*.txt")
ch3 = Channel.fromFilePairs("data_{sample}.txt")

// Transform channels
ch1.map { it * 2 }  // Multiply each value by 2
ch2.filter { it.size() > 1000 }  // Filter large files
ch3.collect()  // Collect all items into a single channel
```

## All Example Scripts

[/examples/nextflow]

## Advanced Topics

### Execution Profiles

Nextflow supports execution profiles for different environments:

```nextflow
profiles {
    local {
        executor = 'local'
        process.cpus = 4
        process.memory = '8 GB'
    }
    
    slurm {
        executor = 'slurm'
        process.queue = 'compute'
        process.cpus = 8
        process.memory = '16 GB'
    }
    
    aws {
        executor = 'awsbatch'
        process.queue = 'my-queue'
    }
}
```

Run with a specific profile:
```bash
nextflow run workflow.nf -profile slurm
```

### Containers

Nextflow supports Docker, Apptainer, and Singularity containers:

```nextflow
process my_process {
    container 'biocontainers/fastqc:0.11.9'
    
    script:
    """
    fastqc input.fastq
    """
}
```

Enable containers:
```bash
nextflow run workflow.nf -with-docker
nextflow run workflow.nf -with-apptainer  # Recommended (Apptainer is the new name for Singularity)
nextflow run workflow.nf -with-singularity  # Legacy option, still supported
```

### Resume Execution

Nextflow can resume failed workflows:

```bash
nextflow run workflow.nf -resume
```

This will skip successfully completed processes and continue from failures.

### Configuration Files

Create a `nextflow.config` file in your project:

```nextflow
// Global configuration
workDir = '/path/to/work'

// Process defaults
process {
    cpus = 4
    memory = '8 GB'
    time = '1h'
}

// Executor configuration
executor {
    name = 'slurm'
    queue = 'compute'
}

// Container configuration
docker {
    enabled = true
}
```

### Error Handling

Handle errors in processes:

```nextflow
process my_process {
    errorStrategy 'retry'
    maxRetries 3
    
    script:
    """
    your_command_here
    """
}
```

### Publishing Results

Publish output files:

```nextflow
process my_process {
    publishDir "${params.output}", mode: 'copy'
    
    output:
    path "result.txt"
    
    script:
    """
    echo "result" > result.txt
    """
}
```

## Additional Resources

### Official Documentation

- [Nextflow Documentation](https://www.nextflow.io/docs/latest/) - Comprehensive guides, API reference, and tutorials
- [Nextflow Blog](https://www.nextflow.io/blog/) - Updates, best practices, and case studies
- [Nextflow GitHub Repository](https://github.com/nextflow-io/nextflow) - Source code and issues

### Learning Resources

- [Nextflow Tutorials](https://www.nextflow.io/docs/latest/getstarted.html) - Official getting started guide
- [Nextflow Patterns](https://www.nextflow.io/docs/latest/pattern.html) - Common workflow patterns
- [nf-core](https://nf-co.re/) - Community-curated Nextflow workflows

### Community

- [Nextflow Slack Community](https://www.nextflow.io/slack) - Real-time community support
- [Nextflow Google Groups](https://groups.google.com/forum/#!forum/nextflow) - Community forum
- [Stack Overflow](https://stackoverflow.com/questions/tagged/nextflow) - Q&A with Nextflow tag

### Related Tools

- [nf-core](https://nf-co.re/) - Community-curated Nextflow workflows for genomics
- [Tower](https://tower.nf/) - Cloud-based workflow management for Nextflow
- [Seqera Platform](https://seqera.io/) - Enterprise workflow management platform
