---
description: "/create-plugin: Criar novo plugin (pacote de skills) para o genoma-kit"
---

Criar novo plugin (pacote de skills reutilizavel).

1. Perguntar nome do plugin (kebab-case, ex: "scraping-tools")
2. Perguntar descricao (1-2 frases)
3. Perguntar quais skills incluir:
   - Listar skills existentes em `.claude/commands/`
   - Perguntar se quer incluir alguma existente
   - Perguntar se quer criar novas skills para o plugin
4. Perguntar dependencias (playwright, supabase, n8n, nenhuma)

5. Criar estrutura do plugin:

```
genoma-kit/plugins/$NOME/
├── manifest.json
├── commands/
│   ├── skill-1.md
│   └── skill-2.md
└── README.md
```

6. Gerar `manifest.json`:
```json
{
  "name": "$NOME",
  "version": "1.0.0",
  "description": "$DESCRICAO",
  "author": "usuario",
  "requires": ["dependencias"],
  "commands": ["commands/skill-1.md"]
}
```

7. Copiar ou criar skills em `commands/`
8. Gerar README.md do plugin com:
   - O que faz
   - Como instalar
   - Skills incluidas
   - Dependencias

9. Informar: "Plugin '$NOME' criado em genoma-kit/plugins/$NOME/"
10. Sugerir: "Para instalar em outro projeto: cp -r plugins/$NOME/commands/* /projeto/.claude/commands/"
