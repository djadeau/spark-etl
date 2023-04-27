FROM ubuntu:22.04 as builder

RUN apt-get update && \
    apt-get install -y curl openjdk-17-jre wget 

ARG KEYSTORE_PASSWORD
         
ENV SPARK_VERSION=3.4.0
ENV HADOOP_VERSION=3
ENV SPARK_HOME=/opt/spark
ENV PYTHONHASHSEED=1 
ENV KEYSTORE_PASSWORD=${KEYSTORE_PASSWORD}

RUN wget --no-verbose -O apache-spark.tgz "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" \
&& mkdir -p ${SPARK_HOME} \
&& tar -xf apache-spark.tgz -C ${SPARK_HOME} --strip-components=1 \
&& rm apache-spark.tgz \
&& wget --no-verbose https://download.oracle.com/otn-pub/otn_software/jdbc/219/ojdbc11.jar --directory-prefix=/opt/spark/jars/ \
&& wget --no-verbose https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.2/hadoop-aws-3.3.2.jar --directory-prefix=/opt/spark/jars/ \
&& wget --no-verbose https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.901/aws-java-sdk-bundle-1.11.901.jar --directory-prefix=/opt/spark/jars/


COPY ca.crt /tmp

RUN keytool -import -cacerts -trustcacerts -alias ca -noprompt -file /tmp/ca.crt -storepass ${KEYSTORE_PASSWORD} \
&& rm -f /tmp/ca.crt

FROM builder as apache-spark

WORKDIR /opt/spark

COPY *.jar ./jars/

ENV SPARK_MASTER_PORT=7077 \
SPARK_MASTER_WEBUI_PORT=8080 \
SPARK_LOG_DIR=/opt/spark/logs \
SPARK_MASTER_LOG=/opt/spark/logs/spark-master.out \
SPARK_WORKER_LOG=/opt/spark/logs/spark-worker.out \
SPARK_WORKER_WEBUI_PORT=8080 \
SPARK_WORKER_PORT=7000 \
SPARK_MASTER="spark://spark-master:7077" \
SPARK_WORKLOAD="master"

EXPOSE 8080 7077 6066

RUN mkdir -p $SPARK_LOG_DIR && \
touch $SPARK_MASTER_LOG && \
touch $SPARK_WORKER_LOG && \
ln -sf /dev/stdout $SPARK_MASTER_LOG && \
ln -sf /dev/stdout $SPARK_WORKER_LOG

COPY start-spark.sh /

CMD ["/bin/bash", "/start-spark.sh"]
