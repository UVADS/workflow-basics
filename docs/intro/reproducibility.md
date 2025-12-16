---
layout: default
title: Reproducibility
parent: Introduction
nav_order: 70
---

# Reproducibility

Reproducibility ensures that workflows produce the same results when run with the same inputs, regardless of when or where they execute. This is critical for scientific computing, data analysis, and production pipelines where consistency and verifiability matter. Reproducible workflows require careful management of code versions, dependencies, execution environments, and data inputs.

## Declarative workflow definitions

Declarative workflow definitions describe **what** should be accomplished rather than **how** to accomplish it step-by-step. This approach is fundamental to reproducibility because:

- **Explicit dependencies**: Declarative definitions make task dependencies explicit and visible, allowing the orchestrator to determine execution order automatically. This eliminates hidden dependencies and execution order ambiguities.

- **Idempotent execution**: Idempotency means that reinvoking the same function with the same arguments will always lead to the same results, with no side effects. Orchestration tools can track execution state and skip tasks that have already completed successfully, but they have no control over the inner workings of tasks themselves. Idempotency is therefore a property of how tasks are designed and implemented, not something the orchestrator enforces. For example, a task that appends content to a file will keep appending on each run, creating unintended duplications unless the task itself checks for existing content. To achieve idempotent execution, tasks must be designed to handle re-execution gracefully—for instance, by checking if outputs already exist, using idempotent operations (e.g., overwriting instead of appending), or implementing proper state management within the task logic.

- **Version control**: Declarative definitions are typically code-based (e.g., Python scripts, YAML files, DSL files) that can be version-controlled, reviewed, and shared. Changes to workflow logic are tracked in version history.

- **Portability**: By separating the "what" (workflow definition) from the "how" (execution environment), declarative workflows can run on different systems (local, cloud, HPC) with the same results, as long as the execution environment is properly configured.

- **Transparency**: Declarative definitions serve as documentation, making it clear what the workflow does, what data it processes, and how tasks relate to each other. This transparency is essential for reproducibility and collaboration.

Most modern workflow orchestration tools (Prefect, Airflow, Nextflow, Snakemake, Targets) use declarative approaches where you define tasks, their dependencies, and data flow, while the orchestrator handles execution scheduling, resource management, and state tracking.

## Workflow packaging

Workflow packaging captures all necessary components into a distributable format, including code, dependencies, configuration, and metadata. This ensures that workflows can be shared, versioned, and executed consistently across different environments. Well-packaged workflows can be easily deployed, tested, and reproduced by others.

## Software containers

Software containers (Docker, Singularity/Apptainer) provide isolated execution environments that bundle code, dependencies, and system libraries together. Containers ensure that workflows run in the same environment regardless of the host system, eliminating "works on my machine" problems and enabling true reproducibility. Containerized workflows can be versioned, shared, and executed consistently across local machines, HPC clusters, and cloud platforms, making them essential for reproducible data science and computational research. Orchestration tools support containers to varying degrees and some platforms are limited in the type of container runtime (e.g. generally no Docker on HPC systems). So choose a workflow orchestrating tool and executor that align with your container strategy and primary target system (local, cloud, HPC).  