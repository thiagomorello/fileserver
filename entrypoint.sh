#!/bin/bash

set -e

# Caminho do arquivo config.php dentro do container
CONFIG_FILE="/var/www/html/config/config.php"

# Verifica se o config.php existe
if [ -f "$CONFIG_FILE" ]; then
    echo "Modificando o config.php para usar o S3 como storage primário..."

    # Insere as configurações de armazenamento S3 no config.php
    if ! grep -q "'objectstore'" $CONFIG_FILE; then
        sed -i "/);/i \\
        'objectstore' => array(\\
            'class' => '\\\\OC\\\\Files\\\\ObjectStore\\\\S3',\\
            'arguments' => array(\\
                'bucket' => 'wedrop-fileserver',\\
                'key'    => getenv('OWNCLOUD_S3_ACCESS_KEY'),\\
                'secret' => getenv('OWNCLOUD_S3_SECRET_KEY'),\\
                'hostname' => getenv('OWNCLOUD_S3_HOSTNAME'),\\
                'port' => getenv('OWNCLOUD_S3_PORT'),\\
                'use_ssl' => getenv('OWNCLOUD_S3_SSL'),\\
                'region' => getenv('OWNCLOUD_S3_REGION'),\\
                'use_path_style' => true,\\
            ),\\
        )," $CONFIG_FILE
        echo "Configuração do S3 adicionada ao config.php"
    else
        echo "Configuração do S3 já presente no config.php"
    fi
else
    echo "Arquivo config.php não encontrado!"
    exit 1
fi

# Executa o comando original do container
exec "$@"
