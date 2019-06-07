## Contruire le contener
```bash
sudo docker build -t php:5.6 .
 ```

## Lancer le conteneur
```bash 
sudo docker run -it --rm --name "php5.6" -p 80:80 -p 443:443 -v `pwd`/www:/var/www -v `pwd`/config/sites-available:/etc/apache2/sites-available php:5.6
```

La mise en place des volume se fera alors sur les dossiers locaux présents au niveau du fichier Dockerfile. Il est possible de monter les volumes autres part dans la mesure ou les fichiers présents y sont copiés.

Le conteneur est configuré pour lancer automatiquement un terminal a son amorçage.

## Ouvrir un terminal sur le conteneur

Identifier le CONTAINER ID à l'aide de la commande
```bash
 sudo docker ps | grep php5.6
 ```

S'il n'y a aucun résultat, c'est que le conteneur n'est pas lancé.

Puis ouvrez un terminal dans le conteneur avec la commande suivante :
```bash
sudo docker exec -ti <container_id> bash
```

## Stopper le conteneur

Identifier le CONTAINER ID à l'aide de la commande
```bash
sudo docker ps | grep php5.6
```

S'il n'y a aucun résultat, c'est que le conteneur n'est pas lancé.

Puis stoppez le conteneur
```bash
sudo docker stop <container_id>
```
