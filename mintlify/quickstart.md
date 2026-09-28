---
title: Primeiros passos
description: Conecte sua aplicação à API do LPData e publique conteúdo de uma Landing Page.
---

# Conecte sua aplicação ao LPData

O fluxo tem duas partes: você gerencia o conteúdo com uma conta autenticada; sua aplicação consumidora busca o conteúdo publicado usando o Identificador Público da Landing Page.

## URL da API

A API do LPData está disponível em `https://api.lpdata.io`. Todos os endpoints desta documentação partem dessa URL base.

## Entre e obtenha um token

Crie uma conta em `POST /auth/sign_up` ou entre em `POST /auth/sign_in`. A resposta contém um token de acesso e um token de atualização. Veja [Autenticação](/authentication) para o ciclo completo.

```http
POST https://api.lpdata.io/auth/sign_in
Content-Type: application/json

{
  "user": {
    "email": "owner@example.com",
    "password": "<sua-senha>"
  }
}
```

Envie o `access_token` retornado no header `Authorization: Bearer <access_token>` das operações autenticadas.

Não coloque credenciais ou tokens em código-fonte público nem os compartilhe. Operações de gerenciamento só podem alterar recursos pertencentes ao usuário autenticado.

## Crie uma Landing Page

Envie o Documento de Conteúdo que sua aplicação espera. O LPData preserva sua estrutura JSON; sua aplicação define como apresentar esse conteúdo.

```http
POST https://api.lpdata.io/landing_pages
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "landing_page": {
    "name": "Launch page",
    "current_data": {
      "hero": {
        "title": {
          "value": "Launch day",
          "type": "string"
        }
      }
    }
  }
}
```

A resposta inclui um `id` para gerenciamento e um `public_id` estável para leitura pela aplicação consumidora. Use o `public_id` na URL pública; não confunda os dois identificadores.

## Leia o conteúdo publicado

A aplicação consumidora lê o Documento de Conteúdo sem autenticação. A resposta é o JSON do documento, sem um objeto `landing_page` em volta:

```http
GET https://api.lpdata.io/landing_pages/<public_id>
```

Uma leitura bem-sucedida retorna, por exemplo:

```json
{
  "hero": {
    "title": {
      "value": "Launch day",
      "type": "string"
    }
  }
}
```

Consulte [Landing Pages](/landing-pages) para gerenciar e ler documentos, e [Referência da API](/api-reference) para a lista de endpoints.