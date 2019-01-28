#!/usr/bin/perl

use HTML::Entities;

$is_odg = 0;
$is_contact = 0;
$is_adresse = 0;
while(<STDIN>) {
	foreach (split(/<br *\/*>/)) {
		foreach (split(/<\/p>/)) {

		$id = $1 if (!$id && /\/produit\/([0-9]+)/);
		$motscles = $1 if (!$motscles && /strong>Mots-clés<.strong> : ([^<]*)<.li>/);
		$produit = $1 if (!$produit && /strong>Produit<.strong> : ([^<]*)<.li>/);


		$is_odg = 1 if(/Organisme de défense et de gestion/);
		$is_odg = 0 if(/(Organisme.s. de contrôle|Site INAO)/);
		next unless($is_odg);

#		print STDERR "DEBUG: $_\n";

		s/ ; / - /g;

		$nom = $1 if (/<h4>([^<]*)</i);
		$is_adresse = 1 if (!$is_adresse && $nom && s/.*<p>//);
		$adresse .= $_ if ($is_adresse);
		$is_adresse = 0 if ($is_adresse && (/<p>/i));

		$tel = $1 if (/<strong>Tel *: *<.strong> *([^<]*)/i);
		$fax = $1 if (/<strong>Fax *: *<.strong> *([^<]*)/i);
		$siret = $1 if (/<strong>N°SIRET *: *<.strong> *([^<]*)/i);
		$prez = $1 if (/<strong>Président[^<]*<.strong> *([^<]*)/i);
		$reconnaissance = $1 if (/Décision de reconnaissance n°([^<]*) */i);

		$is_contact = 1 if (s/<strong>Contact :[^<]*<.strong>//i);
		$contact .= $_ if ($is_contact);
		$is_contact = 0 if ((/<\/p>/i) && $is_contact);
	}}
}
$contact =~ s/\s\s*/ /g;
$contact =~ s/<p>//g;
$contact =~ s/;/ /g;

$adresse =~ s/\s\s*/ /g;
$adresse =~ s/<p>.*//g;
$adresse =~ s/<[^>]*>//g;

$contact_mail = $1 if ($contact =~ /(\S*@\S*)/);
$contact_nom = $contact;
$contact_nom =~ s/$contact_mail//gi;
$contact_nom =~ s/[:]/ /g;
$contact_nom =~ s/  */ /g;

$reconnaissance =~ s/[\r\n]//g;

$ligne = decode_entities("$id;$produit;$nom;$siret;$adresse;$tel;$fax;$contact_nom;$contact_mail;$reconnaissance;$prez;$motscles;\n");
$ligne =~ s/ *; */;/g;
print $ligne;
#print "$contact\n";
