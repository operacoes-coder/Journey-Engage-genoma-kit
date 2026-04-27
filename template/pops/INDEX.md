# POPs — Indice

> PGP (Protocolo GENOMA Perpetuo) v4.0

## Framework (sempre ativos)

| POP | Nome | Trigger | Autonomia |
|-----|------|---------|-----------|
| [POP-000](POP-000.md) | Diagnostico de Inicio de Sessao | Inicio de sessao (auto) | Nivel 2 (auto) |
| [POP-001](POP-001.md) | Save / Protecao Anti-Compressao | Fim de sessao + gatilhos de contexto | Nivel 2 (auto) |
| [POP-002](POP-002.md) | Checkpoint Mid-Session | Monitoramento continuo (~8 trocas) | Nivel 2 (auto) |
| [POP-003](POP-003.md) | Autocorrecao de Erros | Qualquer erro ou warning | Nivel 2/1 (auto/opcoes) |

## Bootstrap (primeira vez)

| POP | Nome | Trigger | Autonomia |
|-----|------|---------|-----------|
| [POP-INIT](POP-INIT.md) | Bootstrap do Projeto | Primeira sessao | Nivel 1 (propor) |

## Projeto (criar conforme necessidade)

<!-- Adicionar POPs especificos do projeto aqui -->
<!-- | [POP-P01](POP-P01.md) | Nome | Trigger | Nivel | -->

## O que cada POP verifica (v4.0)

| Recurso | POP-000 | POP-001 | POP-002 | POP-003 |
|---------|---------|---------|---------|---------|
| SNAPSHOT.md | Le | Atualiza | Atualiza | Atualiza |
| MANIFEST.md | Le | — | — | — |
| tasks/ | Analisa pendentes | Migra pendentes | — | Cria task se recorrente |
| history/ | Le ultima sessao | Cria registro | — | — |
| plans/ | Verifica ativos | — | — | — |
| DECISIONS.md | — | Valida pendentes | — | Registra se relevante |
| tools/ | Verifica configs | — | — | — |
| git status | Verifica | Commita | — | — |
| git log | Le -10 | — | — | Le erros |

## Niveis de Autonomia

- **Nivel 1:** Propor com tudo preparado, aguardar aprovacao do usuario
- **Nivel 2:** Auto-executar sem esperar (com registro no log)

## Slash Commands (atalhos manuais)

POPs sao executados automaticamente por regras no CLAUDE.md, mas tambem podem ser chamados manualmente:

| Comando | POP | Quando usar manualmente |
|---------|-----|------------------------|
| `/pop-000` | POP-000 | Agente nao executou diagnostico no inicio |
| `/pop-001` | POP-001 | Forcar save antes de sair |
| `/pop-002 FULL` | POP-002 | Forcar checkpoint especifico |
| `/pop-003 descricao` | POP-003 | Pedir investigacao de erro |
| `/marcha tarefa` | — | Ativar modo autonomo |
| `/plan titulo` | — | Criar novo plano |
| `/tasks` | — | Listar tasks pendentes |

Os arquivos dos comandos ficam em `.claude/commands/` e sao gerados pelo `genoma-init.sh`.
