# Rotas de Navegacao — {{PROJECT_NAME}}

> PGP (Protocolo GENOMA Perpetuo) v4.0

## Rotas Universais

### "Continuar de onde parou"
**Tempo:** ~2 min | **Tokens:** ~3k

1. SNAPSHOT.md -> "Context to Resume" (DOING/BLOCKED_BY/NEXT_ACTION)
2. `git log --oneline -5` -> confirmar ultimas acoes
3. history/ -> ultima sessao registrada
4. tasks/ -> tasks pendentes

### "Por que fizemos X?"
**Tempo:** ~3 min | **Tokens:** ~5k

1. DECISIONS.md -> buscar por keyword
2. `git log --all --grep="keyword" --oneline` -> commits relacionados
3. plans/ -> planos relacionados
4. deep/ -> investigacoes detalhadas

### "Investigar/Debug profundo"
**Tempo:** ~15 min | **Tokens:** ~15-30k

1. SNAPSHOT.md -> estado atual
2. `git log --oneline -20` -> timeline recente
3. `git diff HEAD~5` -> mudancas recentes
4. specs/error-taxonomy.md -> classificar o erro
5. Criar deep/inv-NNN-titulo.md com findings
6. Atualizar SNAPSHOT com resultado

### "Primeira vez neste projeto" (onboarding)
**Tempo:** ~10 min | **Tokens:** ~8k

1. MANIFEST.md -> entender o projeto + credenciais
2. SNAPSHOT.md -> estado atual
3. ROUTES.md -> saber navegar (este arquivo)
4. specs/glossary.md -> linguagem do dominio
5. tools/ -> ferramentas disponiveis
6. pops/INDEX.md -> saber o que e automatico
7. `git log --oneline -20` -> historia recente
8. DECISIONS.md -> entender escolhas feitas

### "Revisar tasks e priorizar"
**Tempo:** ~5 min | **Tokens:** ~3k

1. tasks/ -> todas as tasks ativas
2. SNAPSHOT.md -> contexto atual
3. plans/ -> planos em andamento
4. Reorganizar prioridades se necessario

### "Criar plano de implementacao"
**Tempo:** ~10 min | **Tokens:** ~8k

1. MANIFEST.md -> constraints e architecture
2. specs/ -> contratos relevantes
3. DECISIONS.md -> decisoes anteriores
4. Criar plans/plan-NNN-titulo.md
5. Decompor em tasks se aprovado

---

## Rotas do Projeto

<!-- Adicionar rotas especificas conforme o projeto cresce -->
<!-- Formato: -->
<!-- ### "Descricao do cenario" -->
<!-- **Tempo:** ~X min | **Tokens:** ~Xk -->
<!-- 1. Passo 1 -->
<!-- 2. Passo 2 -->
