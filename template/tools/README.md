# Tools & Integracoes — {{PROJECT_NAME}}

> PGP (Protocolo GENOMA Perpetuo) v4.0

## Visao Geral

Este diretorio documenta todas as ferramentas, APIs e integracoes do projeto.
Cada ferramenta tem seu arquivo com: o que faz, como configurar, como usar.

## Ferramentas Disponiveis

| Ferramenta | Tipo | Config | Status | Arquivo |
|-----------|------|--------|--------|---------|
| Playwright | Browser/Scraping | Local | A configurar | [playwright.md](playwright.md) |
| MCP Tools | AI Integration | .mcp.json | A configurar | [mcp-config.md](mcp-config.md) |
| APIs Externas | HTTP | .env | A configurar | [api-docs.md](api-docs.md) |

## Tipos de Integracao

### MCP (Model Context Protocol)
- Configuracao em `.mcp.json` na raiz do projeto
- Ferramentas acessiveis diretamente pelo Claude
- Ver: [mcp-config.md](mcp-config.md)

### API Keys / HTTP
- Credenciais em `.env` (nunca hardcoded)
- Documentacao de endpoints em [api-docs.md](api-docs.md)
- Rate limits e boas praticas documentados por API

### Ferramentas Locais
- Instaladas no ambiente do projeto
- Scripts de automacao em `scripts/` (se houver)
- Ver config de cada uma no respectivo arquivo

## Credenciais

> TODAS as credenciais ficam APENAS no `.env`
> Este diretorio documenta COMO usar, nunca VALORES

| Ferramenta | Variavel .env | Tipo | Onde obter |
|-----------|---------------|------|------------|
| <!-- preencher --> | <!-- VAR --> | API Key / Token / MCP | <!-- URL --> |

## Como Adicionar Nova Ferramenta

1. Criar arquivo `tools/nome-da-ferramenta.md`
2. Documentar: o que faz, como instalar, como configurar, como usar
3. Se precisar de credencial: adicionar ao `.env` e documentar aqui
4. Se for MCP: adicionar config ao `.mcp.json`
5. Atualizar tabela acima
