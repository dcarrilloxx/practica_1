#!/bin/bash
cut -d ',' -f 1-11,13-15 supervivents.csv > temporal.csv
head -n 1 temporal.csv | tr ',' '\n' | nl

 


