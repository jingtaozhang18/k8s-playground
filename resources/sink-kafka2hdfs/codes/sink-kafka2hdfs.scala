import org.apache.kafka.clients.admin.{Admin}
import java.util.{Properties}

var properties = new Properties()
properties.setProperty("bootstrap.servers", "bitnami-kafka.infra.svc.cluster.local:9092")
var admin = Admin.create(properties)
var topic_names = admin.listTopics().names().get()

var timestamp_long = System.currentTimeMillis().toString()

topic_names.forEach(x => {
        var df = spark.read
            .format("kafka")
            .option("kafka.bootstrap.servers", "bitnami-kafka.infra.svc.cluster.local:9092")
            .option("subscribe", x)
            .load()
        df = df.withColumn("key", col("key").cast("string"))
        df = df.withColumn("value", col("value").cast("string"))
        df.write.format("json").mode("overwrite").save(f"hdfs://gradiant-hdfs-namenode.infra.svc.cluster.local:8020/kafka_content_sink/$timestamp_long/$x")
        df.write.format("json").mode("overwrite").save(f"hdfs://gradiant-hdfs-namenode.infra.svc.cluster.local:8020/kafka_content_sink/latest/$x")
})

println(f"timestamp_long: $timestamp_long")
