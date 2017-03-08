FROM cargo.caicloud.io/caicloud/alpine

COPY ./cyclone /root
COPY ./testfile /root

WORKDIR /root

CMD ["./cyclone", "testfile"]
