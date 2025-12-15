---
layout: default
title: Monitoring
parent: Introduction
nav_order: 30
---

# Monitoring

Effective monitoring is essential for understanding workflow behavior, diagnosing issues, and optimizing performance. Monitoring encompasses collecting standard logging output and tracking the state of each task throughout execution. Beyond basic logging, monitoring provides insights into execution patterns—revealing whether tasks run sequentially or concurrently, identifying bottlenecks, and helping you understand the actual execution flow versus the planned workflow structure.

## Logging

Logging captures the standard output, error messages, and diagnostic information from each task during execution. Effective logging provides a detailed audit trail of what happened during workflow execution, making it easier to debug failures, understand task behavior, and trace data transformations. Most orchestration tools capture logs at both the task level (individual task output) and workflow level (overall execution summary), often with timestamps and context about the execution environment.

## States

Task and workflow states represent the current status of execution at any given moment. Common states include pending (waiting to run), running (currently executing), completed (successfully finished), failed (encountered an error), and skipped (not executed due to conditions or dependencies). Monitoring state transitions helps you understand workflow progress, identify stuck or failed tasks quickly, and provides visibility into the overall health of your data pipelines. State information is typically displayed in dashboards and can be queried programmatically for automated alerting and reporting.

## Execution pattern

Execution pattern monitoring reveals how tasks actually run compared to how they were designed. This includes identifying whether tasks execute sequentially (one after another) or concurrently (in parallel), measuring execution times and resource usage, and detecting bottlenecks where tasks wait for resources or dependencies. Understanding execution patterns helps optimize workflows by identifying opportunities for parallelization, revealing inefficient task ordering, and highlighting resource constraints that may be limiting performance.