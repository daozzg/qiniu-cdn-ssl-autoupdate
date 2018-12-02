# 自动更新七牛证书
借助于let's encrypt 以及qiniu sdn实现七牛cdn证书的自动更新

## 环境变量:

- CDNDOMAINS:你七牛cdn的域名 多个请用应为逗号(`,`)隔开
- SSLDOMAIN: 你申请ssl的主域名，程序会申请一个通用的泛域名
- ACCESS_KEY: 七牛api ACCESS_KEY
- SECRET_KEY: 七牛api SECRET_KEY

### 可选环境变量:
这里使用dns生成证书,需要给域名增加一条txt做认证,如果不配置,脚本运行后会提示您手动增加txt记录  
但感谢acme.sh,对接了大部分的域名提供商,可以自动添加记录,你只需要提供相关认证信息即可,详细见:https://github.com/Neilpang/acme.sh/blob/master/dnsapi/README.md  

如,你使用的是dnspod,增加下面的环境变量即可:(你需要先登录到 dnspod 账号, 生成你的 api id 和 api key, 都是免费的)
- DP_Id: 
- DP_Key: 

如,你使用的是阿里dns,增加下面的环境变量即可:(你需要先登录到 [阿里 账号:](https://ak-console.aliyun.com/#/accesskey), 生成你的 api id 和 api key, 都是免费的)
- Ali_Key: 
- Ali_Secret: 

## 运行

### 自己构建
```
git clone https://github.com/YahuiWong/qiniu-cdn-ssl-autoupdate.git
cd qiniu-cdn-ssl-autoupdate
docker build -t qiniu-cdn-ssl-autoupdate .
#dnspod
docker run -d -e SSLDOMAIN=yahui.wang  -e CDNDOMAINS=blog.yahui.wang -e ACCESS_KEY=xxx -e SECRET_KEY=xxx -e DP_Id=xxx -e DP_Key=xxx qiniu-cdn-ssl-autoupdate
#aliyun
docker run -d -e SSLDOMAIN=yahui.wang  -e CDNDOMAINS=blog.yahui.wang -e ACCESS_KEY=xxx -e SECRET_KEY=xxx -e Ali_Key=xxx -e Ali_Secret=xxx qiniu-cdn-ssl-autoupdate
```

### 使用构建好的[镜像](https://hub.daocloud.io/repos/c4b55b3e-74de-4c00-87e6-9a82b8484999)

```
#dnspod
docker run -it -e SSLDOMAIN=yahui.wang -e CDNDOMAINS=blog.yahui.wang -e ACCESS_KEY=xxx -e SECRET_KEY=xxx -e DP_Id=xxx -e DP_Key=xxx yahuiwong/qiniu-cdn-ssl-autoupdate
#aliyun
docker run -d -e SSLDOMAIN=yahui.wang -e CDNDOMAINS=blog.yahui.wang -e ACCESS_KEY=xxx -e SECRET_KEY=xxx -e Ali_Key=xxx -e Ali_Secret=xxx yahuiwong/qiniu-cdn-ssl-autoupdate
```
或者通过 docker-compose运行 
创建docker-compose.yml  
```
qiniu-cdn-ssl-autoupdate:
  image: yahuiwong/qiniu-cdn-ssl-autoupdate
  environment:
    - ACCESS_KEY=changeme
    - SECRET_KEY=changeme
    - SSLDOMAIN=yahui.wang
    - CDNDOMAINS=yahui.wang,blog.yahui.wang
    - DP_Id=changeme
    - DP_Key=changeme
```
执行  
```
docker-compose up -d
```

### 泛域名wildcard

指定`DOMAIN=*.wildcard.example.com`即可

## 代码许可

The MIT License (MIT).详情见 [License文件](https://github.com/qiniu/python-sdk/blob/master/LICENSE).
