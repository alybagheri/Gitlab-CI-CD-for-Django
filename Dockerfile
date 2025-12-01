FROM python:3.12-slim AS builder

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc libc6-dev build-essential && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install --prefix=/install -r requirements.txt


FROM python:3.12-slim

WORKDIR /app

RUN groupadd -r appgroup && \
    useradd -r -g appgroup appuser

COPY --from=builder /install /usr/local

COPY . .

USER appuser

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://localhost:8000/ || exit 1

CMD ["gunicorn", "simple_app.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]





#ENV HOME=/home/app/simple_app
#RUN mkdir -p $HOME
#WORKDIR $HOME
#ENV PYTHONDONTWRITEBYECODE 1
#ENV PYTHONUNBUFFERED 1
#COPY . $HOME
#RUN pip install --upgrade pip && \
#    pip install --no-cache-dir -r requirements.txt
#
#EXPOSE 8000
#
#CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

