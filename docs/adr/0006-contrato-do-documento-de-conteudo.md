# Contrato do Documento de Conteúdo

`current_data` é um documento JSON não nulo persistido integralmente em JSONB. Objetos e arrays podem ser arbitrariamente aninhados, inclusive vazios, e valores JSON são retornados sem transformação de apresentação. O backend não impõe schema visual nem atualiza campos individualmente; cada gravação substitui o documento completo.

Um objeto que contenha `value` e `type` é um Campo Editável interpretado pelo dashboard externo. Os tipos iniciais são `string`, `text`, `number`, `boolean`, `url`, `hosted_file` e `external_file`. Para `hosted_file` e `external_file`, `value` contém diretamente a URL usada pela Aplicação Consumidora. A escolha do editor e a interpretação visual não pertencem ao LPData.