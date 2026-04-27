---
description: "/plan: Criar ou revisar plano de implementacao"
---

Executar criacao/revisao de plano.

Se $ARGUMENTS contem um titulo ou descricao:
1. Analisar o objetivo descrito
2. Ler `.context/MANIFEST.md` — constraints e architecture
3. Ler `specs/` — contratos relevantes
4. Ler `.context/DECISIONS.md` — decisoes anteriores (nao propor o que ja foi rejeitado)
5. Criar `plans/plan-NNN-titulo-YYYY-MM-DD.md` com:
   - Objetivo e contexto
   - Abordagem escolhida + alternativas rejeitadas
   - Fases com steps concretos e criterios de done
   - Riscos e mitigacoes
   - Dependencias
   - Metricas de sucesso
6. Apresentar plano ao usuario para aprovacao
7. Se aprovado: decompor em tasks em `tasks/`

Se $ARGUMENTS esta vazio:
1. Listar planos existentes em `plans/`
2. Mostrar status de cada um (Draft/Aprovado/Em Execucao/Concluido)
3. Perguntar: criar novo ou revisar existente?

Timestamps reais do computador em todas as entradas.
