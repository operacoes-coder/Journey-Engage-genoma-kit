# MCP (Model Context Protocol) — Configuracao

## O que e MCP

MCP permite que o Claude acesse ferramentas externas diretamente:
- Buscar na web, acessar bancos de dados, manipular arquivos
- Integrar com APIs sem precisar de codigo intermediario
- Automacao via Claude Code com ferramentas especializadas

## Configuracao

Arquivo: `.mcp.json` na raiz do projeto

```json
{
  "mcpServers": {
    "nome-do-server": {
      "command": "comando",
      "args": ["argumentos"],
      "env": {
        "VAR": "valor-ou-referencia-env"
      }
    }
  }
}
```

## Servers MCP Uteis

### Filesystem (acesso a arquivos)
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-filesystem", "/caminho/permitido"]
    }
  }
}
```

### Playwright (browser)
```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-playwright"]
    }
  }
}
```

### Supabase (banco de dados)
```json
{
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": ["-y", "@supabase/mcp-server"],
      "env": {
        "SUPABASE_URL": "sua-url",
        "SUPABASE_SERVICE_KEY": "sua-key"
      }
    }
  }
}
```

### GitHub
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_..."
      }
    }
  }
}
```

### Fetch (HTTP requests)
```json
{
  "mcpServers": {
    "fetch": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-fetch"]
    }
  }
}
```

### n8n
```json
{
  "mcpServers": {
    "n8n": {
      "command": "npx",
      "args": ["-y", "n8n-mcp-server"],
      "env": {
        "N8N_BASE_URL": "https://sua-instancia.com",
        "N8N_API_KEY": "sua-api-key"
      }
    }
  }
}
```

## Credenciais MCP

> NUNCA colocar credenciais diretamente no `.mcp.json` se for commitado
> Usar variaveis de ambiente ou referencia ao `.env`

| Server | Variavel .env | Onde obter |
|--------|---------------|------------|
| supabase | SUPABASE_URL, SUPABASE_SERVICE_KEY | Supabase Dashboard > Settings > API |
| github | GITHUB_TOKEN | GitHub > Settings > Developer Settings > PAT |
| n8n | N8N_BASE_URL, N8N_API_KEY | n8n > Settings > API |

## Como Testar

```bash
# Verificar se MCP server responde
npx @anthropic/mcp-inspector .mcp.json

# Listar ferramentas disponiveis
# (via Claude Code, digitar /mcp)
```

## Troubleshooting

| Problema | Solucao |
|----------|---------|
| Server nao conecta | Verificar se npx esta instalado e o pacote existe |
| Permission denied | Verificar permissoes do comando e paths |
| Timeout | Aumentar timeout ou verificar rede |
| Credencial invalida | Verificar .env e permissoes do token |
