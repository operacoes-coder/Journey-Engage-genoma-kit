---
description: "/create-pop: Cria um Procedimento Operacional Padrão de projeto em .context/pops/POP-P0x no formato canônico"
---

# /create-pop — Procedimento Operacional Padrão (projeto)

Cria um playbook reutilizável pra um procedimento recorrente (deploy, troubleshoot, rollout, fix de classe conhecida). POPs de projeto ficam em `.context/pops/POP-P0x-titulo.md`. Os `POP-000..003` e `POP-INIT` são do **framework** — não mexer.

## Quando usar
- Procedimento que você já fez 2+ vezes e vai repetir.
- Runbook de troubleshooting de uma classe de problema conhecida.
- Diferente do `/session-learnings` (que registra UM aprendizado/incidente, causa raiz): **POP é o PROCEDIMENTO repetível**.

## Procedimento
1. **Próximo número:** listar `.context/pops/POP-P*.md`, incrementar (primeiro de projeto = `POP-P01`). Slug kebab-case.
2. **Formato canônico:**
   ```
   # POP-P0x — Título
   > Procedimento Operacional Padrão
   > <propósito em 1 linha>
   ---
   ## Quando aplicar      <sintomas / gatilhos>
   ## Diagnóstico (N min)  <passos numerados + comandos exatos>
   ## Procedimento         <execução, com comandos/queries/arquivo:linha>
   ## Verificação          <como confirmar que funcionou — evidência>
   ## Rollback / Contingência
   ```
3. **Salvar** em `.context/pops/` (UTF-8) e **registrar** em `.context/pops/INDEX.md` (seção "Projeto").
4. Se nasceu de um incidente, referenciar o `sessao-aprendizado-*` correspondente em `.context/learnings/`.

## Argumentos
`/create-pop <título>` — usa o título dado.

## Restrições
- Não duplicar POP existente — grep do tema em `.context/pops/` antes.
- Não tocar os POPs de framework (`POP-000..003`, `POP-INIT`).
