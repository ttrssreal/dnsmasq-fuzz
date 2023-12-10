FROM aflplusplus/aflplusplus

RUN apt-get update && \
    apt-get install tmux vim -y

RUN mkdir -p /fuzz/in /fuzz/mnt

WORKDIR /fuzz

RUN git clone https://github.com/ttrssreal/dnsmasq-fuzz

WORKDIR /fuzz/dnsmasq-fuzz

COPY build-fuzz.sh /fuzz/dnsmasq-fuzz/build-fuzz.sh
RUN ./build-fuzz.sh

WORKDIR /fuzz

COPY seeds.tar.gz .
RUN tar xvf seeds.tar.gz -C in

COPY entrypoint.sh .
ENTRYPOINT ["/fuzz/entrypoint.sh"]