#!/usr/bin/env bash
# export_lib_full.sh – save tree and all Dart file contents into one file

OUTPUT="lib_full_export.txt"
LIB_DIR="lib"

# 1. Write the directory tree
echo "===== DIRECTORY STRUCTURE =====" > "$OUTPUT"
if command -v tree &> /dev/null; then
    tree "$LIB_DIR" --dirsfirst -I "*.g.dart|*.freezed.dart|*.gr.dart" >> "$OUTPUT"
else
    find "$LIB_DIR" -print | sort | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/" >> "$OUTPUT"
fi

# 2. Append every .dart file with a clear header
echo -e "\n===== SOURCE FILES =====" >> "$OUTPUT"
find "$LIB_DIR" -type f -name "*.dart" | sort | while read -r file; do
    echo "" >> "$OUTPUT"
    echo "/* ===== $file ===== */" >> "$OUTPUT"
    cat "$file" >> "$OUTPUT"
done

echo "Full export saved to $OUTPUT"