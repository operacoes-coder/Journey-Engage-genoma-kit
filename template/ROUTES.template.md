# Rotas de Navegacao — {{PROJECT_NAME}}

> PGP (Protocolo GENOMA Perpetuo) v2.0

## Rotas Universais

### "Continuar de onde parou"
**Tempo:** ~2 min | **Tokens:** ~3k

1. SNAPSHOT.md -> "Context to Resume" (DOING/BLOCKED_BY/NEXT_ACTION)
2. `git log --oneline -5` -> confirmar ultimas acoes
3. Se unclear -> historico de sessoes

### "Por que fizemos X?"
**Tempo:** ~3 min | **Tokens:** ~5k

1. DECISIONS.md -> buscar por keyword
2. `git log --all --grep="keyword" --oneline` -> commits relacionados
3. deep/ -> investigacoes detalhadas

### "Investigar/Debug profundo"
**Tempo:** ~15 min | **Tokens:** ~15-30k

1. SNAPSHOT.md -> estado atual
2. `git log --oneline -20` -> timeline recente
3. `git diff HEAD~5` -> mudancas recentes
4. Criar deep/inv-NNN-titulo.md com findings
5. Atualizar SNAPSHOT com resultado

### "Primeira vez neste projeto" (onboarding)
**Tempo:** ~10 min | **Tokens:** ~8k

1. MANIFEST.md -> entender o projeto + credenciais
2. SNAPSHOT.md -> estado atual
3. ROUTES.md -> saber navegar (este arquivo)
4. pops/INDEX.md -> saber o que e automatico
5. `git log --oneline -20` -> historia recente
6. DECISIONS.md -> entender escolhas feitas

---

## Rotas do Projeto

<!-- Adicionar rotas especificas conforme o projeto cresce -->
<!-- Formato: -->
<!-- ### "Descricao do cenario" -->
<!-- **Tempo:** ~X min | **Tokens:** ~Xk -->
<!-- 1. Passo 1 -->
<!-- 2. Passo 2 -->
