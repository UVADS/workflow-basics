---
layout: default
title: Home
nav_order: 1
description: "Workflow Basics"
permalink: /
last_modified_date: "2025-12-14 09:13AM"
---

# Workflow Basics
{: .fs-9 }

Source Control Basics: How to set up, configure, and work with `git` and GitHub.
{: .fs-6 .fw-300 }

[Setting Up](docs/setup/){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }
[Basic Commands](docs/basics/){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }
[Advanced](docs/advanced/){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }
[Actions](docs/github-actions/){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }
[Examples](/examples/){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }

---

<img src="https://uvads.github.io/workflow-basics/assets/images/git6963.jpg" style="float:right;max-width:40%;" />



## What's a Workflow?

We distinguish
- Workflows around your Office Productivity tools (not covered here)
- Workflows for DevOps (CI/CD)
- Workflows for Data Engineering and Data Analytics

## Setup

The General Setup section describes the steps to clone this repository, including all examples to your local computer. In addition, each Workflow orchestration tool has its own sets of software dependencies. You can find specific setup instruction under each Workflow chapter.

## Examples

The examples folder provides short scripts to get you started. They are organized in subfolders corresponding to the specific workflow orchestration tools. 

## Contents

- [**Overview**](/docs/overview.md)
    - Which tool is the right one for me?
    - Orchestration
    - Deployment
    - Logging & Observability
    - Exception Handling & Resilience
- [**General Setup**](/docs/setup.md)
- [**Generalists**](/docs/generalists)
    - [Airflow](/docs/generalists/airflow)
    - [NextFlow](/docs/generalists/nextflow)
    - [Snakemake](/docs/generalists/snakemake)
- [**Workflows in R**](/docs/R)
    - [Targets](/docs/R/targets)
- [**Workflows in Python**](/docs/python)
    - [Prefect](/docs/python/prefect)
    - [Dagster](/docs/python/dagster)
- [**Examples**](/examples)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

Distributed under the MIT License.