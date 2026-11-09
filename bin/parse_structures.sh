#!/bin/bash

echo "ID page INAO;Type structure;Nom structure;Label;Type structure;Nom structure;Contact;Email;Telephone;url" > data/produit_structures.csv

ls html/* | while read file ; do
	ID=$(echo $file | sed 's/[^0-9]//g')
	PRODUIT_NAME=$(grep "node-product--title" $file | sed 's/ *<[^>]*>//'  | sed 's/<.*//' )
	PRODUIT_TAG=$(grep "fr-tag" $file | sed 's/ *<[^>]*>//'  | sed 's/<.*//'  | head -n 1)
	PRODUIT_LABEL=$(grep -A 5 product-logo-label $file  | grep 'alt="' | head -n 1 | sed 's/.*alt="//'  | sed 's/".*//' )
	ODG=$(grep -A 10 '(ODG' $file | sed 's/<[^>]*>//g'   | tail -n +2 |  grep -i '[a-z]' | sed 's/^ *//' )
        ODG_CONTACT=$(grep -A 1000 '(ODG' $file | sed 's/<[^>]*>//g' | grep -B 1000 "Délégation territoriale" | tail -n +2  | grep -A 1 "Contact :"  | tail -n 1 | sed 's/^ *//'  | sed 's/ $//')
	ODG_TEL=$(grep -A 1000 '(ODG' $file | sed 's/<[^>]*>//g' | grep -B 1000 "Délégation territoriale" | grep -A 1 Tél | tail -n 1 | sed 's/^ *//'  | sed 's/ $//')
        ODG_EMAIL=$(grep -A 1000 '(ODG' $file | sed 's/<[^>]*>//g' | grep -B 1000 "Délégation territoriale" | grep @ | tail -n 1 | sed 's/^ *//'  | sed 's/ $//')
	OC=$( grep -A 10 '(OC)' $file | sed 's/<[^>]*>//g'   | tail -n +2 |  grep -i '[a-z]' | sed 's/^ *//'  )
        OC_CONTACT=$(grep -A 1000 '(OC' $file | sed 's/<[^>]*>//g' | grep -B 1000 "Page précédente" | tail -n +2  | grep -A 1 "Contact :"  | tail -n 1 | sed 's/^ *//'  | sed 's/ $//')
        OC_TEL=$(grep -A 1000 '(OC' $file | sed 's/<[^>]*>//g' | grep -B 1000 "Page précédente" | grep -A 1 Tél | tail -n 1 | sed 's/^ *//'  | sed 's/ $//')
        OC_EMAIL=$(grep -A 1000 '(OC' $file | sed 's/<[^>]*>//g' | grep -B 1000 "Page précédente" | grep @ | tail -n 1 | sed 's/^ *//'  | sed 's/ $//')
        INAO=$( grep -A 10 "Délégation territoriale" $file | sed 's/<[^>]*>//g'   | tail -n +2 |  grep -i '[a-z]' | sed 's/^ *//'  )
        INAO_CONTACT=$(grep -A 1000 'Délégation territoriale' $file | sed 's/<[^>]*>//g' | grep -B 1000 "(OC" | tail -n +2  | grep -A 1 "Contact :"  | tail -n 1 | sed 's/^ *//'  | sed 's/ $//')
        INAO_TEL=$(grep -A 1000 'Délégation territoriale' $file | sed 's/<[^>]*>//g' | grep -B 1000 "(OC" | grep -A 1 Tél | tail -n 1 | sed 's/^ *//'  | sed 's/ $//')
        INAO_EMAIL=$(grep -A 1000 'Délégation territoriale' $file | sed 's/<[^>]*>//g' | grep -B 1000 "(OC" | grep @ | tail -n 1 | sed 's/^ *//'  | sed 's/ $//')

	echo $ID";"$PRODUIT_NAME";"$PRODUIT_TAG";"$PRODUIT_LABEL";ODG;"$ODG";"$ODG_CONTACT";"$ODG_EMAIL";"$ODG_TEL";"$file | sed 's|html/|https://www.inao.gouv.fr/produit/|'
        echo $ID";"$PRODUIT_NAME";"$PRODUIT_TAG";"$PRODUIT_LABEL";OC;"$OC";"$OC_CONTACT";"$OC_EMAIL";"$OC_TEL";"$file | sed 's|html/|https://www.inao.gouv.fr/produit/|'
        echo $ID";"$PRODUIT_NAME";"$PRODUIT_TAG";"$PRODUIT_LABEL";INAO;"$INAO";"$INAO_CONTACT";"$INAO_EMAIL";"$INAO_TEL";"$file | sed 's|html/|https://www.inao.gouv.fr/produit/|'
done | sed 's/&#039;/'"'"'/g' | sed -i 's/&quot;//g' >> data/produit_structures.csv
