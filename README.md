[![Build, Release](https://github.com/acdh-oeaw/schnitzler-briefe/actions/workflows/build.yml/badge.svg)](https://github.com/acdh-oeaw/schnitzler-briefe/actions/workflows/build.yml)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5555918.svg)](https://doi.org/10.5281/zenodo.5555918)

# this is obsolete. the current repositories are https://github.com/arthur-schnitzler/schnitzler-briefe-data and https://github.com/arthur-schnitzler/schnitzler-briefe-static


# Arthur Schnitzler – Briefwechsel mit Autorinnen und Autoren

Quellcode der Website:
https://schnitzler-briefe.acdh.oeaw.ac.at

Transkriptionen von

* Martin Anton Müller (@martinantonmueller) 

* Gerd-Hermann Susen (2018–2021)

Die Transkriptionen der Korrespondenzstücke finden sich im Ordner /editions/data

Die Web-Applikation basierend auf der DSE Base App (https://github.com/KONDE-AT/dsebaseapp) wurde unterstützt durch: 
* Peter Andorfer (@csae8092)
* Ingo Börner (@ingoboerner)
* Thomas Klampfl (@tklampfl)

## Funding

FWF-Projekte:
P 31277 (2018–2021)
P 34792 (2021–2024)

## Rights
Die Daten unterliegen der https://de.wikipedia.org/wiki/MIT-Lizenz

Zusätzlich sei darauf verwiesen, dass das nicht heißt, dass die Texte der jeweiligen Autorinnen und Autoren frei verfügbar sind. Im Zweifel sind die Rechte mit den Rechteinhabern von Schreibpartnerinnen und Schreibpartnern, die vor weniger als 70 Jahren verstorben sind, mit den jeweiligen Erben zu klären.


## Install (no docker)

1. clone the repo `git clone https://github.com/acdh-oeaw/schnitzler-briefe.git`
1. enter the repo and init and update the submodules `cd schnitzler-briefe && git submodule init && git submodule update`
1. build the application `ant` -> creates a `.xar` in the `build` directory
1. install this `.xar` package via eXist-db Package Manager

## Install (with docker)

1. build the image with `docker image build -t sb:latest .`
1. run the image with `docker run -it -d -p 8080:8080 -p 8443:8443 --name sb sb:latest`
1. bind-mount log-file-dir `docker run -it -d -p 8080:8080 -p 8443:8443 -v $(pwd)/logs:/exist/logs --name sb sb:latest`
1. inpect logs with `docker container logs --follow sb`
1. run image from dockerub `docker run -it -p 8080:8080 -p 8443:8443 --name sb acdhch/schnitzler-briefe`

