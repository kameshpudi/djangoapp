#!/bin/sh

cd /app/
source /antenv/bin/activate
pip install -r requirements.txt
python manage.py migrate