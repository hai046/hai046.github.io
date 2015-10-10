# ganglia 安装



###服务端 ganglia
命令：
```yum install ganglia ganglia-gmetad ganglia-web ganglia-gmond ```

修改配置
```/etc/ganglia/gmetad.conf```


修改文件/etc/ganglia/gmetad.conf

>data_source "jiemo_ganglia_cluster" localhost
setuid_username ganglia

### 创建rrds目录
  mkdir -p /var/lib/ganglia/rrds
  chown ganglia:ganglia /var/lib/ganglia/rrds
  chmod a+w /var/lib/ganglia/rrds
  
###客户端 ganglia-gmond

命令：
```yum install ganglia ganglia-gmond```

修改配置
```vim /etc/ganglia/gmond.conf ```

>\#1,修改名字
cluster {
  name = "JiemoApp-ganglia"
  }


>\#2修改描述
host {
        location = "grape"
    }
    
>\#3 修改发送到服务器的配置
udp_send_channel {
  host=10.44.138.0
  port = 8649
  ttl = 1
 }
 
>\#4接收配置
udp_recv_channel {
  port = 8649
  }
    
####启动
```service gmond start//启动
    service gmond status//查看状态 ```


##参考资料
>1. 安装php支持
 yum install php-common php-cli php-gb php
 
 >2. 安装ganglia及其相关组件
server端：yum install rrdtool rrdtool-devel ganglia-web ganglia-gmetad ganglia-gmond ganglia-gmond-python httpd apr-devel zlib-devel libconfuse-devel expat-devel pcre-devel 
client端：yum install ganglia-gmond
 
>3. 相关配置
  修改/etc/ganglia/gmond.conf
 cluster {
   name = "Cynric"  //这个是整个集群的名字
 }
 
> dup_send_channel {
  host = 127.0.0.1  // host为单播模式  mcast_join为多播模式
 }
 
> udp_recv_channel {
  port = 8649   // 如果是用单播模式则要删除mcast_join和bind两个选项
 }
 
> 客户端
 修改文件/etc/ganglia/gmetad.conf
 data_source "jiemoapp_ganglia" localhost   //Cynric是gmond.conf中cluster里name的名字  localhost则需要是服务器端的ip
 
> setuid_username "ganglia"
 
>4. 创建rrds目录
  mkdir -p /var/lib/ganglia/rrds
  chown ganglia:ganglia /var/lib/ganglia/rrds
  chmod a+w /var/lib/ganglia/rrds
 
>5. 关闭SELinux不然无法访问监控的web的页面
   vi /etc/selinux/config
   SELINUX=disable
   以上方法需要重启机器
 
>  可以在终端上直接输入setenforce 0即可
 
>6. 启动相关服务
   service gmond restart
   service gmetad restart
   service httpd restart
 
>7. 浏览器中输入127.0.0.1/ganglia检验是否成功
 
>8. 遇到相关问题请查看http://blog.csdn.net/cybercode/article/details/6210444
