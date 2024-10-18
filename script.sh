#!/bin/bash

# Filtrar registres que tenen 16 camps
awk -F',' '{ if (NF == 16) print $0 }' CAvideos.csv > supervivents.csv

# Eliminar columna 12 i conservar altres columnes
cut -d ',' -f 1-11,13-15 supervivents.csv > temporal.csv

# Filtrar els registres on la columna 14 no és "True"
awk -F ',' '{ if ($14 != "True") print $0 }' temporal.csv > temporal2.csv

# Comptar registres eliminats
x=$(wc -l < supervivents.csv)
y=$(wc -l < temporal2.csv)
diferencia=$((x - y))
echo "$diferencia registres eliminats"

# Afegir columna "Ranking_Views"
awk -F',' '{
    if ($8 <= 1000000) ranking="Bo";
    else if ($8 > 1000000 && $8 <= 10000000) ranking="Excel·lent";
    else ranking="Estrella";
    print $0 "," ranking;
}' temporal2.csv > temporal3.csv

# Calcular rlikes i rdislikes, si les views no són majors que 0, likes i dislikes són 0
while IFS=',' read -r id trending title channel category publish tags views likes dislikes comments comment_disabled rating_disabled error ranking
do
    # Comprovar que views sigui numèric i major que 0
    if [[ "$views" =~ ^[0-9]+$ && "$views" -gt 0 ]]; then
        rlikes=$(echo "scale=2; ($likes * 100) / $views" | bc)
        rdislikes=$(echo "scale=2; ($dislikes * 100) / $views" | bc)
    else
        rlikes=0
        rdislikes=0
    fi
    # Escribir resultados en un archivo CSV de salida
    echo "VideoID: $id | Title: $title | Publish_time: $publish | Views: $views | Likes: $likes | Dislikes: $dislikes | Rlikes: $rlikes% | Rdislikes: $rdislikes% | Ranking: $ranking" >> sortida.csv
done < temporal3.csv


# Demana a l'usuari que introdueixi la id o el títol del vídeo
echo "Introdueix la id o el títol d'un vídeo: "
read variable

# Cerca coincidències a l'arxiu sortida.csv
grep -q "$variable" sortida.csv

# Comprova si s'ha trobat una coincidència
if [[ $? != 0 ]]; then
    echo "No s'han trobat coincidències"
else
    # Mostra les línies que contenen el valor cercat
    grep "$variable" sortida.csv
fi







