# LiberatINAO

Ce projet vise à libérer en Open Data des données provenant de l'INAO.

Il intégère aussi les codes INAO utilisés par la douane pour sont application DRM CIEL.

[Interface de consultation des produits CIEL](https://io.24eme.fr/liberatinao/www/)

Les données récupérées dans ce projet sont mis à disposition dans deux fichiers CSV :

* [Les vins (data/vins.csv)](data/vins.csv)
* [Les autres (data/nonvins.csv)](data/nonvins.csv)

## Doc

### Mise à jour référentiel CIEL

Pour mettre à jour le référenciel CIEL, il faut :

 - se connecter sur le portail de la douane
 - se rentre sur l'application CIEL https://douane.gouv.fr/cielinternet/CielInternet.html
 - interroger la page https://douane.gouv.fr/cielinternet/cielinternet/secured/downloadExportReferentielInaoServlet

