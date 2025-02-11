FROM mcr.microsoft.com/mssql/server:2022-latest

USER root

# Naprawa problemu z uprawnieniami i dodanie repozytoriów Microsoft
RUN mkdir -p /var/lib/apt/lists/partial && chmod -R 777 /var/lib/apt/lists/ \
    && apt-get update && apt-get install -y curl apt-transport-https gnupg2 \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/11/prod.list -o /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools \
    && echo 'export PATH=$PATH:/opt/mssql-tools/bin' >> /etc/bash.bashrc \
    && rm -rf /var/lib/apt/lists/*

USER mssql

ENTRYPOINT [ "/opt/mssql/bin/sqlservr" ]
