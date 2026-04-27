# APIs Externas — Documentacao

## Formato por API

```markdown
## [Nome da API]

- **Base URL:** https://api.exemplo.com/v1
- **Auth:** Bearer Token / API Key / OAuth2
- **Variavel .env:** API_NOME_KEY
- **Rate Limit:** X requests/min
- **Docs oficiais:** [link]

### Endpoints Usados

| Metodo | Endpoint | Para que | Rate Limit |
|--------|----------|---------|------------|
| GET | /resource | Listar recursos | 60/min |
| POST | /resource | Criar recurso | 30/min |

### Exemplo de Uso

\`\`\`bash
curl -H "Authorization: Bearer $API_KEY" \
  https://api.exemplo.com/v1/resource
\`\`\`

### Erros Comuns

| HTTP | Significado | Acao |
|------|------------|------|
| 401 | Token invalido/expirado | Renovar token |
| 429 | Rate limit excedido | Aguardar X segundos |
| 503 | API fora do ar | Retry com backoff |
```

## APIs do Projeto

<!-- Preencher conforme o projeto usa APIs externas -->

| API | Base URL | Auth | .env var | Status |
|-----|----------|------|----------|--------|
| <!-- nome --> | <!-- url --> | <!-- tipo --> | <!-- var --> | A configurar |

## Boas Praticas

1. **Sempre usar .env** para API keys — nunca hardcoded
2. **Respeitar rate limits** — implementar backoff exponencial
3. **Cachear respostas** quando possivel (reduz calls)
4. **Validar responses** — nunca confiar cegamente em API externa
5. **Documentar aqui** cada nova API adicionada ao projeto
6. **Monitorar uso** — alertar quando proximo do limite
