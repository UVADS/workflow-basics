---
layout: default
title: Prefect
parent: Tools
nav_order: 4
---
# Prefect
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .no_toc .text-delta }
- TOC
{:toc}
</details>

## What is Prefect?

Prefect is a modern workflow orchestration platform designed for building, running, and monitoring data workflows. It was created by [Prefect Technologies, Inc.](https://www.prefect.io/) and provides a Python-native approach to workflow automation with a focus on developer experience, observability, and reliability.

Prefect is open-source software, with the core Prefect engine available under the Apache 2.0 license. Prefect also offers Prefect Cloud, a managed service for workflow orchestration, and Prefect Server, a self-hosted option for organizations that need more control.

It is particularly well-suited for:

- **Data Engineering**: ETL/ELT pipelines, data processing workflows

- **Data Analytics**: Automated reporting, data quality checks

- **ML Operations**: Model training pipelines, feature engineering

- **DevOps**: Automated deployments, infrastructure management

Key features of Prefect include:

- **Python-native**: Workflows are defined as Python code using decorators and functions

- **Dynamic workflows**: Support for conditional logic, loops, and dynamic task generation

- **Observability**: Built-in dashboard for monitoring workflow runs, logs, and metrics

- **Flexible execution**: Run workflows locally, on Prefect Cloud, or self-hosted Prefect Server

- **Error handling**: Automatic retries, failure notifications, and state management

- **Scheduling**: Built-in scheduling with cron expressions or interval-based triggers


## Setup

### Installation

Install Prefect using pip:

```bash
pip install prefect
```

Or using conda:

```bash
conda install -c conda-forge prefect
```

Verify that Prefect is installed correctly:

```bash
prefect version
```

### Prefect Server

You have three options to observe Prefect workflow execution:

1. Local Prefect Server
2. SDS Prefect Server
3. Prefect Cloud Server

**Local Prefect Server**

You can start a local Prefect's UI server on your own computer to monitor workflows on your own computer. This is useful for local development.

```bash
prefect server start
```

This will start a local Prefect server and open the UI at `http://localhost:4200`.

**Using SDS Prefect Server**

SDS is running a Prefect server instance at: https://sds-prefect.pods.uvarc.io/dashboard. This server can be used for monitoring workflows running on your own computer or UVA's shared computing resources like the Afton/Rivanna HPC systems, or the SDS Kubernetes environment. You need to set up a new profile with these commands: 

```bash
prefect profile create uvasds
prefect profile use uvasds
prefect config set PREFECT_API_URL=<REACH_OUT_TO_N.MAGEE>
prefect config set PREFECT_API_KEY=<REACH_OUT_TO_N.MAGEE>
```

Your profile is added to `~/.prefect/profile.toml`. You can have many profiles and switch between the using the `prefect profile use <NAME>` command.
 

**Using Prefect Cloud**

If you prefer to use Prefect Cloud (the managed service), you'll need to:

1. Sign up for a free account at [app.prefect.cloud](https://app.prefect.cloud)
2. Authenticate your local environment:

```bash
prefect cloud login
```

3. Create a workspace in Prefect Cloud
4. Set your workspace:

```bash
prefect cloud workspace set --workspace <your-workspace-name>
```

**Once Prefect is installed and configured, you can:**
- Create your first workflow (see "A simple Workflow" section below)
- Explore the Prefect UI to monitor workflow runs
- Check out the example scripts in the examples folder

## Getting Started

### Of Tasks and Flows

Prefect workflows are built from two fundamental building blocks: **tasks** and **flows**.

**Tasks** are the individual units of work in a Prefect workflow. They represent discrete operations that perform a specific function, such as extracting data, transforming it, or loading it into a database. Tasks are created by applying the `@task` decorator to a Python function. When you call a task function within a flow, Prefect tracks its execution, manages its state, and provides observability features like logging and retries.

**Flows** are the containers that orchestrate tasks and define the workflow's structure. A flow is created by applying the `@flow` decorator to a Python function. Flows coordinate task execution, manage dependencies between tasks, and provide the overall workflow context.

Tasks and flows are chained together through function calls. When you call a task function inside a flow function, Prefect automatically creates a dependency relationship. The output of one task becomes the input to the next, creating a directed acyclic graph (DAG) of task dependencies. Prefect uses these dependencies to determine execution order: tasks that don't depend on each other can run concurrently, while dependent tasks execute sequentially.

For example, if task B requires the output of task A, Prefect ensures task A completes before task B begins. This dependency chaining happens naturally through Python function calls—no special syntax is needed beyond the `@task` and `@flow` decorators.

### A simple Workflow

Here's a basic Prefect workflow that processes data:

```python
import random
import numpy as np
from time import sleep

from prefect import task, flow

# Define a set of functions as tasks
# Adding the @task decorator is all it takes.
@task
def get_number(min=1, max=100) -> int:
    """Return a random number n, with min<=n<max"""
    sleep(1)  # simulate longer processing
    return random.randint(min, max)

@task
def add(n1: int, n2: int) -> int:
    """Return sum of two numbers"""
    sleep(1.5)  # simulate longer processing
    return n1 + n2

@task
def multiply(n1: int, n2: int) -> int:
    """Return product of two numbers"""
    sleep(1)  # simulate longer processing
    return  n1 * n2

@task
def mean(*args: int) -> float:
    """Return the mean of provided numbers"""
    sleep(3)  # simulate longer processing
    return np.mean(args)

# Define a function as flow that encapsulates a set of tasks
@flow
def analysis():
    """Return results of some arbitrary calculations"""
    n1 = get_number()
    n2 = get_number()
    temp_sum = add(n1, n2)
    n3 = get_number()
    r = multiply(n3, temp_sum)
    m = mean(n1, n2, n3)
    return r, m

if __name__ == "__main__":
    r, m = analysis()
    print(f"arbitrary calc: r={r}, mean={m}")
```

Run this with: `python examples/prefect/numbers.py`, or check out the notebook `python examples/prefect/numbers.ipynb`. The output should look similar to this:

```code
16:08:59.356 | INFO    | Flow run 'crouching-kittiwake' - Beginning flow run 'crouching-kittiwake' for flow 'analysis'
16:08:59.366 | INFO    | Flow run 'crouching-kittiwake' - View at https://sds-prefect.pods.uvarc.io/runs/flow-run/96b5b5d8-0d90-4390-80b2-e948d85d9cdd
16:09:00.449 | INFO    | Task run 'get_number-3a9' - Finished in state Completed()
16:09:01.482 | INFO    | Task run 'get_number-077' - Finished in state Completed()
16:09:03.015 | INFO    | Task run 'add-fe8' - Finished in state Completed()
16:09:04.054 | INFO    | Task run 'get_number-496' - Finished in state Completed()
16:09:05.088 | INFO    | Task run 'multiply-dc3' - Finished in state Completed()
16:09:08.129 | INFO    | Task run 'mean-2b8' - Finished in state Completed()
16:09:08.169 | INFO    | Flow run 'crouching-kittiwake' - Finished in state Completed()
arbitrary calc: r=4320, mean=47.0
```

### Visualizing the task graph and execution

When you execute functions decorated with `@task`/`@flow` the execution will be monitored by a Prefect Server instance. The specific instance is based on the active profile set in your `~/.prefect/profiles.toml` file.

You will see a URL pointing to the Prefect Server instance in the standard output, e.g. something like .

![View of sequential flow execution in Prefect Server instance]({{ "/assets/images/prefect/prefect-numbers.png" | relative_url }})

{: .note :}
Notice how the the tasks are executed sequentially based on the order of invocation in the encapsulating flow function.

### Concurrent Task Execution

We can convert the above script for concurrent task execution by using `submit()` when invoking out task functions (technically, our task functions has been wrapped into callable objects with a submit method, but that's syntactic sugar).

**So let's add these changes:**
- Rename our flow as "concurrent analysis",
- redirect all print statements to be collected as Prefect logs,
- and `submit` each function for concurrent execution.

```python

@flow(name="concurrent analysis", log_prints=True)
def analysis():
    """Return results of some arbitrary calculations"""
    n1 = get_number.submit()
    n2 = get_number.submit()
    temp_sum = add.submit(n1, n2)
    n3 = get_number.submit()
    r = multiply.submit(n3, temp_sum)
    m = mean.submit(n1, n2, n3)
    return r, m
```

You can find the updated code in  `python examples/prefect/numbers-concurrent.py`, or the corresponding notebook `python examples/prefect/numbers-concurrent.ipynb`

After running the script/notebook, check the task graph and execution timing in the Prefect Server instance.

![View of sequential flow execution in Prefect Server instance]({{ "/assets/images/prefect/prefect-numbers-concurrent.png" | relative_url }})

{: .note :}
Notice how Prefect orchestrated the concurrent execution for tasks that have no dependency on each other: i.e. temporal overlap of the get_number functions, and the overlap of the mean function with the add and multiply functions.

Prefect provides several integrations that control how task concurrency is controlled, see [Advanced Topics > Task Runners](#taskrunners) 

### Timeouts

Add timeouts to prevent tasks from running indefinitely:

```python
from prefect import flow, task
from prefect.tasks import task_input_hash
import time

@task(timeout_seconds=5)
def extract_data():
    """Extract data from a source."""
    time.sleep(2)  # Simulate work
    return [1, 2, 3, 4, 5]

@task(timeout_seconds=10)
def transform_data(data):
    """Transform the data."""
    time.sleep(1)  # Simulate work
    return [x * 2 for x in data]

@task(timeout_seconds=5)
def load_data(transformed_data):
    """Load the transformed data."""
    time.sleep(1)  # Simulate work
    print(f"Loaded data: {transformed_data}")
    return len(transformed_data)

@flow
def data_pipeline():
    """A pipeline with timeout protection."""
    data = extract_data()
    transformed = transform_data(data)
    result = load_data(transformed)
    return result

if __name__ == "__main__":
    result = data_pipeline()## Restart Failed Tasks
```

Configure automatic retries for failed tasks:

```python
from prefect import flow, task
import random

@task(retries=3, retry_delay_seconds=2)
def extract_data():
    """Extract data with potential failures."""
    if random.random() < 0.3:  # 30% chance of failure
        raise Exception("Extraction failed!")
    return [1, 2, 3, 4, 5]

@task(retries=2, retry_delay_seconds=1)
def transform_data(data):
    """Transform the data."""
    return [x * 2 for x in data]

@task(retries=2)
def load_data(transformed_data):
    """Load the transformed data."""
    print(f"Loaded data: {transformed_data}")
    return len(transformed_data)

@flow
def data_pipeline():
    """A resilient pipeline with retry logic."""
    data = extract_data()
    transformed = transform_data(data)
    result = load_data(transformed)
    return result

if __name__ == "__main__":
    result = data_pipeline()
```    

### Cache workflow outputs

Cache task results to avoid recomputing expensive operations:

```python
from prefect import flow, task
from prefect.tasks import task_input_hash
import time

@task(cache_key_fn=task_input_hash, cache_expiration_seconds=3600)
def extract_data(source: str):
    """Extract data - results are cached based on input."""
    print(f"Extracting from {source}...")
    time.sleep(2)  # Simulate expensive operation
    return [1, 2, 3, 4, 5]

@task(cache_key_fn=task_input_hash)
def transform_data(data, multiplier: int):
    """Transform data - cached based on data and multiplier."""
    print(f"Transforming with multiplier {multiplier}...")
    time.sleep(1)
    return [x * multiplier for x in data]

@task
def load_data(transformed_data):
    """Load the transformed data."""
    print(f"Loaded data: {transformed_data}")
    return len(transformed_data)

@flow
def data_pipeline(source: str = "database", multiplier: int = 2):
    """A pipeline with cached intermediate results."""
    data = extract_data(source)
    transformed = transform_data(data, multiplier)
    result = load_data(transformed)
    return result

if __name__ == "__main__":
    # First run - tasks execute
    result1 = data_pipeline("database", 2)
    
    # Second run with same inputs - uses cached results
    result2 = data_pipeline("database", 2)
    
    # Different inputs - tasks execute again
    result3 = data_pipeline("database", 3)
```

### Event Driven Computing

Execute code based on task or workflow state changes:

```python
from prefect import flow, task
from prefect.events import emit_event
import random

@task
def extract_data():
    """Extract data and emit an event."""
    data = [1, 2, 3, 4, 5]
    emit_event(
        event="data.extracted",
        resource={"prefect.resource.id": "extract-task"},
        payload={"count": len(data)}
    )
    return data

@task
def transform_data(data):
    """Transform data and emit events."""
    transformed = [x * 2 for x in data]
    
    # Emit event on success
    emit_event(
        event="data.transformed",
        resource={"prefect.resource.id": "transform-task"},
        payload={"count": len(transformed)}
    )
    return transformed

@task
def load_data(transformed_data):
    """Load data and emit completion event."""
    print(f"Loaded data: {transformed_data}")
    
    emit_event(
        event="data.loaded",
        resource={"prefect.resource.id": "load-task"},
        payload={"count": len(transformed_data)}
    )
    return len(transformed_data)

@flow
def data_pipeline():
    """A pipeline with event-driven capabilities."""
    try:
        data = extract_data()
        transformed = transform_data(data)
        result = load_data(transformed)
        
        # Emit workflow completion event
        emit_event(
            event="pipeline.completed",
            resource={"prefect.resource.id": "data-pipeline"},
            payload={"items_processed": result}
        )
        return result
    except Exception as e:
        # Emit failure event
        emit_event(
            event="pipeline.failed",
            resource={"prefect.resource.id": "data-pipeline"},
            payload={"error": str(e)}
        )
        raise

if __name__ == "__main__":
    result = data_pipeline()
    print(f"Pipeline completed. Processed {result} items.")
```
    
**Note**: Events can trigger automations in Prefect Cloud or be consumed by external systems for monitoring, alerting, or triggering downstream workflows.

### All Example Scripts

You can find the example scripts and notebooks in the [examples folder](/examples/python/prefect) in the Git repository.

## Advanced Topics

### TaskRunners

By default Prefect uses a thread pool to execute tasks and flows. Alternatively, you may choose a process pool which can be advantageous in particular with older Python versions which employ the global interpreter lock on cpu bound tasks. 

In addition, Prefect offers integrations with dask and ray for distributed task execution beyond single nodes. See the [Prefect TaskRunner documentation](https://docs.prefect.io/v3/concepts/task-runners) for details.


### Work pools deployments

Workflow tasks often have different compute requirements—some need high-memory resources, others require GPU acceleration, and some can run on minimal resources. Using a single compute configuration for all tasks can be inefficient, leading to wasted resources or insufficient capacity for demanding tasks.

Prefect's deployment system addresses this by allowing you to configure work pools that match your specific infrastructure needs. You can deploy workflows across a wide variety of execution environments, including:

- **Container platforms**: Docker, Kubernetes, ECS, and other containerized environments
- **Cloud services**: AWS, Azure, GCP compute resources
- **HPC systems**: High-performance computing clusters for intensive workloads
- **Prefect-managed infrastructure**: Prefect Cloud's managed execution options

This flexibility enables you to optimize resource usage (and cost) by matching each task to the most appropriate compute environment.

### Automations

https://docs.prefect.io/v3/how-to-guides/automations/creating-automations

## Useful integrations

Prefect offers a wide range of integrations through `prefect-*` packages that extend functionality for cloud services, data processing, parallelization, and more. Install these packages separately as needed.

**Cloud Providers**

- **`prefect-aws`** - Integration with Amazon Web Services (S3, ECS, Lambda, etc.)
- **`prefect-azure`** - Integration with Microsoft Azure (Blob Storage, Container Instances, etc.)
- **`prefect-gcp`** - Integration with Google Cloud Platform (GCS, BigQuery, Cloud Run, etc.)
- **`prefect-docker`** - Docker container execution and management

**Parallelization & Distributed Computing**

- **`prefect-dask`** - Distributed computing with Dask for parallel task execution
- **`prefect-ray`** - Distributed execution using Ray for scalable parallel processing

**Data Storage & Databases**

- **`prefect-sqlalchemy`** - Database connectivity using SQLAlchemy
- **`prefect-snowflake`** - Snowflake data warehouse integration
- **`prefect-bigquery`** - Google BigQuery integration
- **`prefect-postgres`** - PostgreSQL database integration
- **`prefect-redis`** - Redis database integration

**Other Common Integrations**

- **`prefect-github`** - GitHub API integration for repository and workflow management
- **`prefect-slack`** - Slack notifications and messaging
- **`prefect-databricks`** - Databricks platform integration
- **`prefect-kubernetes`** - Kubernetes job execution and management

**Installation:**

Install integrations using pip:

```bash
pip install prefect-aws
```

Or install multiple at once:
```bash
pip install prefect-aws prefect-dask prefect-sqlalchemy
```

**Full List of Integrations:**

You can find a complete list of all available Prefect integrations in the [Official Prefect Integrations Catalog](https://docs.prefect.io/integrations/integrations/).

## Additional Resources

### Official Documentation

- [Prefect Documentation](https://docs.prefect.io/) - Comprehensive guides, API reference, and tutorials
- [Prefect Blog](https://www.prefect.io/blog) - Articles, best practices, and case studies
- [Prefect Discourse](https://discourse.prefect.io/) - Community forum for questions and discussions

### Learning Resources

- [Prefect Tutorials](https://docs.prefect.io/tutorials/) - Step-by-step tutorials for common use cases
- [Prefect Examples](https://github.com/PrefectHQ/prefect/tree/main/examples) - Official example workflows and patterns
- [Prefect YouTube Channel](https://www.youtube.com/c/PrefectIO) - Video tutorials and webinars

### Community

- [Prefect GitHub Repository](https://github.com/PrefectHQ/prefect) - Source code, issues, and contributions
- [Prefect Slack Community](https://www.prefect.io/slack) - Real-time community support

### Related Tools

- [Prefect Cloud](https://www.prefect.io/cloud) - Managed workflow orchestration service
- [Prefect Server](https://docs.prefect.io/latest/guides/deployment/server/) - Self-hosted Prefect server option
- [Prefect Agents](https://docs.prefect.io/latest/concepts/work-pools/) - Execution infrastructure for workflows