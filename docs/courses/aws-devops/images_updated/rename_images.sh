#!/bin/bash

################################################################################
# Image Filename Standardization Script
# Converts hyphens to underscores in image filenames
# 
# Usage: 
#   ./rename_images.sh              (dry-run preview)
#   ./rename_images.sh --execute    (actually rename files)
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if we're in dry-run mode
DRY_RUN=true
if [[ "$1" == "--execute" ]]; then
  DRY_RUN=false
fi

# Get the directory (use current dir or first argument)
IMAGE_DIR="${2:-.}"

# Verify directory exists
if [[ ! -d "$IMAGE_DIR" ]]; then
  echo -e "${RED}Error: Directory '$IMAGE_DIR' not found${NC}"
  exit 1
fi

cd "$IMAGE_DIR"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        Image Filename Standardization Script                  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Directory:${NC} $(pwd)"
echo ""

# Count files
total_files=$(find . -maxdepth 1 -name "*.png" | wc -l)
echo -e "${YELLOW}Total PNG files found:${NC} $total_files"
echo ""

# Initialize counters
renamed_count=0
skipped_count=0

# Create backup list if executing
if [[ "$DRY_RUN" == false ]]; then
  BACKUP_FILE="rename_backup_$(date +%Y%m%d_%H%M%S).txt"
  echo "# Rename backup - $(date)" > "$BACKUP_FILE"
  echo "# Old Name → New Name" >> "$BACKUP_FILE"
  echo "" >> "$BACKUP_FILE"
  echo -e "${GREEN}✓ Created backup list: $BACKUP_FILE${NC}"
  echo ""
fi

# Display mode
if [[ "$DRY_RUN" == true ]]; then
  echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${YELLOW}                    DRY-RUN MODE (Preview Only)                ${NC}"
  echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo -e "The following changes ${YELLOW}WOULD${NC} be made:"
  echo ""
else
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${GREEN}                    EXECUTING RENAMES                          ${NC}"
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
fi

# Process each PNG file
for file in *.png; do
  # Skip if no files found
  [[ -e "$file" ]] || continue
  
  # Convert all hyphens to underscores
  newname=$(echo "$file" | tr '-' '_')
  
  # Check if filename would change
  if [[ "$file" != "$newname" ]]; then
    renamed_count=$((renamed_count + 1))
    
    # Show the change
    if [[ "$DRY_RUN" == true ]]; then
      echo -e "${YELLOW}[$renamed_count]${NC} ${RED}$file${NC}"
      echo -e "    ${GREEN}↓${NC}"
      echo -e "    ${GREEN}$newname${NC}"
      echo ""
    else
      echo -e "${YELLOW}[$renamed_count]${NC} Renaming..."
      echo -e "    ${RED}OLD:${NC} $file"
      echo -e "    ${GREEN}NEW:${NC} $newname"
      
      # Check if target file already exists
      if [[ -e "$newname" ]]; then
        echo -e "    ${RED}⚠ WARNING: Target file already exists! Skipping...${NC}"
        echo ""
        renamed_count=$((renamed_count - 1))
        skipped_count=$((skipped_count + 1))
        continue
      fi
      
      # Save to backup list
      echo "$file → $newname" >> "$BACKUP_FILE"
      
      # Actually rename the file
      mv "$file" "$newname"
      echo -e "    ${GREEN}✓ Success${NC}"
      echo ""
    fi
  else
    skipped_count=$((skipped_count + 1))
  fi
done

# Summary
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}                         SUMMARY                               ${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "Total files scanned:     ${YELLOW}$total_files${NC}"

if [[ "$DRY_RUN" == true ]]; then
  echo -e "Files to be renamed:     ${YELLOW}$renamed_count${NC}"
  echo -e "Files already correct:   ${GREEN}$skipped_count${NC}"
else
  echo -e "Files renamed:           ${GREEN}$renamed_count${NC}"
  echo -e "Files skipped:           ${YELLOW}$skipped_count${NC}"
fi

echo ""

# Final instructions
if [[ "$DRY_RUN" == true ]]; then
  if [[ $renamed_count -gt 0 ]]; then
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}This was a DRY-RUN. No files were actually renamed.${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "To execute the renames, run:"
    echo -e "${GREEN}./rename_images.sh --execute${NC}"
    echo ""
  else
    echo -e "${GREEN}✓ All files already have the correct naming format!${NC}"
  fi
else
  if [[ $renamed_count -gt 0 ]]; then
    echo -e "${GREEN}✓ Successfully renamed $renamed_count files!${NC}"
    echo -e "${GREEN}✓ Backup list saved to: $BACKUP_FILE${NC}"
    echo ""
    echo -e "${YELLOW}To undo these changes, use:${NC}"
    echo -e "${YELLOW}./undo_rename.sh $BACKUP_FILE${NC}"
  else
    echo -e "${GREEN}✓ All files already had the correct naming format!${NC}"
  fi
fi

echo ""
