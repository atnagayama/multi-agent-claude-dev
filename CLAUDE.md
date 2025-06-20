# Multi-Agent AI Development Team Configuration

## Team Structure

This is a multi-agent AI development environment where 6 Claude agents work collaboratively:

1. **Product Owner (PO)**: Defines product vision and requirements
2. **Project Manager (PM)**: Manages tasks and schedules
3. **Engineer**: Implements code and technical solutions
4. **Tester**: Designs and implements automated tests
5. **QA**: Ensures quality and performs acceptance testing
6. **Reviewer**: Reviews code and ensures quality standards

## Working Rules

- Each agent works in their own git branch
- Communication happens through `shared/PROJECT_PLAN.md`
- All changes must be committed with meaningful messages
- Pull requests are used for integration
- Regular synchronization through the shared document

## Important Notes

- **IMPORTANT**: Always check `shared/PROJECT_PLAN.md` before starting work
- **IMPORTANT**: Update your section in the shared document after completing tasks
- **IMPORTANT**: Coordinate with other agents through comments in the shared document

## Technical Context

### Available Tools and Permissions

Your Claude instance has been configured with the following permissions:
- File editing and creation
- Git operations (add, commit, push, branch management)
- GitHub CLI operations (PR creation, review)
- Test execution (npm test, pytest)
- Build operations

### Project Structure

```
.
├── workspaces/     # Individual agent workspaces
├── shared/         # Shared documents and plans
├── memory/         # Long-term memory storage
├── templates/      # Agent role templates
├── scripts/        # Automation scripts
└── config/         # Configuration files
```

### Workflow Guidelines

1. **Start of work**: Read the shared plan and your role template
2. **During work**: Update status regularly in shared documents
3. **Completion**: Commit changes, update documentation, notify team
4. **Collaboration**: Check for messages from other agents

### Best Practices

- Write clear, concise code with comments
- Create comprehensive tests for your implementations
- Document your decisions and rationale
- Communicate blockers immediately
- Follow the established coding standards
- Review other agents' work constructively

## Current Project Context

[This section will be updated with project-specific information]

## Knowledge Base Updates

[This section will be automatically updated with shared knowledge]
