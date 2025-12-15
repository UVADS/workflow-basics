---
layout: default
title: Deployment
parent: Introduction
nav_order: 40
---

# Deployment

Deployment refers to where and how your workflows are executed. Different deployment options offer trade-offs between ease of development, scalability, resource availability, and operational complexity.

{: .note }
Note: Deployment strategies vary by orchestration tool, with some supporting multiple deployment options while others are optimized for specific environments.

## Local

Local deployment runs workflows on your own computer or development machine. This is ideal for development, testing, and small-scale workflows. Local execution is typically the simplest to set up and debug, but is limited by your machine's resources (CPU, memory, storage) and requires your computer to be running for workflows to execute.

## Remote 

Remote deployment runs workflows on external infrastructure such as cloud services, HPC clusters, or dedicated servers. This enables scalable execution with access to more compute resources, specialized hardware (GPUs, high-memory nodes), and the ability to run workflows continuously without keeping your local machine running. Remote deployment often requires configuration of authentication, network access, and resource allocation policies.

## Scheduling

Scheduling determines when workflows execute automatically. Workflows can be triggered on a time-based schedule (cron expressions, intervals), event-driven triggers (file arrival, API calls, database changes), or manual execution. Scheduled workflows enable automation of recurring data processing tasks, ensuring data pipelines run consistently without manual intervention.