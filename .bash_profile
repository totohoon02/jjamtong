# docker 
alias up="docker compose up -d"
alias down="docker compose down"

pydocker(){
    echo 'FROM python:3.10-slim' > Dockerfile
    echo '' >> Dockerfile
    echo 'WORKDIR /app' >> Dockerfile
    echo '' >> Dockerfile
    echo 'COPY requirements.txt .' >> Dockerfile
    echo '' >> Dockerfile
    echo 'RUN pip install -r requirements.txt' >> Dockerfile
    echo '' >> Dockerfile
    echo 'COPY . .' >> Dockerfile
    echo '' >> Dockerfile
    echo 'EXPOSE 8000' >> Dockerfile
    echo '' >> Dockerfile
    echo 'CMD ["uvicorn", "main:app"]' >> Dockerfile
}

build(){
    docker build -t "$@" .
}

# python 

venv(){
    version=${1:-3.10}
    py -$version -m venv .venv
}

activate(){
    . .venv/Scripts/activate
}

requirements(){
    pip install -r requirements.txt
}

freeze(){
    pip freeze > requirements.txt
}

fast(){
    venv
    activate
    pip install fastapi uvicorn
    freeze
    
    echo 'from fastapi import FastAPI' > main.py
    echo '' >> main.py
    echo 'app = FastAPI()' >> main.py
    echo '' >> main.py
    echo '@app.get("/")' >> main.py
    echo 'def index():' >> main.py
    echo '    return {"message": "Hello World!"}' >> main.py
}

run() {
    port=${1:-8000}
    uvicorn main:app --reload --port=$port
}
