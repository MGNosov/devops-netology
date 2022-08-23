FROM centos:7

EXPOSE 9200 9300

EXPOSE 5601 5601

RUN yum install wget -y

RUN yum install perl-Digest-SHA1 -y

RUN cd /usr/local/src

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.3.3-linux-x86_64.tar.gz

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.3.3-linux-x86_64.tar.gz.sha512

RUN sha512sum -c elasticsearch-8.3.3-linux-x86_64.tar.gz.sha512

RUN tar -xzf elasticsearch-8.3.3-linux-x86_64.tar.gz

RUN mkdir /usr/local/elasticsearch

RUN mv elasticsearch-8.3.3 /usr/local/elasticsearch

RUN cd /usr/local/elasticsearch/

RUN useradd elasticsearch

RUN chown -R elasticsearch:elasticsearch /usr/local/elasticsearch

RUN mkdir /var/lib/elasticsearch && chown elasticsearch:elasticsearch /var/lib/elasticsearch/

RUN mkdir /var/log/elasticsearch && chown elasticsearch:elasticsearch /var/log/elasticsearch/

ENV ES_HOME="/usr/local/elasticsearch/elasticsearch-8.3.3"
ENV ES_PATH_CONF="/usr/local/elasticsearch/elasticsearch-8.3.3/config"

RUN cd /usr/local/elasticsearch

RUN wget https://artifacts.elastic.co/downloads/kibana/kibana-8.3.3-linux-x86_64.tar.gz

RUN wget https://artifacts.elastic.co/downloads/kibana/kibana-8.3.3-linux-x86_64.tar.gz.sha512

RUN sha512sum -c kibana-8.3.3-linux-x86_64.tar.gz.sha512

RUN tar -xzf kibana-8.3.3-linux-x86_64.tar.gz

RUN mkdir /usr/local/kibana

RUN mv kibana-8.3.3 /usr/local/kibana

RUN yum install epel-release -y

RUN yum install nginx -y

WORKDIR ${ES_HOME}
