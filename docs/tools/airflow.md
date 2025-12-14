---
layout: default
title: Airflow
parent: Tools
nav_order: 1
---
# Airflow
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .no_toc .text-delta }
- TOC
{:toc}
</details>

## What is Airflow?

Apache Airflow is an open-source platform for programmatically authoring, scheduling, and monitoring workflows. It was originally created by Airbnb in 2014 and is now maintained by the Apache Software Foundation. Airflow uses directed acyclic graphs (DAGs) to define workflows as code, making them versionable, testable, and maintainable.

Airflow is particularly well-suited for:

- **Data Engineering**: Complex ETL/ELT pipelines, data processing workflows
- **Data Analytics**: Scheduled reporting, data quality checks, batch processing
- **ML Operations**: Model training pipelines, feature engineering workflows
- **DevOps**: Automated deployments, infrastructure management, system maintenance

Key features of Airflow include:

- **Python-based**: Workflows are defined as Python code (DAGs)
- **Rich UI**: Web-based interface for monitoring and managing workflows
- **Extensible**: Large ecosystem of operators and integrations
- **Scheduling**: Built-in scheduler with cron expressions and interval-based triggers
- **Scalable**: Can run on distributed systems with multiple workers
- **Task dependencies**: Clear definition of task relationships and execution order

## Setup

### Installation

Install Apache Airflow using pip:

```bash
pip install apache-airflow
```

Or install with specific providers:

```bash
pip install apache-airflow[postgres,slack]
```

For a minimal installation:

```bash
pip install apache-airflow==2.8.0 --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.8.0/constraints-3.10.txt"
```

### Initialization

Initialize the Airflow database:

```bash
airflow db init
```

Create an admin user:

```bash
airflow users create \
    --username admin \
    --firstname Admin \
    --lastname User \
    --role Admin \
    --email admin@example.com \
    --password admin
```

### Starting Airflow

Start the Airflow webserver:

```bash
airflow webserver --port 8080
```

In a separate terminal, start the scheduler:

```bash
airflow scheduler
```

Access the Airflow UI at `http://localhost:8080` (default username: `admin`, password: `admin`).

### Configuration

Airflow configuration is stored in `~/airflow/airflow.cfg`. Key settings include:

- `dags_folder`: Location of your DAG files (default: `~/airflow/dags`)
- `executor`: Execution backend (default: `SequentialExecutor` for local development)
- `sql_alchemy_conn`: Database connection string

For production, consider using `CeleryExecutor` or `KubernetesExecutor` for distributed execution.

**Once Airflow is installed and configured, you can:**
- Create your first DAG (see "Getting Started" section below)
- Explore the Airflow UI to monitor DAG runs
- Check out the example scripts in the examples folder

## Getting Started

### Understanding DAGs

In Airflow, workflows are defined as **DAGs** (Directed Acyclic Graphs). A DAG is a collection of tasks with dependencies that define the execution order.

**Key Concepts:**

- **DAG**: The workflow definition that contains tasks and their dependencies
- **Task**: An individual unit of work (e.g., running a Python function, executing a SQL query)
- **Operator**: A template for a task (e.g., `PythonOperator`, `BashOperator`, `PostgresOperator`)
- **Dependencies**: Relationships between tasks defined using `>>` (right shift) or `set_downstream()` / `set_upstream()`

Tasks are connected to form a DAG using dependency operators. For example, `task_a >> task_b` means task_b depends on task_a completing successfully.

### A simple Workflow

Here's a basic Airflow DAG that processes data:

```python
from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator

def extract_data():
    """Extract data from a source."""
    import random
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
    schedule_interval=timedelta(days=1),
    start_date=datetime(2024, 1, 1),
    catchup=False,
    tags=['example', 'etl'],
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
extract_task >> transform_task >> load_task
```

Save this file as `simple_data_pipeline.py` in your `~/airflow/dags/` directory. The DAG will appear in the Airflow UI within a few minutes.

**Key points:**
- Tasks are defined using operators (e.g., `PythonOperator`)
- Dependencies are set using `>>` operator: `extract_task >> transform_task >> load_task`
- Data is passed between tasks using XCom (Airflow's cross-communication mechanism)
- The DAG has scheduling information (`schedule_interval`, `start_date`)

## All Example Scripts

[/examples/airflow]

## Advanced Topics

### Operators

Airflow provides many built-in operators for common tasks:
- `PythonOperator`: Execute Python functions
- `BashOperator`: Execute bash commands
- `PostgresOperator`: Execute SQL queries on PostgreSQL
- `DockerOperator`: Run tasks in Docker containers
- `KubernetesPodOperator`: Run tasks in Kubernetes pods

### Task Dependencies

Tasks can have complex dependencies:
```python
# Sequential: task_a >> task_b >> task_c
# Parallel branches:
task_a >> [task_b, task_c] >> task_d
# Conditional dependencies using branching operators
```

### XComs

XComs (cross-communication) allow tasks to exchange data:
```python
# Push data
task_instance.xcom_push(key='my_key', value='my_value')
# Pull data
value = task_instance.xcom_pull(task_ids='task_id', key='my_key')
```

### Sensors

Sensors wait for external conditions before proceeding:
- `FileSensor`: Wait for a file to appear
- `HttpSensor`: Wait for an HTTP endpoint to be available
- `SqlSensor`: Wait for a SQL condition to be true

### Executors

Different executors for different scales:
- `SequentialExecutor`: Single process (development)
- `LocalExecutor`: Multiple processes on one machine
- `CeleryExecutor`: Distributed execution with Celery
- `KubernetesExecutor`: Kubernetes-native execution

## Additional Resources

### Official Documentation

- [Apache Airflow Documentation](https://airflow.apache.org/docs/) - Comprehensive guides, API reference, and tutorials
- [Airflow Blog](https://airflow.apache.org/blog/) - Updates, best practices, and case studies
- [Airflow GitHub Repository](https://github.com/apache/airflow) - Source code and issues

### Learning Resources

- [Airflow Tutorials](https://airflow.apache.org/docs/apache-airflow/stable/tutorial/index.html) - Official getting started guide
- [Airflow Examples](https://github.com/apache/airflow/tree/main/airflow/example_dags) - Official example DAGs
- [Airflow YouTube Channel](https://www.youtube.com/c/ApacheAirflow) - Video tutorials and webinars

### Community

- [Airflow Slack Community](https://apache-airflow-slack.herokuapp.com/) - Real-time community support
- [Airflow Discourse](https://discuss.apache.org/) - Community forum
- [Stack Overflow](https://stackoverflow.com/questions/tagged/airflow) - Q&A with Airflow tag

### Related Tools

- [Astro](https://www.astronomer.io/) - Managed Airflow platform
- [Google Cloud Composer](https://cloud.google.com/composer) - Managed Airflow on GCP
- [Amazon MWAA](https://aws.amazon.com/managed-workflows-for-apache-airflow/) - Managed Airflow on AWS
