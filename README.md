# File Names Watcher

This repository provides a Bash script that automatically enforces best practices for file naming (based on Jenny Bryan's "Naming Things" guide) while tracking file edits and renaming history in real time.

## Features
- Automatic renaming of files to follow **machine-readable**, **human-readable**, and **sortable** conventions.
- Real-time monitoring of directories for new files or edits.
- Centralised log (`file_mod_log.txt`) tracking renames, timestamps, and edit durations.
- ISO 8601 date prefixes for consistent sorting.
- Ready to use for **bioinformatics workflows**, pipelines, or collaborative coding.

## Installation
1. Clone or download this repository.
2. Ensure you have `inotify-tools` installed (Linux/macOS):
   ```bash
   sudo apt install inotify-tools   # Ubuntu/Debian
   brew install inotify-tools       # macOS (via Homebrew)
   ```
3. Make the script executable:
   ```bash
   chmod +x file_watcher.sh
   ```

## Usage
Run the script to monitor a directory (default: current directory):
```bash
./file_watcher.sh /path/to/directory
```

## Log Output Example
```
### File: 2025-07-29_my_Bioniformatics_file_counts_final.tsv
Date: 2025-07-29 15:12:03
Event: Renamed
Details: Old name: my Bioniformatics file counts (final).txt  → 2025-07-29_my_Bioniformatics_file_counts_final.txt
----------------------------------------
### File: 2025-07-29_RNAseq_counts_GSE12345.tsv
Date: 2025-07-29 15:13:10
Event: Modified
Details: Active editing duration: 42s
----------------------------------------
```

## Example File
This repository includes `my Bioniformatics file counts (final).txt` as an example file. Running the script will automatically rename it to follow proper conventions.

## License
MIT License
