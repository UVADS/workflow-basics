# Airflow Examples

This directory contains example Airflow DAGs and helper scripts.

## Files

- `simple_data_pipeline.py` - A basic ETL pipeline DAG demonstrating task dependencies and XCom
- `run_dag.sh` - Script to test and run DAGs manually
- `requirements.txt` - Python dependencies for Airflow

## Setup

1. Install Airflow:
   ```bash
   pip install -r requirements.txt
   ```

2. Initialize Airflow database:
   ```bash
   airflow db init
   ```

3. Create an admin user:
   ```bash
   airflow users create \
       --username admin \
       --firstname Admin \
       --lastname User \
       --role Admin \
       --email admin@example.com \
       --password admin
   ```

4. Copy the DAG file to your Airflow dags folder:
   ```bash
   cp simple_data_pipeline.py ~/airflow/dags/
   ```

5. Start Airflow:
   ```bash
   # Terminal 1: Start webserver
   airflow webserver --port 8080
   
   # Terminal 2: Start scheduler
   airflow scheduler
   ```

6. Access the UI at http://localhost:8080 (username: `admin`, password: `admin`)

## Running the Example

1. The DAG will appear in the Airflow UI within a few minutes
2. Toggle it ON to enable scheduling
3. Click the play button to trigger a manual run
4. Monitor the execution in the UI

## Testing the DAG

Test the DAG without running it:
```bash
airflow dags test simple_data_pipeline 2024-01-01
```

Or use the provided script:
```bash
chmod +x run_dag.sh
./run_dag.sh simple_data_pipeline
```

## Additional Resources

- [Airflow Documentation](https://airflow.apache.org/docs/)
- [Airflow Tutorial](https://airflow.apache.org/docs/apache-airflow/stable/tutorial/index.html)

