FROM python:3
WORKDIR /my-app
RUN pip install flask
COPY . ./
EXPOSE 8080
ENTRYPOINT ["python3", "helloworld.py"]