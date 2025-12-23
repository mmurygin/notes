# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal knowledge base containing learning notes on various technical topics. The repository is organized as a hierarchical documentation structure with markdown files covering software engineering, infrastructure, and related subjects.

The target audience for this repository is an expirienced software engineer.

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

### README.md Structure

README files serve as navigation indices and follow specific structural patterns depending on their location in the repository hierarchy.

#### Root README.md

The repository root README.md is the main entry point and follows this structure:

```markdown
# My learning notes

- [GenAI](genai)
- [SRE](sre)
- [Databases](databases)
```

**Characteristics:**
- Simple title: `# My learning notes`
- Flat bullet list of top-level topics
- Links point to **directories** (not README.md files)
- Link text uses title case with spaces (e.g., "GenAI", "Computer Science")
- No subdirectory nesting at this level
- Alphabetically or logically ordered

#### Topic README Files

Each topic directory contains a README.md that serves as a table of contents for that topic:

```markdown
# SRE

- [DevOps](devops.md)
- [Monitoring](monitoring.md)
- [Logging](logging.md)
- [Alerting](alerting.md)
```

**Characteristics:**
- Heading uses `#` (H1) with the topic name
- Some older READMEs may use `##` (H2) - both are acceptable
- Links point to **specific .md files** (explicit `.md` extension)
- Link text is descriptive and human-readable
- Topics listed in logical order (not necessarily alphabetical)
- May include subdirectories with nested structure

#### Nested Structure Pattern

When a topic has subdirectories, show the hierarchy using indentation:

```markdown
## Databases

- [Common](common.md)
- [Optimization](optimization.md)
- [MySQL](mysql)
    - [Common](mysql/common.md)
    - [QueryInfo Script](mysql/queryinfo.sql)
- [MongoDB](mongodb.md)
```

**Rules for nested items:**
- Parent item links to subdirectory (no `.md`)
- Child items use 4-space indentation
- Child items link to full relative path with file extension
- Can mix files and subdirectories at the same level

### Topic Organization

- Each main topic directory contains a README.md that serves as the table of contents
- README files use bullet lists with links to individual topic files
- When adding new content:
  1. Create the content file (e.g., `new-topic.md`)
  2. Add entry to the README.md with descriptive link text
  3. Place entry in logical order within the list
  4. Ensure link text is clear and matches file content

#### Link Formatting Rules

**Root README links to directories:**
```markdown
- [GenAI](genai)          ✓ Correct
- [GenAI](genai/)         ✗ Avoid trailing slash
- [GenAI](genai/README.md) ✗ Don't link to README explicitly
```

**Topic README links to files:**
```markdown
- [Monitoring](monitoring.md)     ✓ Correct
- [Monitoring](monitoring)         ✗ Missing extension
- [Monitoring](./monitoring.md)    ✗ Unnecessary ./
```

**Subdirectory links:**
```markdown
- [MySQL](mysql)                   ✓ Correct (directory)
    - [Common](mysql/common.md)    ✓ Correct (file in subdirectory)
```

### When to Update READMEs

**Always update the README when:**
- Adding a new topic file to a directory
- Removing a topic file from a directory
- Renaming a topic file
- Adding a new subdirectory with content

**README update checklist:**
1. Add new entry with descriptive link text
2. Place in logical order (consider grouping related topics)
3. Verify the link works (correct path and extension)
4. Ensure consistent formatting with existing entries
5. Check that link text accurately describes the content

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
