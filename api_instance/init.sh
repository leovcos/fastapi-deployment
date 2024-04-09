#!/bin/bash -xe

# Define o diretório do script
directory=$(dirname "$0")

# Atualiza e instala pacotes necessários
apt-get update -y
apt-get install python3-venv python3-pip supervisor -y

# Verifica a instalação do Supervisor
if ! which supervisorctl > /dev/null 2>&1; then
    echo "Erro: Supervisor não foi instalado corretamente."
    exit 1
fi

# Verifica o status do serviço Supervisor
if ! systemctl status supervisor > /dev/null 2>&1; then
    echo "Erro: O serviço Supervisor não está em execução."
    exit 1
fi

# Cria e move arquivos para o diretório de aplicação
cd ~/fastapi/api_instance
mkdir -p /var/www/fastapi
mv api /var/www/fastapi

# Navega até o diretório de aplicação e configura o ambiente virtual
cd /var/www/fastapi
python3 -m venv env
source env/bin/activate
pip3 install -r requirements.txt

# Define permissões de usuário para o diretório
chown www-data:www-data -R /var/www

# Configura o Supervisor
mv ~/fastapi/api_instance/etc/supervisor/conf.d/fastapi-gunicorn.conf /etc/supervisor/conf.d/
supervisorctl reread
supervisorctl update

# Verifica se a configuração do Supervisor está correta
if ! supervisord -c /etc/supervisor/supervisord.conf -n; then
    echo "Erro: A configuração do Supervisor não é válida."
    exit 1
fi

echo "Instalação e configuração do Supervisor concluídas com sucesso."
