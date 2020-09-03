# locust-plus

locust-plus 是根据《Locust+Prometheus+Grafana 搭建性能监控平台》这篇文章完成的一个 docker 集群配置文件集。主要目的是为了简化使用这个监控方案的部署。

感谢原始方案作者 **见欢** ：https://bugvanisher.cn/2020/04/05/locust-with-prometheus-and-grafana/

### 启动 locust-plus

#### 方法一：使用 docker-compose 启动 locust-plus

本方法需要提前安装部署好 docker-compose 程序，docker 集群配置使用工程内的 docker-compose.yml 文件

```bash
sudo docker-compose up  # 前台启动 locust-plus 集群
sudo docker-compose up -D  # 后台启动 locust-plus 集群
sudo docker-compose down. # 停止当前 locust-plus 集群
```

#### 方法二：使用 docker swarm 启动 locust-plus

1. 创建一个 docker swarm 集群（如原来已经是 docker swarm 集群里的话，跳过此步骤）

   ```bash
   docker swarm init
   ```

2. 构建 locust-plus 的 locust master 镜像

   > 默认使用工程目录下的 dockerfile 进行镜像构建

   ```bash
   docker build -t locust-plus .
   ```

3. 启动 locust-plus

   ```bash
   docker stack deploy -c stack.yml LocustPlus  # 启动 locust-plus 集群
   docker stack rm LocustPlus  # 停止 locust-plus 集群
   ```

### 配置 Grafana 监控面板

1. 打开 Grafana http://127.0.0.1:3000/ 并登陆，默认用户名：admin 密码：admin

2. 添加 **数据源:**

   DATA SOURES —— Prometheus —— URL [ http://prometheus:9090 ] —— Save&Test

3. 添加**监控面板：**

   图标➕弹出菜单 —— Import —— Import via grafana.com [ 12081 ] —— Load —— Prometheus 下拉选择 [ Prometheus ]

4. 查看面板**Locust for Prometheus**

   右上角即可选择不同的时间段的数据了。

### 测试 locust-plus

1. 打开 locust web UI http://127.0.0.1:8089/，在打开页面使用 locust 测试；

   > 默认使用工程目录下的 locustfile.py 进行测试，可根据需要更改。具体使用方法请参考 lcosut 使用方法。

2. 再次打开 Grafana 查看是否成功记录下测试数据数据

   如果能成功看到历史数据，那 locust-plus 即完成成功部署完成。后续使用可以将 docker-compose.yml 或 stack.yml 配置文件中的`worker`相关的配置注释掉，再重启 locust-plus 集群使用。

### 使用 locust-plus 之外的 locust slave 节点

1. 确认 locust-plus 开放端口：**5557**

   > docker-compose.yml 或 stack.yml 配置文件中的`master`的`ports:`是否开放了端口**5557**

2. 使用 locust-plus 之外的主机充当 slave 节点

   ```bash
   locust -f yourLocustfile.py --worker --master-host locust-plusHOST
   ```

   > 上述命令 yourLocustfile.py 代表测试任务编写的 locustfile.py 脚本文件；locust-plusHOST 代表部署了 locust-plus 的主机 ip 地址







