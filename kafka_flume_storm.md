# flume+kafka+storm

---
flume+kafka+storm 实现大批量日志实时分析处理


|软件|位置|说明|
|-|-|-|
|kafka|/opt/kafka|官方：http://kafka.apache.org/|
|flume|/opt/apache-flume|官方：http://flume.apache.org/|
|storm|/opt/storm|官方：http://storm.apache.org/|

部署
|软件|部署|说明|
|-|-|-|
|kafka|暂用2台，使用集群 | 可动态扩展|
|flume|api所在的服务器 |每台机子可以部署多个agent，可动态扩展|
|storm|在新加的机子上 2台以上 |可动态扩展|


*** apache 一系列 全面兼容，网址看着就爽 ***

kafka，flume，storm 安装官方要求直接下载源码 直接可以运行

storm 安装暂时忽略 以前已经说明了

###flume 收集日志配置[修改配置不用重启服务]
```
agent1.sources = source1
agent1.channels = channel1

##使用 tail命名监控日志 建议使用-F
agent1.sources.source1.type = exec 
agent1.sources.source1.command = tail -Fn 0 /data/log/jiemo-api/access.log
agent1.sources.source1.channels = channel1
agent1.sources.source1.batchSize = 1

##开启kafka传输
agent1.channels.channel1.type =  org.apache.flume.channel.kafka.KafkaChannel
agent1.channels.channel1.keep-alive = 15
agent1.channels.channel1.capacity = 500
agent1.channels.channel1.zookeeperConnect=zk.d.jiemoapp.com:2181
agent1.channels.channel1.brokerList=10.10.5.11:7092
agent1.chnnnels.channel1.topic= zkkafkaspout-topic
agent1.channels.channel1.transactionCapacity = 100
```


然后启动  
```
bin/flume-ng agent -c conf -f conf/jiemo-api.properties  -n agent1 -Dflume.root.logger=INFO,console&
```


##开启kafka

其中server.properties配置修改如下[内网9092端口被我们自己用了，开始把我坑住了]
```
……
listeners=PLAINTEXT://:7092
zookeeper.connect=zk.d.jiemoapp.com:2181
……

```


开启服务
```
 bin/kafka-server-start.sh config/server.properties
```

如果没有topic 需要新建
```
bin/kafka-topics.sh --create --zookeeper 10.174.10.234:2181 --replication-factor 1 --partitions 1 --topic zkkafkaspout-topic 
```

###对接storm

见 jiemo-storm develop 分支


其中config 变成了 flume-channel 这个有点郁闷  以为是自己去的名字zkkafkaspout_topic



###开始测试
在10.10.5.11 运行2个flume agent 【其实一台服务器可以合并，这里做测试用】
```
bin/flume-ng agent -c conf -f conf/jiemo-api.properties  -n agent1 -Dflume.root.logger=DEBUG,console ##监控api access log

bin/flume-ng agent -c conf -f conf/jiemo-admin.properties  -n agent1 -Dflume.root.logger=DEBUG,console ##监控admin access log
```

然互开启kafka
运行 jiemo-storm 的 LogStatTopology 本地模式

在本机本地运行
打印log发现  是实时收集的api 和 admin log 如下 [开头乱码  稍后解决]


能收集到log 那么随后就可以分析了  嘎嘎嘎


该套日志分析优点是：与我们服务完全独立，我们可以随时的更改统计而不影响我们的在线服务


