# Use a imagem base do OwnCloud
FROM owncloud/server:latest

# Copia o script entrypoint para dentro do container
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Dá permissão de execução ao script
RUN chmod +x /usr/local/bin/entrypoint.sh

# Define o entrypoint customizado
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Comando padrão do OwnCloud (pode ser apache2-foreground ou php-fpm)
CMD ["apache2-foreground"]
