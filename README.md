# GENOMA Kit — Inicializador do PGP (Protocolo GENOMA Perpetuo)

Kit para aplicar o framework GENOMA em qualquer projeto.

## Inicio Rapido

```bash
# No diretorio do projeto
bash /caminho/para/genoma-kit/genoma-init.sh

# Ou apontando para outro projeto
bash genoma-kit/genoma-init.sh /caminho/do/projeto
```

## O que o onboarding faz

O script roda em 7 passos:

```
[1/7] IDENTITY     — Pergunta nome, descricao, idioma
[2/7] STACK        — Auto-detecta tecnologias (package.json, requirements.txt, etc.)
[3/7] AMBIENTES    — Pergunta producao, dev, staging
[4/7] CREDENCIAIS  — Importa do .env.example ou pergunta manualmente
[5/7] GUARDRAILS   — Configura senha para acoes criticas
[6/7] POPs         — Sugere POPs baseado no que detectou (banco, testes, deploy)
[7/7] INSTALACAO   — Copia, personaliza e commita tudo
```

### O que e automatico (nao pergunta)

- Kernel GENOMA (README, hooks, POPs universais)
- Slash commands Claude Code (`.claude/commands/` — /pop-000 a /pop-003, /marcha)
- Git hooks (commit-msg, post-commit, pre-push)
- Templates (sessao, deep/)
- Deteccao de stack (Node, Python, Go, Rust, Java, n8n, Docker, CI/CD)
- Deteccao de banco (Supabase, Prisma, SQLite)
- Deteccao de testes (Jest, Vitest, Mocha, Cypress, Playwright, pytest)
- Importacao de credenciais do .env.example/.env.template
- Rotas especificas por tipo de projeto (webapp, api, cli, automation)
- .gitignore com .env protegido

### O que pergunta (precisa personalizar)

- Nome e descricao do projeto
- Idioma da documentacao (pt-BR, en, es)
- URLs dos ambientes
- Credenciais (se nao tiver .env.example)
- Senha para guardrails
- Quais POPs de projeto ativar

## 3 formas de usar

### 1. Script interativo (recomendado para projetos novos)

```bash
bash genoma-kit/genoma-init.sh /meu/projeto
```

Roda o wizard completo com auto-deteccao + perguntas.

### 2. Copia manual (para controle total)

```bash
cp -r genoma-kit/template/ /meu/projeto/.context/
```

Depois renomeie os `*.template.md` para `*.md` e preencha os placeholders `{{PROJECT_NAME}}`.

### 3. POP-INIT com Claude (para projetos existentes)

Apos copiar o template, na primeira sessao do Claude diga:

> "Executar POP-INIT para este projeto"

O Claude vai:
1. Analisar o projeto (pastas, stack, README, .env.example)
2. Preencher MANIFEST com dados reais
3. Criar diagrama de arquitetura no GRAPH
4. Adicionar rotas especificas no ROUTES
5. Identificar e criar POPs de projeto
6. Atualizar SNAPSHOT com estado real

## Apos inicializar

1. Revisar `.context/MANIFEST.md` — dados corretos?
2. Revisar `.context/ROUTES.md` — falta algum cenario?
3. Criar POPs de projeto em `.context/pops/POP-P0x.md` conforme necessidade
4. Trabalhar normalmente — POP-000 roda automaticamente no inicio de cada sessao

## Stacks detectadas automaticamente

| Arquivo/Pasta | Detecta |
|---------------|---------|
| package.json | Node.js, React, Vue, Next.js, Express, TypeScript |
| requirements.txt / pyproject.toml | Python, Django, FastAPI, Flask |
| go.mod | Go |
| Cargo.toml | Rust |
| pom.xml / build.gradle | Java |
| .mcp.json / workflows/ | n8n |
| Dockerfile / docker-compose | Docker |
| .github/workflows | GitHub Actions |
| .gitlab-ci.yml | GitLab CI |
| supabase/ / migrations/ | Supabase |
| prisma/schema.prisma | Prisma |
| *.sqlite | SQLite |

## Estrutura gerada

```
.context/
+-- README.md              <- Doc do framework (pronto)
+-- MANIFEST.md            <- Personalizado com dados do projeto
+-- SNAPSHOT.md            <- Estado inicial
+-- ROUTES.md              <- Universais + especificas do tipo de projeto
+-- DECISIONS.md           <- Vazio, pronto para crescer
+-- GRAPH.md               <- Zoom levels + placeholder para arquitetura
+-- pops/
|   +-- INDEX.md           <- Indice completo
|   +-- POP-000..003.md    <- Universais (prontos, inclui autocorrecao)
|   +-- POP-INIT.md        <- Bootstrap (uso unico)
|   +-- POP-P0x.md         <- De projeto (criados pelo onboarding)
+-- hooks/                 <- Git hooks (instalados automaticamente)
+-- templates/             <- Templates reutilizaveis
+-- deep/                  <- Investigacoes profundas

.claude/
+-- commands/
|   +-- pop-000.md         <- /pop-000 (diagnostico de sessao)
|   +-- pop-001.md         <- /pop-001 (save anti-compressao)
|   +-- pop-002.md         <- /pop-002 (checkpoint mid-session)
|   +-- pop-003.md         <- /pop-003 (autocorrecao de erros)
|   +-- marcha.md          <- /marcha (modo autonomo)
```

## Slash Commands

Os POPs funcionam automaticamente via regras no CLAUDE.md, mas tambem podem ser chamados manualmente via `/` no Claude Code:

| Comando | Funcao | Disparo principal |
|---------|--------|-------------------|
| `/pop-000` | Diagnostico do projeto | Auto no inicio da sessao |
| `/pop-001` | Save total anti-compressao | Auto por contagem de trocas |
| `/pop-002 FULL` | Checkpoint intermediario | Auto por monitoramento |
| `/pop-003 descricao` | Investigar e corrigir erro | Auto quando ha erro |
| `/marcha tarefa` | Modo autonomo | Manual |

**IMPORTANTE:** `.gitignore` deve ignorar `.claude/*` mas permitir `!.claude/commands/` para que os slash commands sejam versionados.
