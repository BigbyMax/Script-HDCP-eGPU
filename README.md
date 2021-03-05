# iGPU auto switcher for HDCP on eGPU
## _Un script powershell pour (dés)activer la partie graphique Intel (iGPU) lors de la connexion et la déconnexion d'une partie graphique externe (eGPU)_



[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

Il arrive que la partie graphique Intel entre en conflit avec une partie graphique externe (dans mon cas l’Aorus Gaming Box 1080) pour la lecture de contenus protégés. Des saccades empêchent le confort de lecture et il faut désactiver la partie graphique interne du portable pour que tout se lise sans accro. 
Mais voilà, devoir se rendre dans le gestionnaire de fichiers chaque fois que l’on branche et qu’on débranche son eGPU n’est pas pratique. 
C’est pourquoi j’ai concocté ce script PowerShell, qui peut encore être amélioré. Il permet de détecter quand l’eGPU vient d’être branché et désactive la partie graphique intégrée Intel. 
Il n’est pas très complexe, il marche plutôt bien mais il arrive que le changement de partie graphique fasse planter l’ordinateur. Cela n’a généralement aucune incidence une fois la machine redémarrée.

## Features

- Permet de désactiver l'iGPU en branchant un eGPU.
- Permet d'activer l'iGPU en débranchant un eGPU.

## Requis

Pour réaliser ce projet, il faut utiliser *Powershell* et le *Planificateur de tâches*, ce script ne fonctionnera donc que sur Windows.


And of course Dillinger itself is open source with a [public repository][dill] GitHub.

## Installation
### Partie 1
Pour pouvoir avoir cette automatisation, il faut d’abord identifier les parties graphiques qui se disputent Netflix. Il suffit de se rendre sur le [Gestionnaire de périphériques] (clic droit sur le bouton Windows)
![alt text](https://github.com/BigbyMax/Script-HDCP-eGPU/blob/main/images/gdp.jpg?raw=true)
puis de développer [Cartes graphiques] 
![alt text](https://github.com/BigbyMax/Script-HDCP-eGPU/blob/main/images/gdp2.jpg?raw=true)

### Partie 2 
En faisant clic droit sur les appareils, rendez-vous dans les propriétés et puis dans l’onglet [Détails]. Cliquez sur [Propriétés] et sur [Chemin d’accès à l’instance du périphérique]. Vous devriez avoir une valeur qui commence par *PCI\VEN_*. Notez la valeur donnée quelque part, en précisant bien lequel est la partie graphique Intel et lequel est l’eGPU. 

### Partie 3
C’est maintenant que cela devient un peu plus délicat. Vous allez devoir modifier le script en question. Lancez [Powershell ISE], ensuite appuyez sur [Fichier] et sélectionnez [Ouvrir]. De là, localisez le fichier [script_eGPU.ps1] et ouvrez-le. 

Une fois devant le script, ne paniquez pas. Il suffit de localiser toutes les instances marquées <eGPU> et <GPU_Intel>. On retrouve <GPU_Intel> quatre fois (ligne 17, ligne 23, ligne 34 et ligne 43) et <eGPU> trois fois (ligne 17, ligne 19 et ligne 32).
![alt text](https://github.com/BigbyMax/Script-HDCP-eGPU/blob/main/images/ps.jpg?raw=true)
Remplacez toutes les instances <eGPU> par la valeur *PCI\VEN_* de l’eGPU notée plus tôt. Remplacez tous les instances <GPU_Intel> par la valeur PCI\VEN_ de la partie graphique Intel notée plus tôt. Enregistrez les modifications et quittez [Powershell ISE].

Voilà, vous avez un script fonctionnel, désormais il faut le configurer pour qu’il puisse tourner toujours en tâche de fond. 

### Partie 4
Tout commence en lançant le [Planificateur de tâches]. Il y a beaucoup d’informations, c’est même peut-être intimidant mais il n’y a aucune crainte à avoir. Tout en haut de la fenêtre se trouve le menu [Action] qui nous intéresse. 
![alt text](https://github.com/BigbyMax/Script-HDCP-eGPU/blob/main/images/pdt.jpg?raw=true)
Ce menu nous permet d’accéder à la fonction qui nous intéresse aujourd’hui, [Créer une tâche]. Donnez à cette tâche un nom reconnaissable et ne lésinez pas sur la description. 
![alt text](https://github.com/BigbyMax/Script-HDCP-eGPU/blob/main/images/pdt2.jpg?raw=true)
Veillez à cocher [Exécuter même si l’utilisateur n’est pas connecté] et |Exécuter avec les autorisations maximales].

Dans la partie [Déclencheurs], vous pouvez choisir de faire comme moi et de lancer la tâche [Au démarrage]. Validez et passez à l’onglet [Actions].
![alt text](https://github.com/BigbyMax/Script-HDCP-eGPU/blob/main/images/pdt3.jpg?raw=true)
Vérifier que le champ Action est bien réglé sur Démarrer un programme. Dans le champ Programme/script, collez cette ligne :
```sh
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
```
Puis, dans la partie Ajouter des arguments, collez la ligne suivante en prenant bien soin de remplacer les parties adéquates :
```sh
-WindowStyle Hidden -ExecutionPolicy Unrestricted -File "C:\Users\NomDuUser\CheminJusqu’auScript\script_eGPU.ps1" 
```
SANS ignorer les guillemets !
![alt text](https://github.com/BigbyMax/Script-HDCP-eGPU/blob/main/images/pdt4.jpg?raw=true)

Accrochez-vous, nous allons bientôt en voir le bout. Dans l’onglet [Conditions], décochez tout, puis passez à [Paramètres].
![alt text](https://github.com/BigbyMax/Script-HDCP-eGPU/blob/main/images/pdt5.jpg?raw=true)

Ici, à peu près tout est déjà réglé, il vous suffit de cocher [Exécuter la tâche dès que possible si un démarrage planifié est manqué], parce qu’on n'est jamais trop prudent. 
![alt text](https://github.com/BigbyMax/Script-HDCP-eGPU/blob/main/images/pdt6.jpg?raw=true)
En cliquant sur [OK] et en redémarrant votre machine, tout devrait fonctionner. Vous n’avez plus à lancer le gestionnaire de périphériques chaque fois que vous voulez regarder Netflix ou Amazon Prime Video avec votre eGPU branché !