# PGP — Protocolo GENOMA Perpetuo v2.0

## O Nome

**PGP** = sigla curta para referencia rapida (commits, hooks, docs)
**GENOMA** = substancia — cada letra e um pilar funcional do framework

---

## Os 6 Pilares

```
G . E . N . O . M . A
|   |   |   |   |   |
|   |   |   |   |   +-- Atualizacao ---- contexto que nunca morre (SNAPSHOT + hooks)
|   |   |   |   +------ Metricas ------- rastrear decisoes e credenciais (DECISIONS)
|   |   |   +---------- Orientada ------ saber pra onde ir (ROUTES + GRAPH)
|   |   +-------------- Normalizada ---- padronizar tudo (pops/ + hooks/)
|   +------------------ Estruturada ---- arquitetura clara (MANIFEST + GRAPH)
+---------------------- Gestao --------- governanca e regras (MANIFEST)
```

---

## Estrutura de Arquivos

```
.context/
|
+-- MANIFEST.md            <- DNA do projeto
+-- SNAPSHOT.md            <- Estado AGORA (auto-atualizado pelo post-commit hook)
+-- ROUTES.md              <- GPS — cenarios com rotas diretas
+-- DECISIONS.md           <- Registro de decisoes arquiteturais
+-- GRAPH.md               <- Diagramas visuais (Mermaid)
+-- pops/                  <- Procedimentos Operacionais (modular)
|   +-- INDEX.md
|   +-- POP-000.md         <- Diagnostico de inicio (auto)
|   +-- POP-001.md         <- Save de fim de sessao (auto)
|   +-- POP-002.md         <- Checkpoint mid-session
|   +-- POP-INIT.md        <- Bootstrap do projeto (primeira vez)
|   +-- POP-P0x.md         <- POPs especificos do projeto
+-- hooks/                 <- Git hooks de automacao
+-- templates/             <- Templates reutilizaveis
+-- deep/                  <- Investigacoes profundas (Zoom 8)
```

---

## Niveis de Zoom — Do Universo ao Atomo

So descer de nivel quando o anterior nao resolver. Economiza tokens.

```
Zoom 0  Universo     MEMORY.md        0 tokens    Auto-loaded toda sessao
Zoom 1  Galaxia      MANIFEST.md     ~1k tokens   Entender o projeto
Zoom 2  Sistema      SNAPSHOT.md     ~2k tokens   Estado atual
Zoom 3  Navegacao    ROUTES + POPs   ~2k tokens   Saber pra onde ir
Zoom 4  Planeta      git log         ~3k tokens   Timeline recente
Zoom 5  Continente   DECISIONS.md    ~5k tokens   Entender decisoes
Zoom 6  Cidade       git show        ~10k tokens  Detalhe de um commit
Zoom 7  Edificio     git blame       ~15k tokens  Quem mudou o que
Zoom 8  Atomo        deep/           ~30k tokens  Investigacao profunda
```

---

## Ciclo de Vida de uma Sessao

```
INICIO
  +-- POP-000 (auto) -> Le SNAPSHOT + git log + .env -> Diagnostico proativo
TRABALHO
  +-- A cada ~8 trocas -> POP-002 avalia necessidade de checkpoint
  +-- ~15 trocas sem save -> ALERTA AMARELO (POP-002 FULL)
  +-- ~25 trocas ou 10+ arquivos -> ALERTA LARANJA (POP-001)
  +-- ~35 trocas ou compressao -> ALERTA VERMELHO (POP-001 EMERGENCIA)
  +-- Erro em comando -> POP-003 (autocorrecao)
  +-- Decisao importante -> Registra em DECISIONS.md
  +-- Commits -> hook post-commit atualiza SNAPSHOT automaticamente
FIM
  +-- POP-001 (auto) -> Atualiza SNAPSHOT completo -> Commit de sessao
```

---

## Contexto Perpetuo — Protecao Anti-Compressao

O Claude comprime automaticamente mensagens antigas quando a janela de contexto fica grande.
Quando isso acontece, DETALHES SAO PERDIDOS PARA SEMPRE. O GENOMA previne essa perda.

**Principio:** O `.context/SNAPSHOT.md` e a MEMORIA PERSISTENTE do projeto.
Ler o SNAPSHOT sozinho deve ser suficiente para retomar 100% do trabalho.

**Gatilhos de Seguranca:**
| Nivel | Condicao | Acao |
|-------|----------|------|
| AMARELO | ~15 trocas sem save | POP-002 FULL |
| LARANJA | ~25 trocas OU 10+ arquivos lidos | POP-001 completo |
| VERMELHO | ~35 trocas OU sinal de compressao | POP-001 EMERGENCIA (parar tudo) |

**Regra de Ouro:** Na duvida entre salvar ou nao -> SALVAR.

---

## Autonomia dos POPs

| Nivel | Comportamento | Quais POPs |
|-------|--------------|------------|
| **Nivel 2** | Auto-executa sem perguntar | POP-000, POP-001, POP-002, POP-003 (correcoes seguras) |
| **Nivel 1** | Propoe e aguarda aprovacao | POP-003 (opcoes), POP-P01, POP-P02, POP-P04 |

---

## O que cada pilar protege

| Pilar | Sem ele... | Com ele... |
|-------|-----------|-----------|
| **G** (Gestao) | Acoes destrutivas sem controle | Guardrails + senha para acoes criticas |
| **E** (Estruturada) | Nao sabe onde nada esta | File map + arquitetura claros |
| **N** (Normalizada) | Cada commit num formato, POPs soltos | Conventional commits + POPs modulares |
| **O** (Orientada) | Perde tempo procurando | Rotas diretas com custo estimado |
| **M** (Metricas) | Repete erros, esquece decisoes | Log de decisoes com rationale |
| **A** (Atualizacao) | Perde contexto entre sessoes | SNAPSHOT perpetuo + hooks automaticos |
