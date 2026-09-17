# LPData

LPData é a infraestrutura que separa a estrutura de uma landing page do conteúdo que ela exibe. O contexto existe para que conteúdo seja alterado sem modificar ou redistribuir o código consumidor.

## Linguagem

**Usuário**:
Pessoa autenticada que é proprietária de landing pages no LPData.
_Evite_: Cliente, conta

**Landing Page**:
Recurso pertencente a um usuário que representa uma página cujo conteúdo é gerenciado pelo LPData.
_Evite_: Site, projeto, página estática

**Documento de Conteúdo**:
Valor JSON livre associado a uma landing page; a sua estrutura e interpretação são definidas pela aplicação consumidora.
_Evite_: Schema de página, template, código da página

**Aplicação Consumidora**:
Frontend independente que consulta um documento de conteúdo e o transforma na apresentação de uma landing page.
_Evite_: Frontend do LPData, template hospedado

**Identificador Público**:
Identificador estável de uma landing page que uma aplicação consumidora usa para consultar seu documento de conteúdo sem autenticação.
_Evite_: ID interno, token de edição
