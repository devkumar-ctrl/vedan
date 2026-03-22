# Vedan v2.1 - Advanced Bug Bounty Toolkit 🛠️

**Vedan** is an automated Bug Bounty Toolkit designed for high-efficiency reconnaissance. Version 2.1 introduces advanced scanning capabilities including GF pattern filtering, secret detection, and JavaScript analysis, all while maintaining a balanced system load.

> [!IMPORTANT]
> **This tool is optimized for Linux environments ONLY.**

---

## Features ✨
- **Subdomain Enumeration**: Discovery using `subfinder` with balanced threading.
- **HTTP Probing**: Identifying live hosts with `httpx`.
- **URL Gathering**: Combined historical data from `gau` and `waybackurls`.
- **URL Cleaning**: Deduplication and cleanup using `uro`.
- **Vulnerability Filtering**: Automated pattern matching for XSS, SQLi, SSRF, and LFI using `gf`.
- **JavaScript Recon**: Extraction of JS files for endpoint analysis.
- **Secret Detection**: Pattern-based scanning for API keys and sensitive tokens.
- **Vulnerability Scanning**: Template-based scanning with `nuclei`.
- **Visual Capture**: Automated screenshots of all live hosts.

---

## Installation 🛠️

### Prerequisites
Ensure you are on a **Linux** environment with the following tools installed:
- `subfinder`, `httpx`, `gau`, `waybackurls`, `gf`, `uro`, `nuclei`, `grep`

### Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/devkumar-swipe/vedan.git
   ```
2. Make the script executable:
   ```bash
   chmod +x vedan.sh
   ```

---

## Usage 🚀
Run the script with a target domain:
```bash
./vedan.sh example.com
```

### Configuration
- **Threads**: Defaulted to `10` to ensure stable CPU performance.
- **Output**: Results are organized by domain in `~/vedan/`.

---

## Output 📂
Results are stored in structured directories:
```text
~/vedan/example.com/
├── subs.txt            # Unique subdomains
├── alive.txt           # Live hosts
├── urls.txt            # Processed & cleaned URLs
├── params.txt          # URLs with parameters
├── js_files.txt        # Discovered JavaScript files
├── secrets.txt         # Potential sensitive findings
├── vulns/              # Categorized GF patterns (XSS, SQLi, etc.)
├── screenshots/        # Visual evidence
└── nuclei_results.txt  # Nuclei scan output
```

---

## Dependencies 📦
- [subfinder](https://github.com/projectdiscovery/subfinder) | [httpx](https://github.com/projectdiscovery/httpx) | [nuclei](https://github.com/projectdiscovery/nuclei)
- [gau](https://github.com/lc/gau) | [waybackurls](https://github.com/tomnomnom/waybackurls)
- [gf](https://github.com/tomnomnom/gf) | [uro](https://github.com/s0md3v/uro)

---

## Support and Contact 📧
Email: devkumarmahto204@outlook.com

## License 📄
This project is licensed under the MIT License.

Happy Hunting! 🐛🔍
