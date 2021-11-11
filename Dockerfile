FROM python:3.8-buster

USER root
WORKDIR /app

RUN apt-get update && apt-get -y install git ant && pip install -U pip
RUN pip install acdh-tei-pyutils==0.17.0

COPY . .
RUN add-attributes -g "/app/data/editions/*.xml" -b "https://id.acdh.oeaw.ac.at/schnitzler/schnitzler-briefe/editions" \
    && add-attributes -g "/app/data/indices/list*.xml" -b "https://id.acdh.oeaw.ac.at/schnitzler/schnitzler-briefe/indices"
RUN mentions-to-indices -t "erwähnt in " -i "./data/indices/*.xml" -f "./data/editions/*.xml" -x ".//tei:title[@level='a']/text()"
RUN find /app/data/editions/ -type f -name "*.xml" -print0 | xargs -0 sed -i -e 's|../../XML/META/asbwschema.xsd"|https://id.acdh.oeaw.ac.at/schnitzler/schnitzler-briefe/meta/asbwschema.xsd"|g'
RUN ant -f /app/build.xml

# START STAGE 2
FROM acdhch/existdb:5.3.0-java11-ShenGC

COPY --from=0 /app/build/*.xar /exist/autodeploy

EXPOSE 8080 8443

RUN [ "java", \
    "org.exist.start.Main", "client", "-l", \
    "--no-gui",  "--xpath", "system:get-version()" ]

CMD [ "java", "-jar", "start.jar", "jetty" ]
