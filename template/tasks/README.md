# Tasks — {{PROJECT_NAME}}

> PGP (Protocolo GENOMA Perpetuo) v4.0

## Formato

Arquivo de grupo: `tasks-YYYY-MM-DD-HHmm.md`
Exemplo: `tasks-2026-03-12-1430.md`

> Timestamps SEMPRE do relogio do computador local

## Template de Grupo de Tasks

```markdown
# Tasks — YYYY-MM-DD HH:MM

**Sessao:** NNN | **Prioridade:** Alta/Media/Baixa
**Origem:** POP-000 / POP-001 / Manual / Sessao NNN

## Tasks Ativas

| ID | Task | Status | Prioridade | Criada | Atualizada |
|----|------|--------|------------|--------|------------|
| T-001 | [descricao] | TODO/DOING/DONE/BLOCKED | Alta | HH:MM | HH:MM |
| T-002 | [descricao] | TODO | Media | HH:MM | HH:MM |

## Detalhes

### T-001: [titulo]
- **Status:** TODO
- **Prioridade:** Alta
- **Contexto:** [por que existe]
- **Criterio de Done:** [quando esta pronta]
- **Dependencias:** [de que depende]
- **Notas:** [observacoes]

## Tasks Concluidas (arquivo)

| ID | Task | Concluida em | Sessao |
|----|------|-------------|--------|
```

## Indice de Grupos

| Arquivo | Data | Sessao | Tasks | Status |
|---------|------|--------|-------|--------|
| tasks-{{DATE}}.md | {{DATE}} | 001 | 0 | Inicial |

## Status Possiveis

- `TODO` — Pendente, nao iniciada
- `DOING` — Em andamento na sessao atual
- `DONE` — Concluida
- `BLOCKED` — Bloqueada por dependencia
- `CANCELLED` — Cancelada (manter para historico)

## Regras

1. **POP-000** verifica tasks pendentes no inicio de cada sessao
2. **POP-001** migra tasks nao concluidas da sessao para proximo grupo
3. Tasks BLOCKED devem indicar o que desbloqueia
4. Tasks DONE sao movidas para secao "Concluidas" no fim da sessao
5. Cada grupo de tasks referencia a sessao de origem
6. Prioridade segue: `URGENTE > ALTA > MEDIA > BAIXA > FUTURO`
