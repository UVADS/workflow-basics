---
layout: default
title: Reproducibility
parent: Introduction
nav_order: 70
---

# Reproducibility

Reproducibility ensures that workflows produce the same results when run with the same inputs, regardless of when or where they execute. This is critical for scientific computing, data analysis, and production pipelines where consistency and verifiability matter. Reproducible workflows require careful management of code versions, dependencies, execution environments, and data inputs.

## Workflow packaging

Workflow packaging captures all necessary components into a distributable format, including code, dependencies, configuration, and metadata. This ensures that workflows can be shared, versioned, and executed consistently across different environments. Well-packaged workflows can be easily deployed, tested, and reproduced by others.

## Software containers

Software containers (Docker, Singularity/Apptainer) provide isolated execution environments that bundle code, dependencies, and system libraries together. Containers ensure that workflows run in the same environment regardless of the host system, eliminating "works on my machine" problems and enabling true reproducibility. Containerized workflows can be versioned, shared, and executed consistently across local machines, HPC clusters, and cloud platforms, making them essential for reproducible data science and computational research. Orchestration tools support containers to varying degrees and some platforms are limited in the type of container runtime (e.g. generally no Docker on HPC systems). So choose a workflow orchestrating tool and executor that align with your container strategy and primary target system (local, cloud, HPC).  