# Documentação de domínio

## Antes de explorar ou modificar o projeto

Leia `CONTEXT.md` na raiz. Se existir, leia também os ADRs relevantes em `docs/adr/`.

Se esses arquivos ainda não existirem, prossiga normalmente. A skill de modelagem de domínio os cria quando um termo ou uma decisão tiver sido realmente resolvida.

## Estrutura

O LPData é um projeto de contexto único:

```text
/
├── CONTEXT.md
├── docs/
│   ├── adr/
│   └── agents/
└── src/
```

Use os termos definidos em `CONTEXT.md` de forma consistente. Caso uma proposta contradiga um ADR existente, deixe esse conflito explícito.
