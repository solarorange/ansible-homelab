# Version Management Guide

## Overview

This document describes the comprehensive version management system for the Ansible Homelab project. The system provides multiple fallback options and ensures you can always recover from any issues.

## 🎯 Version Management Features

### **Multi-Level Fallback Strategy**
1. **Git Tags** - Clean, tagged releases (recommended)
2. **Version Backups** - Complete state snapshots
3. **Git Commits** - Fine-grained history
4. **Emergency Backups** - Last resort recovery

### **Automatic Backup System**
- **Pre-rollback backups** - Always create backup before changes
- **Version snapshots** - Complete state preservation
- **Metadata tracking** - Detailed backup information
- **Validation** - Ensure backups are valid

## 🚀 Quick Start

### **Check Current Version**
```bash
python3 scripts/version_manager.py info
```

### **Create Version Backup**
```bash
python3 scripts/version_manager.py backup
```

### **List Available Rollback Options**
```bash
./scripts/version_rollback.sh --list
```

### **Rollback to Previous Version**
```bash
# Rollback to git tag
./scripts/version_rollback.sh tag:v2.0.0

# Rollback to version backup
./scripts/version_rollback.sh backup:backups/versions/v2.0.0_20241219_143022

# Rollback to git commit
./scripts/version_rollback.sh commit:06f4db6
```

## 📊 Version Manager Commands

### **Information Commands**
```bash
# Show current version information
python3 scripts/version_manager.py info

# Generate detailed version report
python3 scripts/version_manager.py report
```

### **Backup Commands**
```bash
# Create version backup
python3 scripts/version_manager.py backup

# Create backup with specific version
python3 scripts/version_manager.py backup --version 2.0.0

# List available backups
python3 scripts/version_manager.py list-backups
```

### **Restore Commands**
```bash
# Restore from backup
python3 scripts/version_manager.py restore --backup-path backups/versions/v2.0.0_20241219_143022
```

### **Version Control Commands**
```bash
# Bump patch version (bug fixes)
python3 scripts/version_manager.py bump --bump-type patch

# Bump minor version (new features)
python3 scripts/version_manager.py bump --bump-type minor

# Bump major version (breaking changes)
python3 scripts/version_manager.py bump --bump-type major

# Create git tag
python3 scripts/version_manager.py tag --message "Release version 2.0.0"
```

## 🔄 Rollback Script Commands

### **Information Commands**
```bash
# List all rollback options
./scripts/version_rollback.sh --list

# Validate current state
./scripts/version_rollback.sh --validate
```

### **Backup Commands**
```bash
# Create emergency backup
./scripts/version_rollback.sh --backup
```

### **Rollback Commands**
```bash
# Rollback to git tag
./scripts/version_rollback.sh tag:v2.0.0

# Rollback to version backup
./scripts/version_rollback.sh backup:backups/versions/v2.0.0_20241219_143022

# Rollback to git commit
./scripts/version_rollback.sh commit:06f4db6

# Force rollback (no confirmation)
./scripts/version_rollback.sh --force tag:v2.0.0
```

## 🛡️ Safety Features

### **Automatic Backup Before Rollback**
- Creates backup before any rollback operation
- Preserves current state for recovery
- Validates backup integrity

### **Confirmation Prompts**
- Requires user confirmation for rollback operations
- Shows target and current version information
- Allows cancellation of rollback

### **Validation**
- Checks critical files after rollback
- Validates version manager functionality
- Ensures system integrity

## 📁 Backup Structure

### **Version Backups**
```
backups/versions/
├── v2.0.0_20241219_143022/
│   ├── main.yml
│   ├── site.yml
│   ├── ansible.cfg
│   ├── requirements.yml
│   ├── group_vars/all/vars.yml
│   ├── group_vars/all/vault.yml
│   ├── inventory.yml
│   ├── VERSION
│   ├── service_versions.json
│   └── backup_metadata.json
└── emergency_backup_20241219_143022/
    ├── backup_metadata.json
    └── [critical files]
```

### **Backup Metadata**
```json
{
  "version": "2.0.0",
  "timestamp": "2024-12-19T14:30:22",
  "git_commit": "06f4db6",
  "git_version": "v2.0.0",
  "backup_path": "backups/versions/v2.0.0_20241219_143022",
  "type": "version"
}
```

## 🔧 Version Management Workflow

### **Normal Development Workflow**
1. **Make changes** to your homelab configuration
2. **Test changes** thoroughly
3. **Create backup** before major changes
4. **Commit changes** to git
5. **Bump version** when ready for release
6. **Create git tag** for release
7. **Push to GitHub** with tags

### **Emergency Recovery Workflow**
1. **Identify issue** with current version
2. **List rollback options** to see available versions
3. **Create emergency backup** of current state
4. **Choose rollback target** (tag, backup, or commit)
5. **Execute rollback** with confirmation
6. **Validate rollback** to ensure success
7. **Test functionality** of rolled back version

### **Version Release Workflow**
1. **Complete development** and testing
2. **Bump version** to appropriate level
3. **Create git tag** with release message
4. **Create version backup** for safety
5. **Push to GitHub** with tags
6. **Update changelog** with release notes

## 📋 Best Practices

### **Version Naming**
- Use semantic versioning (MAJOR.MINOR.PATCH)
- Tag releases with `v` prefix (e.g., `v2.0.0`)
- Use descriptive commit messages

### **Backup Strategy**
- Create backups before major changes
- Keep multiple backup versions
- Test backup restoration periodically
- Store backups in version control

### **Rollback Strategy**
- Start with git tags (cleanest)
- Use version backups for complex changes
- Use git commits for fine-grained control
- Use emergency backups as last resort

### **Documentation**
- Update CHANGELOG.md with each release
- Document breaking changes clearly
- Include rollback instructions for major changes
- Maintain version compatibility matrix

## 🚨 Emergency Procedures

### **System Unresponsive**
```bash
# Create emergency backup
./scripts/version_rollback.sh --backup

# Rollback to last known good version
./scripts/version_rollback.sh tag:v2.0.0
```

### **Configuration Corrupted**
```bash
# List available backups
./scripts/version_rollback.sh --list

# Restore from version backup
./scripts/version_rollback.sh backup:backups/versions/v2.0.0_20241219_143022
```

### **Git Repository Issues**
```bash
# Create emergency backup
python3 scripts/version_manager.py backup

# Restore from backup
python3 scripts/version_manager.py restore --backup-path backups/versions/v2.0.0_20241219_143022
```

## 📊 Monitoring and Maintenance

### **Regular Tasks**
- **Weekly**: Check available backups
- **Monthly**: Test backup restoration
- **Quarterly**: Clean up old backups
- **Annually**: Review version strategy

### **Backup Maintenance**
```bash
# List all backups
python3 scripts/version_manager.py list-backups

# Clean up old backups (manual)
rm -rf backups/versions/v1.0.0_*

# Validate backup integrity
./scripts/version_rollback.sh --validate
```

## 🔗 Integration with GitHub

### **Pushing with Tags**
```bash
# Create tag
python3 scripts/version_manager.py tag --message "Release version 2.0.0"

# Push to GitHub
git push origin main --tags
```

### **GitHub Releases**
1. Create git tag
2. Push to GitHub
3. Create GitHub release from tag
4. Upload backup artifacts
5. Add release notes

## 📚 Related Documentation

- **[CHANGELOG.md](CHANGELOG.md)** - Version history and changes
- **[README.md](README.md)** - Project overview and setup
- **[DEPLOYMENT.md](DEPLOYMENT.md)** - Deployment procedures
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Common issues and solutions

---

**🎯 This version management system ensures you can always recover from any issues and maintain a stable, production-ready homelab!** 