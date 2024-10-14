alias up="docker compose up -d"
alias down="docker compose down"

build(){
    docker build -t "$@" .
}

venv(){
    py -"$@" -m venv .venv
}

activate(){
    . .venv/Scripts/activate
}
