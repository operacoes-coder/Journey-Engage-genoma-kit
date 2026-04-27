# Decisions Log — {{PROJECT_NAME}}

> PGP (Protocolo GENOMA Perpetuo) v4.0

## Formato

| # | Data | Hora | Decisao | Rationale | Impacto | Trigger |
|---|------|------|---------|-----------|---------|---------|
| D-001 | YYYY-MM-DD | HH:MM | [o que decidiu] | [por que] | [onde afeta] | [o que motivou] |

## Decisions

<!-- Decisoes sao registradas automaticamente durante as sessoes -->
<!-- POP-001 verifica se houve decisoes nao registradas no fim da sessao -->

| # | Data | Hora | Decisao | Rationale | Impacto | Trigger |
|---|------|------|---------|-----------|---------|---------|
| — | — | — | Nenhuma decisao registrada | — | — | — |

## Triggers de Analise

> Condicoes que DEVEM gerar uma decisao registrada

- Escolha de tecnologia/framework/lib
- Mudanca de arquitetura ou padrao
- Trade-off de performance vs legibilidade
- Rejeicao de abordagem alternativa
- Mudanca de escopo ou prioridade
- Definicao de constraint ou regra de negocio
- Escolha de design system ou componentes
- Definicao de estrategia de deploy

## Como Registrar

1. Identificar que uma decisao esta sendo tomada (triggers acima)
2. Registrar na tabela com timestamp real do computador
3. Incluir rationale (POR QUE, nao so O QUE)
4. Indicar impacto (quais modulos/areas afeta)
5. Referenciar em SNAPSHOT.md se relevante
6. Se for ADR formal: criar arquivo em `docs/decisions/`

## Regras

- **Timestamps reais** — sempre do relogio do computador (`date +%H:%M`)
- **Nunca deletar** — decisoes sao historico permanente
- **Rationale obrigatorio** — sem "por que" = decisao incompleta
- **POP-001 valida** — no fim da sessao, verifica decisoes pendentes
