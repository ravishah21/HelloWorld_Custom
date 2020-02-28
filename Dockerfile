FROM python:3.6
COPY . /app
WORKDIR /app
RUN pip install flask==1.0.2
EXPOSE 8080
ENTRYPOINT ["python"]
CMD ["helloworld.py"]
