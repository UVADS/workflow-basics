---
layout: default
title: Dagster
parent: Tools
nav_order: 5
---

# Dagster
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .no_toc .text-delta }
- TOC
{:toc}
</details>

## What is Dagster?

Dagster is a modern data orchestration platform designed for building, deploying, and maintaining data applications. It was created by Elementl (now Dagster Labs) and provides a Python-native approach to data engineering with a focus on development productivity, observability, and data quality.

Dagster is particularly well-suited for:

- **Data Engineering**: ETL/ELT pipelines, data transformation workflows
- **Data Platforms**: Building internal data platforms and data products
- **ML Operations**: Model training pipelines, feature stores, ML workflows
- **Analytics Engineering**: dbt integration, analytics workflows

Key features of Dagster include:

- **Python-native**: Workflows are defined as Python code using assets and ops
- **Asset-centric**: Data assets are first-class citizens, enabling data lineage and dependency tracking
- **Type system**: Built-in type checking and validation for data quality
- **Observability**: Rich UI for monitoring assets, runs, and data lineage
- **Development experience**: Local development, testing, and debugging tools
- **Integration**: Strong integration with popular data tools (dbt, Spark, Pandas, etc.)