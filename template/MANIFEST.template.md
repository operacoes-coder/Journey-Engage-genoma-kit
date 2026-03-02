# {{PROJECT_NAME}} — Manifest

> PGP (Protocolo GENOMA Perpetuo) v2.0

## GENOMA — Os 6 Pilares

| Pilar | Significado | Funcao | Arquivo(s) |
|-------|-------------|--------|------------|
| **G** | Gestao | Governanca, guardrails, regras | MANIFEST.md |
| **E** | Estruturada | Arquitetura, mapa de arquivos, stack | MANIFEST.md + GRAPH.md |
| **N** | Normalizada | Padronizacao, commits, POPs | pops/ + hooks/ |
| **O** | Orientada | Navegacao por cenario, zoom levels | ROUTES.md + GRAPH.md |
| **M** | Metricas | Rastreabilidade, decisoes, credenciais | DECISIONS.md |
| **A** | Atualizacao | Perpetuidade, snapshots auto, checkpoints | SNAPSHOT.md + hooks/ |

## Identity

- **Projeto:** {{PROJECT_NAME}}
- **Descricao:** <!-- O que este projeto faz -->
- **Stack:** <!-- Linguagens, frameworks, servicos -->
- **Repositorio:** <!-- URL ou local -->
- **Ambientes:** <!-- dev, staging, producao -->

## Architecture

<!-- Descrever padroes e decisoes arquiteturais do projeto -->
- ...

## File Map

<!-- Mapear pastas e arquivos importantes -->
- `.context/` — PGP (Protocolo GENOMA Perpetuo) v2.0
- ...

## Scopes (para conventional commits)

<!-- Scopes especificos do projeto para conventional commits -->
- `context` — Estrutura .context/
- `genoma` — Framework GENOMA
- ...

## Constraints (armadilhas conhecidas)

<!-- Gotchas, limitacoes, coisas que nao sao obvias -->
- ...

## Credenciais

| ID | Nome | Var no .env | Para que | Status |
|----|------|-------------|---------|--------|
| CRED-01 | <!-- nome --> | <!-- VAR --> | <!-- uso --> | <!-- status --> |

### Seguranca

- .env deve estar no .gitignore
- NUNCA escrever valores de credenciais em arquivos commitados
- NUNCA incluir credenciais em SNAPSHOT, DECISIONS, deep/, commits
