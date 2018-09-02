
neo4j的docker镜像，安装了apoc插件，注释掉了：`VOLUME /data`；

git clone https://github.com/neo4j/docker-neo4j-publish.git

cp -r docker-neo4j-publish/3.4.6/community neo4j-ce-alpine

curl -o neo4j-ce-alpine/local-package/apoc-3.4.0.2-all.jar https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/3.4.0.2/apoc-3.4.0.2-all.jar


