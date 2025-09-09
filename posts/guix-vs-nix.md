---
title: Why I'm switching my development workflow from Guix to Nix (Despite Prefering Guix's Design)
date: 2025-08-26
author: getstate
tags:
  - guix
  - nix
---

# Nix vs Guix

After years of using Guix System, I'm making the painful decision to switch my development workflow to Nix. I'm not celebrating Nix's superiority. This is just a blog post I felt the need to write, as I sincerely feel that better design doesn't always win when it can't sustain itself.

## What Guix Gets Right

Guix's technical design is genuinely superior in several key areas:

**Package definitions are clean and intuitive.** Writing packages in Scheme feels natural, you're working with a real programming language instead of fighting with a DSL that was extended to accomadate needs. The syntax is consistent, the package structure is logical, and you don't have to decode weird attribute set manipulations. A package definition is what it says on the label, a definition of how to build the package, which can be understood by someone who has no idea what language they are looking at, rather than a glued together attribute set that represents a definition.

**Build phases are elegant.** Guix lets you cleanly extend or replace build phases completely in guile. The gexp system allows you to stage code to be executed within the build time environment, which is a much cleaner separation and a practical use case for build expressions. This makes the definition easier to reason about, learn, and extend, rather than a data format with conventions that you need to learn about.

**Service management is conceptually superior.** Shepherd's service extension model makes dependencies and side effects explicit. You can query the actual dependency graph and see exactly which services extend shared configurations like PAM. When something breaks, you know exactly what touched what, instead of hunting through scattered config files.

**The bootstrapping is principled.** Guix actually cares about having a minimal, auditable bootstrap path instead of accepting binary seeds. This kind of engineering should matter more than it does.

**Much better UX.** Since Guix is newer than nix, the interface is a lot cleaner and well-thought out. Starting an FHS environment on guix happens through a command line flag, `guix shell --container`. This is a natural way of separating what you want to do, from the packages you want to be provided in the environment. You can use `makeFHSEnv` on nix, but this is defined as a nix derivation within whatever nix file/flake (which has it's own appeal).

**Documentation is actually helpful.** Nix has scattered documentation, Guix's manual explains concepts clearly.

## The Reality Check

But here's the problem: none of this matters if you can't safely use the internet or do basic development work.

**Chromium is 6+ months behind.** An old browser leaves your system open to known attacks, and is a sad sign of the project not getting enough contributors.

**Development tools are ancient.** ADB is from 2015, making Android development essentially impossible. OCaml is months behind. When basic development infrastructure is years out of date; the distribution becomes unusable for professional work.

**Critical packages are being deprecated.**  Resources are scarce, so packages that require a lot of work can sometimes be dropped if nobody uses them.

## Some things that make me sad

**Months without QA infrastructure.** Basic project infrastructure like continuous integration remains broken, making it harder for contributors to get patches reviewed and merged, driving away the very thing that the project needs.

**Rewriting working components.** There is a distributed effort that doesn't take into account the whole project.

**Ideological choices.** While Shepherd is nice, it being written in Guile means that there is an interpreter running at a core level, and bringing in a huge attack surface. Dogfooding lead to it getting a lot better, but FWIW this is worth noting.

I contributed several packages myself, but there's a huge gap between "I can package a library" and "I can maintain a browser engine." 

## Why Nix Wins Despite Being Worse

NixOS has significant technical disadvantages:

**Package definitions are less readable.** Using attribute sets to define packages is a weird abstraction. Mixing bash scripts into attribute sets feels like wrestling against the language.

**The syntax is genuinely awful.** The mix of functional programming concepts, lazy evaluation, curly braces, and inconsistent function calling conventions makes it unnecessarily harder. The semantics of `with` is another issue.

**Less elegant overall design.** Nix feels like it evolved organically.

But Nix has crucial practical advantages:

**Evaluation model.** Nix is faster for a variety of reasons, including the fact that the nix cli itself only evalutes nix expressions lazily, and that includes nixpkgs. The Guix cli includes all the modules and package definitions, which is why `guix pull` is slower as it needs to rebuild all the modules.

**System state management.** Nix tracks system-state instead of expecting you to read news entries to understand what changed, so packages that depend on internal state details don't get upgraded automatically!

**Ecosystem momentum.** Packages stay current because there's a sustainable maintenance model and big enough contributor base.

**Modern system features.** Systemd support, secure boot, and other useful stuff. Right now, there is no way to specify capabilities to a daemon in Shepherd.

**Home Manager.** Much bigger support for user environment configurations.

**Flakes.** Let's you mix multiple nixpkgs sources, etc.

## The Broader Problem

This situation reflects a common pattern in open source: projects that prioritize technical elegance over sustainability can sometimes fall behind on important things. Guix made brilliant design decisions but couldn't solve the social and economic problems of maintaining a modern software ecosystem.

The unfair part is systemic—there's no good funding model for the boring but critical work of package maintenance. Everyone wants browsers to work, but nobody wants to pay for keeping browser packages updated.

Meanwhile, maintainers get bored with unglamorous maintenance work and chase interesting side projects. The result is beautiful, theoretically superior software that can't perform basic computing tasks.

## The Reluctant Switch

I hate having to abandon a system that got so many things right for one that got them wrong. Every time I have to debug a weird Nix expression or fight with attribute set manipulations, I'll remember how much cleaner the equivalent would have been in Guix.

But I can't package the things I need my self, so I have to use nix regardless of how elegant Guix's design is. Sometimes "worse is better" wins not because it's actually better, but because it solves your problems.

## The Long Game

The real tragedy is that Guix's good ideas, explicit service extensions, clean package definitions, principled bootstrapping doesn't make it automatically better than nix. Meanwhile, Nix continues growing and evolving, gradually adopting some of Guix's better concepts and gaining richer ecosystem with alternative DSLs like Nickel.

For my immediate needs, Nix provides the practical foundation I need for development work, as such I will be starting most of my development projects on my guix system with nix. The syntax is still terrible, the package definitions still are awkward, but their is enough critical mass to sustain the package repo and stay current, and give access to newer packages.
