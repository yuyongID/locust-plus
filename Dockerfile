FROM locustio/locust
RUN pip3 install prometheus_client
COPY prometheus_exporter.py $WORKDIR