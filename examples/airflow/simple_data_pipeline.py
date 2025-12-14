"""
A Simple Airflow DAG

This DAG demonstrates a basic ETL pipeline with three tasks:
1. Extract: Generate random data
2. Transform: Multiply each value by 2
3. Load: Print the transformed data

To use this DAG:
1. Copy this file to your Airflow dags folder (default: ~/airflow/dags/)
2. Ensure Airflow scheduler and webserver are running
3. The DAG will appear in the Airflow UI within a few minutes
4. Trigger the DAG manually or wait for the scheduled time
"""

from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python import PythonOperator
import random


def extract_data():
    """Extract data from a source."""
    data = [random.randint(1, 100) for _ in range(5)]
    print(f"Extracted data: {data}")
    return data


def transform_data(**context):
    """Transform the data."""
    # Get data from previous task using XCom
    data = context['ti'].xcom_pull(task_ids='extract')
    transformed = [x * 2 for x in data]
    print(f"Transformed data: {transformed}")
    return transformed


def load_data(**context):
    """Load the transformed data."""
    transformed = context['ti'].xcom_pull(task_ids='transform')
    print(f"Loaded data: {transformed}")
    print(f"Total items processed: {len(transformed)}")
    return len(transformed)


# Define default arguments
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Define the DAG
dag = DAG(
    'simple_data_pipeline',
    default_args=default_args,
    description='A simple ETL pipeline',
    schedule_interval=timedelta(days=1),  # Run daily
    start_date=datetime(2024, 1, 1),
    catchup=False,  # Don't backfill past runs
    tags=['example', 'etl', 'beginner'],
)

# Define tasks
extract_task = PythonOperator(
    task_id='extract',
    python_callable=extract_data,
    dag=dag,
)

transform_task = PythonOperator(
    task_id='transform',
    python_callable=transform_data,
    dag=dag,
)

load_task = PythonOperator(
    task_id='load',
    python_callable=load_data,
    dag=dag,
)

# Define task dependencies
# This creates: extract -> transform -> load
extract_task >> transform_task >> load_task

