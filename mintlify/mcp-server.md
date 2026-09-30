---
title: Servidor MCP
description: Conecte um agente ao LPData e gerencie o conteúdo conversando com ele.
---

# Gerencie o conteúdo por um agente

O LPData expõe as operações de gerenciamento como um servidor [MCP](https://modelcontextprotocol.io) hospedado junto da API, em `https://api.lpdata.io/mcp`. Um agente conectado a ele cria landing pages, escreve o Documento de Conteúdo, envia arquivos e confere a leitura pública sem que você monte chamadas HTTP à mão.

Não há nada para instalar: você adiciona uma URL e a sua credencial ao seu cliente MCP.

Esta página é para quem **desenvolve** a landing page. As ferramentas são as mesmas operações descritas em [Landing Pages](/landing-pages) e [Assets](/assets), uma ferramenta por operação.

## Coloque a credencial no ambiente

O servidor identifica você pela mesma conta do [login](/authentication). Defina as variáveis no ambiente do shell de onde você inicia o cliente MCP:

```sh
export LPDATA_EMAIL="owner@example.com"
export LPDATA_PASSWORD="<sua-senha>"
export LPDATA_URL="https://api.lpdata.io"
```

`LPDATA_URL` é usada pelo comando de envio de arquivo e assume `https://api.lpdata.io` quando não está definida. As três também servem ao `curl` que o agente executa para enviar um Asset, então defina-as mesmo que seu cliente só precise das duas primeiras.

## Adicione o servidor ao seu cliente MCP

Aponte o cliente para a URL do servidor e envie a credencial em dois headers, `X-LPData-Email` e `X-LPData-Password`. A configuração referencia as variáveis de ambiente e não contém segredo, então pode ser versionada:

```json
{
  "mcpServers": {
    "lpdata": {
      "type": "http",
      "url": "https://api.lpdata.io/mcp",
      "headers": {
        "X-LPData-Email": "${LPDATA_EMAIL}",
        "X-LPData-Password": "${LPDATA_PASSWORD}"
      }
    }
  }
}
```

A credencial diz **quem** está chamando: cada pessoa usa a própria conta e enxerga apenas as próprias Landing Pages e Assets. Não existe ferramenta de login, logout ou refresh, e nenhum token é devolvido ao agente.

Peça ao agente para chamar `check_connection`. Ele responde com o `id` e o e-mail da conta, o que confirma que os headers chegaram ao servidor.

## Ferramentas

| Ferramenta | O que faz |
| --- | --- |
| `check_connection` | Devolve a conta autenticada. Carrega o contrato do Documento de Conteúdo na descrição |
| `create_landing_page` | Cria uma Landing Page com `name`, `current_data` e `allowed_hosts` |
| `list_landing_pages` | Lista as Landing Pages da conta, sem o `current_data` |
| `get_landing_page` | Devolve uma Landing Page própria, com o `current_data` |
| `update_landing_page` | Atualiza `name`, `current_data` ou `allowed_hosts`; o que você omite fica como está |
| `delete_landing_page` | Remove uma Landing Page |
| `get_public_content` | Lê o Documento de Conteúdo por `public_id`, cru, como a Aplicação Consumidora recebe |
| `list_assets` | Lista os Assets da conta com `public_url` |
| `get_asset_upload_command` | Monta o comando de shell que envia um arquivo |
| `delete_asset` | Remove um Asset |

Use o `id` nas ferramentas de gerenciamento e o `public_id` em `get_public_content`; os dois identificadores não são intercambiáveis.

## O contrato do Documento de Conteúdo

O agente recebe este contrato na descrição de `check_connection`, então não precisa consultar esta página para escrever um documento válido. Ele está aqui para você conferir o que o agente produziu.

- `current_data` é um JSON não nulo; objetos e arrays aninham à vontade e podem estar vazios.
- Um valor primitivo não pode aparecer solto em um objeto ou em um array. Toda folha é um Campo Editável.
- Um Campo Editável é um objeto com **as duas** chaves `value` e `type`. Só uma delas é inválido.
- `string`, `text`, `url`, `hosted_file` e `external_file` recebem string; `number` recebe número; `boolean` recebe `true` ou `false`.
- `hosted_file` e `external_file` guardam a URL diretamente em `value`.
- Chaves além de `value` e `type` são aceitas; é assim que o `dashboard_config` trafega.

```json
{
  "hero": {
    "title": { "value": "Bem-vindo", "type": "string" },
    "cta_url": { "value": "https://exemplo.com", "type": "url" }
  },
  "features": [
    { "name": { "value": "Rápido", "type": "string" } }
  ]
}
```

Enviar `{ "features": ["Rápido"] }` é recusado, porque `"Rápido"` é uma string solta dentro de um array:

```text
Current data contains a value outside an editable field at $.features[0]
```

O servidor MCP não valida nem corrige o documento: quem recusa é a API, e o agente recebe a mensagem inteira, com o caminho do campo.

## Envie um arquivo

O servidor é remoto e não lê o disco da sua máquina, então ele não transfere bytes. `get_asset_upload_command` devolve o comando que o agente executa no shell dele:

```sh
FILE='/caminho/do/hero.webp'

TOKEN=$(curl -s -X POST "${LPDATA_URL:-https://api.lpdata.io}/auth/sign_in" \
  -H 'Content-Type: application/json' \
  -d "{\"user\":{\"email\":\"$LPDATA_EMAIL\",\"password\":\"$LPDATA_PASSWORD\"}}" | jq -r .access_token)

curl -s -X POST "${LPDATA_URL:-https://api.lpdata.io}/assets" \
  -H "Authorization: Bearer $TOKEN" -F "asset[file]=@$FILE"
```

O shell é quem expande `$LPDATA_EMAIL`, `$LPDATA_PASSWORD` e `$TOKEN`: o agente escreve o comando, mas nunca vê a sua senha nem o token. O comando precisa do [`jq`](https://jqlang.github.io/jq/) instalado e deve ser executado como está.

A resposta do segundo `curl` traz a `public_url` do Asset. Use essa URL como `value` de um Campo Editável do tipo `hosted_file`.

## Um fluxo completo

1. `check_connection` confirma a conta.
2. `create_landing_page` cria a página com o Documento de Conteúdo inicial e devolve o `id` e o `public_id`.
3. `get_asset_upload_command` monta o comando; o agente o executa e obtém a `public_url` da imagem.
4. `update_landing_page` grava o documento com a `public_url` em um campo `hosted_file`.
5. `get_public_content` lê pelo `public_id` e mostra exatamente o que a Aplicação Consumidora vai receber.

Lembre que `current_data` é sempre substituído por inteiro: para mudar um campo, o agente envia o documento completo com aquele campo alterado. O LPData não guarda histórico do documento.

## Erros

O servidor repassa os erros da API sem reformular.

| Situação | O que o agente recebe |
| --- | --- |
| Credencial ausente ou inválida | `401 Unauthorized` dizendo para conferir `X-LPData-Email` e `X-LPData-Password` |
| Documento fora do contrato | A lista de mensagens de validação, cada uma com o caminho do campo |
| `id` ou `public_id` inexistente, ou recurso de outra conta | `Landing page not found` ou `Asset not found` |
| Limite da leitura pública excedido | `Too many requests`, com o tempo de espera; veja [Limite de leituras](/public-content#limite-de-leituras) |
