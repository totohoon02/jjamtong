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

list(){
    echo "###### DOCKER ######"
    echo "up"
    echo "down"
    echo "pydocker"
    echo "build <image:dev>"
    echo ""
    echo "###### PYTHON ######"
    echo "venv <py:version>"
    echo "activate"
    echo "requirements"
    echo "freeze"
    echo "fast"
    echo "run <port>"
    echo "db"
}
