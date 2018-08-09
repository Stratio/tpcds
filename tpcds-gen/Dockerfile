FROM qa.stratio.com/stratio/hadoop:2.7.2
MAINTAINER Stratio Crossdata team "crossdata@stratio.com"

# USAGE: docker build -t <docker-name> <output-path>
# USAGE Example: docker build -t tpcds-hdfs .

RUN apt-get update \ 
	&& apt-get -y install apt-utils \
	&& apt-get -y install git

RUN wget -q http://apache.mirrors.lucidnetworks.net/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz \
	&& mkdir -p /usr/local/apache-maven \
	&& mv apache-maven-3.3.9-bin.tar.gz /usr/local/apache-maven \
	&& cd /usr/local/apache-maven \
	&& tar -xzvf apache-maven-3.3.9-bin.tar.gz

RUN git clone https://github.com/Stratio/tpcds.git \
	&& cd tpcds \
	&& /usr/local/apache-maven/apache-maven-3.3.9/bin/mvn clean package

RUN wget -q https://d3kbcqa49mib13.cloudfront.net/spark-2.2.2-bin-hadoop2.7.tgz \
	&& tar xzfv spark-2.2.2-bin-hadoop2.7.tgz \
	&& rm spark-2.2.2-bin-hadoop2.7.tgz

COPY docker-entrypoint.sh /
COPY tpcds-entrypoint.sh /

EXPOSE 4040 9000 50070

ENTRYPOINT ["/docker-entrypoint.sh"]
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64
     
