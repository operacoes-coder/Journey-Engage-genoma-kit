---
description: "/create-skill: Criar nova skill (slash command) interativamente"
---

Criar nova skill para o projeto.

Se $ARGUMENTS contem um nome:
1. Usar o nome fornecido (sem /)
2. Perguntar: "O que esta skill deve fazer?"
3. Perguntar: "Aceita parametros ($ARGUMENTS)? Se sim, quais?"
4. Gerar `.claude/commands/$NOME.md` com:
   - Frontmatter: `description: "/nome: descricao curta"`
   - Instrucao principal
   - Procedimento numerado (passos claros)
   - Tratamento de $ARGUMENTS (se aplicavel)
   - Output esperado
5. Informar: "Skill /$NOME criada. Teste com: /$NOME"

Se $ARGUMENTS vazio:
1. Perguntar: "Nome da skill (sem /)"
2. Perguntar: "O que deve fazer? (1-2 frases)"
3. Perguntar: "Aceita parametros? (s/n)"
4. Perguntar: "Quantos passos no procedimento?"
5. Para cada passo: perguntar descricao
6. Gerar o arquivo completo
7. Salvar em `.claude/commands/`
8. Informar e sugerir teste

Template base:

```markdown
---
description: "/nome: descricao curta da skill"
---

[Instrucao principal]

Se $ARGUMENTS:
[como usar o parametro]

## Procedimento

1. [passo 1]
2. [passo 2]
3. [passo N]

## Output

[o que o Claude deve produzir/entregar]
```
