# Plugin: scraping-tools

Skills para scraping web, screenshots e automacao de browser com Playwright.

## Skills Incluidas

| Skill | O que faz |
|-------|-----------|
| `/scrape url` | Fazer scraping de pagina web |
| `/screenshot url` | Tirar screenshot de pagina |

## Dependencias

- Playwright (`npm install playwright` ou `pip install playwright`)
- Chromium (`npx playwright install chromium`)

## Instalacao

```bash
# Copiar skills para o projeto
cp plugins/scraping-tools/commands/* /seu-projeto/.claude/commands/
```

## Uso

```
/scrape https://exemplo.com
/scrape https://exemplo.com ".product-card"
/screenshot https://exemplo.com
/screenshot https://exemplo.com full
```
