---
title: Ler conteúdo publicado
description: Busque o Documento de Conteúdo de uma Landing Page na sua aplicação consumidora.
---

# Leia o conteúdo na aplicação consumidora

Sua aplicação consumidora busca o Documento de Conteúdo pelo Identificador Público (`public_id`) da Landing Page. A leitura é pública: não exige conta nem token.

## Buscar o Documento de Conteúdo

```http
GET https://api.lpdata.io/landing_pages/<public_id>
```

A resposta `200 OK` é o próprio Documento de Conteúdo, sem o envelope `landing_page` usado nas rotas de gerenciamento:

```json
{
  "hero": {
    "title": { "value": "Launch day", "type": "string" }
  }
}
```

Use o `public_id` retornado ao [criar a Landing Page](/landing-pages#criar). O `id` serve apenas para as rotas autenticadas de gerenciamento e não funciona aqui.

Cada leitura retorna o documento atual: depois de uma [atualização](/landing-pages#atualizar), a próxima leitura já entrega o novo conteúdo.

## Identificador desconhecido

Um `public_id` inexistente retorna `404 Not Found`:

```json
{ "error": "Landing page not found" }
```

## Limite de leituras

A leitura pública é limitada por IP a cada minuto:

| Origem da requisição | Limite por minuto |
| --- | --- |
| Navegador com header `Origin` que corresponde a um dos [hosts permitidos](/landing-pages#hosts-permitidos) da Landing Page | 1.000 |
| Demais casos, como chamadas feitas por servidores | 30 |

Ao exceder o limite, a API retorna `429 Too Many Requests` com o header `Retry-After: 60`:

```json
{ "error": "Too many requests" }
```

Para leituras feitas pelo navegador em produção, cadastre os hosts do seu frontend em `allowed_hosts`.
