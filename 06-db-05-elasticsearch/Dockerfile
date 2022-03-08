FROM centos:7

ENV PATH=/usr/lib:/elasticsearch-8.0.1/jdk/bin:/elasticsearch-8.0.1/bin:$PATH

RUN yum install -y perl-Digest-SHA

RUN curl -o elasticsearch-8.0.1-linux-x86_64.tar.gz https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.0.1-linux-x86_64.tar.gz && \
    curl -o elasticsearch-8.0.1-linux-x86_64.tar.gz.sha512 https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.0.1-linux-x86_64.tar.gz.sha512 && \
    shasum -a 512 -c elasticsearch-8.0.1-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-8.0.1-linux-x86_64.tar.gz && \
    rm elasticsearch-8.0.1-linux-x86_64.tar.gz && \
    rm elasticsearch-8.0.1-linux-x86_64.tar.gz.sha512

ENV ES_HOME=/elasticsearch-8.0.1

RUN groupadd -g 1000 elasticsearch && useradd elasticsearch -u 1000 -g 1000

RUN mkdir /var/lib/elasticsearch

WORKDIR /var/lib/elasticsearch

RUN set -ex && for path in data logs config config/scripts; do \
        mkdir -p "$path"; \
        chown -R elasticsearch:elasticsearch "$path"; \
    done

RUN mkdir /elasticsearch-8.0.1/snapshots && \
    chown -R elasticsearch:elasticsearch /elasticsearch-8.0.1

COPY logging.yml /elasticsearch-8.0.1/config/
COPY elasticsearch.yml /elasticsearch-8.0.1/config/

USER elasticsearch

CMD ["elasticsearch"]

EXPOSE 9200 9300