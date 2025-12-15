"""
Shell Workflow Example

This example demonstrates how to execute shell commands using Prefect's ShellOperation.
It shows basic usage including:
- Simple command execution
- Processing files with external tools
- Running multiple commands
- Using environment variables

Run with: python shell-workflow.py
"""

from prefect import flow
from prefect_shell import ShellOperation


@flow
def shell_workflow(filename: str = "data.txt"):
    """A workflow that executes shell commands using ShellOperation."""
    
    # Simple command execution
    echo_task = ShellOperation(
        commands=["echo 'Hello from Prefect!'"],
        stream_output=True
    )
    echo_result = echo_task()
    print(f"Echo output: {echo_result}")
    
    # Process file with external tool (e.g., count lines)
    # Note: This will fail if the file doesn't exist, but demonstrates the concept
    wc_task = ShellOperation(
        commands=[f"wc -l {filename}"],
        stream_output=True
    )
    wc_result = wc_task()
    line_count = int(wc_result.split()[0])
    print(f"File {filename} has {line_count} lines")
    
    # Run multiple commands in sequence
    system_info_task = ShellOperation(
        commands=[
            "date",
            "pwd",
            "ls -la"
        ],
        stream_output=True
    )
    system_info = system_info_task()
    print("System information:")
    print(system_info)
    
    # Execute command with environment variables
    env_task = ShellOperation(
        commands=["echo $MY_VAR"],
        env={"MY_VAR": "Prefect is awesome!"},
        stream_output=True
    )
    env_result = env_task()
    print(f"Environment variable: {env_result}")
    
    return {
        "echo_output": echo_result,
        "line_count": line_count,
        "system_info": system_info,
        "env_result": env_result
    }


if __name__ == "__main__":
    # Create a test file if it doesn't exist
    import os
    test_file = "data.txt"
    if not os.path.exists(test_file):
        with open(test_file, "w") as f:
            f.write("Line 1\nLine 2\nLine 3\nLine 4\nLine 5\n")
        print(f"Created test file: {test_file}")
    
    result = shell_workflow(test_file)
    print("\nWorkflow completed!")
    print(f"Results: {result}")

