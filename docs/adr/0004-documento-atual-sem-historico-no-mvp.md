# Documento atual sem histórico no MVP

Cada atualização persiste um novo `current_data` completo, substituindo o documento anterior; campos individuais não são unidades de atualização. O MVP não mantém histórico, versões anteriores ou controle de concorrência: quando houver atualizações concorrentes, a última gravação prevalece. Uma estratégia de versionamento será considerada somente quando houver necessidade real.
