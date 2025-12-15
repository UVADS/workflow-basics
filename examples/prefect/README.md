---
layout: default
title: Prefect Examples
parent: Examples
nav_order: 3
---

# Prefect Examples

This directory contains example Prefect workflows demonstrating various features and patterns.

## Files

- `numbers.py` - A basic workflow with sequential task execution
- `numbers-concurrent.py` - A workflow demonstrating concurrent task execution using `.submit()`
- `shell-workflow.py` - Basic shell command execution using ShellOperation
- `shell-advanced.py` - Advanced shell operations with error handling and custom working directories
- `numbers.ipynb` - Jupyter notebook version of the sequential workflow
- `numbers-concurrent.ipynb` - Jupyter notebook version of the concurrent workflow
- `requirements.txt` - Python dependencies for Prefect examples

## Setup

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. (Optional) Configure Prefect profile to use a remote server or Prefect Cloud:

   **Using Prefect Cloud:**
   ```bash
   # Sign up at https://app.prefect.cloud if you haven't already
   prefect cloud login
   prefect cloud workspace set --workspace <your-workspace-name>
   ```

   **Using a custom Prefect server instance:**
   ```bash
   # Create a new profile
   prefect profile create <profile-name>
   prefect profile use <profile-name>
   
   # Configure the API URL and key
   prefect config set PREFECT_API_URL=<your-api-url>
   prefect config set PREFECT_API_KEY=<your-api-key>
   ```

   Profiles are stored in `~/.prefect/profile.toml`. You can switch between profiles using:
   ```bash
   prefect profile use <profile-name>
   ```

   **Using local Prefect server (default):**
   ```bash
   prefect server start
   ```
   This will start a local Prefect server and open the UI at `http://localhost:4200`.

## Running the Examples

### Sequential Workflow

Run the basic sequential workflow:
```bash
python numbers.py
```

This example demonstrates:
- Basic task and flow decorators
- Sequential task execution
- Data passing between tasks
- Simple ETL pipeline pattern

### Concurrent Workflow

Run the concurrent workflow:
```bash
python numbers-concurrent.py
```

This example demonstrates:
- Concurrent task execution using `.submit()`
- Parallel execution of independent tasks
- Using Prefect futures for async task management
- Flow with `log_prints=True` for better observability

### Shell Command Execution

Run the basic shell workflow:
```bash
python shell-workflow.py
```

This example demonstrates:
- Executing shell commands using `ShellOperation`
- Processing files with external tools (e.g., `wc`)
- Running multiple commands in sequence
- Using environment variables in shell commands

Run the advanced shell workflow:
```bash
python shell-advanced.py
```

This example demonstrates:
- Custom working directories
- Error handling with `continue_on_error`
- Capturing both stdout and stderr with `return_all`
- Chaining multiple commands with proper error handling

## Understanding the Examples

### Sequential Execution (`numbers.py`)

Tasks execute in order based on their dependencies:
- `get_number()` tasks run sequentially
- `add()` waits for two numbers
- `multiply()` waits for the sum
- `mean()` calculates the mean of all numbers

### Concurrent Execution (`numbers-concurrent.py`)

Independent tasks can run in parallel:
- Multiple `get_number()` tasks can run simultaneously
- Tasks are submitted using `.submit()` which returns futures
- Prefect automatically manages task dependencies and parallelization

## Working with Jupyter Notebooks

If you prefer to work with notebooks:
1. Open `numbers.ipynb` or `numbers-concurrent.ipynb` in Jupyter
2. Install the kernel dependencies: `pip install -r requirements.txt`
3. Run the cells to execute the workflow

## Monitoring Workflows

### Local Prefect Server

Start the local server to monitor workflow execution:
```bash
prefect server start
```

The UI provides:
- Workflow run history
- Task execution logs
- Visual representation of task dependencies
- Performance metrics

### Prefect Cloud

For cloud-based monitoring:
1. Sign up at [app.prefect.cloud](https://app.prefect.cloud)
2. Authenticate: `prefect cloud login`
3. Set your workspace: `prefect cloud workspace set --workspace <your-workspace>`

## Additional Resources

For comprehensive documentation, tutorials, and additional resources, see the [Prefect documentation page]({{ "/docs/quickstart/prefect/" | relative_url }}).

