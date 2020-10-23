# Dockerfile
FROM python:3.7-buster


WORKDIR /app

# package required
RUN apt update -qq && \
    apt install -qy \
    git \
#    gnupg \
#    unzip \
    python3-dev \
    python3-dev \
    python3-venv \
    python3-psycopg2 
    

RUN cd /app && python3 -m venv hc-venv # && /bin/bash -c "source hc-venv/bin/activate" 

RUN git clone https://github.com/healthchecks/healthchecks.git /app/healthchecks 

COPY r/requirements.txt /app/healthchecks/requirements.txt


RUN pip install psycopg2-binary 
RUN pip install -r /app/healthchecks/requirements.txt  
RUN cd /app/healthchecks/ && cp hc/local_settings.py.example hc/local_settings.py

RUN cd /app/healthchecks && \
    ./manage.py migrate && \
    ./manage.py shell -c "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'test@test.com', 'toto42sh')"

