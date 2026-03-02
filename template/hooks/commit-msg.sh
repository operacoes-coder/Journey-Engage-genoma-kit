#!/bin/bash
# PGP (Protocolo GENOMA Perpetuo) - Commit message validation hook
# Enforces conventional commit format with GENOMA extensions

COMMIT_MSG=$(cat "$1")

# Allow merge commits
if echo "$COMMIT_MSG" | grep -qE "^Merge "; then
  exit 0
fi

# Conventional commit pattern (standard + GENOMA types)
PATTERN="^(feat|fix|refactor|docs|test|deploy|config|decision|investigate|snapshot|context|session|playbook|audit|rollback)(\(.+\))?: .+"

if ! echo "$COMMIT_MSG" | head -1 | grep -qE "$PATTERN"; then
  echo ""
  echo "ERRO: Mensagem de commit deve seguir formato convencional:"
  echo "  type(scope): descricao"
  echo ""
  echo "Tipos padrao:"
  echo "  feat | fix | refactor | docs | test | deploy | config"
  echo ""
  echo "Tipos GENOMA:"
  echo "  decision | investigate | snapshot | context | session | playbook | audit | rollback"
  echo ""
  echo "Sua mensagem foi:"
  echo "  $COMMIT_MSG"
  echo ""
  exit 1
fi
