#!/bin/bash

################################################################################
# Undo Rename Script
# Reverts changes made by rename_images.sh
# 
# Usage: ./undo_rename.sh <backup_file>
################################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if backup file provided
if [[ -z "$1" ]]; then
  echo -e "${RED}Error: No backup file specified${NC}"
  echo ""
  echo "Usage: ./undo_rename.sh <backup_file>"
  echo ""
  echo "Available backup files:"
  ls -1 rename_backup_*.txt 2>/dev/null || echo "  (none found)"
  exit 1
fi

BACKUP_FILE="$1"

# Verify backup file exists
if [[ ! -f "$BACKUP_FILE" ]]; then
  echo -e "${RED}Error: Backup file '$BACKUP_FILE' not found${NC}"
  exit 1
fi

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║               Undo Rename Script                               ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Backup file:${NC} $BACKUP_FILE"
echo ""

# Count changes
change_count=$(grep -c "→" "$BACKUP_FILE" || true)
echo -e "${YELLOW}Changes to revert:${NC} $change_count"
echo ""

# Confirm
echo -e "${YELLOW}This will rename files back to their original names.${NC}"
read -p "Continue? (yes/no): " confirm

if [[ "$confirm" != "yes" ]]; then
  echo -e "${RED}Aborted.${NC}"
  exit 0
fi

echo ""
echo -e "${GREEN}Reverting changes...${NC}"
echo ""

reverted=0

# Read backup file and revert each change
while IFS='→' read -r old new; do
  # Trim whitespace
  old=$(echo "$old" | xargs)
  new=$(echo "$new" | xargs)
  
  # Skip empty lines and comments
  [[ -z "$old" ]] && continue
  [[ "$old" == \#* ]] && continue
  
  # Check if new file exists
  if [[ -f "$new" ]]; then
    echo -e "${YELLOW}[$((reverted+1))]${NC} Reverting..."
    echo -e "    ${RED}CURRENT:${NC} $new"
    echo -e "    ${GREEN}ORIGINAL:${NC} $old"
    
    # Rename back
    mv "$new" "$old"
    reverted=$((reverted + 1))
    echo -e "    ${GREEN}✓ Success${NC}"
    echo ""
  else
    echo -e "${RED}⚠ File not found: $new (skipping)${NC}"
  fi
done < "$BACKUP_FILE"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Successfully reverted $reverted changes${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
