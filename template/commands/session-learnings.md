---
description: "/session-learnings: Gera o aprendizado da sessão como MD de 9 campos em .context/learnings/sessao-aprendizado-DATA-HORA.md e destila a regra pro índice LEARNINGS.md"
---

# /session-learnings — Aprendizado da sessão (9 campos)

Persiste o que foi aprendido pra a próxima sessão não reaprender. Dois artefatos:
- **`.context/learnings/sessao-aprendizado-AAAA-MM-DD-HHMM.md`** — o aprendizado COMPLETO (9 campos). Local.
- **`LEARNINGS.md`** (raiz do repo, versionado) — ÍNDICE terse: 1 linha/bloco por aprendizado + link pro MD. É o que viaja pro time.

## Quando usar
- "salva o que aprendemos" / "lições aprendidas" / "capture learnings".
- Depois de um debug com causa raiz cravada (incidente).
- Depois de uma decisão de design não-óbvia.
- NÃO usar: commit rotineiro, status update, tarefa trivial sem lição.

## Procedimento
1. **Nome do arquivo:** `sessao-aprendizado-<AAAA-MM-DD>-<HHMM>.md` (data + hora atuais — confira no contexto, não chute).
2. **Preencher os 9 campos** (base: `.context/learnings/sessao-aprendizado-TEMPLATE.md`), nenhum em branco:
   1. Causa raiz · 2. Rotas de identificação · 3. Caminho que causou o problema · 4. Mecanismo causal · 5. Caminho de solução · 6. Mecanismo da solução · 7. Aprendizado · 8. Prevenção · 9. Medidas de segurança.
   Honestidade: evidência antes de afirmação; marque o que é inferência (não observação direta).
   Campos 8 e 9 são forward-looking: **8. Prevenção** = o que mudar no jeito de fazer; **9. Medidas de segurança** = a barreira automática (teste/lint/hook/assert/default) que pega o erro mesmo se a prevenção falhar.
3. **Salvar** em `.context/learnings/` (UTF-8).
4. **Destilar pro índice:** pegar o campo **7 (Aprendizado)** e dar append no `LEARNINGS.md` (Edit, nunca overwrite) APÓS a última entrada, com separador `==========` (10 iguais) ANTES do novo `## Session:`, incluindo o link `→ .context/learnings/sessao-aprendizado-...md`. A linha do índice deve ser **auto-suficiente** (entende sem o MD).
5. Commit: `docs: learning — <título>`. NÃO push sem o usuário pedir.

## Formato do índice (LEARNINGS.md — estrito)
- Separador: exatamente `==========` (10 iguais, sem espaços).
- `## Session: <Título>` + `Date: AAAA-MM-DD` + bullets `-` densos. Sem emoji, sem transcript, sem play-by-play. Regra, não timeline.
- PT-BR: preservar acentuação.

## Anti-patterns
Colar transcript bruto · narrar a linha do tempo · deixar um dos 9 campos vazio · linguagem comemorativa · capturar trabalho trivial · editar entradas antigas do índice (append uma nova que supersede — a antiga é trilha de auditoria).
