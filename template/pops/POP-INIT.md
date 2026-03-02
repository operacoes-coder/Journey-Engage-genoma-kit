# POP-INIT: Bootstrap do Projeto

- **Trigger:** Primeira sessao do Claude num projeto com GENOMA recem-inicializado
- **Autonomia:** Nivel 1 (propor analise, aguardar aprovacao)
- **Requer:** .context/ ja copiado (via genoma-init.sh ou manualmente)
- **Execucao unica:** Este POP roda apenas 1 vez, na inicializacao

## Procedimento

### Fase 1: Analise do Projeto (~5 min)

1. Ler estrutura de pastas do projeto (ls, tree)
2. Identificar stack tecnologico:
   - Ler package.json, requirements.txt, Cargo.toml, go.mod, etc.
   - Ler docker-compose.yml, Dockerfile se existir
   - Ler configuracoes (tsconfig, eslint, etc.)
3. Ler README.md do projeto (se existir)
4. Ler .env.example ou .env.template (se existir, SEM ler .env real)
5. `git log --oneline -20` -> entender historico recente
6. Identificar padroes de commit existentes
7. Mapear arquivos e pastas importantes

### Fase 2: Preencher MANIFEST.md

1. Preencher Identity:
   - Nome do projeto
   - Descricao (o que faz)
   - Stack (linguagens, frameworks, servicos)
   - Repositorio
   - Ambientes
2. Preencher Architecture:
   - Padroes identificados
   - Dependencias principais
   - Guardrails relevantes
3. Preencher File Map:
   - Pastas principais e suas funcoes
4. Preencher Scopes:
   - Baseado na estrutura do projeto
5. Preencher Constraints:
   - Gotchas observados
   - Limitacoes conhecidas
6. Preencher Credenciais:
   - Baseado no .env.example ou configuracoes

### Fase 3: Preencher GRAPH.md

1. Criar diagrama Mermaid da arquitetura:
   - Componentes principais
   - Fluxo de dados
   - Servicos externos
2. Manter simples (max 10-15 nos)

### Fase 4: Configurar ROUTES.md

1. Manter rotas universais (ja incluidas)
2. Adicionar rotas especificas do projeto:
   - Baseado no tipo de projeto (web app, API, CLI, etc.)
   - Cenarios comuns para o stack identificado

### Fase 5: Identificar POPs de Projeto

1. Analisar se o projeto precisa de:
   - POP de deploy? (se tem CI/CD)
   - POP de teste? (se tem test suite)
   - POP de build? (se tem build process)
   - POP de banco? (se tem database)
   - POP de backup? (se tem dados criticos)
2. Criar os POPs identificados em pops/POP-P0x.md
3. Atualizar pops/INDEX.md

### Fase 6: Primeiro SNAPSHOT

1. Atualizar SNAPSHOT.md com:
   - Module Status real do projeto
   - In Progress (tarefas pendentes identificadas)
   - Next Steps (baseado na analise)
   - Context to Resume (estado apos bootstrap)
2. Commitar tudo

## Output Esperado

Apresentar ao usuario:

```
=== POP-INIT Completo ===

Projeto: [nome]
Stack: [tecnologias]
Modulos: [X] identificados

Arquivos preenchidos:
- [x] MANIFEST.md (identity, architecture, file map, credentials)
- [x] GRAPH.md (diagrama de arquitetura)
- [x] ROUTES.md (rotas universais + [N] rotas do projeto)
- [x] SNAPSHOT.md (estado inicial)
- [x] POPs de projeto: [lista]

Proximos passos:
1. Revisar MANIFEST — dados corretos?
2. Revisar ROUTES — falta algum cenario?
3. Comecar a trabalhar (POP-000 ativo a partir de agora)
```

## Criterios de Sucesso

- MANIFEST preenchido com dados reais do projeto
- GRAPH com diagrama de arquitetura
- ROUTES com pelo menos 2 rotas especificas do projeto
- SNAPSHOT refletindo estado real
- Pelo menos 1 POP de projeto criado (se aplicavel)
- Commit: `context(genoma): POP-INIT bootstrap for [projeto]`

## Apos Execucao

- Este POP nao precisa ser executado novamente
- A partir de agora, POP-000/001/002 cuidam do ciclo de sessoes
- POPs de projeto rodam conforme seus triggers
