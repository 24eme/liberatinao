#!/bin/bash

echo "Statut CE,Statut FR,Appellation,Dénomination,Produit,Catégorie générale,Sous Catégorie,Couleur,Sucrosité,Mention,Code INAO,url site" > data/produits.csv
grep '<strong>Produit</strong>' html/* | 
	sed 's/<li>/;/g' | sed 's/<li>/;/g'  | sed 's/:/;/' | sed 's/^html.//' |
	awk -F ';' 'BEGIN{OFS=";"}  {if ( $5 !~ /Statut FR/ ) $5=";"$5 ; print $0 ;}' | 
	awk -F ';' 'BEGIN{OFS=";"}  {if ( $6 !~ /Statut CE/ ) $6=";"$6 ; print $0 ;}' | 
	sed 's/<strong>[^<]*<.strong>//g' |  sed 's/<[^>]*>//g' | sed -r 's/(Description|Historique|Chiffres-clés).*//' | sed 's/[^;]*: *//g'  | 
	awk -F ';' '{gsub(/ - ?/, ";", $7) ; print $1";"$6";"$5";"$8";"$9";"$3";"$7}' | 
        awk -F ';' 'BEGIN {OFS=";"} { if ( $10 ~ /[0-9][A-Z][0-9]*/ ) $10 = ";;"$10 ; if ( $11 ~ /[0-9][A-Z][0-9]*/ ) $11 = ";"$11 ; print $0 }' | 
        awk -F ';' 'BEGIN {OFS=";"} { if ( $9 ~ /^Sec/ ) { $10 = $9 ; $9 = "" } if ( $10 ~ /^(Dép|Grand|Premier|Régio|Zone)/ ) { $11 = $10 ; $10 = "" } print $0 }' | 
        awk -F ';' 'BEGIN {OFS=";"} { $13="http://www.inao.gouv.fr/produit/"$1 ; $1=""; print $0}' | sed 's/^;//' | 
	sed 's/[,"]//g' | sed 's/;/,/g' | sort -r -t ',' -k 12,12 >> data/produits.csv

echo "Statut,Appellation,Produit,Sous Catégorie,Couleur,Sucrosité,Mention,Code INAO" > data/vins.csv
cat data/produits.csv | grep ',Vins,' | sed 's/,Vins,/,/' |
        sed 's/ *([^)]*)//' | 
        sed 's/ . Appellation d.origine protégée//' | sed 's/ . Indication géographique protégée//' | sed 's/ . Indication géographique//' |
	sed 's/ - Appellation d.origine contrôlée//' | sed 's/ - Appellation d.origine réglementée//' | sed 's/ - Label rouge//' |
	sed 's/^,AOC,/AOC,/' | sed 's/^AOP,AOC,/AOC,/' | sed 's/^IGP,,/IGP,/' |
	awk -F ',' '{print $1","$2","$4","$5","$6","$7","$8","$9}' |
	cat | sort -r -t ',' -k 8,8 >> data/vins.csv

cat data/produits.csv | grep -v ',Vins,' | sort -r -t ',' -k 12,12 > data/nonvins.csv
