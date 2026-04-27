# {{PROJECT_NAME}}

> PGP (Protocolo GENOMA Perpetuo) v4.0 — Framework de Alta Performance para Claude

## ============================================================
## BLOCO A: CONTEXT LOADING
## ============================================================

### Ordem de Leitura (SEMPRE nesta sequencia)

```
1. CLAUDE.md (este arquivo)          <- Regras + ancoragem
2. specs/glossary.md                 <- Falar a mesma lingua
3. .context/SNAPSHOT.md              <- Estado atual
4. .context/MANIFEST.md              <- DNA do projeto
5. .context/tasks/                   <- Tasks pendentes
6. .context/plans/                   <- Planos ativos
7. .context/history/                 <- Ultima sessao
8. .context/tools/                   <- Ferramentas disponiveis
9. Codigo de referencia              <- Padrao vivo
10. Specs sob demanda                <- Quando for implementar
```

### Context Tags

- `[ALWAYS]` — Regras que NUNCA ignoro
- `[WHEN:modulo]` — Regras ativas somente nesse modulo
- `[REFERENCE]` — Ponteiros para ler sob demanda
- `[CALIBRATION]` — Exemplos bom/ruim para calibracao

## ============================================================
## BLOCO B: MUNDO DO PROJETO
## ============================================================

## Projeto

- **Nome:** {{PROJECT_NAME}}
- **Descricao:** {{PROJECT_DESC}}
- **Stack:** {{DETECTED_STACK}}
- **Tipo:** {{PROJECT_TYPE}}
- **Repositorio:** <!-- URL do repositorio -->

### Visao
{{PROJECT_VISION}}

### Personas
<!-- Quem usa, como pensa, o que odeia -->

### Anti-goals
<!-- O que o projeto NAO pretende ser/fazer -->

## ============================================================
## BLOCO C: LINGUAGEM UBIQUA
## ============================================================

<!-- [ALWAYS] CRITICO: ambiguidade de vocabulario causa mais bugs que ambiguidade tecnica -->

| Termo | Significado Exato | NAO confundir com |
|-------|--------------------|--------------------|
| <!-- preencher termos do dominio --> | | |

> Arquivo completo: `specs/glossary.md`

## ============================================================
## BLOCO D: ESTRUTURA GENOMA
## ============================================================

```
.context/
+-- MANIFEST.md     # DNA do projeto (stack, credenciais, constraints)
+-- SNAPSHOT.md     # Estado ATUAL (ler primeiro para retomar)
+-- DECISIONS.md    # Log de decisoes com triggers de analise
+-- ROUTES.md       # GPS — cenarios com rotas diretas
+-- GRAPH.md        # Diagramas visuais (Mermaid)
+-- history/        # Historico de sessoes (data + hora)
+-- tasks/          # Grupos de tasks (data + hora)
+-- plans/          # Planos de implementacao
+-- tools/          # Ferramentas, APIs, MCP configs
+-- pops/           # Procedimentos Operacionais Padrao
+-- hooks/          # Git hooks de automacao
+-- templates/      # Templates reutilizaveis
+-- deep/           # Investigacoes profundas (Zoom 8)

specs/
+-- glossary.md           # Linguagem ubiqua
+-- invariants.md         # Leis inviolaveis
+-- error-taxonomy.md     # Catalogo de erros
+-- security-model.md     # Trust boundaries
+-- observability.md      # Logs, metricas, alertas
+-- performance.md        # Baselines e SLAs
+-- openapi.yaml          # Contrato da API
+-- schemas/              # JSON Schemas
+-- state-machines/       # Diagramas de estado
+-- data-flows/           # Fluxos de dados
+-- side-effects/         # Efeitos colaterais

docs/
+-- decisions/            # ADRs
+-- post-mortems/         # Bugs graves resolvidos
+-- anti-patterns.md      # O que nunca fazer
+-- session-history/      # (legado, usar .context/history/)

.claude/
+-- commands/             # Slash commands do GENOMA
+-- settings.json         # Permissions
```

## ============================================================
## BLOCO E: BANCO DE DADOS
## ============================================================

- **Tipo:** {{DB_TYPE}}
- **Provider:** {{DB_PROVIDER}}
- **Projeto:** <!-- ID ou nome do projeto no provider -->

### Regras de Banco
<!-- Constraints, migrations, backups -->

> Credenciais em `.env` — NUNCA hardcoded

## ============================================================
## BLOCO F: DESIGN SYSTEM
## ============================================================

- **Framework CSS:** {{DESIGN_SYSTEM}}
- **Componentes:** {{DESIGN_COMPONENTS}}
- **Tokens:** <!-- cores, tipografia, espacamento -->

<!-- Preencher conforme o projeto. Se nao aplicavel, remover bloco -->

## ============================================================
## BLOCO G: SPECS E CONTRATOS
## ============================================================

### [REFERENCE] Specs Disponiveis
- API: `specs/openapi.yaml`
- Schemas: `specs/schemas/`
- State Machines: `specs/state-machines/`
- Data Flows: `specs/data-flows/`

### [ALWAYS] Invariantes do Dominio

| ID | Invariante | Modulo |
|----|------------|--------|
| <!-- preencher --> | | |

> Arquivo completo: `specs/invariants.md`

### [ALWAYS] State Machines
<!-- Diagramas de estado por entidade -->
> Diagramas completos: `specs/state-machines/`

### [REFERENCE] Side Effects Map
> Arquivo completo: `specs/side-effects/`

## ============================================================
## BLOCO H: COMO FAZEMOS AQUI
## ============================================================

### [ALWAYS] Codigo de Referencia
<!-- O modulo modelo que eu replico -->
- **Modulo referencia:** <!-- caminho do modulo -->
- **Padrao de arquitetura:** <!-- MVC, Clean, etc -->

### [ALWAYS] Convencoes
<!-- Preencher conforme o projeto -->
- Nomes de arquivo: <!-- kebab-case, camelCase, etc -->
- Funcoes: <!-- camelCase, snake_case -->
- Testes: <!-- localizacao dos testes -->

### [ALWAYS] Comandos

```bash
# Desenvolvimento
<!-- comando de dev -->

# Testes
<!-- comando de teste -->

# Build
<!-- comando de build -->
```

### Commits

Conventional commits com scopes do projeto:
<!-- listar scopes: feat, fix, etc -->

Formato: `tipo(scope): descricao curta`

Tipos validos: feat, fix, refactor, docs, test, deploy, config, decision, investigate, snapshot, context, session, playbook, audit, rollback

## ============================================================
## BLOCO I: PONTOS CEGOS
## ============================================================

### [ALWAYS] Error Taxonomy

| Tipo | HTTP | Retentavel | Estrategia |
|------|------|------------|------------|
| Validacao | 400 | Nao | Retornar campos invalidos |
| Autenticacao | 401 | Nao | Redirecionar para login |
| Rate limit | 429 | Sim | Backoff exponencial |
| Infraestrutura | 503 | Sim | Retry 3x com backoff |

> Arquivo completo: `specs/error-taxonomy.md`

### [ALWAYS] Trust Boundaries

| Fronteira | Nivel de Confianca | Acao |
|-----------|-------------------|------|
| Input do usuario | Nao confiavel | Validar tudo |
| API externa | Nao confiavel | Validar response |
| Entre services | Semi-confiavel | Validar tipos |
| Banco de dados | Confiavel | Constraints validam |

### [REFERENCE] Security Model
> `specs/security-model.md`

### [REFERENCE] Observability
> `specs/observability.md`

## ============================================================
## BLOCO J: CALIBRACAO
## ============================================================

### [CALIBRATION] Exemplo Positivo
```{{LANG}}
<!-- codigo exemplo BOM do projeto -->
```

### [CALIBRATION] Exemplo Negativo
```{{LANG}}
<!-- codigo exemplo RUIM + por que e ruim -->
```

### Correcao Protocol
Quando corrigido, espero: 1) O que esta errado 2) O correto 3) Escopo

## ============================================================
## BLOCO K: GUARDRAILS E RESTRICOES
## ============================================================

### [ALWAYS] Proibido
- Nunca expor API keys, tokens ou credenciais
- Nunca modificar producao sem backup previo

### [ALWAYS] Anti-patterns
> `docs/anti-patterns.md`

### Guardrails
{{GUARDRAIL_SECTION}}

### Ambientes

| Ambiente | URL/Config |
|----------|-----------|
| Dev | {{ENV_DEV}} |
| Staging | {{ENV_STAGING}} |
| Producao | {{ENV_PROD}} |

### Performance Baselines
> `specs/performance.md`

## ============================================================
## BLOCO L: VERIFICACAO
## ============================================================

### [ALWAYS] Definition of Done

Antes de considerar QUALQUER tarefa pronta:
- [ ] Codigo segue o modulo de referencia
- [ ] Invariantes do dominio respeitados
- [ ] Side effects implementados conforme specs
- [ ] Error handling conforme error taxonomy
- [ ] Sem secrets hardcoded
- [ ] Tasks atualizadas em tasks/

## ============================================================
## BLOCO M: REGRAS DE SESSAO (ciclo GENOMA)
## ============================================================

### Inicio (POP-000 — auto)
1. Ler `CLAUDE.md` + `.context/SNAPSHOT.md` + `specs/glossary.md`
2. `git log --oneline -10` + `git status`
3. Verificar `tasks/` — tasks pendentes (TODO, DOING, BLOCKED)
4. Verificar `plans/` — planos ativos
5. Ler ultima sessao em `history/`
6. Verificar `tools/` — configs e credenciais
7. Gerar diagnostico proativo e perguntar foco

### Durante
- A cada ~8 trocas: checkpoint (POP-002)
- ~15 trocas: ALERTA AMARELO
- ~25 trocas ou 10+ arquivos: ALERTA LARANJA (POP-001)
- ~35 trocas ou compressao: ALERTA VERMELHO (POP-001 EMERGENCIA)
- Decisao importante: registrar em DECISIONS.md com timestamp real
- Erro: POP-003 (autocorrecao)

### Fim (POP-001 — auto)
1. Commitar tudo pendente
2. Verificar decisoes nao registradas
3. Salvar historico em `history/session-NNN-YYYY-MM-DD-HHmm.md`
4. Migrar tasks pendentes
5. Atualizar SNAPSHOT.md completo e autocontido
6. Commit: `session(save): session NNN - [resumo]`

### Timestamps
TODOS os timestamps (history, tasks, decisions, snapshot) usam o relogio do computador:
- Data: `date +%Y-%m-%d`
- Hora: `date +%H:%M`
- Arquivo: `date +%Y-%m-%d-%H%M`

## ============================================================
## BLOCO N: COMPORTAMENTO
## ============================================================

### [ALWAYS] Verificar antes de perguntar
NUNCA perguntar se algo esta instalado. SEMPRE verificar primeiro.

### [ALWAYS] Resolver antes de escalar
Tentar resolver sozinho. Se bloqueado: explicar o que tentou.

### [ALWAYS] Confidence Signals
- Se tem spec: implementar sem perguntar
- Se NAO tem spec: perguntar antes
- Se tem invariante: proteger SEMPRE
- Se tem ambiguidade no glossario: perguntar SEMPRE

## ============================================================
## BLOCO O: AUTONOMIA E ESCALACAO
## ============================================================

### Escalation Rules

| Situacao | Acao |
|----------|------|
| Reversivel + tem spec | Fazer sozinho |
| Reversivel + sem spec | Fazer + informar |
| Irreversivel + tem spec | Confirmar rapido |
| Irreversivel + sem spec | Parar e perguntar |
| Producao | SEMPRE perguntar |
| Seguranca/auth | SEMPRE perguntar |
| Deletar | SEMPRE perguntar |

### Slash Commands

| Comando | Funcao |
|---------|--------|
| `/pop-000` | Diagnostico completo |
| `/pop-001` | Save de sessao |
| `/pop-002 FULL` | Checkpoint |
| `/pop-003 descricao` | Autocorrecao |
| `/marcha tarefa` | Modo autonomo |
| `/plan titulo` | Criar/revisar plano |
| `/tasks` | Gerenciar tasks |

### Tools Disponiveis
> Ver `.context/tools/` para lista completa de ferramentas configuradas

## ============================================================
## BLOCO P: FERRAMENTAS E INTEGRACOES
## ============================================================

### MCP Servers
<!-- Listar MCP servers configurados em .mcp.json -->
> Ver: `.context/tools/mcp-config.md`

### APIs Externas
<!-- Listar APIs usadas pelo projeto -->
> Ver: `.context/tools/api-docs.md`

### Ferramentas Locais
<!-- Listar ferramentas locais (Playwright, etc) -->
> Ver: `.context/tools/playwright.md`

## ============================================================
## BLOCO Q: CREDENCIAIS
## ============================================================

Todas em `.env` (nunca hardcoded). Ver MANIFEST.md > Credenciais para lista completa.
NUNCA incluir valores de credenciais em commits, SNAPSHOT, DECISIONS ou deep/.
Documentacao de uso: `tools/api-docs.md` e `tools/mcp-config.md`

## ============================================================
## META: Sobre este template
## ============================================================

<!--
PGP GENOMA v4.0 — Framework de Alta Performance
17 blocos de contexto:
  A. Context Loading     -> Ordem de carregamento
  B. Mundo do Projeto    -> Visao, personas, anti-goals
  C. Linguagem Ubiqua    -> Glossario
  D. Estrutura           -> Onde tudo esta (com history, tasks, plans, tools)
  E. Banco de Dados      -> Tipo, provider, regras
  F. Design System       -> Framework CSS, componentes, tokens
  G. Specs e Contratos   -> Invariantes, state machines, side effects
  H. Padroes Vivos       -> Referencia, convencoes, commits
  I. Pontos Cegos        -> Error taxonomy, trust boundaries
  J. Calibracao          -> Exemplos bom/ruim
  K. Guardrails          -> Proibicoes, ambientes, performance
  L. Verificacao         -> Definition of Done
  M. Ciclo de Sessao     -> POPs com tasks + history + timestamps reais
  N. Comportamento       -> Verificar antes de perguntar
  O. Autonomia           -> Escalation rules, slash commands
  P. Ferramentas         -> MCP, APIs, tools locais
  Q. Credenciais         -> Seguranca

Evolucao v3 -> v4:
  + history/ (sessoes com data+hora)
  + tasks/ (grupos com data+hora)
  + plans/ (planos de implementacao)
  + tools/ (ferramentas, MCP, APIs)
  + Banco de Dados (bloco E)
  + Design System (bloco F)
  + Ferramentas (bloco P)
  + Timestamps reais do computador em tudo
  + POPs verificam tasks/plans/history
  + Decisoes com triggers de analise
-->
