---
description: "/screenshot: Tirar screenshot de pagina web"
---

Tirar screenshot de: $ARGUMENTS

## Procedimento

1. Verificar Playwright instalado
2. Se $ARGUMENTS contem URL:
   - Acessar a URL
   - Aguardar carregamento completo
   - Tirar screenshot full-page
   - Salvar como `screenshot-YYYY-MM-DD-HHmm.png`
3. Se $ARGUMENTS contem URL + seletor:
   - Acessar a URL
   - Localizar elemento pelo seletor
   - Screenshot apenas do elemento
4. Opcoes:
   - `full` — pagina inteira (default)
   - `viewport` — apenas area visivel
   - `element .selector` — apenas o elemento
5. Informar caminho do arquivo salvo

## Output

Arquivo PNG salvo + caminho informado ao usuario.
