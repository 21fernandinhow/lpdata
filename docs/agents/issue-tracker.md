# Issue tracker: GitHub

Issues e especificações deste repositório vivem nas GitHub Issues. Use a CLI `gh` para as operações.

## Convenções

- Criar issue: `gh issue create --title "..." --body "..."`.
- Consultar issue: `gh issue view <número> --comments`.
- Listar issues: `gh issue list --state open`.
- Comentar: `gh issue comment <número> --body "..."`.
- Adicionar ou remover labels: `gh issue edit <número> --add-label "..."` ou `--remove-label "..."`.
- Fechar: `gh issue close <número> --comment "..."`.

O repositório é inferido pelo remoto Git configurado localmente.

## Pull requests como superfície de triagem

**PRs como superfície de solicitação: não.**

Quando uma skill orientar a publicação no issue tracker, crie uma GitHub Issue.
