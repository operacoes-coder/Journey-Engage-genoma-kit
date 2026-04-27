# Plans — {{PROJECT_NAME}}

> PGP (Protocolo GENOMA Perpetuo) v4.0

## Formato

Arquivo: `plan-NNN-titulo-YYYY-MM-DD.md`
Exemplo: `plan-001-setup-api-2026-03-12.md`

## Template de Plano

```markdown
# Plan NNN: [Titulo]

**Criado:** YYYY-MM-DD HH:MM | **Status:** Draft/Aprovado/Em Execucao/Concluido
**Sessao:** NNN | **Autor:** Claude + Usuario
**Estimativa:** ~X sessoes

## Objetivo
[O que este plano resolve]

## Contexto
[Por que agora, o que motivou]

## Abordagem Escolhida
[Estrategia de implementacao]

### Alternativas Consideradas
| Alternativa | Pros | Contras | Rejeitada por |
|------------|------|---------|---------------|
| [opcao A] | [vantagens] | [desvantagens] | [motivo] |

## Fases

### Fase 1: [nome] (~X sessoes)
- [ ] Step 1.1: [descricao]
- [ ] Step 1.2: [descricao]
**Criterio:** [como saber que terminou]

### Fase 2: [nome] (~X sessoes)
- [ ] Step 2.1: [descricao]
**Criterio:** [como saber que terminou]

## Riscos
| Risco | Probabilidade | Impacto | Mitigacao |
|-------|--------------|---------|-----------|
| [risco] | Alta/Media/Baixa | Alto/Medio/Baixo | [como mitigar] |

## Dependencias
- [do que este plano depende]

## Metricas de Sucesso
- [como medir se deu certo]

## Atualizacoes
| Data | Hora | Update |
|------|------|--------|
| YYYY-MM-DD | HH:MM | [o que mudou] |
```

## Indice de Planos

| # | Titulo | Status | Criado | Sessoes |
|---|--------|--------|--------|---------|
| — | Nenhum plano criado | — | — | — |

## Regras

1. **Plano antes de feature grande** — >2 sessoes de trabalho = criar plano
2. **POP-000** verifica planos em execucao no inicio da sessao
3. **Atualizacoes** com timestamp real do computador
4. Planos concluidos ficam como referencia (nunca deletar)
5. Plano rejeitado = documentar por que (evita revisitar)
