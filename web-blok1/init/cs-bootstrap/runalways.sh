cd /opt/secretsapp
source .venv/bin/activate

FLASK_ENV=development python3 -m flask --app . run --host=0.0.0.0 --debug --port 80
