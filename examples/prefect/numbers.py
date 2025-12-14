"""
A Simple Workflow with Prefect

This script demonstrates a basic Prefect workflow with sequential task execution.
Tasks are executed in order based on their dependencies.
"""

import random
import numpy as np
from time import sleep

from prefect import task, flow
from prefect import get_run_logger


# Define a set of functions as tasks
# Adding the @task decorator is all it takes.

@task
def get_number(min=1, max=100) -> int:
    """Return a random number n, with min<=n<max"""
    sleep(1)  # simulate longer processing
    n = random.randint(min, max)
    print(f"random number: {n}")
    return n


@task
def add(n1: int, n2: int) -> int:
    """Return sum of two numbers"""
    sleep(1.5)  # simulate longer processing
    s = n1 + n2
    print(f"sum: {s}")
    return s


@task
def multiply(n1: int, n2: int) -> int:
    """Return product of two numbers"""
    sleep(1)  # simulate longer processing
    p = n1 * n2
    print(f"product: {p}")
    return p


@task
def mean(*args: int) -> float:
    """Return the mean of provided numbers"""
    sleep(3)  # simulate longer processing
    m = np.mean(args)
    print(f"mean: {m}")
    return m


# Define the data pipeline as a flow
# Adding the @flow decorator does the trick.

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


# Run the data pipeline
# Local execution is triggered by invoking the function with the @flow decorator.
# In the output you will see the logs of the Prefect execution engine, including
# a URL to the Prefect Server that observes flow and provides visualization of
# all task dependencies, execution states and logs.

if __name__ == "__main__":
    r, m = analysis()
    print(f"arbitrary calc: r={r}, mean={m}")

