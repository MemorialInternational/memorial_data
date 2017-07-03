unzip lists.memo.ru-disk.zip -d csv_cp1251

# Convert CP-1251 for all CSV files into UTF-8
mkdir -p csv
find csv_cp1251/*.csv | xargs -n1 basename | xargs -n1 -I{} echo 'iconv -f cp1251 -t utf-8 csv_cp1251/{} > csv/{}' | bash
rm -r csv_cp1251

# Replace tabulation inside data strings with spaces (it's manually checked that it doesn't break anything
find csv/*.csv | xargs grep --files-with-matches -Pe $'\t' | xargs -n1 -I{} echo "sed --in-place --regexp-extended -e 's/\s*\t\s*/ /g' {}" | bash

# convert into single table and pack it
ruby glue_tables.rb > memorial_lists.tsv
rm -r csv
time 7z a memorial_lists.tsv.7z memorial_lists.tsv
rm memorial_lists.tsv
