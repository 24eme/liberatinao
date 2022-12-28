#!/bin/bash

if grep ';Supprime' data/vins_ciel_complet.csv > /dev/null; then
	sed -i 's/ *, */ - /g' data/vins_ciel_complet.csv
fi
sed -i 's/\r/\n/g; s/\n$//' data/vins_ciel_complet.csv
sed -i 's/;/,/g' data/vins_ciel_complet.csv
sed -i 's/"//g' data/vins_ciel_complet.csv

head -n 1 data/vins_ciel_complet.csv > data/vins_ciel.csv
grep ',Valide' data/vins_ciel_complet.csv | sort >> data/vins_ciel.csv
sed -i 's/,Valide//' data/vins_ciel.csv
sed -i 's/,STATUT//' data/vins_ciel.csv

