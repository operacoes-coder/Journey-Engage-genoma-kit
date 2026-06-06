# sessao-aprendizado-AAAA-MM-DD-HHMM — <título do aprendizado/incidente>

> **Aprendizado de Sessão** — os 7 campos são obrigatórios, nenhum em branco.
> Date: AAAA-MM-DD HH:MM · Sessão: <id-ou-slug> · Severidade: P0/P1/P2/N-A · Status: resolvido/aberto

---

## 1. Causa raiz
<A causa REAL, cravada com evidência — não o sintoma. Uma frase + a prova que confirma (query, log, arquivo:linha).>

## 2. Rotas de identificação
<Como DETECTAR/diagnosticar isto: os sinais, queries, logs ou comandos que apontam pra esta causa. O "por onde olhar PRIMEIRO" numa reincidência.>

## 3. Caminho que causou o problema
<O encadeamento que LEVOU ao problema: o que mudou / qual condição o disparou. Inclua hipóteses levantadas e DESCARTADAS com prova, se houve.>

## 4. Mecanismo causal
<COMO o problema produz o sintoma — o encadeamento técnico. Arquivo:linha quando ancorado a código.>

## 5. Caminho de solução
<Os PASSOS feitos pra resolver (a sequência da correção). Reproduzível.>

## 6. Mecanismo da solução
<POR QUE o fix funciona — por que ataca a CAUSA, não o sintoma. O que muda no mecanismo do campo 4.>

## 7. Aprendizado
<A regra destilada, auto-suficiente (1–3 linhas). É ISTO que vai pro índice LEARNINGS.md. Futuro-orientada: o que teria mudado a abordagem de uma sessão anterior.>

---

## Referências
<commits, PRs, tasks, outros sessao-aprendizado ou POP-P0x relacionados>
