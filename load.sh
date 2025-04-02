#!/bin/bash

# URL base do httpbin - altere conforme necessário
HTTPBIN_URL="http://example.lab.local"

# Array com diferentes paths do httpbin
PATHS=(
  "/get"
  "/post"
  "/status/200"
  "/status/404"
  "/status/500"
  "/delay/1"
  "/delay/2"
  "/headers"
  "/ip"
  "/user-agent"
  "/cookies"
  "/stream/5"
  "/redirect/3"
  "/image/png"
  "/image/jpeg"
  "/xml"
  "/html"
  "/json"
  "/gzip"
  "/deflate"
  "/robots.txt"
  "/uuid"
  "/cache"
  "/etag/etag"
  "/response-headers?Content-Type=text/plain"
  "/anything"
)

# Função para fazer requisições
make_request() {
  local path="$1"
  local method="$2"
  
  # Método POST para o endpoint /post, todos os outros usam GET
  if [ "$method" == "POST" ]; then
    curl -s -X POST -d "data=test" -o /dev/null -w "%{http_code} %{time_total}s $method ${HTTPBIN_URL}${path}\n" "${HTTPBIN_URL}${path}"
  else
    curl -s -o /dev/null -w "%{http_code} %{time_total}s $method ${HTTPBIN_URL}${path}\n" "${HTTPBIN_URL}${path}"
  fi
}

# Função para executar uma rajada de requisições
run_burst() {
  # Executa requisições em paralelo
  for path in "${PATHS[@]}"; do
    # Escolhe entre GET e POST aleatoriamente para alguns endpoints
    if [ "$path" == "/post" ]; then
      # Sempre usa POST para /post
      make_request "$path" "POST" &
    elif [ "$path" == "/anything" ] && [ $((RANDOM % 2)) -eq 0 ]; then
      # 50% de chance de usar POST para /anything
      make_request "$path" "POST" &
    else
      # Usa GET para todos os outros endpoints
      make_request "$path" "GET" &
    fi
  done
  
  # Aguarda todas as requisições em andamento terminarem
  wait
}

echo "Iniciando teste de carga em ${HTTPBIN_URL}..."
echo "Pressione CTRL+C para encerrar"

# Loop infinito
counter=1
while true; do
  echo "=== Rajada #$counter ==="
  run_burst
  
  # Incrementa o contador
  ((counter++))
  
  # Pequena pausa entre rajadas (opcional)
  sleep 0.5
done