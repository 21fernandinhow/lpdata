# PostgreSQL com JSONB para conteúdo

O MVP usará Rails com PostgreSQL. Os dados estruturados da aplicação serão relacionais, enquanto o `current_data` de cada landing page será persistido em uma coluna JSONB; isso preserva a flexibilidade necessária para o conteúdo arbitrário sem separar o produto em dois bancos de dados. O JSON não tem schema de apresentação imposto pelo backend: objetos e arrays são estruturais, e um objeto com `value` e `type` é um Campo Editável para o dashboard.
