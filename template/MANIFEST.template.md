# {{PROJECT_NAME}} — Manifest

> PGP (Protocolo GENOMA Perpetuo) v4.0

## GENOMA — Os 6 Pilares

| Pilar | Significado | Funcao | Arquivo(s) |
|-------|-------------|--------|------------|
| **G** | Gestao | Governanca, guardrails, regras | MANIFEST.md |
| **E** | Estruturada | Arquitetura, mapa de arquivos, stack | MANIFEST.md + GRAPH.md |
| **N** | Normalizada | Padronizacao, commits, POPs | pops/ + hooks/ |
| **O** | Orientada | Navegacao por cenario, zoom levels | ROUTES.md + GRAPH.md |
| **M** | Metricas | Rastreabilidade, decisoes, tasks | DECISIONS.md + tasks/ |
| **A** | Atualizacao | Perpetuidade, snapshots, historico | SNAPSHOT.md + history/ |

## Identity

- **Projeto:** {{PROJECT_NAME}}
- **Descricao:** <!-- O que este projeto faz -->
- **Visao:** <!-- Por que existe -->
- **Stack:** <!-- Linguagens, frameworks, servicos -->
- **Repositorio:** <!-- URL ou local -->
- **Ambientes:** <!-- dev, staging, producao -->
- **Banco de Dados:** <!-- Tipo, provider, projeto -->

## Architecture

<!-- Descrever padroes e decisoes arquiteturais do projeto -->
- ...

## File Map

<!-- Mapear pastas e arquivos importantes -->
- `.context/` — PGP (Protocolo GENOMA Perpetuo) v4.0
- `specs/` — Contratos, invariantes, schemas
- `docs/` — Decisoes, post-mortems, anti-patterns
- `tools/` — Ferramentas, APIs, MCP configs
- ...

## Design System

<!-- Se aplicavel: framework CSS, componentes, tokens -->
- **Framework:** <!-- Tailwind, Bootstrap, Material, etc -->
- **Componentes:** <!-- shadcn/ui, Radix, Chakra, etc -->
- **Tokens:** <!-- cores, tipografia, espacamento -->

## Scopes (para conventional commits)

<!-- Scopes especificos do projeto para conventional commits -->
- `context` — Estrutura .context/
- `genoma` — Framework GENOMA
- ...

## Constraints (armadilhas conhecidas)

<!-- Gotchas, limitacoes, coisas que nao sao obvias -->
- ...

## Credenciais

| ID | Nome | Var no .env | Para que | Tipo | Status |
|----|------|-------------|---------|------|--------|
| CRED-01 | <!-- nome --> | <!-- VAR --> | <!-- uso --> | API Key/Token/MCP | <!-- status --> |

### Seguranca

- .env deve estar no .gitignore
- NUNCA escrever valores de credenciais em arquivos commitados
- NUNCA incluir credenciais em SNAPSHOT, DECISIONS, deep/, commits
- Credenciais MCP documentadas em `tools/mcp-config.md`
- Credenciais de API documentadas em `tools/api-docs.md`
