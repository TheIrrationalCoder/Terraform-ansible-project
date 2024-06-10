# Base image
FROM python:3 AS build-stage

RUN mkdir -p /app
RUN mkdir -p /app/files

WORKDIR /app

COPY Requirements.txt /app/files
COPY Config.yaml /app/files
COPY SampleData.json /app/files

RUN pip install --no-cache-dir -r /app/files/Requirements.txt 

COPY Process.py /app

VOLUME [ "/app/output" ]

ENTRYPOINT [ "python" ]
CMD [ "./Process.py" ]






