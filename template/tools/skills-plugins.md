# Skills & Plugins — Sistema de Extensoes

> PGP (Protocolo GENOMA Perpetuo) v4.0

## O que sao Skills e Plugins

### Skills (Slash Commands)
Skills sao **comandos reutilizaveis** que o Claude executa via `/nome`.
Ficam em `.claude/commands/nome.md` e sao carregados automaticamente.

### Plugins (Templates de Skills)
Plugins sao **pacotes de skills** que podem ser instalados em qualquer projeto.
Ficam em `genoma-kit/plugins/` e sao copiados durante a instalacao.

## Como Criar uma Skill

### 1. Criar o arquivo

```bash
# Criar em .claude/commands/
touch .claude/commands/minha-skill.md
```

### 2. Estrutura da Skill

```markdown
---
description: "Nome curto da skill — o que ela faz"
---

Instrucoes para o Claude executar quando o usuario digitar /minha-skill.

Voce pode usar $ARGUMENTS para receber parametros do usuario.

## Procedimento

1. Passo 1
2. Passo 2
3. Passo 3

## Output Esperado

Descrever o que o Claude deve produzir.
```

### 3. Usar

```
/minha-skill argumento opcional
```

## Exemplos de Skills

### Skill: /review (review de codigo)

```markdown
---
description: "/review: Revisar codigo por qualidade, seguranca e padroes"
---

Revisar o codigo em $ARGUMENTS.

1. Ler o arquivo/modulo indicado
2. Verificar contra:
   - specs/invariants.md — invariantes violados?
   - specs/security-model.md — dados sensiveis expostos?
   - CLAUDE.md > Bloco H — segue padroes do projeto?
   - specs/error-taxonomy.md — error handling correto?
3. Listar problemas encontrados por severidade
4. Sugerir correcoes concretas
5. Se tudo OK: confirmar aprovacao
```

### Skill: /deploy-check (pre-deploy)

```markdown
---
description: "/deploy-check: Verificar se esta pronto para deploy"
---

Verificacao pre-deploy:

1. `git status` — mudancas nao commitadas?
2. Executar testes (se configurados)
3. Verificar SNAPSHOT — tasks DOING que impedem deploy?
4. Verificar specs/invariants.md — todos respeitados?
5. Verificar .env — credenciais de producao configuradas?
6. Gerar checklist de aprovacao
```

### Skill: /scrape (scraping com Playwright)

```markdown
---
description: "/scrape: Fazer scraping de pagina web com Playwright"
---

Fazer scraping de: $ARGUMENTS

1. Verificar se Playwright esta instalado (`npx playwright --version`)
2. Se nao: instalar (`npm install playwright && npx playwright install chromium`)
3. Acessar a URL fornecida
4. Extrair dados conforme solicitado
5. Formatar resultado
6. Se solicitado: salvar screenshot
```

## Como Criar um Plugin (Pacote de Skills)

### 1. Estrutura do Plugin

```
genoma-kit/plugins/
└── meu-plugin/
    ├── manifest.json          # Metadados do plugin
    ├── commands/              # Skills do plugin
    │   ├── skill-1.md
    │   └── skill-2.md
    ├── templates/             # Templates opcionais
    │   └── template-1.md
    └── README.md              # Documentacao
```

### 2. manifest.json

```json
{
  "name": "meu-plugin",
  "version": "1.0.0",
  "description": "O que este plugin faz",
  "author": "seu-nome",
  "requires": ["playwright", "supabase"],
  "commands": [
    "commands/skill-1.md",
    "commands/skill-2.md"
  ],
  "templates": [
    "templates/template-1.md"
  ]
}
```

### 3. Instalar Plugin

```bash
# Copiar commands do plugin para o projeto
cp -r genoma-kit/plugins/meu-plugin/commands/* /projeto/.claude/commands/

# Ou o instalador pode fazer automaticamente:
# No genoma-init-v4.sh, selecionar plugins na etapa de ferramentas
```

## Skill que Cria Skills (Meta-Skill)

### /create-skill

```markdown
---
description: "/create-skill: Criar nova skill interativamente"
---

Criar nova skill para o projeto.

Se $ARGUMENTS contem nome:
1. Usar o nome fornecido
2. Perguntar: "O que esta skill deve fazer?"
3. Criar `.claude/commands/$ARGUMENTS.md` com:
   - description no frontmatter
   - Procedimento baseado na descricao
   - Output esperado
4. Informar: "Skill /nome criada. Teste com: /nome"

Se $ARGUMENTS vazio:
1. Perguntar nome da skill
2. Perguntar descricao (o que faz)
3. Perguntar se precisa de $ARGUMENTS
4. Perguntar quantos passos
5. Gerar a skill completa
6. Salvar em .claude/commands/
```

## Skill que Cria Plugins (Meta-Plugin)

### /create-plugin

```markdown
---
description: "/create-plugin: Criar novo plugin (pacote de skills)"
---

Criar novo plugin para o genoma-kit.

1. Perguntar nome do plugin
2. Perguntar descricao
3. Perguntar quais skills incluir (existentes ou novas)
4. Perguntar dependencias (playwright, supabase, etc.)
5. Criar estrutura:
   - `genoma-kit/plugins/$NOME/manifest.json`
   - `genoma-kit/plugins/$NOME/commands/` (copiar ou criar skills)
   - `genoma-kit/plugins/$NOME/README.md`
6. Informar: "Plugin criado em genoma-kit/plugins/$NOME/"
7. Sugerir: "Para instalar: copiar commands/ para .claude/commands/"
```

## Skills Pre-Incluidas no GENOMA v4

| Skill | Arquivo | O que faz |
|-------|---------|-----------|
| /pop-000 | pop-000.md | Diagnostico de sessao (auto) |
| /pop-001 | pop-001.md | Save de sessao (auto) |
| /pop-002 | pop-002.md | Checkpoint mid-session |
| /pop-003 | pop-003.md | Autocorrecao de erros |
| /marcha | marcha.md | Modo autonomo |
| /plan | plan.md | Gerenciar planos |
| /tasks | tasks.md | Gerenciar tasks |

## Boas Praticas

1. **Uma skill = uma responsabilidade** — nao misturar funcoes
2. **Descricao clara** — o frontmatter description aparece no menu
3. **$ARGUMENTS** — sempre documentar o que aceita como parametro
4. **Procedimento numerado** — passos claros e sequenciais
5. **Output esperado** — dizer ao Claude o que deve produzir
6. **Reutilizar specs** — referenciar glossario, invariantes, etc.
7. **Testar** — usar a skill logo apos criar para validar
