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

rmi(){
    for image_id in $(docker images --filter "dangling=true" -q); do
        docker rmi "$image_id"
    done
}

# python 

venv(){
    version=${1:-3.10}

    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        py -$version -m venv .venv
    else
        python$version -m venv .venv
    fi
}

activate(){
    if [ -d "./.venv/Scripts/" ]; then
        . .venv/Scripts/activate
    else
        . .venv/bin/activate
    fi
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

db(){
    # install package
    pip install sqlalchemy

    # create db.py
    echo 'from sqlalchemy import create_engine' > db.py
    echo 'from sqlalchemy.ext.declarative import declarative_base' >> db.py
    echo 'from sqlalchemy.orm import sessionmaker' >> db.py
    echo '' >> db.py
    echo 'SQLALCHEMY_DATABASE_URL = "sqlite:///./mydb.db"' >> db.py
    echo '' >> db.py
    echo 'engine = create_engine(' >> db.py
    echo '    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}' >> db.py
    echo ')' >> db.py
    echo '' >> db.py
    echo 'SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)' >> db.py
    echo '' >> db.py
    echo 'Base = declarative_base()' >> db.py

    # create models.py
    
    echo 'from db import Base' > models.py
    echo '' >> models.py
    echo 'class DummyModel(Base):' >> models.py
    echo '    pass' >> models.py
    
    # main.py
    echo 'import models' >> main.py
    echo 'from db import engine' >> main.py
    echo 'models.Base.metadata.create_all(bind=engine)' >> main.py
}


# bash
pk() {
    port=$1

    if [[ -z "$port" ]]; then
        echo "Usage: $0 <port>"
        exit 1
    fi

    pid_to_kill=$(netstat -tuln 2>/dev/null | grep ":$port" | awk '{print $7}' | cut -d'/' -f1)

    if [[ -n "$pid_to_kill" ]]; then
        echo "killed process on $port"
        kill -9 "$pid_to_kill"
    else
        echo "No process found on $port"
    fi
}

# git
ignore(){
    language=$(echo "$1" | sed -E 's/^(.)/\U\1/')
    curl https://raw.githubusercontent.com/github/gitignore/refs/heads/main/$language.gitignore > .gitignore
}



# help

list(){
    echo "###### DOCKER ######"
    echo "up"
    echo "down"
    echo "pydocker"
    echo "build <image:dev>"
    echo "rmi"
    echo ""
    echo "###### PYTHON ######"
    echo "venv <py:version>"
    echo "activate"
    echo "requirements"
    echo "freeze"
    echo "fast"
    echo "run <port>"
    echo "db"
    echo ""
    echo "###### BASH COMMAND ######"
    echo "pk <port>"
    echo
    echo "###### github COMMAND ######"
    echo "git <language>"
}
