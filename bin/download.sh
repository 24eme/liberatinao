#!/bin/bash
mkdir -p tmp html
curl -s https://www.inao.gouv.fr/Espace-professionnel-et-outils/Rechercher-un-produit | sed 's|\(</*option\)|\n\1|g' | grep '^<option' | grep dep | sed 's/.*value="//' | sed 's/".*//' | while read dep ; do 
        for (( i = 0 ; i < 100 ; i++)) ; do
	curl -s "https://www.inao.gouv.fr/Espace-professionnel-et-outils/Rechercher-un-produit?actimage_design_product_type%5BsearchType%5D=product&actimage_design_product_type%5Bdepartement%5D="$dep"&page="$i > tmp/$$.html
        cat tmp/$$.html | sed 's|</li>|</li>\n|g' | grep '/produit/' | sed 's/.*href=.//' | sed 's/".*//' 
        if ! grep 'a class="next' tmp/$$.html > /dev/null ; then
		break;
	fi
        done
done > tmp/produit_inao.list

rm tmp/$$.html

sort -u tmp/produit_inao.list > tmp/produit_inao.uniq.list

wget -nc -i tmp/produit_inao.uniq.list -P html/

