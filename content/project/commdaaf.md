+++
title = "CommDAAF"
date = 2026-03-13T00:00:00
draft = false

# Tags: can be used for filtering projects.
tags = ["Methodology", "Multi-Model", "Computational Communication", "Research"]

# Project summary to display on homepage.
summary = "Computational Multi-Model Data Analysis and Augmentation Framework - a methodology for epistemically diverse AI validation in social science research."

# Optional external URL for project (replaces project detail page).
external_link = ""

# Links (optional).
url_pdf = ""
url_code = ""
url_dataset = ""
url_slides = ""
url_video = ""
url_poster = ""

# Featured image
[image]
  caption = ""
  focal_point = "Smart"
+++

## What is CommDAAF?

**Computational Multi-Model Data Analysis and Augmentation Framework** (CommDAAF) is a methodology for conducting rigorous computational social science research using multiple AI models for triangulated validation.

## Core Principles

### 1. Epistemic Diversity
Different AI models have different training data, architectures, and "perspectives." By using multiple models (Claude, GLM, Kimi, etc.), we achieve methodological triangulation similar to traditional mixed-methods research.

### 2. Multi-Model Validation
- **Primary coding** with one model
- **Cross-validation** with adversarial models
- **Consensus analysis** to identify robust findings

### 3. Effect Size Reporting
Following Cohen (1988) benchmarks, CommDAAF emphasizes:
- Practical significance over p-values
- Cramér's V for categorical comparisons
- Cohen's d for continuous measures

## Application Areas

- **Framing Analysis** - Identifying how issues are framed in media/political discourse
- **Coordinated Behavior Detection** - Identifying inauthentic amplification
- **Content Analysis** - Systematic coding at scale
- **Sentiment Analysis** - Multi-model validated sentiment

## Key Studies

### Global South AI Framing Study
Compared AI policy framing in U.S. vs. South Africa, Brazil, and India. Found U.S. emphasizes sovereignty/competition (22%) while Global South emphasizes governance (42%). Overall κ = 0.91.

### Congressional AI Hearings
Analysis of 198 AI-related congressional hearings using 8-frame coding scheme with multi-model validation.

## Quality Controls

- **Mandatory distribution diagnostics** before regression
- **Frame-specific reliability reporting**
- **Bonferroni correction** for multiple comparisons
- **Causal language hedging** for observational data
