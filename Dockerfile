FROM lly-nw-cafe-d-acr-01-registry-vpc.cn-shanghai.cr.aliyuncs.com/myapp-dev/python:3.11-slim

WORKDIR /app

COPY app/requirements.txt .
RUN pip install --no-cache-dir -i https://mirrors.aliyun.com/pypi/simple/ -r requirements.txt

COPY app/ .

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "main:app"]
