---
description: "/tasks: Listar, criar ou gerenciar tasks do projeto"
---

Gerenciar tasks do projeto.

Se $ARGUMENTS esta vazio — LISTAR:
1. Ler todos os arquivos em `.context/tasks/`
2. Mostrar resumo:
   - Tasks TODO (por prioridade)
   - Tasks DOING (em andamento)
   - Tasks BLOCKED (com motivo do bloqueio)
   - Total de tasks DONE (ultimas 5)
3. Sugerir priorizacao se necessario

Se $ARGUMENTS contem "add" ou "criar" — CRIAR:
1. Obter timestamp real: `date +%Y-%m-%d-%H%M`
2. Identificar ou perguntar:
   - Descricao da task
   - Prioridade (URGENTE/ALTA/MEDIA/BAIXA)
   - Criterio de done
   - Dependencias (se houver)
3. Adicionar ao grupo de tasks ativo ou criar novo
4. Atualizar SNAPSHOT.md > Tasks Pendentes

Se $ARGUMENTS contem "done" ou "feito" + ID — CONCLUIR:
1. Marcar task como DONE com timestamp real
2. Mover para secao "Concluidas"
3. Atualizar SNAPSHOT se necessario

Se $ARGUMENTS contem "block" + ID — BLOQUEAR:
1. Marcar task como BLOCKED
2. Registrar motivo do bloqueio
3. Atualizar SNAPSHOT

Todos os timestamps sao reais do computador (`date`).
