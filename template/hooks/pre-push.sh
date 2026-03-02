#!/bin/bash
# PGP (Protocolo GENOMA Perpetuo) - Pre-push hook
# Valida que SNAPSHOT.md esta atualizado antes de push

SNAPSHOT=".context/SNAPSHOT.md"

if [ ! -f "$SNAPSHOT" ]; then
  echo "AVISO: SNAPSHOT.md nao encontrado em .context/"
  echo "Considere executar POP-001 antes de fazer push."
  exit 0
fi

# Verificar se SNAPSHOT tem mudancas nao commitadas
if git diff --name-only | grep -q "SNAPSHOT.md"; then
  echo ""
  echo "ERRO: SNAPSHOT.md tem mudancas nao commitadas!"
  echo "Execute POP-001 (save de fim de sessao) antes de fazer push."
  echo ""
  echo "Ou commite manualmente:"
  echo "  git add .context/SNAPSHOT.md"
  echo "  git commit -m \"snapshot(context): update before push\""
  echo ""
  exit 1
fi

exit 0
