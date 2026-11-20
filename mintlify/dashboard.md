---
title: Dashboard
description: Edite o Documento de Conteúdo das suas Landing Pages sem terminal, pelo formulário ou pelo JSON.
---

# Edite pelo Dashboard

O [Dashboard](https://dashboard.lpdata.io) é a aplicação onde você edita o Documento de Conteúdo das suas Landing Pages sem chamar a API à mão. Ele usa as mesmas rotas de gerenciamento descritas em [Landing Pages](/landing-pages), com a sua conta.

Ao abrir uma Landing Page, a aba **Conteúdo** mostra o documento em dois modos: **Formulário** e **JSON**. Os dois editam o mesmo documento, então você pode alternar entre eles a qualquer momento sem perder o que ainda não salvou. O Dashboard abre no Formulário; um documento vazio abre no JSON.

## Salvar

Salve pelo ícone de disquete ou com `⌘S` (`Ctrl+S` fora do Mac). Um ponto no ícone indica alterações não salvas. O documento é sempre gravado inteiro, como no [PATCH de atualização](/landing-pages#atualizar).

Se você tentar sair da Landing Page com alterações não salvas, o Dashboard pede confirmação. Recarregar ou fechar a aba mostra o aviso do navegador.

Quando a API recusa o documento, os erros aparecem acima do editor, com o caminho do campo, como `$.hero.title`. Clique em um erro para ir até o campo.

## Formulário

O Formulário mostra cada Campo Editável com o editor do seu `type`, sem JSON:

| `type` | Editor |
| --- | --- |
| `string` | Texto de uma linha |
| `text` | Texto de várias linhas |
| `number` | Número |
| `boolean` | Interruptor |
| `url`, `external_file`, `hosted_file` | Endereço |

As seções aparecem aninhadas, com a chave como título. O primeiro nível já abre; os demais abrem ao clicar. Itens de uma lista aparecem como **Item 1**, **Item 2** e assim por diante.

### Criar seções e campos

No rodapé de cada seção ficam os botões que criam dentro dela:

- **Campo** pede o nome e o `type`. O valor começa vazio: `""`, `0` ou `false`.
- **Seção** pede o nome e cria uma seção vazia.
- **Item**, nas listas, adiciona um item com a mesma estrutura do primeiro e os valores vazios.

Os botões no fim do formulário criam no primeiro nível do documento. Duas chaves iguais na mesma seção não são permitidas.

### Mudar o tipo, renomear e remover

- O `type` de cada campo aparece ao lado do nome e pode ser trocado. Trocar o tipo apaga o valor e deixa o vazio do tipo novo.
- O lápis renomeia um campo ou uma seção; a chave mantém a posição.
- A lixeira remove um campo, uma seção inteira ou um item da lista.

Renomear ou remover uma chave muda a estrutura que a sua Aplicação Consumidora lê. O LPData não avisa a aplicação: atualize o código dela junto.

### Campos que o Formulário não edita

Um valor fora de um Campo Editável, um `type` desconhecido ou um valor que não corresponde ao `type` aparecem só para leitura, com o motivo. Corrija esses pelo JSON; o Formulário ainda permite renomear ou remover a chave.

## JSON

O modo JSON mostra o Documento de Conteúdo inteiro como texto, com destaque de sintaxe e números de linha. Ele muda qualquer coisa no documento, inclusive a ordem das chaves, que o Formulário não alcança.

- `Tab` indenta. Para sair do editor pelo teclado, pressione `Esc` e depois `Tab`.
- `Enter` mantém a indentação da linha.

Antes de enviar, o Dashboard confere se o texto é um JSON válido e aponta a linha e a coluna do erro. As regras do conteúdo são as da API, descritas em [Documento de Conteúdo](/landing-pages#documento-de-conteúdo); um erro delas aparece com o caminho do campo e leva à linha correspondente.

Se o JSON estiver inválido, o Formulário fica indisponível até a correção.
