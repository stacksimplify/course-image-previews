# Image Renaming Scripts - Quick Reference

## 📋 What These Scripts Do

Standardizes image filenames by converting **all hyphens to underscores**.

### Examples:

```
00-retail-store-components.png         → 00_retail_store_components.png
01-01-Retail-Store-Component.png       → 01_01_Retail_Store_Component.png
02-01-Docker-Terminology.png           → 02_01_Docker_Terminology.png
06-03-01-VPC-Architecture.png          → 06_03_01_VPC_Architecture.png
17-04-01-Karpenter-Spot.png            → 17_04_01_Karpenter_Spot.png
```

---

## 🚀 Usage

### Step 1: Preview Changes (Dry Run)

**Always run this first to see what will change:**

```bash
# Make script executable
chmod +x rename_images.sh

# Preview changes (safe - doesn't modify anything)
./rename_images.sh
```

### Step 2: Execute Renames

**Once you're happy with the preview:**

```bash
# Actually rename the files
./rename_images.sh --execute
```

### Step 3: Undo if Needed (Optional)

**If you need to revert:**

```bash
# Make undo script executable
chmod +x undo_rename.sh

# Revert using the backup file
./undo_rename.sh rename_backup_20250102_143022.txt
```

---

## 📁 Running in Different Directory

### Option 1: Run from images directory
```bash
cd images/
./rename_images.sh --execute
```

### Option 2: Specify directory
```bash
./rename_images.sh --execute ./images/
```

---

## 🎯 What You'll See

### Dry Run Output Example:
```
╔════════════════════════════════════════════════════════════════╗
║        Image Filename Standardization Script                  ║
╚════════════════════════════════════════════════════════════════╝

Directory: /path/to/images
Total PNG files found: 86

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                    DRY-RUN MODE (Preview Only)                
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] 00-retail-store-components.png
    ↓
    00_retail_store_components.png

[2] 01-01-Retail-Store-Component-Diagram.png
    ↓
    01_01_Retail_Store_Component_Diagram.png

...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                         SUMMARY                               
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Total files scanned:     86
Files to be renamed:     45
Files already correct:   41
```

### Execute Output Example:
```
✓ Created backup list: rename_backup_20250102_143022.txt

[1] Renaming...
    OLD: 00-retail-store-components.png
    NEW: 00_retail_store_components.png
    ✓ Success

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ Successfully renamed 45 files!
✓ Backup list saved to: rename_backup_20250102_143022.txt
```

---

## 🛡️ Safety Features

1. **Dry-run by default** - Preview before executing
2. **Backup file created** - Can undo all changes
3. **Collision detection** - Won't overwrite existing files
4. **Color-coded output** - Easy to read
5. **Error handling** - Stops on errors

---

## 🔧 Alternative: Quick One-Liner

If you prefer a simple one-liner (no backup):

```bash
# Preview only
for f in *.png; do echo "$f → $(echo $f | tr '-' '_')"; done

# Execute (USE WITH CAUTION - no backup!)
for f in *.png; do mv "$f" "$(echo $f | tr '-' '_')"; done 2>/dev/null || true
```

⚠️ **Warning:** One-liner has no undo capability. Use the full script for safety.

---

## 📝 Backup File Format

The backup file is plain text and human-readable:

```
# Rename backup - Sat Jan  2 14:30:22 PST 2025
# Old Name → New Name

00-retail-store-components.png → 00_retail_store_components.png
01-01-Retail-Store-Component-Diagram.png → 01_01_Retail_Store_Component_Diagram.png
02-01-Docker-Terminology.png → 02_01_Docker_Terminology.png
```

---

## ❓ Troubleshooting

### "Permission denied"
```bash
chmod +x rename_images.sh
chmod +x undo_rename.sh
```

### "No such file or directory"
Make sure you're in the correct directory:
```bash
pwd  # Check current directory
ls   # List files
```

### Want to test on a few files first?
```bash
# Create a test directory
mkdir test_rename
cp images/*.png test_rename/ | head -5  # Copy 5 files
cd test_rename
../rename_images.sh --execute
```

---

## 🎯 Best Practices

1. **Always run dry-run first** (`./rename_images.sh`)
2. **Review the preview carefully**
3. **Keep the backup file** until you're sure everything works
4. **Test on a copy first** if you're nervous
5. **Commit to git before running** (if using version control)

---

## 📦 Files Included

- `rename_images.sh` - Main renaming script
- `undo_rename.sh` - Revert changes
- `README.md` - This file
- `rename_backup_*.txt` - Auto-generated backup files

---

## ✅ What Gets Changed

**YES - These change:**
- `01-01-Docker.png` → `01_01_Docker.png`
- `section-number.png` → `section_number.png`
- `All-Hyphens-Become-Underscores.png` → `All_Underscores_Become_Underscores.png`

**NO - These stay the same:**
- `01_01_Docker.png` (already correct)
- `17_04_01_Karpenter.png` (already correct)
- Any file without hyphens

---

## 🎓 After Renaming

After running the script, your gallery will automatically:
- ✅ Display images in correct numerical order
- ✅ Have consistent naming across all files
- ✅ Be ready for automation/scripting
- ✅ Look more professional

No need to update the HTML gallery - natural sort handles everything!

---

**Questions?** The scripts include helpful error messages and will guide you through any issues.
