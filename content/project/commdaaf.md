+++
title = "CommDAAF"
date = 2026-03-13T00:00:00
draft = false

tags = ["Methodology", "Multi-Model", "Computational Communication", "Research"]
summary = "Multi-model validation framework for computational social science. Use multiple AI models to triangulate your findings."

external_link = ""

[image]
  focal_point = "Smart"
+++

CommDAAF stands for **Computational Multi-Model Data Analysis and Augmentation Framework**. The name is a mouthful but the idea is simple: don't trust one AI model, use several.

## The problem

Most AI-assisted research uses one model. That's like having one coder for your content analysis. You'd never publish that. So why accept it with AI?

## The solution

Use multiple models with different training data and architectures. I typically run Claude, GLM (Chinese), and Kimi. If they all agree, you're probably onto something real. If they disagree, that's interesting too — tells you where the uncertainty is.

## What it looks like in practice

1. **Primary coding** with one model
2. **Cross-validation** with adversarial models  
3. **Consensus analysis** to find robust findings
4. **Report disagreements** — they matter

## Stuff I've learned the hard way

* Always check your distributions before running regressions
* Report effect sizes, not just p-values (Cohen's d, Cramér's V)
* Flag frame-specific reliability, not just overall kappa
* Never use OLS on engagement data — it's skewed, use negative binomial
* Bonferroni correct when you're testing multiple comparisons

## Studies using CommDAAF

* **Global South AI Framing** — US vs South Africa, Brazil, India. Found US frames AI as competition, Global South frames it as governance.
* **Congressional AI Hearings** — 198 hearings, 8-frame coding scheme.
* **Coordinated behavior detection** — multi-model validation of bot/astroturf activity.
