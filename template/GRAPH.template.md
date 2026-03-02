# GENOMA — Diagramas

> PGP (Protocolo GENOMA Perpetuo) v2.0

## Arquitetura — {{PROJECT_NAME}}

```mermaid
graph TB
    A["Componente A"] --> B["Componente B"]
    B --> C["Componente C"]

    %% Substituir pelo diagrama real do projeto
    %% Dica: manter simples, max 10-15 nos
```

<!-- Substituir o diagrama acima pela arquitetura real do projeto -->

## Niveis de Zoom (Universo -> Atomo)

```mermaid
graph LR
    Z0["Zoom 0<br/>Universo<br/>MEMORY.md<br/>0 tokens"]
    Z1["Zoom 1<br/>Galaxia<br/>MANIFEST<br/>~1k"]
    Z2["Zoom 2<br/>Sistema<br/>SNAPSHOT<br/>~2k"]
    Z3["Zoom 3<br/>Navegacao<br/>ROUTES+POPs<br/>~2k"]
    Z4["Zoom 4<br/>Planeta<br/>git log<br/>~3k"]
    Z5["Zoom 5<br/>Continente<br/>DECISIONS<br/>~5k"]
    Z6["Zoom 6<br/>Cidade<br/>git show<br/>~10k"]
    Z7["Zoom 7<br/>Edificio<br/>git blame<br/>~15k"]
    Z8["Zoom 8<br/>Atomo<br/>deep/<br/>~30k"]

    Z0 --> Z1 --> Z2 --> Z3 --> Z4 --> Z5 --> Z6 --> Z7 --> Z8

    style Z0 fill:#e8f5e9
    style Z1 fill:#e8f5e9
    style Z2 fill:#e8f5e9
    style Z3 fill:#fff3e0
    style Z4 fill:#fff3e0
    style Z5 fill:#fff3e0
    style Z6 fill:#fce4ec
    style Z7 fill:#fce4ec
    style Z8 fill:#fce4ec
```

### Legenda dos Niveis

| Zoom | Nome | Fonte | Tokens | Quando usar |
|------|------|-------|--------|-------------|
| 0 | Universo | MEMORY.md | 0 | Auto-loaded toda sessao |
| 1 | Galaxia | MANIFEST.md | ~1k | Entender o projeto |
| 2 | Sistema | SNAPSHOT.md | ~2k | Estado atual |
| 3 | Navegacao | ROUTES + POPs | ~2k | Saber pra onde ir |
| 4 | Planeta | git log | ~3k | Timeline recente |
| 5 | Continente | DECISIONS.md | ~5k | Entender decisoes |
| 6 | Cidade | git show | ~10k | Detalhe de commit |
| 7 | Edificio | git blame | ~15k | Quem mudou o que |
| 8 | Atomo | deep/ | ~30k | Investigacao profunda |
