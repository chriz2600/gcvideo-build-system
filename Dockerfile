FROM docker.i74.de:5000/xilinx-ise:14.7

# adding scripts
ADD files /

RUN apt-get update && \
    apt-get -y install build-essential flex && \
    cd && \
    git clone https://github.com/zylin/zpugcc.git
    
RUN /root/compile
