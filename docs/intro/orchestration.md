---
layout: default
title: Orchestration
parent: Introduction
nav_order: 20
---

# Orchestration

## Organization of Tasks into Workflows

**Tasks** are the individual units of work often implemented as programmable function, or method of an class object. They represent discrete operations, such as extracting data, transforming it, or loading it into a database.

**Workflows** combine tasks into pipelines. The output of one task becomes the input to the next, creating a directed acyclic graph (DAG) of task dependencies. Most orchestrators allow the composition of nested workflows, providing even more flexibility to build complex processing pipelines from reusable smaller building blocks. 

![Organizing Tasks (Programmable Functions) into workflows with defined dependencies]({{ "/assets/images/intro/orchestration.png" | relative_url }})

## Orchestration, Execution, Scheduling

The **orchestrator** defines workflow structure and task dependencies, the **execution engine** runs tasks on available compute resources, and the **resource scheduler** manages and allocates compute resources (CPU, GPU, memory, storage) to meet workflow demands.

![Layered responsibilities of orchestrators, execution engines, and resource schedulers]({{ "/assets/images/intro/orch-exec-sch.png" | relative_url }})

