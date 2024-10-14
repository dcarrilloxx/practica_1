#!/bin/bash

# Comptar registres eliminats
x=$(wc -l < supervivents.csv)
y=$(wc -l < temporal2.csv)
diferencia=$((x - y))
echo "$diferencia registres eliminats"

# Afegir columna Ranking_Views
awk -F',' '{
    if ($8 <= 1000000) ranking="Bo";
    else if ($8 > 1000000 && $8 <= 10000000) ranking="Excel·lent";
    else ranking="Estrella";
    print $0 "," ranking;
}' temporal2.csv > temporal3.csv

# Calcular rlikes i rdislikes, si les views no són majors que 0, likes i dislikes són 0
while IFS=',' read -r id trending title channel category publish tags views likes dislikes comments comment_disabled rating_disabled error
do
    # Comprovar que views sigui numèric i major que 0
    if [[ "$views" =~ ^[0-9]+$ && "$views" -gt 0 ]]; then
        rlikes=$(echo "scale=2; ($likes * 100) / $views" | bc)
        rdislikes=$(echo "scale=2; ($dislikes * 100) / $views" | bc)
    else
        rlikes=0
        rdislikes=0
    fi

    # Mostrar els resultats ben formatejats
    echo "VideoID: $id | Title: $title | Views: $views | Likes: $likes | Dislikes: $dislikes | Rlikes: $rlikes% | Rdislikes: $rdislikes%"
done < temporal3.csv

# Búsqueda de vídeo per títol o ID
# Búsqueda de vídeo por títol o ID
if [ -n "$1" ]; then
    resultat=$(grep -i "$1" temporal3.csv)  # -i para ignorar mayúsculas/minúsculas
    if [ -z "$resultat" ]; then
        echo "No s'ha trobat cap vídeo amb aquest títol o identificador."
    else
        echo "$resultat" | cut -d',' -f3,6,8,9,10,17,18,19  # Filtrar columnas específicas
    fi
fi


