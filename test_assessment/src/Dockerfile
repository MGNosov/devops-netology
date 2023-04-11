FROM python:3.12.0a7-bullseye
COPY ./prerequest.txt /app/prerequest.txt
WORKDIR /app
RUN pip install -r prerequest.txt
COPY ./web_microservice /app
ENTRYPOINT [ "python3" ]
CMD [ "main.py" ]
