---
title: Dashboard
description: Altere os textos, links e imagens das suas Landing Pages sem programar.
---

# Edite pelo Dashboard

No [Dashboard](https://dashboard.lpdata.io), você altera o conteúdo das suas Landing Pages, como textos, números, links e imagens, sem programar.

Abra uma Landing Page e clique na aba **Conteúdo**. Acima do conteúdo, os botões **Formulário** e **JSON** trocam o jeito de editar:

- **Formulário**: campos para preencher, como num cadastro. É o jeito mais fácil.
- **JSON**: o conteúdo em formato de código, para quem programa.

Os dois mostram o mesmo conteúdo. Você pode trocar de um para o outro a qualquer momento, e o que você ainda não salvou continua lá. A página abre no Formulário.

## Salvar

Para salvar, clique no ícone de disquete, à direita, acima do conteúdo. Você também pode usar o atalho `⌘S` no Mac ou `Ctrl+S` no Windows.

Um ponto no ícone de disquete avisa que há alterações não salvas. Se você tentar sair da página antes de salvar, o Dashboard pergunta se você quer descartar essas alterações.

Se o LPData não aceitar o conteúdo, uma mensagem aparece acima do conteúdo e explica o problema. Clique na mensagem para ir até o campo com o problema.

## Formulário

O Formulário organiza o conteúdo em **seções** e **campos**:

- Uma **seção** é uma caixa que agrupa os campos de uma parte da página. Por exemplo, a seção `hero` pode guardar o título e a imagem do topo da página. Uma seção pode ter outras seções dentro dela.
- Um **campo** é uma informação que você preenche, como um título ou um preço.

Clique no nome de uma seção para abrir ou fechar a seção. As seções principais já aparecem abertas.

Algumas seções são **listas**, como uma lista de vantagens de um produto. Os itens de uma lista aparecem como **Item 1**, **Item 2** e assim por diante.

### Editar um campo

Clique no campo, altere o conteúdo e salve.

Cada campo tem um **tipo**. O tipo aparece ao lado do nome do campo e define o que você preenche:

| Tipo | O que você preenche |
| --- | --- |
| `string` | Um texto curto, de uma linha, como um título |
| `text` | Um texto longo, que pode ter várias linhas |
| `number` | Um número, como um preço |
| `boolean` | Um interruptor de ligado e desligado, como mostrar ou esconder um bloco |
| `url` | O endereço de uma página, como `https://exemplo.com` |
| `hosted_file` | Um dos seus arquivos, escolhido numa lista, como uma imagem |
| `external_file` | O endereço de um arquivo que está em outro site, como um vídeo |

Num campo `hosted_file`, clique em **Escolher arquivo**. Uma janela mostra os seus arquivos: clique no que você quer usar. Para usar um arquivo novo, clique em **+** na mesma janela, envie o arquivo e depois clique nele. Se o arquivo for uma imagem, o campo mostra uma prévia. **Limpar** deixa o campo vazio.

Num campo `external_file`, cole o endereço do arquivo. Se for uma imagem, o campo também mostra uma prévia.

Num campo de número, se você apagar o número ou escrever algo que não é número, o campo mostra **Número inválido**. O Dashboard só guarda o número quando ele estiver certo.

### Criar seções e campos

No fim de cada seção há botões que criam algo **dentro** daquela seção:

- **+ Campo** cria um campo. Escreva o nome, escolha o tipo e clique em **Adicionar**. O campo começa vazio.
- **+ Seção** cria uma seção. Escreva o nome e clique em **Adicionar**. A seção nova começa vazia e já aparece aberta.
- **+ Item**, nas listas, cria um item novo. O item novo tem os mesmos campos do primeiro item, todos vazios.

No fim do formulário, fora das seções, os botões **+ Campo** e **+ Seção** criam no nível principal da página.

Dentro de uma mesma seção, cada campo e cada seção precisa ter um nome diferente.

### Mudar o tipo de um campo

Clique no tipo, ao lado do nome do campo, e escolha outro tipo. **Atenção:** quando você muda o tipo, o Dashboard apaga o conteúdo do campo.

### Renomear e remover

À direita do nome de cada campo e de cada seção há dois ícones:

- O **lápis** muda o nome do campo ou da seção.
- A **lixeira** remove o campo, o item da lista ou a seção inteira, com tudo o que está dentro dela.

Os itens de uma lista têm só a lixeira, porque não têm nome.

O Dashboard pede confirmação antes de renomear ou remover.

**Atenção:** fale com quem cuida do site antes de renomear ou remover. O site que mostra esta Landing Page procura cada campo pelo nome. Se um nome muda ou um campo some, essa parte do site pode ficar vazia ou deixar de funcionar.

### Campos que o Formulário não edita

Às vezes um campo aparece só com uma mensagem, sem lugar para editar. Isso acontece quando o conteúdo desse campo está num formato que o Formulário não reconhece. Peça para quem cuida do site corrigir o campo no JSON. Você ainda pode renomear ou remover esse campo pelo Formulário.

## JSON

O modo JSON mostra o Documento de Conteúdo inteiro como texto, com destaque de sintaxe e números de linha. Ele muda qualquer coisa no documento, inclusive a ordem das chaves, que o Formulário não alcança.

- `Tab` indenta. Para sair do editor pelo teclado, pressione `Esc` e depois `Tab`.
- `Enter` mantém a indentação da linha.

Antes de enviar, o Dashboard confere se o texto é um JSON válido e aponta a linha e a coluna do erro. As regras do conteúdo são as da API, descritas em [Documento de Conteúdo](/landing-pages#documento-de-conteúdo). Um erro dessas regras aparece com o caminho do campo, como `$.hero.title`, e leva à linha correspondente.

Se o JSON estiver inválido, o Formulário fica indisponível até a correção.
