FROM python:3.12.0a7-bullseye
COPY ./web_microservice/prerequest.txt /app/prerequest.txt
WORKDIR /app
RUN pip install -r prerequest.txt
COPY ./web_microservice /app
ENTRYPOINT [ "python" ]
CMD [ "main.py" ]
