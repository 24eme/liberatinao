#!/bin/bash

echo "id;produit;nom;siret;adresse;tel;fax;contact_nom;contact_mail;reconnaissance;prez;motscles" > data/odg.csv
ls html/* | while read file ; do perl bin/parse_one_odg.pl < $file ; done >> data/odg.csv
