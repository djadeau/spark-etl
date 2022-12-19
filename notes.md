https://blogs.oracle.com/connect/post/deliver-oracle-database-18c-express-edition-in-containers
SELECT owner, table_name FROM dba_tables;


# Create Roles and so on
kubectl create role spark --verb=get,list,watch,create,delete --resource=pod,pods,deployment
kubectl create clusterrole spark --verb=get,list,watch,create,delete --resource=pod,pods,services,configmaps,deployment
kubectl create rolebinding spark --clusterrole=spark --serviceaccount=default:spark


#pyspark
from pyspark.sql import SparkSession
from datetime import datetime, date

spark = SparkSession.builder.getOrCreate()
df = spark.createDataFrame([
    Row(a=1, b=2., c='string1', d=date(2000, 1, 1), e=datetime(2000, 1, 1, 12, 0)),
    Row(a=2, b=3., c='string2', d=date(2000, 2, 1), e=datetime(2000, 1, 2, 12, 0)),
    Row(a=4, b=5., c='string3', d=date(2000, 3, 1), e=datetime(2000, 1, 3, 12, 0))
])


# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "3"
  creationTimestamp: "2022-12-19T13:54:36Z"
  generation: 3
  labels:
    app: my-dep
  name: my-dep
  namespace: default
  resourceVersion: "288235"
  uid: f7edd9b8-9022-4ee2-ad18-fac43a7505e6
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: my-dep
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: my-dep
    spec:
      containers:
      - command:
        - /bin/bash
        - -c
        - sleep 3600
        image: debian
        imagePullPolicy: Always
        name: debian
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      serviceAccount: spark
      serviceAccountName: spark
      terminationGracePeriodSeconds: 30
status:
  availableReplicas: 1
  conditions:
  - lastTransitionTime: "2022-12-19T14:07:17Z"
    lastUpdateTime: "2022-12-19T14:07:17Z"
    message: Deployment has minimum availability.
    reason: MinimumReplicasAvailable
    status: "True"
    type: Available
  - lastTransitionTime: "2022-12-19T13:54:36Z"
    lastUpdateTime: "2022-12-19T14:07:17Z"
    message: ReplicaSet "my-dep-5696cdb59f" has successfully progressed.
    reason: NewReplicaSetAvailable
    status: "True"
    type: Progressing
  observedGeneration: 3
  readyReplicas: 1
  replicas: 1
  updatedReplicas: 1

