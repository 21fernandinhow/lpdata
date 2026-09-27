# LPData — instruções para agentes

## Agent skills

### Issue tracker

Issues e especificações vivem nas GitHub Issues deste repositório. Veja `docs/agents/issue-tracker.md`.

### Triage labels

Usamos os labels padrão de triagem. Veja `docs/agents/triage-labels.md`.

### Domain docs

O projeto usa um único contexto de domínio. Veja `docs/agents/domain.md`.

## Desenvolvimento orientado a testes

TDD é um pilar do LPData. Para cada fluxo, escreva primeiro um teste de integração enxuto que defina o contrato; depois, conduza a implementação pelo ciclo red-green-refactor de testes unitários. O teste de integração é a validação final de que o caminho completo funciona.

## Manutenção da documentação pública

A documentação Mintlify em `mintlify/` é parte do produto e atende aos donos das Aplicações Consumidoras. Em toda entrega, avalie se mudanças de comportamento ou contrato da API alteram como esse público integra ou usa o LPData. Quando alterarem, atualize as páginas equivalentes em português brasileiro e inglês na mesma entrega e valide o portal com o CLI Mintlify. Ao concluir, registre quais páginas foram atualizadas ou por que não houve impacto na documentação pública. Atualize `CONTEXT.md` e ADRs somente quando as regras de modelagem de domínio e decisões arquiteturais indicarem.
