#!/bin/bash


"$SPARK_PATH"/bin/spark-submit \
    --master k8s://https://$KUBE_HOST:$KUBE_PORT \
    --deploy-mode cluster \
    --name spark-pi \
    --class org.apache.spark.examples.SparkPi \
    --conf spark.executor.instances=3 \
    --conf spark.kubernetes.container.image=$SPARK_IMAGE \
    --conf spark.kubernetes.authenticate.submission.oauthTokenFile=/run/secrets/kubernetes.io/serviceaccount/token \
    local://$SPARK_APP

#--conf spark.kubernetes.authenticate.driver.serviceAccountName=spark
#--conf spark.kubernetes.authenticate.oauthToken=$KUBE_TOKEN \
#--conf spark.kubernetes.authenticate.driver.serviceAccountName=$KUBE_USER \
#--conf spark.kubernetes.context=$KUBE_CONFIG \ --> PAS BON
#--conf spark.kubernetes.authenticate.submission.caCertFile=$CERT_PATH  \
#--conf spark.kubernetes.authenticate.caCertFile=$CERT_PATH  \
#--conf spark.kubernetes.authenticate.driver.serviceAccountName=$KUBE_USER \