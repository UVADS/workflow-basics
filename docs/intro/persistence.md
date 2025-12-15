---
layout: default
title: Persistence
parent: Introduction
nav_order: 50
---

# Persistence

Caching and persistence help workflows avoid recomputing expensive steps, speed up retries, and enable resume-from-checkpoint behavior after failures. Good cache discipline pairs with resilience strategies to keep pipelines fast and reliable.

## Memory Caching

Memory caches keep data in-process or in-worker RAM. They are fast and ideal for small, frequently reused results (e.g., configuration, small lookup tables) within a single run. They are ephemeral and lost when the process restarts; many orchestration tools provide options to force purging of data from memory immediately after a task is completed which is helpful to manage large datasets.

## Storage Caching

Storage caches persist results across runs on disk, object storage, or distributed stores. They enable deterministic tasks to skip work when inputs and parameters have not changed (often via hashing) and support resume/retry after failures. Set clear invalidation rules (TTL, versioning, input-hash changes) to avoid serving stale data, and prefer immutable, content-addressable locations for reproducibility.

**Link to resilience:** Effective caching reduces recompute during retries and restarts. See the [Resilience]({{ "/docs/intro/resilience" | relative_url }}) section for how retries and restarts interact with cached results.

