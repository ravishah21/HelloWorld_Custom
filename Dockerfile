FROM ubuntu
LABEL maintainer="Ravi Shah <ravishah21@gmail.com>"
RUN apt-get update -y && \
    apt-get install -y python-pip python-dev
RUN pip install flask==1.0.2
COPY . /app
WORKDIR /app
EXPOSE 5000
ENTRYPOINT ["python"]
CMD ["helloworld.py"]

#FROM python:3.6
#COPY . /app
#WORKDIR /app
#RUN pip install flask==1.0.2
#EXPOSE 8080
#ENTRYPOINT ["python"]
#CMD ["helloworld.py"]
