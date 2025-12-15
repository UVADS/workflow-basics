#!/usr/bin/env nextflow

/*
 * A Simple Nextflow Workflow
 * 
 * This workflow demonstrates a basic ETL pipeline with three processes:
 * 1. Extract: Reads input data
 * 2. Transform: Processes the data
 * 3. Load: Generates output
 * 
 * Usage:
 *   nextflow run simple_pipeline.nf --input data.txt
 */

// Define workflow parameters
params.input = "data.txt"
params.output = "results"

// Print workflow information
workflow {
    println "========================================="
    println "Simple Data Processing Workflow"
    println "========================================="
    println "Input file: ${params.input}"
    println "Output directory: ${params.output}"
    println ""
}

// Process 1: Extract data
process extract {
    label "extract"
    
    input:
    path input_file
    
    output:
    path "extracted.txt", emit: extracted
    
    script:
    """
    echo "Extracting data from ${input_file}"
    echo "Processing file: \$(basename ${input_file})"
    head -n 10 ${input_file} > extracted.txt || echo "Sample data" > extracted.txt
    echo "Extraction complete"
    """
}

// Process 2: Transform data
process transform {
    label "transform"
    
    input:
    path input_file
    
    output:
    path "transformed.txt", emit: transformed
    
    script:
    """
    echo "Transforming data"
    # Simple transformation: multiply each number by 2
    awk "{if (\$1 ~ /^[0-9]+$/) print \$1 * 2; else print \$1}" ${input_file} > transformed.txt
    echo "Transformation complete"
    """
}

// Process 3: Load data
process load {
    label "load"
    
    input:
    path input_file
    
    output:
    path "loaded.txt", emit: loaded
    
    script:
    """
    echo "Loading data"
    echo "File: \$(basename ${input_file})" > loaded.txt
    echo "Lines: \$(wc -l < ${input_file})" >> loaded.txt
    echo "Size: \$(du -h ${input_file} | cut -f1)" >> loaded.txt
    echo "Load complete"
    """
}

// Define the main workflow
workflow {
    // Create input channel from parameter
    input_ch = Channel.fromPath(params.input, checkIfExists: false)
    
    // If input file doesn't exist, create a sample one
    if (!file(params.input).exists()) {
        println "Warning: Input file not found. Creating sample data..."
        file(params.input).text = "1\n2\n3\n4\n5\n6\n7\n8\n9\n10"
        input_ch = Channel.fromPath(params.input)
    }
    
    // Chain processes: extract -> transform -> load
    extract(input_ch)
    transform(extract.out.extracted)
    load(transform.out.transformed)
    
    // Print results
    load.out.loaded.view { "Result file: ${it}" }
    
    // Publish results
    load.out.loaded
        .collectFile(name: "final_result.txt", newLine: true)
        .set { final_output }
    
    final_output.view { "Final output saved to: ${it}" }
}

