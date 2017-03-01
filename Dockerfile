FROM busybox

COPY ./cyclone /root
COPY ./testfile /root

WORKDIR /root

CMD ["./cyclone", "testfile"]
