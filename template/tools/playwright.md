# Playwright — Browser Automation

## O que faz
- Navegar em paginas web programaticamente
- Fazer scraping de dados
- Tirar screenshots de paginas
- Preencher formularios
- Testar interfaces web
- Acessar conteudo dinamico (SPA, JS-rendered)

## Instalacao

### Via npm (Node.js)
```bash
npm init -y  # se nao tiver package.json
npm install playwright
npx playwright install chromium  # instala apenas Chromium (mais leve)
# OU
npx playwright install  # instala todos os browsers
```

### Via pip (Python)
```bash
pip install playwright
playwright install chromium
```

### Via MCP (para uso direto pelo Claude)
```json
// .mcp.json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@anthropic/mcp-playwright"]
    }
  }
}
```

## Uso Basico — Node.js

### Screenshot de pagina
```javascript
const { chromium } = require('playwright');

async function screenshot(url, outputPath) {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto(url);
  await page.screenshot({ path: outputPath, fullPage: true });
  await browser.close();
}

screenshot('https://example.com', 'screenshot.png');
```

### Scraping de dados
```javascript
const { chromium } = require('playwright');

async function scrape(url, selector) {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto(url, { waitUntil: 'networkidle' });

  const data = await page.$$eval(selector, elements =>
    elements.map(el => ({
      text: el.textContent.trim(),
      href: el.href || null
    }))
  );

  await browser.close();
  return data;
}
```

### Preencher formulario
```javascript
async function fillForm(url) {
  const browser = await chromium.launch({ headless: false }); // visivel
  const page = await browser.newPage();
  await page.goto(url);

  await page.fill('input[name="email"]', 'user@example.com');
  await page.fill('input[name="password"]', 'senha123');
  await page.click('button[type="submit"]');

  await page.waitForNavigation();
  await browser.close();
}
```

## Uso Basico — Python

### Screenshot
```python
from playwright.sync_api import sync_playwright

def screenshot(url, output_path):
    with sync_playwright() as p:
        browser = p.chromium.launch()
        page = browser.new_page()
        page.goto(url)
        page.screenshot(path=output_path, full_page=True)
        browser.close()
```

### Scraping
```python
from playwright.sync_api import sync_playwright

def scrape(url, selector):
    with sync_playwright() as p:
        browser = p.chromium.launch()
        page = browser.new_page()
        page.goto(url, wait_until='networkidle')
        elements = page.query_selector_all(selector)
        data = [{'text': el.text_content().strip()} for el in elements]
        browser.close()
        return data
```

## Boas Praticas

- **Headless por padrao** — usar `headless: false` so para debug
- **waitUntil: 'networkidle'** — para paginas com JS dinamico
- **Timeouts** — configurar timeouts razoaveis (30s padrao)
- **User Agent** — rotacionar se fazendo scraping frequente
- **Rate limiting** — respeitar robots.txt e intervalos entre requests
- **Screenshots** — salvar em pasta temporaria, nao commitar

## Credenciais

Nenhuma credencial necessaria para uso basico.
Se acessar sites autenticados, usar variaveis do `.env`.

## Troubleshooting

| Problema | Solucao |
|----------|---------|
| Browser nao encontrado | `npx playwright install chromium` |
| Timeout em paginas SPA | Usar `waitUntil: 'networkidle'` |
| Elemento nao encontrado | Verificar selector, usar `page.waitForSelector()` |
| Bloqueado por bot detection | Usar `stealth` plugin ou Camoufox |
| Crash em CI/CD | Adicionar `--no-sandbox` flag |
