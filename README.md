# GENOMA Kit v4.0 — Instalador Definitivo do PGP

> **G**estao **E**struturada **N**ormalizada **O**rientada por **M**etricas e **A**tualizacao

Framework de alta performance para Claude Code. Transforma qualquer projeto em um ambiente com contexto perpetuo, rastreabilidade completa e automacao inteligente.

---

## Por que usar o GENOMA?

### O Problema
- Claude perde contexto entre sessoes (compressao de contexto)
- Informacoes importantes se perdem quando a janela de contexto enche
- Cada sessao comeca do zero — o Claude nao sabe onde parou
- Decisoes sao tomadas sem registro — erros se repetem
- Tasks se perdem entre sessoes

### A Solucao
O GENOMA cria um **sistema nervoso** para o projeto:

| Recurso | O que resolve |
|---------|---------------|
| **SNAPSHOT.md** | Claude retoma exatamente de onde parou |
| **history/** | Historico completo de cada sessao (data+hora) |
| **tasks/** | Tasks nunca se perdem entre sessoes |
| **plans/** | Planos estruturados com fases e criterios |
| **DECISIONS.md** | Decisoes registradas — nunca repete erro |
| **tools/** | Ferramentas documentadas e pre-configuradas |
| **POPs** | Automacao de diagnostico, save e correcao |
| **CLAUDE.md** | 17 blocos de contexto de alta performance |

### Beneficios

- **Continuidade perfeita** — Retoma em ~3k tokens, como se nunca tivesse saido
- **Zero perda de contexto** — POP-001 salva automaticamente antes de compressao
- **Tasks rastreadas** — Criacao, priorizacao e migracao automatica
- **Decisoes documentadas** — Com triggers de analise e rationale
- **Ferramentas prontas** — Playwright, MCP, APIs pre-configurados
- **3 modos** — Do rapido ao completo, conforme a necessidade

---

## Inicio Rapido

```bash
# Clonar o genoma-kit (ou copiar a pasta)
git clone https://github.com/retonalinha-coder/genoma-kit.git

# Instalar no seu projeto
bash genoma-kit/genoma-init-v4.sh /caminho/do/projeto
```

O instalador detecta se o projeto ja existe e preenche automaticamente.

---

## 3 Modos de Instalacao

### 1. Rapido (~2 min)
Para projetos simples ou quando quer so o essencial.

**Instala:** `.context/` (MANIFEST, SNAPSHOT, ROUTES, POPs, hooks) + `.claude/commands/`

```
[1/7] IDENTITY      — Nome, descricao, idioma
[2/7] STACK         — Auto-deteccao de tecnologias
[3/7] BANCO         — Pergunta sobre banco de dados
[4/7] AMBIENTES     — Producao, dev, staging
[5/7] CREDENCIAIS   — Importa de .env.example ou manual
[6/7] GUARDRAILS    — Senha para acoes criticas
[7/7] INSTALACAO    — Copia, personaliza, commita
```

### 2. Intermediario (~5 min)
Para projetos em andamento que precisam de rastreabilidade.

**Instala:** Tudo do rapido + `history/` + `tasks/` + `plans/` + `tools/` + `specs/` (glossario + invariantes) + `CLAUDE.md`

```
[1-6/10] ... (mesmos do rapido)
[7/10]  FERRAMENTAS    — Playwright, MCP, APIs
[8/10]  DESIGN SYSTEM  — Framework CSS + componentes (se webapp)
[9/10]  POPs PROJETO   — Auditoria DB, testes, deploy, backup
[10/10] INSTALACAO     — Tudo + CLAUDE.md 17 blocos
```

### 3. Completo (~10 min)
Para projetos criticos ou quando quer performance maxima do Claude.

**Instala:** Tudo do intermediario + `specs/` completo (error taxonomy, security, observability, performance, openapi) + `docs/` (decisions, post-mortems, anti-patterns) + glossario interativo + invariantes

```
[1-8/13] ... (mesmos do intermediario)
[9/13]  GLOSSARIO       — Linguagem ubiqua do dominio
[10/13] INVARIANTES     — Leis inviolaveis
[11/13] POPs PROJETO    — Baseados na deteccao
[12/13] INSTALACAO      — Estrutura completa
[13/13] COMMIT          — Commit inicial
```

---

## Deteccao Automatica

### Projeto Existente vs Novo
O instalador detecta automaticamente se a pasta tem um projeto:
- **Existente:** Varre a pasta, detecta stack, importa credenciais, preenche dados
- **Novo:** Faz perguntas para configurar do zero

### Stacks Detectadas

| Arquivo/Pasta | Detecta |
|---------------|---------|
| package.json | Node.js, React, Vue, Next.js, Express, TypeScript |
| requirements.txt / pyproject.toml | Python, Django, FastAPI, Flask, Playwright |
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

### Bancos de Dados
Detecta automaticamente ou pergunta:
Supabase, PostgreSQL, MySQL, MongoDB, SQLite, Firebase, Redis

### Design System (webapps)
Pergunta framework CSS (Tailwind, Bootstrap, Material, Chakra, etc.) e biblioteca de componentes (shadcn/ui, Radix, Headless UI, Ant Design).

---

## Estrutura Completa (modo completo)

```
projeto/
├── CLAUDE.md                      # Framework 17 blocos de alta performance
├── .context/
│   ├── MANIFEST.md                # DNA do projeto (stack, credenciais, DB)
│   ├── SNAPSHOT.md                # Estado atual (perpetuo, autocontido)
│   ├── DECISIONS.md               # Decisoes com triggers de analise
│   ├── ROUTES.md                  # GPS + rotas por tipo de projeto
│   ├── GRAPH.md                   # Diagramas + fluxo GENOMA
│   ├── history/                   # Sessoes com data+hora real
│   ├── tasks/                     # Tasks com data+hora real
│   ├── plans/                     # Planos de implementacao
│   ├── tools/                     # Ferramentas e integracoes
│   │   ├── playwright.md          # Browser, scraping, screenshots
│   │   ├── mcp-config.md          # MCP servers (Claude tools)
│   │   └── api-docs.md            # APIs externas
│   ├── pops/                      # POPs universais + projeto
│   │   ├── INDEX.md               # Indice com matriz de verificacao
│   │   ├── POP-000.md             # Diagnostico (tasks+planos+tools)
│   │   ├── POP-001.md             # Save (historico+decisoes+tasks)
│   │   ├── POP-002.md             # Checkpoint (LIGHT/FULL/SAFETY)
│   │   ├── POP-003.md             # Autocorrecao (com prevencao)
│   │   ├── POP-INIT.md            # Bootstrap (uso unico)
│   │   └── POP-P0x.md             # De projeto (DB, testes, deploy)
│   ├── hooks/                     # Git hooks (commit-msg, etc.)
│   ├── deep/                      # Investigacoes profundas
│   └── templates/                 # Templates reutilizaveis
├── specs/
│   ├── glossary.md                # Linguagem ubiqua
│   ├── invariants.md              # Leis inviolaveis
│   ├── error-taxonomy.md          # Catalogo de erros
│   ├── security-model.md          # Trust boundaries
│   ├── observability.md           # Logs e metricas
│   ├── performance.md             # Baselines e SLAs
│   ├── openapi.yaml               # Contrato da API
│   ├── schemas/                   # JSON Schemas
│   ├── state-machines/            # Diagramas de estado
│   ├── data-flows/                # Fluxos de dados
│   └── side-effects/              # Efeitos colaterais
├── docs/
│   ├── decisions/                 # ADRs formais
│   ├── post-mortems/              # Bugs graves resolvidos
│   └── anti-patterns.md           # O que nunca fazer
└── .claude/
    └── commands/                  # Slash commands
        ├── pop-000.md             # /pop-000 diagnostico
        ├── pop-001.md             # /pop-001 save
        ├── pop-002.md             # /pop-002 checkpoint
        ├── pop-003.md             # /pop-003 autocorrecao
        ├── marcha.md              # /marcha modo autonomo
        ├── plan.md                # /plan criar/revisar planos
        └── tasks.md               # /tasks gerenciar tasks
```

---

## Slash Commands

| Comando | O que faz | Disparo |
|---------|-----------|---------|
| `/pop-000` | Diagnostico completo (tasks, planos, tools, historico) | Auto no inicio |
| `/pop-001` | Save total (historico, decisoes, tasks, SNAPSHOT) | Auto por trocas |
| `/pop-002 FULL` | Checkpoint intermediario (LIGHT/FULL/SAFETY) | Auto ~8 trocas |
| `/pop-003 descricao` | Investigar e corrigir erro (com prevencao) | Auto em erros |
| `/marcha tarefa` | Modo autonomo — trabalhar sem pedir permissao | Manual |
| `/plan titulo` | Criar ou revisar plano de implementacao | Manual |
| `/tasks` | Listar, criar ou gerenciar tasks | Manual |

---

## POPs (Procedimentos Operacionais Padrao)

### Ciclo de Sessao

```
Inicio ──→ POP-000 ──→ Trabalho ──→ POP-001 ──→ Fim
              │            │             │
              ├─ Tasks     ├─ POP-002    ├─ History
              ├─ Plans     ├─ POP-003    ├─ Tasks
              ├─ History   ├─ Decisions  ├─ Decisions
              └─ Tools     └─ Tasks      └─ SNAPSHOT
```

### O que cada POP verifica (v4)

| Recurso | POP-000 | POP-001 | POP-002 | POP-003 |
|---------|---------|---------|---------|---------|
| SNAPSHOT | Le | Atualiza | Atualiza | Atualiza |
| tasks/ | Analisa pendentes | Migra pendentes | Atualiza status | Cria se recorrente |
| history/ | Le ultima sessao | Cria registro | — | — |
| plans/ | Verifica ativos | — | — | — |
| DECISIONS | — | Valida pendentes | FULL: valida | Registra se relevante |
| tools/ | Verifica configs | — | — | — |

### Timestamps
**TODOS** os timestamps usam o relogio do computador:
- Historico: `session-NNN-YYYY-MM-DD-HHmm.md`
- Tasks: `tasks-YYYY-MM-DD-HHmm.md`
- Decisoes: tabela com data + hora real
- SNAPSHOT: Recent Activity com data + hora

---

## 4 Formas de Usar

### 1. Instalador interativo (recomendado)
```bash
bash genoma-kit/genoma-init-v4.sh /meu/projeto
```

### 2. Copia manual
```bash
cp -r genoma-kit/template/ /meu/projeto/.context/
# Renomear *.template.md → *.md
# Substituir {{PROJECT_NAME}} pelo nome
```

### 3. POP-INIT com Claude
Apos copiar o template, na primeira sessao:
> "Executar POP-INIT para este projeto"

### 4. Claude direto (sem script)
> "Instale o framework GENOMA v4 neste projeto usando as instrucoes do genoma-kit"

---

## Estrategia por tras

### Zoom Levels (Universo → Atomo)
O GENOMA organiza contexto em 9 niveis de profundidade:

| Zoom | Nome | Fonte | Tokens |
|------|------|-------|--------|
| 0 | Universo | MEMORY.md | 0 |
| 1 | Galaxia | MANIFEST | ~1k |
| 2 | Sistema | SNAPSHOT | ~2k |
| 3 | Navegacao | ROUTES + POPs | ~2k |
| 4 | Planeta | git log | ~3k |
| 5 | Continente | DECISIONS | ~5k |
| 6 | Cidade | git show | ~10k |
| 7 | Edificio | git blame | ~15k |
| 8 | Atomo | deep/ | ~30k |

**Principio:** Carregar apenas o que precisa, no nivel certo, no momento certo.

### Contexto Proativo
O Claude nao espera voce pedir — ele:
1. Diagnostica o estado do projeto automaticamente (POP-000)
2. Salva antes de perder contexto (POP-001)
3. Verifica tasks e planos pendentes
4. Registra decisoes quando triggers disparam
5. Cria historico de sessao com timestamps reais

### Anti-Compressao
Quando o contexto do Claude esta proximo do limite:
- **~15 trocas:** Alerta amarelo
- **~25 trocas:** Alerta laranja (save automatico)
- **~35 trocas:** Alerta vermelho (save emergencial)

O SNAPSHOT e **autocontido** — a proxima sessao retoma sem ler mais nada.

---

## Comparacao com versoes anteriores

| Feature | v2 | v3 | v4 |
|---------|----|----|-----|
| .context/ core | OK | OK | OK |
| specs/ | — | OK | OK |
| docs/ | — | OK | OK |
| history/ (data+hora) | — | — | **OK** |
| tasks/ (data+hora) | — | — | **OK** |
| plans/ | — | — | **OK** |
| tools/ (Playwright, MCP, API) | — | — | **OK** |
| Banco de dados | — | — | **OK** |
| Design system | — | — | **OK** |
| 3 modos (rapido/inter/completo) | — | — | **OK** |
| Decisoes com triggers | — | — | **OK** |
| POPs verificam tasks/plans | — | — | **OK** |
| Rotas por tipo de projeto | OK | — | **OK** |
| POPs de projeto (arquivos) | OK | — | **OK** |
| .env.template fallback | OK | — | **OK** |
| /plan e /tasks commands | — | — | **OK** |
| CLAUDE.md 17 blocos | — | 15 | **17** |
| Timestamps reais | — | — | **OK** |

---

## FAQ

**Q: Posso usar em projetos existentes?**
R: Sim. O instalador detecta projetos existentes e preenche automaticamente.

**Q: Funciona com qualquer linguagem?**
R: Sim. Detecta automaticamente Node, Python, Go, Rust, Java, n8n e mais.

**Q: E se eu so quiser o basico?**
R: Use o modo **rapido** — instala em ~2 min so o essencial.

**Q: Preciso do Claude Code?**
R: Recomendado mas nao obrigatorio. Os slash commands (`/pop-000`, etc.) so funcionam no Claude Code. O framework funciona em qualquer interface do Claude.

**Q: .gitignore?**
R: O instalador cria/atualiza .gitignore para ignorar `.env` e `.claude/*` (exceto commands).

---

## Licenca

MIT — Use, modifique, distribua livremente.
