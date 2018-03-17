FROM daocloud.io/python:2.7
WORKDIR /app

#install acme.sh
RUN apt-get -y update && apt-get install -y cron socat vim
RUN git clone https://github.com/Neilpang/acme.sh.git && cd ./acme.sh && ./acme.sh --install && cd ..

#install qiniu sdk
#TODO if qiniu merge PR,change this to qiniu : https://github.com/qiniu/python-sdk.git
RUN git clone https://github.com/daozzg/qiniu-python-sdk.git qiniu-python-sdk && cd qiniu-python-sdk && python setup.py install && cd ..

ADD . /app
CMD ["bash","startup.sh"]