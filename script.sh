
#!/bin/bash
awk -F',' '{ if (NF == 16) print $0 }' CAvideos.csv > supervivents.csv
cut -d ',' -f 1-11,13-15 supervivents.csv > temporal.csv
awk -F ',' '{ if ($14 != "True") print $0 }' temporal.csv > temporal2.csv

x=$(wc -l < supervivents.csv)
y=$(wc -l < temporal2.csv)

diferencia=$((x-y))

echo "$diferencia registres eliminats"

awk -F',' '{
    if ($8 <= 1000000) ranking="Bo";
    else if ($8 > 1000000 && $8 <= 10000000) ranking="Excel·lent";
    else ranking="Estrella";
    print $0 "," ranking;
}' temporal2.csv > temporal3.csv

awk -F',' '{
  if ($8 != 0) {
    Rlikes = ($9 * 100) / $8;
    Rdislikes = ($10 * 100) / $8;
  } else {
    Rlikes = "No es pot dividir entre 0 o valor invàlid";
    Rdislikes = "No es pot dividir entre 0 o valor invàlid";
  }
  print $0 "," Rlikes "," Rdislikes;
}' temporal3.csv > sortida.csv



