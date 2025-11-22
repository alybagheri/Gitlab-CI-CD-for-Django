FROM python:3.11

ENV HOME=/home/app/simple_app
RUN mkdir -p $HOME
WORKDIR $HOME
ENV PYTHONDONTWRITEBYECODE 1
ENV PYTHONUNBUFFERED 1
COPY . $HOME
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

