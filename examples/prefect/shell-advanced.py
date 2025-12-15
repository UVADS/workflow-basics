"""
Advanced Shell Workflow Example

This example demonstrates advanced shell operations with Prefect's ShellOperation,
including:
- Custom working directories
- Error handling
- Chaining multiple commands
- Capturing both stdout and stderr

Note: This example uses placeholder paths. Modify the working_dir and commands
to match your environment.

Run with: python shell-advanced.py
"""

from prefect import flow
from prefect_shell import ShellOperation
import os


@flow
def advanced_shell_workflow():
    """Advanced shell operations with custom working directory."""
    
    # Get current directory as a safe working directory
    current_dir = os.getcwd()
    
    # Run command in specific directory
    # Example: List files in current directory
    build_task = ShellOperation(
        commands=["ls -la"],
        working_dir=current_dir,
        stream_output=True,
        return_all=True  # Return both stdout and stderr
    )
    build_result = build_task()
    print("Directory listing:")
    print(build_result)
    
    # Chain multiple commands with error handling
    # Example: Run a series of informational commands
    pipeline_task = ShellOperation(
        commands=[
            "echo 'Step 1: Getting system info'",
            "uname -a",
            "echo 'Step 2: Checking Python version'",
            "python --version",
            "echo 'Step 3: Listing current directory'",
            "ls -1"
        ],
        stream_output=True,
        continue_on_error=False  # Stop on first error
    )
    pipeline_result = pipeline_task()
    print("\nPipeline output:")
    print(pipeline_result)
    
    # Example with error handling (this will succeed even if some commands fail)
    error_handling_task = ShellOperation(
        commands=[
            "echo 'This will succeed'",
            "nonexistent_command_12345",  # This will fail
            "echo 'This will not run if continue_on_error=False'"
        ],
        stream_output=True,
        continue_on_error=True  # Continue even if commands fail
    )
    try:
        error_result = error_handling_task()
        print("\nError handling example (with continue_on_error=True):")
        print(error_result)
    except Exception as e:
        print(f"\nError occurred: {e}")
    
    return {
        "build": build_result,
        "pipeline": pipeline_result
    }


if __name__ == "__main__":
    result = advanced_shell_workflow()
    print("\nAdvanced workflow completed!")
    print(f"Results keys: {list(result.keys())}")

