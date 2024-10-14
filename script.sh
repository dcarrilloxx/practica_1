#!/bin/bash

# Filtrar registres amb 16 camps
awk -F',' '{ if (NF == 16) print $0 }' CAvideos.csv > supervivents.csv

# Eliminar columnes q no volem
cut -d ',' -f 1-11,13-15 supervivents.csv > temporal.csv

# Filtrar videos ssense errors
awk -F ',' '{ if ($14 != "True") print $0 }' temporal.csv > temporal2.csv


# Comptar registres eliminats
x=$(wc -l < supervivents.csv)
y=$(wc -l < temporal2.csv)

diferencia=$((x-y))

echo "$diferencia registres eliminats"


# afegir columna Ranking_Views
awk -F',' '{
    if ($8 <= 1000000) ranking="Bo";
    else if ($8 > 1000000 && $8 <= 10000000) ranking="Excel·lent";
    else ranking="Estrella";
    print $0 "," ranking;
}' temporal2.csv > temporal3.csv

# Calcular rlikes y rdislikes
while IFS=',' read -r id trending title channel category publish tags views likes dislikes comments comment_disabled rating_disabled error
do

    if [ "$views" -gt 0 ]; then
        rlikes=$(echo "scale=2; ($likes * 100) / $views" | bc)
        rdislikes=$(echo "scale=2; ($dislikes * 100) / $views" | bc)
    else
        rlikes=0
        rdislikes=0
    fi
done < temporal3.csv


# Mostrar detalls del video
echo "VideoID: $id $title $views $likes $dislikes $rlikes $rdislikes"



# Búsqueda de vídeo per títol o ID
if [ -n "$1" ]; then
    resultat=$(grep -i "$1" temporal3.csv)
    if [ -z "$resultat" ]; then
        echo "No s'ha trobat cap vídeo amb aquest títol o identificador."
    else
        echo "$resultat" | cut -d',' -f3,6,8,9,10,17,18,19
    fi
fi
