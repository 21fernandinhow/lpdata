# LPData

LPData é a infraestrutura que separa a estrutura de uma landing page do conteúdo e dos assets que ela exibe. O contexto existe para que esses elementos sejam alterados sem modificar ou redistribuir o código consumidor.

O LPData é uma aplicação exclusivamente API. Não possui telas HTML, dashboard visual, formulários ou frontend próprio; todas as operações administrativas e públicas são expostas como endpoints, e a apresentação pertence à Aplicação Consumidora.

## Linguagem

**Usuário**:
Pessoa autenticada que é proprietária de landing pages no LPData.
_Evite_: Cliente, conta

**Landing Page**:
Recurso pertencente a um usuário que representa uma página cujo conteúdo é gerenciado pelo LPData.
_Evite_: Site, projeto, página estática

**Documento de Conteúdo**:
Documento JSONB atual (`current_data`) associado a uma landing page. A aplicação consumidora define sua estrutura e interpretação, e o documento inteiro é a unidade de atualização.
_Evite_: Schema de página, template, código da página, campo individual

**Campo Editável**:
Objeto do Documento de Conteúdo que possui `value` e `type`. O tipo define o editor que o dashboard oferece para seu valor.
_Evite_: Objeto estrutural, campo de banco

**Configuração de Dashboard**:
Metadado opcional (`dashboard_config`) de um Campo Editável que ajusta seu comportamento no dashboard.
_Evite_: Schema obrigatório, metadata genérica

**Asset**:
Arquivo pertencente a um usuário e hospedado pelo LPData para ser referenciado por documentos de conteúdo, como uma imagem raster ou um arquivo vetorial. Um mesmo asset pode ser reutilizado por várias landing pages do proprietário.
_Evite_: Arquivo estático do código, imagem convertida, arquivo da landing page

**Referência Externa**:
URL em um documento de conteúdo que aponta para um arquivo hospedado fora do LPData. Ela pode ser usada no lugar de um Asset.
_Evite_: Asset hospedado, upload obrigatório

**Aplicação Consumidora**:
Frontend independente que consulta um documento de conteúdo e o transforma na apresentação de uma landing page.
_Evite_: Frontend do LPData, template hospedado

**Identificador Público**:
Identificador numérico estável (`public_id`) de uma landing page que uma aplicação consumidora usa para consultar seu documento de conteúdo sem autenticação. Ele é independente do nome humano (`name`) e do ID interno de gerenciamento.
_Evite_: slug, nome da landing page, ID interno, token de edição
