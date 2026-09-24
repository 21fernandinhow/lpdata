# LPData

API Rails para gerenciar landing pages, documentos de conteudo e assets.

## Desenvolvimento local

Requisitos: Ruby na versao indicada em `.ruby-version` e PostgreSQL.

```sh
bin/setup
bin/rails server
```

Os testes podem ser executados com:

```sh
bin/rails test
```

## Deploy no Railway

Adicione um servico PostgreSQL ao projeto Railway e conecte este repositorio ao
servico da aplicacao. O `Procfile` fixa o processo web em `production`; sem
isso, um valor incorreto de `RAILS_ENV` pode fazer o Rails tentar carregar um
ambiente inexistente.

Configure estas variaveis no servico da aplicacao:

```text
RAILS_ENV=production
SECRET_KEY_BASE=<uma chave aleatoria longa>
DEVISE_JWT_SECRET_KEY=<outra chave aleatoria longa>
```

O Railway fornece `DATABASE_URL` automaticamente quando o PostgreSQL esta
conectado ao servico. Gere as duas chaves localmente com `bin/rails secret` e
adicione os valores diretamente nas variaveis do Railway; elas nao devem ser
commitadas.

Depois do primeiro deploy, execute as migracoes pelo shell do servico:

```sh
bin/rails db:prepare
```
