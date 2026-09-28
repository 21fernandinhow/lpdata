---
title: Landing Pages
description: Crie, atualize e publique o Documento de Conteúdo de uma Landing Page.
---

# Gerencie suas Landing Pages

Operações de gerenciamento exigem o token Bearer do usuário proprietário. O `id` identifica o registro nas rotas de gerenciamento; o `public_id` estável é usado pela Aplicação Consumidora para ler o conteúdo.

## Criar

`POST /manage/landing_pages` recebe um nome e o Documento de Conteúdo definido pela sua aplicação. `allowed_hosts` é opcional.

```http
POST https://api.lpdata.io/manage/landing_pages
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

O endpoint retorna `201 Created`, com o registro criado:

```json
{
  "landing_page": {
    "id": 12,
    "public_id": 3407,
    "name": "Launch page",
    "current_data": {
      "hero": { "title": { "value": "Launch day", "type": "string" } }
    },
    "allowed_hosts": [],
    "user_id": 42,
    "created_at": "2026-09-27T12:00:00.000Z",
    "updated_at": "2026-09-27T12:00:00.000Z"
  }
}
```

Guarde `public_id` para a leitura pública e use `id` somente nas operações autenticadas de gerenciamento.

## Documento de Conteúdo

`current_data` é obrigatório e aceita objetos e arrays aninhados livremente, inclusive vazios. Todo valor primitivo, porém, precisa estar dentro de um Campo Editável: um objeto com as chaves `value` e `type`.

| `type` | `value` esperado |
| --- | --- |
| `string`, `text`, `url` | String |
| `hosted_file`, `external_file` | String com a URL do arquivo |
| `number` | Número |
| `boolean` | `true` ou `false` |

```json
{
  "hero": {
    "title": { "value": "Launch day", "type": "string" },
    "image": { "value": "https://cdn.example.com/hero.webp", "type": "hosted_file" }
  },
  "features": [
    { "label": { "value": "Fast", "type": "string" } }
  ]
}
```

Um documento fora desse contrato retorna `422 Unprocessable Content`, indicando o caminho do problema:

```json
{ "errors": ["Current data editable field value does not match its type at $.hero.title"] }
```

Outras mensagens possíveis: `contains a value outside an editable field`, `editable fields must contain both value and type` e `contains an unsupported editable field type`. O LPData não interpreta a apresentação dos campos; isso continua sendo responsabilidade da sua aplicação.

## Hosts permitidos

`allowed_hosts` lista os hosts do frontend que leem a Landing Page no navegador, como `["example.com", "localhost:3000"]`. Os valores são convertidos para minúsculas. Um host sem porta também vale para seus subdomínios; um host com porta exige host e porta exatos.

A leitura pública é limitada por IP a cada minuto: 1.000 requisições quando o header `Origin` corresponde a um host permitido e 30 nos demais casos, como chamadas feitas por servidores. Ao exceder o limite, a API retorna `429 Too Many Requests` com `Retry-After: 60`.

## Listar e consultar

Liste apenas as Landing Pages da conta autenticada:

```http
GET https://api.lpdata.io/manage/landing_pages
Authorization: Bearer <access_token>
```

Consulte uma Landing Page própria por `id`:

```http
GET https://api.lpdata.io/manage/landing_pages/<id>
Authorization: Bearer <access_token>
```

As respostas são envelopadas em `landing_pages` ou `landing_page`, respectivamente. Uma conta não pode consultar os registros de outra; o recurso retorna `404 Not Found`.

## Atualizar

`PATCH /manage/landing_pages/:id` aceita um ou mais atributos. Quando enviar `current_data`, ele substitui o Documento de Conteúdo inteiro; o LPData não mescla campos individuais.

```http
PATCH https://api.lpdata.io/manage/landing_pages/<id>
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "landing_page": {
    "name": "Summer launch",
    "current_data": {
      "hero": {
        "title": {
          "value": "Summer is here",
          "type": "string"
        }
      }
    }
  }
}
```

Uma atualização bem-sucedida retorna `200 OK` e o objeto `landing_page` atualizado.

## Excluir

`DELETE /manage/landing_pages/:id` remove uma Landing Page pertencente ao usuário autenticado e retorna `204 No Content`.

## Ler o conteúdo na aplicação consumidora

`GET /landing_pages/:public_id` é público e retorna somente o Documento de Conteúdo em JSON, sem autenticação e sem o envelope `landing_page`.

```http
GET https://api.lpdata.io/landing_pages/<public_id>
```

Um identificador desconhecido retorna `404 Not Found`:

```json
{ "error": "Landing page not found" }
```

Leituras acima do limite retornam `429 Too Many Requests`; veja [Hosts permitidos](#hosts-permitidos).
