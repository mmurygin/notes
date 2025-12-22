# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal knowledge base containing learning notes on various technical topics. The repository is organized as a hierarchical documentation structure with markdown files covering software engineering, infrastructure, and related subjects.

## Repository Structure

The repository follows a topic-based organization:

- **lang/** - Programming language notes (C++, Python, JavaScript, Go)
- **genai/** - Generative AI and prompting best practices
- **sre/** - Site Reliability Engineering (DevOps, monitoring, logging, incident management)
- **databases/** - Database concepts, SQL optimization, specific DBMS notes (PostgreSQL, MySQL, MongoDB)
- **highload/** - High-load system design (caching, distributed systems, message queues, scalability)
- **microservices/** - Microservices architecture, DDD, anti-patterns
- **networking/** - Network protocols, TCP, HTTP, DNS
- **computer-science/** - Algorithms, OS concepts, hashing, assembly
- **security/** - OWASP, vulnerabilities, security analysis
- **web/** - Web development, frontend/backend, nginx, MVC
- **tests/** - Testing best practices and common patterns
- **linux/** - Linux administration and configuration
- **soft-skills/** - Non-technical skills documentation
- **english/**, **dutch/** - Language learning resources

Each major topic typically has:
- A README.md file serving as the index for that topic
- Individual markdown files covering specific subtopics
- Occasional subdirectories for more complex topics (e.g., lang/cpp/, databases/mysql/)

## Common Operations

### Viewing Documentation

Since this is a documentation-only repository, the primary operations are reading and editing markdown files:

```bash
# View the main index
cat README.md

# Navigate to a specific topic
cat lang/cpp/README.md

# Search for specific content across all notes
grep -r "pattern" .
```

### Editing Notes

When adding or modifying content:
- Follow the existing markdown structure and formatting
- Update the relevant README.md index file when adding new topics
- Use relative links between documents (e.g., `[Monitoring](monitoring.md)`)
- Keep code examples properly formatted with language-specific syntax highlighting

### Git Workflow

This repository uses standard git operations:

```bash
# Check status
git status

# View changes
git diff

# Stage and commit
git add .
git commit -m "description"

# Push changes
git push origin master
```

The main branch is `master`.

## Documentation Patterns

### Topic Organization

- Each main topic directory contains a README.md that serves as the table of contents
- README files use bullet lists with links to individual topic files
- Example from lang/cpp/README.md:
  ```markdown
  ## C++

  - [Compilation](compilation.md)
  - [Dynamic memory](dynamic-memory.md)
  - [Pointers and references](pointers-references.md)
  ```

### Cross-Topic References

The root README.md serves as the main navigation hub with links to all major topics. When content spans multiple topics, reference related documents using relative paths.

### Content Style

- Documentation is concise and focused on technical accuracy
- Code examples are included inline when relevant
- Notes often reference external courses, books, or certifications (see learn.md)
- Some topics include diagrams stored in img/ subdirectories

## Key Files

- **README.md** - Main navigation index
- **learn.md** - Learning path tracking courses and books completed
- **.gitignore** - Excludes swap files (*.swp)
- **CNAME** - Domain configuration for potential GitHub Pages hosting
