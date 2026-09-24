# Leitura pública e escrita autenticada

No MVP, uma aplicação consumidora consulta o documento de conteúdo de uma landing page por seu `public_id` numérico, sem autenticação. O `name` é uma identificação humana e não participa da URL pública. Criar, editar e gerenciar landing pages exige autenticação e é permitido somente ao usuário proprietário; isso mantém a integração do frontend simples sem expor operações de alteração.
