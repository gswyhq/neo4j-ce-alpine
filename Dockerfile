FROM openjdk:8-jre-alpine

RUN addgroup -S neo4j && adduser -S -H -h /var/lib/neo4j -G neo4j neo4j

ENV NEO4J_SHA256=8302c45ba4efa14ee5019120a6dd9f8cd1ff61c2b6b0012e7dfebe73b5207e2d \
    NEO4J_TARBALL=neo4j-community-3.4.6-unix.tar.gz \
    NEO4J_EDITION=community


# ARG NEO4J_URI=http://dist.neo4j.org/neo4j-community-3.4.6-unix.tar.gz
ARG NEO4J_URI=https://neo4j.com/artifact.php?name=neo4j-community-3.4.6-unix.tar.gz
#COPY ./local-package/* /tmp/

RUN apk add --no-cache --quiet \
    bash \
    curl \
    tini \
    wget \
    su-exec \
    && curl --fail --silent --show-error --location -o ${NEO4J_TARBALL} ${NEO4J_URI} \
    && echo "${NEO4J_SHA256}  ${NEO4J_TARBALL}" | sha256sum -csw - \
    && tar --extract --file ${NEO4J_TARBALL} --directory /var/lib \
    && mv /var/lib/neo4j-* /var/lib/neo4j \
    && rm ${NEO4J_TARBALL} \
    && mv /var/lib/neo4j/data /data \
    && chown -R neo4j:neo4j /data \
    && chmod -R 777 /data \
    && chown -R neo4j:neo4j /var/lib/neo4j \
    && chmod -R 777 /var/lib/neo4j \
    && ln -s /data /var/lib/neo4j/data \
    && mkdir /plugins \
    && wget -c -t 0 -O /plugins/apoc-3.4.0.2-all.jar https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/3.4.0.2/apoc-3.4.0.2-all.jar \
    && apk del curl wget

ENV PATH /var/lib/neo4j/bin:$PATH

WORKDIR /var/lib/neo4j

#VOLUME /data


COPY docker-entrypoint.sh /docker-entrypoint.sh


EXPOSE 7474 7473 7687

ENTRYPOINT ["/sbin/tini", "-g", "--", "/docker-entrypoint.sh"]
CMD ["neo4j"]

# docker build -t neo4j-alpine-3.4.6 -f Dockerfile .
