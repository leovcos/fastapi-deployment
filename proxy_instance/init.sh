#!/bin/bash -xe

# Define o diretório do script
directory=$(dirname "$0")

cd "$directory"

# Muda para needrestart para auto 
# ref: https://stackoverflow.com/questions/73397110/how-to-stop-ubuntu-pop-up-daemons-using-outdated-libraries-when-using-apt-to-i
sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf

# Atualiza e instala pacotes necessários
apt-get update -y
apt-get upgrade -y
apt-get install nginx -y


# Para o nginx
service nginx stop

# Exclui o arquivo padrão do nginx.conf
rm /etc/nginx/nginx.conf

cp -R etc/* /etc/

ln -s /etc/nginx/sites-available/fastapi.conf /etc/nginx/sites-enabled/

systemctl enable nginx
systemctl start nginx



