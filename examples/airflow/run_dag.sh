#!/bin/bash
# Script to run an Airflow DAG manually
# Usage: ./run_dag.sh <dag_id> [execution_date]
# Example: ./run_dag.sh simple_data_pipeline

DAG_ID=${1:-simple_data_pipeline}
EXECUTION_DATE=${2:-$(date +%Y-%m-%d)}

echo "Running DAG: $DAG_ID"
echo "Execution date: $EXECUTION_DATE"
echo ""

# Test the DAG first
echo "Testing DAG..."
airflow dags test $DAG_ID $EXECUTION_DATE

if [ $? -eq 0 ]; then
    echo ""
    echo "DAG test successful!"
    echo ""
    echo "To trigger the DAG in the Airflow UI:"
    echo "1. Open http://localhost:8080"
    echo "2. Find the DAG '$DAG_ID' in the list"
    echo "3. Click the play button to trigger it"
    echo ""
    echo "Or trigger it via command line:"
    echo "airflow dags trigger $DAG_ID"
else
    echo ""
    echo "DAG test failed. Please check the errors above."
    exit 1
fi

