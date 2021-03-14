  
FROM python:3.8.6

RUN ["mkdir", "/app"]

COPY "src/" "/app"

WORKDIR "/app/"

RUN ["pip", "install", "-r", "/app/requirements.txt"]

ENTRYPOINT ["sh", "launch.sh"]