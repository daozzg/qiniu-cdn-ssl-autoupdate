# -*- coding: utf-8 -*-
"""
更新cdn证书(可配合let's encrypt 等完成自动证书更新)
"""
import qiniu
from qiniu import DomainManager
import os
import time

# 账户ak，sk
access_key = os.getenv('ACCESS_KEY', '')
secret_key = os.getenv('SECRET_KEY', '')
ssl_domain_name = os.getenv('SSLDOMAIN', '')
cdn_domain_names = os.getenv('CDNDOMAINS', '')

auth = qiniu.Auth(access_key=access_key, secret_key=secret_key)
domain_manager = DomainManager(auth)

privatekey = "/ssl/{}/privkey.pem".format(ssl_domain_name)
ca = "/ssl/{}/fullchain.pem".format(ssl_domain_name)

with open(privatekey, 'r') as f:
    privatekey_str = f.read()

with open(ca, 'r') as f:
    ca_str = f.read()

ret, info = domain_manager.create_sslcert("{}/{}".format(ssl_domain_name, time.strftime("%Y-%m-%d", time.localtime())),
                                          ssl_domain_name, privatekey_str, ca_str)
print(ret)
print(info)
cdn_domain_names_arrs = cdn_domain_names.split(',')
print(cdn_domain_names_arrs)
for cdn_domain in cdn_domain_names_arrs:
    print(cdn_domain)
    r, i = domain_manager.put_httpsconf(cdn_domain, ret['certID'], False)
    print(i)
    pass