#!/bin/bash

echo "Statut FR,Statut CE,Appellation,Dénomination,Produit,Catégorie générale,Sous Catégorie,Couleur,Sucrosité,Mention,Code INAO" > data/produits.csv
grep '<strong>Produit</strong>' html/* | 
	sed 's/<li>/;/g' | sed 's/<li>/;/g'  | sed 's/:/;/' | sed 's/^html.//' |
	awk -F ';' 'BEGIN{OFS=";"}  {if ( $5 !~ /Statut FR/ ) $5=";"$5 ; print $0 ;}' | 
	sed 's/<strong>[^<]*<.strong>//g' |  sed 's/<[^>]*>//g' | sed -r 's/(Description|Historique|Chiffres-clés).*//' | sed 's/[^;]*: *//g'  | 
	awk -F ';' '{gsub(/ - ?/, ";", $7) ; print $6";"$5";"$8";"$9";"$3";"$7}' | 
        awk -F ';' 'BEGIN {OFS=";"} { if ( $9 ~ /[0-9][A-Z][0-9]*/ ) $9 = ";;"$9 ; if ( $10 ~ /[0-9][A-Z][0-9]*/ ) $10 = ";"$10 ; print $0 }' | 
        awk -F ';' 'BEGIN {OFS=";"} { if ( $8 ~ /^Sec/ ) { $9 = $8 ; $8 = "" } if ( $9 ~ /^(Dép|Grand|Premier|Régio|Zone)/ ) { $10 = $9 ; $9 = "" } print $0 }' | 
	sed 's/[,"]//g' | sed 's/;/","/g' | sed 's/$/"/' | sed 's/^/"/' >> data/produits.csv

