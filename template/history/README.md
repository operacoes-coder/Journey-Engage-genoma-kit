# Session History — {{PROJECT_NAME}}

> PGP (Protocolo GENOMA Perpetuo) v4.0

## Formato

Arquivo: `session-NNN-YYYY-MM-DD-HHmm.md`

Exemplo: `session-001-2026-03-12-1430.md`

> Timestamps SEMPRE do relogio do computador local (`date +%Y-%m-%d-%H%M`)

## Template de Sessao

```markdown
# Sessao NNN — YYYY-MM-DD HH:MM

**Inicio:** HH:MM | **Fim:** HH:MM | **Duracao:** ~Xh
**Modo:** Normal / #marcha / Debug
**Foco:** [objetivo principal da sessao]

## Concluido
- [x] [tarefa completada]
- [x] [tarefa completada]

## Pendente (migrado para tasks/)
- [ ] [tarefa nao finalizada] → tasks/task-NNN.md

## Decisoes Tomadas
| Decisao | Rationale | Impacto |
|---------|-----------|---------|
| [o que] | [por que] | [onde afeta] |

## Erros Encontrados
| Erro | Causa | Fix | POP-003? |
|------|-------|-----|----------|
| [descricao] | [causa raiz] | [como resolveu] | Sim/Nao |

## Metricas da Sessao
- Commits: X
- Arquivos modificados: X
- Trocas Claude: ~X
- Checkpoints: X

## Contexto para Proxima Sessao
- **Comecar por:** [arquivo/modulo]
- **Seguir padrao de:** [referencia]
- **Tasks pendentes:** [link para tasks/]
- **Bloqueios:** [se houver]
```

## Indice de Sessoes

| # | Data | Hora | Foco | Resultado |
|---|------|------|------|-----------|
| 001 | {{DATE}} | -- | Inicializacao GENOMA v4 | Projeto configurado |

## Regras

1. **POP-001** cria automaticamente o registro da sessao aqui
2. **Timestamps** SEMPRE do relogio local (nunca estimados)
3. **Tasks pendentes** migradas para `tasks/` com referencia cruzada
4. **Decisoes** duplicadas em `.context/DECISIONS.md` se arquiteturais
5. **Nunca deletar** sessoes antigas — sao o historico do projeto
