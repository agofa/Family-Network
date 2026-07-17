#!/bin/bash
# folder-sizes.sh
OUTDIR="/volume1/homes/pindus/script"   # <-- modifica con il percorso dove vuoi salvare
TMPFILE="$OUTDIR/.folder-sizes_tmp.txt"
OUTFILE="$OUTDIR/folder-sizes_$(date +%Y%m%d_%H%M%S).txt"
mkdir -p "$OUTDIR"
> "$TMPFILE"

EXCLUDED_KB=0
TOTAL_KB=0

echo "Inizio scansione: $(date)"

for vol in /volume1 /volume2 /volumeUSB1 /volumeUSB2 ; do
    if [ -d "$vol" ]; then
        for dir in "$vol"/*/; do
            base=$(basename "$dir")
            size_kb=$(du -sk "$dir" 2>/dev/null | awk '{print $1}')
            [ -z "$size_kb" ] && continue

            # Escludi cartelle di sistema Synology (iniziano con @)
            if [[ "$base" == @* ]]; then
                echo "Escluso: $dir ($size_kb KB)"
                EXCLUDED_KB=$((EXCLUDED_KB + size_kb))
                continue
            fi

            echo "Elaboro: $dir ($size_kb KB)"
            TOTAL_KB=$((TOTAL_KB + size_kb))
            echo -e "${size_kb}\t${dir}" >> "$TMPFILE"
        done
    fi
done

echo ""
echo "Scansione completata: $(date)"
echo "Ordino e salvo il report finale..."

# Funzione di conversione KB -> formato leggibile (stile du -h)
human_kb() {
    awk -v kb="$1" 'BEGIN {
        split("K M G T P", units, " ")
        val = kb
        i = 1
        while (val >= 1024 && i < 5) {
            val = val / 1024
            i++
        }
        printf "%.1f%s", val, units[i]
    }'
}

{
    sort -n -k1 "$TMPFILE" | while IFS=$'\t' read -r kb dir; do
        h=$(human_kb "$kb")
        echo -e "${dir}\t${h}"
    done

    echo ""
    echo "-----------------------------------"
    echo -e "Totale cartelle escluse (@*)\t$(human_kb "$EXCLUDED_KB")"
    echo -e "Totale cartelle dati\t$(human_kb "$TOTAL_KB")"
} > "$OUTFILE"

rm -f "$TMPFILE"

echo "Report salvato in: $OUTFILE"