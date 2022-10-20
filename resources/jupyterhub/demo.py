import socket
hostname = socket.gethostname()
local_ip = socket.gethostbyname(hostname)
print(f"hostname: {hostname}, ip: {local_ip}")

# Import SparkSession
from pyspark.sql import SparkSession

# Pacakges

jar_packages = [
    "org.apache.spark:spark-sql-kafka-0-10_2.12:3.2.1",
    "io.delta:delta-core_2.12:1.2.1",
    "org.mongodb.spark:mongo-spark-connector_2.12:3.0.2"
]


# Create SparkSession 
spark = SparkSession.builder \
    .master("spark://bitnami-spark-master-svc.infra.svc.cluster.local:7077") \
    .config("spark.driver.host", f"{local_ip}") \
    .config("spark.jars.packages", ",".join(jar_packages)) \
    .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension") \
    .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog") \
    .appName("DemoTrst-V1") \
    .getOrCreate()

person_infos_df = spark.read.json("hdfs://gradiant-hdfs-namenode.infra.svc.cluster.local:8020/kafka_content_sink/latest/db_world_v2.db_world.person_infos")
cnt = person_infos_df.count()
print(cnt)