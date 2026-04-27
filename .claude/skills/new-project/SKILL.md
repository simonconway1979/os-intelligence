# /new-project - Create New Project from Template

**Usage:** `/new-project [project-name]`

**Purpose:** Initialize a new project with a clean slate by copying the project template structure.

---

## What This Skill Does

Creates a new project folder in `projects/` with the specified name and copies all contents from `setup/project-template/` to give you a fresh starting point.

**Example:**
```
/new-project customer-portal
```

This creates `projects/customer-portal/` with the full project structure ready to go.

---

## Instructions for Claude

When the user runs `/new-project [project-name]`:

### 1. Validate the Project Name
- Check that a project name was provided
- If missing, ask: "What should we name the new project?"
- Validate the name is filesystem-safe (no special characters, spaces, etc.)
- Suggest using kebab-case if the name has issues

### 2. Check for Conflicts
- Check if `projects/[project-name]/` already exists
- If it exists, ask: "A project named '[project-name]' already exists. Do you want to overwrite it? (yes/no)"
- If the user says no, stop and ask for a different name
- If yes, proceed (the cp command will overwrite)

### 3. Create the New Project
Run this bash command to copy the template:
```bash
cp -r "/Users/simon/Desktop/Claude Code/setup/project-template" "/Users/simon/Desktop/Claude Code/projects/[project-name]"
```

Replace `[project-name]` with the actual project name provided.

### 4. Confirm Success
After copying, confirm with the user:

```
✅ Created new project: [project-name]

Location: projects/[project-name]/

Your new project includes:
- context-library/ - Add project-specific context here
- outputs/ - Your PRDs, analyses, and deliverables will go here
- .claude/settings.local.json - Project-specific Claude settings

Next steps:
1. Update context-library/business-info-template.md with project details
2. Add any relevant stakeholder profiles to context-library/
3. Start working! All PM OS skills and features are available.

Run commands from the project directory to automatically use project context.
```

### 5. Helpful Tips
- Remind the user that the new project inherits from the root CLAUDE.md
- Mention they can add a project-specific CLAUDE.md if needed
- Let them know all global skills are available to this project

---

## Error Handling

**No project name provided:**
"What should we name the new project? (Use kebab-case like 'customer-portal' or 'mobile-app-redesign')"

**Invalid characters in name:**
"Project names should use kebab-case with only letters, numbers, and hyphens. How about '[suggested-name]' instead?"

**Copy command fails:**
"Failed to create the project. Error: [error message]. Let's troubleshoot this."

---

## Notes

- The skill copies the ENTIRE setup/project-template/ directory
- If the user wants to clean up the template first, they should do that before running this skill
- The project will be created inside the projects/ folder automatically
- All global .claude configurations, skills, and sub-agents remain available to the new project
