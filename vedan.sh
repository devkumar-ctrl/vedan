#!/bin/bash

#I hate LGBTQ... so don't copy my codes.

TOOL_NAME="Vedan v2.1 - Advanced Bug Bounty Toolkit"
VERSION="2.1"
AUTHOR="Ved Kumar"


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'


THREADS=10  
BASE_DIR="$HOME/vedan"



header() {
  echo -e "${GREEN}========================================${NC}"
  echo -e "${BLUE}$TOOL_NAME${NC}"
  echo -e "${YELLOW}Version: $VERSION | Author: $AUTHOR${NC}"
  echo -e "${GREEN}========================================${NC}"
}

log() {
  echo -e "${BLUE}[*]${NC} $1"
}

error() {
  echo -e "${RED}[!] $1${NC}"
  exit 1
}

check_os() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ -f /etc/os-release ]; then
      if grep -qi "linux" /etc/os-release; then
        return 0
      fi
    fi
  fi
  echo -e "${YELLOW}[!] Warning: This tool is optimized for Linux only.${NC}"
}

check_tool() {
  if ! command -v "$1" &> /dev/null; then
    error "$1 not installed. Install it first."
  fi
}

validate_domain() {
  if [[ ! "$1" =~ ^([a-zA-Z0-9][a-zA-Z0-9-]*\.)+[a-zA-Z]{2,}$ ]]; then
    error "Invalid domain format"
  fi
}


check_dependencies() {
  log "Checking dependencies..."
  tools=("subfinder" "httpx" "gau" "waybackurls" "gf" "uro" "nuclei" "grep")
  for tool in "${tools[@]}"; do
    check_tool "$tool"
  done
  log "All dependencies are installed ✅"
}


run_scan() {
  DOMAIN=$1
  DIR="$BASE_DIR/$DOMAIN"

  mkdir -p "$DIR"

  log "Target: $DOMAIN"
  log "Output Directory: $DIR"


  log "Running subfinder..."
  subfinder -d "$DOMAIN" -silent -t $THREADS > "$DIR/subs_raw.txt" || error "subfinder failed"
  sort -u "$DIR/subs_raw.txt" > "$DIR/subs.txt" && rm "$DIR/subs_raw.txt"


  log "Checking live hosts..."
  cat "$DIR/subs.txt" | httpx -silent -threads $THREADS > "$DIR/alive.txt" || error "httpx failed"

 
  log "Gathering URLs (gau & waybackurls)..."
  gau "$DOMAIN" --subs > "$DIR/gau.txt"
  waybackurls "$DOMAIN" > "$DIR/wayback.txt"
  
  log "Cleaning and deduplicating URLs with uro..."
  cat "$DIR/gau.txt" "$DIR/wayback.txt" | sort -u | uro > "$DIR/urls.txt"
  rm "$DIR/gau.txt" "$DIR/wayback.txt"

  
  log "Extracting parameters for attack surface..."
  cat "$DIR/urls.txt" | grep "=" | sort -u > "$DIR/params.txt"


  log "Filtering potential vulnerabilities using GF patterns..."
  mkdir -p "$DIR/vulns"
  cat "$DIR/urls.txt" | gf xss > "$DIR/vulns/xss.txt"
  cat "$DIR/urls.txt" | gf sqli > "$DIR/vulns/sqli.txt"
  cat "$DIR/urls.txt" | gf ssrf > "$DIR/vulns/ssrf.txt"
  cat "$DIR/urls.txt" | gf lfi > "$DIR/vulns/lfi.txt"
  
 
  cat "$DIR/params.txt" | gf xss > "$DIR/vulns/xss_params.txt"
  cat "$DIR/params.txt" | gf sqli > "$DIR/vulns/sqli_params.txt"


  log "Extracting JavaScript files for analysis..."
  cat "$DIR/urls.txt" | grep "\.js$" | sort -u > "$DIR/js_files.txt"


  log "Scanning for secrets and sensitive patterns..."
  grep -E "api_key|apikey|token|secret|access_key|auth|password" "$DIR/urls.txt" > "$DIR/secrets.txt"

 
  log "Running nuclei (light mode)..."
  nuclei -l "$DIR/alive.txt" -silent -o "$DIR/nuclei_results.txt" -threads $THREADS

 
  log "Taking screenshots of live hosts..."
  mkdir -p "$DIR/screenshots"
  cat "$DIR/alive.txt" | httpx -silent -threads $THREADS -screenshot -srd "$DIR/screenshots"

  log "Scan completed successfully"
  log "All results are available in: $DIR"
}


usage() {
  echo -e "${YELLOW}Usage:${NC}"
  echo -e "  ./vedan.sh <domain>"
  exit 1
}


main() {
  header
  check_os

  [[ -z "$1" ]] && usage

  DOMAIN=$1
  validate_domain "$DOMAIN"
  check_dependencies
  run_scan "$DOMAIN"
}

main "$@"
