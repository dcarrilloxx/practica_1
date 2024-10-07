#!/bin/bash
cut -d ',' -f 1-11,13-15 supervivents.csv > temporal.csv && mv temporal.csv supervivents.csv
awk -F',' '$15 != "True"' supervivents.csv > temporal.csv && mv temporal.csv supervivents.csv

wc -l supervivents.csv

awk -F',' 'BEGIN{OFS=","} {if($8<=1000000) $17 = "Bo"; else if ($8<=10000000) $17="Excel·lent"; else $17="Estrella"; print $0}' supervivents.csv > temp.csv && mv temp.csv supervivents.csv


cut -d ',' -f 1-11,13-15 supervivents.csv > temporal.csv
awk -F',' '$15 != "True"' temporal.csv > temporal2.csv

