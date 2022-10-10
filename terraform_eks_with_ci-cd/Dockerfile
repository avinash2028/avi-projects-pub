FROM python:3.8-alpine
WORKDIR /app
COPY app.py requirements.txt config.py model.py /app/
RUN apk update \
    && apk add --virtual build-deps gcc python3-dev musl-dev \
    && apk add --no-cache mysql-dev
RUN pip3 install -r requirements.txt 
EXPOSE 5000
ENTRYPOINT [ "python" ]
CMD ["app.py" ]
