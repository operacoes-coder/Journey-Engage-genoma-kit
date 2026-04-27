---
description: "/scrape: Fazer scraping de pagina web com Playwright"
---

Fazer scraping de: $ARGUMENTS

## Procedimento

1. Verificar se Playwright esta instalado:
   - Node: `npx playwright --version`
   - Python: `playwright --version`
2. Se nao instalado:
   - Node: `npm install playwright && npx playwright install chromium`
   - Python: `pip install playwright && playwright install chromium`
3. Acessar a URL fornecida em $ARGUMENTS
4. Aguardar carregamento completo (`waitUntil: 'networkidle'`)
5. Extrair dados conforme solicitado:
   - Se nao especificado: extrair texto principal + links
   - Se seletor CSS fornecido: usar seletor
6. Formatar resultado em tabela ou JSON
7. Se pagina com paginacao: perguntar se deve navegar

## Boas Praticas

- Respeitar robots.txt
- Minimo 2s entre requests
- Usar headless mode (sem janela)
- Nao salvar dados sensiveis sem permissao

## Output

Dados extraidos formatados + informar quantos itens encontrados.
