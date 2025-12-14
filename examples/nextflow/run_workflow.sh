#!/bin/bash
# Script to run Nextflow workflows
# Usage: ./run_workflow.sh [workflow.nf] [options]
# Example: ./run_workflow.sh simple_pipeline.nf --input data.txt

WORKFLOW=${1:-simple_pipeline.nf}
shift
OPTIONS="$@"

echo "========================================="
echo "Running Nextflow Workflow"
echo "========================================="
echo "Workflow: $WORKFLOW"
echo "Options: $OPTIONS"
echo ""

# Check if Nextflow is installed
if ! command -v nextflow &> /dev/null; then
    echo "Error: Nextflow is not installed or not in PATH"
    echo "Install Nextflow: curl -s https://get.nextflow.io | bash"
    exit 1
fi

# Check if workflow file exists
if [ ! -f "$WORKFLOW" ]; then
    echo "Error: Workflow file '$WORKFLOW' not found"
    exit 1
fi

# Display Nextflow version
echo "Nextflow version:"
nextflow -version
echo ""

# Run the workflow
echo "Starting workflow execution..."
echo ""

nextflow run "$WORKFLOW" $OPTIONS

EXIT_CODE=$?

echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo "========================================="
    echo "Workflow completed successfully!"
    echo "========================================="
    echo ""
    echo "Results are in the 'results' directory"
    echo "Check the HTML report: results/report.html"
else
    echo "========================================="
    echo "Workflow failed with exit code: $EXIT_CODE"
    echo "========================================="
    echo ""
    echo "To resume from the last successful step:"
    echo "  nextflow run $WORKFLOW $OPTIONS -resume"
    echo ""
    echo "Check logs in the work directory for details"
fi

exit $EXIT_CODE

