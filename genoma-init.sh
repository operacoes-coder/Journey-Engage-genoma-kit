#!/bin/bash
# ============================================================================
# genoma-init.sh — Onboarding Interativo do PGP (Protocolo GENOMA Perpetuo)
# ============================================================================
#
# Uso:
#   ./genoma-init.sh                        # Projeto no diretorio atual
#   ./genoma-init.sh /caminho/do/projeto    # Projeto em outro diretorio
#
# O que faz:
#   1. Instala o kernel automaticamente (hooks, POPs universais, templates)
#   2. Pergunta o que precisa personalizar (nome, stack, credenciais, etc.)
#   3. Auto-detecta o que conseguir (stack, banco, testes)
#   4. Gera os arquivos personalizados
#   5. Instala git hooks
#   6. Cria commit inicial
#
# ============================================================================

set -e

# ---------- Cores ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ---------- Funcoes utilitarias ----------

print_header() {
  clear 2>/dev/null || true
  echo ""
  echo -e "${CYAN}   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo -e "${BOLD}${CYAN}"
  echo '     ██████╗ ███████╗███╗   ██╗ ██████╗ ███╗   ███╗ █████╗'
  echo '    ██╔════╝ ██╔════╝████╗  ██║██╔═══██╗████╗ ████║██╔══██╗'
  echo '    ██║  ███╗█████╗  ██╔██╗ ██║██║   ██║██╔████╔██║███████║'
  echo '    ██║   ██║██╔══╝  ██║╚██╗██║██║   ██║██║╚██╔╝██║██╔══██║'
  echo '    ╚██████╔╝███████╗██║ ╚████║╚██████╔╝██║ ╚═╝ ██║██║  ██║'
  echo '     ╚═════╝ ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝'
  echo -e "${NC}"
  echo ""
  echo -e "     ${BOLD}PGP — Protocolo GENOMA Perpetuo v2.0${NC}"
  echo ""
  echo -e "     ${CYAN}Projeto guarnecido. Contexto perpetuo.${NC}"
  echo -e "     ${CYAN}A estrutura essencial para o seu projeto comecar.${NC}"
  echo -e "     ${CYAN}Seja bem-vindo(a) a nova era da Gestao Estruturada.${NC}"
  echo ""
  echo -e "     ${BOLD}G${NC}estao ${BOLD}E${NC}struturada ${BOLD}N${NC}ormalizada ${BOLD}O${NC}rientada por ${BOLD}M${NC}etricas e ${BOLD}A${NC}tualizacao"
  echo ""
  echo -e "${CYAN}   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
}

print_step() {
  echo ""
  echo -e "${BLUE}[$1/7]${NC} ${BOLD}$2${NC}"
  echo -e "${BLUE}$(printf '%.0s─' {1..50})${NC}"
}

print_auto() {
  echo -e "  ${GREEN}[AUTO]${NC} $1"
}

print_ask() {
  echo -e "  ${YELLOW}[?]${NC} $1"
}

print_ok() {
  echo -e "  ${GREEN}[OK]${NC} $1"
}

print_skip() {
  echo -e "  ${YELLOW}[SKIP]${NC} $1"
}

ask() {
  local prompt="$1"
  local default="$2"
  local var_name="$3"

  if [ -n "$default" ]; then
    echo -ne "  ${YELLOW}>${NC} $prompt ${CYAN}[$default]${NC}: "
    read -r input
    eval "$var_name=\"${input:-$default}\""
  else
    echo -ne "  ${YELLOW}>${NC} $prompt: "
    read -r input
    eval "$var_name=\"$input\""
  fi
}

ask_yn() {
  local prompt="$1"
  local default="$2"
  echo -ne "  ${YELLOW}>${NC} $prompt ${CYAN}[$default]${NC}: "
  read -r input
  input="${input:-$default}"
  [[ "$input" =~ ^[Ss]$ ]]
}

ask_choice() {
  local prompt="$1"
  shift
  local options=("$@")

  echo -e "  ${YELLOW}>${NC} $prompt"
  for i in "${!options[@]}"; do
    echo -e "    ${CYAN}$((i+1)))${NC} ${options[$i]}"
  done
  echo -ne "  ${YELLOW}>${NC} Escolha (numero): "
  read -r choice
  echo "$choice"
}

# ---------- Parametros ----------

PROJECT_PATH="${1:-.}"
PROJECT_PATH="$(cd "$PROJECT_PATH" 2>/dev/null && pwd)" || {
  echo -e "${RED}ERRO: Diretorio '$1' nao existe.${NC}"
  exit 1
}
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/template"
CONTEXT_DIR="$PROJECT_PATH/.context"
DATE=$(date +%Y-%m-%d)

# ---------- Validacoes ----------

if [ ! -d "$TEMPLATE_DIR" ]; then
  echo -e "${RED}ERRO: template/ nao encontrado em $SCRIPT_DIR${NC}"
  exit 1
fi

if [ -d "$CONTEXT_DIR" ]; then
  echo -e "${YELLOW}AVISO: .context/ ja existe em $PROJECT_PATH${NC}"
  if ! ask_yn "Sobrescrever?" "n"; then
    echo "Cancelado."
    exit 0
  fi
  rm -rf "$CONTEXT_DIR"
fi

# ---------- Banner ----------

print_header

echo -e "Projeto em: ${BOLD}$PROJECT_PATH${NC}"
echo ""
echo "O GENOMA instala automaticamente o que e padrao"
echo "e pergunta apenas o que precisa personalizar."
echo ""
echo -e "Pressione ${CYAN}Enter${NC} para aceitar valores padrao entre [colchetes]."
echo ""
read -p "Iniciar? (Enter para continuar, Ctrl+C para cancelar) "

# ============================================================================
# STEP 1: IDENTITY — Dados basicos do projeto
# ============================================================================

print_step 1 "IDENTITY — Dados do Projeto"

# Auto-detectar nome do projeto pela pasta
FOLDER_NAME=$(basename "$PROJECT_PATH")
ask "Nome do projeto" "$FOLDER_NAME" "PROJECT_NAME"
print_ok "Projeto: $PROJECT_NAME"

ask "Descricao curta (o que faz)" "" "PROJECT_DESC"
print_ok "Descricao: $PROJECT_DESC"

# Idioma
LANG_CHOICE=$(ask_choice "Idioma principal da documentacao" "Portugues Brasileiro (pt-BR) [recomendado]" "English (en)" "Espanol (es)")
case "$LANG_CHOICE" in
  1) PROJECT_LANG="pt-BR" ;;
  2) PROJECT_LANG="en" ;;
  3) PROJECT_LANG="es" ;;
  *) PROJECT_LANG="pt-BR" ;;
esac
print_ok "Idioma: $PROJECT_LANG"

# ============================================================================
# STEP 2: STACK — Auto-detectar tecnologias
# ============================================================================

print_step 2 "STACK — Detectando Tecnologias"

DETECTED_STACK=""
DETECTED_STACK_LIST=()
HAS_DB=""
HAS_TESTS=""
HAS_CI=""
HAS_DOCKER=""
PROJECT_TYPE=""

# --- Detectar linguagens e frameworks ---

if [ -f "$PROJECT_PATH/package.json" ]; then
  print_auto "Node.js detectado (package.json)"
  DETECTED_STACK_LIST+=("Node.js")

  if grep -q '"next"' "$PROJECT_PATH/package.json" 2>/dev/null; then
    print_auto "  Next.js detectado"
    DETECTED_STACK_LIST+=("Next.js")
    PROJECT_TYPE="webapp"
  fi
  if grep -q '"react"' "$PROJECT_PATH/package.json" 2>/dev/null; then
    print_auto "  React detectado"
    DETECTED_STACK_LIST+=("React")
    PROJECT_TYPE="${PROJECT_TYPE:-webapp}"
  fi
  if grep -q '"vue"' "$PROJECT_PATH/package.json" 2>/dev/null; then
    print_auto "  Vue.js detectado"
    DETECTED_STACK_LIST+=("Vue.js")
    PROJECT_TYPE="${PROJECT_TYPE:-webapp}"
  fi
  if grep -q '"express"' "$PROJECT_PATH/package.json" 2>/dev/null; then
    print_auto "  Express detectado"
    DETECTED_STACK_LIST+=("Express")
    PROJECT_TYPE="${PROJECT_TYPE:-api}"
  fi
  if grep -q '"typescript"' "$PROJECT_PATH/package.json" 2>/dev/null; then
    print_auto "  TypeScript detectado"
    DETECTED_STACK_LIST+=("TypeScript")
  fi

  # Testes
  if grep -q '"jest"\|"vitest"\|"mocha"\|"cypress"\|"playwright"' "$PROJECT_PATH/package.json" 2>/dev/null; then
    print_auto "  Suite de testes detectada"
    HAS_TESTS="sim"
  fi
fi

if [ -f "$PROJECT_PATH/requirements.txt" ] || [ -f "$PROJECT_PATH/pyproject.toml" ] || [ -f "$PROJECT_PATH/setup.py" ]; then
  print_auto "Python detectado"
  DETECTED_STACK_LIST+=("Python")

  if [ -f "$PROJECT_PATH/requirements.txt" ]; then
    if grep -qi "django" "$PROJECT_PATH/requirements.txt" 2>/dev/null; then
      print_auto "  Django detectado"
      DETECTED_STACK_LIST+=("Django")
      PROJECT_TYPE="${PROJECT_TYPE:-webapp}"
    fi
    if grep -qi "fastapi\|flask" "$PROJECT_PATH/requirements.txt" 2>/dev/null; then
      print_auto "  FastAPI/Flask detectado"
      DETECTED_STACK_LIST+=("FastAPI")
      PROJECT_TYPE="${PROJECT_TYPE:-api}"
    fi
    if grep -qi "pytest" "$PROJECT_PATH/requirements.txt" 2>/dev/null; then
      HAS_TESTS="sim"
    fi
  fi
fi

if [ -f "$PROJECT_PATH/go.mod" ]; then
  print_auto "Go detectado (go.mod)"
  DETECTED_STACK_LIST+=("Go")
  PROJECT_TYPE="${PROJECT_TYPE:-api}"
fi

if [ -f "$PROJECT_PATH/Cargo.toml" ]; then
  print_auto "Rust detectado (Cargo.toml)"
  DETECTED_STACK_LIST+=("Rust")
fi

if [ -f "$PROJECT_PATH/pom.xml" ] || [ -f "$PROJECT_PATH/build.gradle" ]; then
  print_auto "Java detectado"
  DETECTED_STACK_LIST+=("Java")
fi

# --- n8n ---
if [ -f "$PROJECT_PATH/.mcp.json" ] || ls "$PROJECT_PATH"/workflows/*.json >/dev/null 2>&1; then
  print_auto "n8n detectado (workflows/MCP)"
  DETECTED_STACK_LIST+=("n8n")
  PROJECT_TYPE="${PROJECT_TYPE:-automation}"
fi

# --- Docker ---
if [ -f "$PROJECT_PATH/Dockerfile" ] || [ -f "$PROJECT_PATH/docker-compose.yml" ] || [ -f "$PROJECT_PATH/docker-compose.yaml" ]; then
  print_auto "Docker detectado"
  DETECTED_STACK_LIST+=("Docker")
  HAS_DOCKER="sim"
fi

# --- CI/CD ---
if [ -d "$PROJECT_PATH/.github/workflows" ]; then
  print_auto "GitHub Actions detectado"
  HAS_CI="github-actions"
elif [ -f "$PROJECT_PATH/.gitlab-ci.yml" ]; then
  print_auto "GitLab CI detectado"
  HAS_CI="gitlab-ci"
elif [ -f "$PROJECT_PATH/Jenkinsfile" ]; then
  print_auto "Jenkins detectado"
  HAS_CI="jenkins"
fi

# --- Banco de dados ---
if [ -d "$PROJECT_PATH/supabase" ] || [ -d "$PROJECT_PATH/migrations" ]; then
  print_auto "Supabase/Migrations detectado"
  HAS_DB="supabase"
elif [ -f "$PROJECT_PATH/prisma/schema.prisma" ]; then
  print_auto "Prisma detectado"
  HAS_DB="prisma"
elif ls "$PROJECT_PATH"/*.sqlite >/dev/null 2>&1; then
  print_auto "SQLite detectado"
  HAS_DB="sqlite"
fi

# --- Montar string de stack ---
if [ ${#DETECTED_STACK_LIST[@]} -eq 0 ]; then
  print_skip "Nenhuma tecnologia detectada automaticamente"
  ask "Qual e a stack do projeto?" "" "DETECTED_STACK"
else
  DETECTED_STACK=$(IFS=", "; echo "${DETECTED_STACK_LIST[*]}")
  echo ""
  print_ok "Stack detectada: $DETECTED_STACK"
  ask "Stack (edite ou Enter para aceitar)" "$DETECTED_STACK" "DETECTED_STACK"
fi

# Confirmar tipo de projeto
if [ -z "$PROJECT_TYPE" ]; then
  TYPE_CHOICE=$(ask_choice "Tipo de projeto" "Web App" "API/Backend" "CLI/Tool" "Automacao/Workflows" "Data/Analytics" "Mobile" "Outro")
  case "$TYPE_CHOICE" in
    1) PROJECT_TYPE="webapp" ;;
    2) PROJECT_TYPE="api" ;;
    3) PROJECT_TYPE="cli" ;;
    4) PROJECT_TYPE="automation" ;;
    5) PROJECT_TYPE="data" ;;
    6) PROJECT_TYPE="mobile" ;;
    *) PROJECT_TYPE="other" ;;
  esac
fi
print_ok "Tipo: $PROJECT_TYPE"

# ============================================================================
# STEP 3: AMBIENTES — Dev, staging, prod
# ============================================================================

print_step 3 "AMBIENTES — Onde roda"

ask "URL/ambiente de producao (ou 'local')" "local" "ENV_PROD"
ask "URL/ambiente de desenvolvimento" "local" "ENV_DEV"

if ask_yn "Tem ambiente de staging/homologacao?" "n"; then
  ask "URL/ambiente de staging" "" "ENV_STAGING"
else
  ENV_STAGING=""
fi

# ============================================================================
# STEP 4: CREDENCIAIS — O que precisa de segredo
# ============================================================================

print_step 4 "CREDENCIAIS — Segredos e acessos"

CRED_LINES=""
CRED_COUNT=0
ENV_TEMPLATE_LINES=""

# Auto-detectar do .env.example
if [ -f "$PROJECT_PATH/.env.example" ]; then
  print_auto "Detectado .env.example — importando variaveis"
  while IFS= read -r line; do
    # Pular comentarios e linhas vazias
    [[ "$line" =~ ^#.*$ ]] && continue
    [[ -z "$line" ]] && continue
    VAR_NAME=$(echo "$line" | cut -d'=' -f1)
    if [ -n "$VAR_NAME" ]; then
      CRED_COUNT=$((CRED_COUNT + 1))
      CRED_LINES="${CRED_LINES}| CRED-$(printf '%02d' $CRED_COUNT) | $VAR_NAME | $VAR_NAME | <!-- uso --> | Verificar .env |\n"
      ENV_TEMPLATE_LINES="${ENV_TEMPLATE_LINES}${VAR_NAME}=\n"
    fi
  done < "$PROJECT_PATH/.env.example"
  print_ok "$CRED_COUNT credenciais importadas do .env.example"
elif [ -f "$PROJECT_PATH/.env.template" ]; then
  print_auto "Detectado .env.template — importando variaveis"
  while IFS= read -r line; do
    [[ "$line" =~ ^#.*$ ]] && continue
    [[ -z "$line" ]] && continue
    VAR_NAME=$(echo "$line" | cut -d'=' -f1)
    if [ -n "$VAR_NAME" ]; then
      CRED_COUNT=$((CRED_COUNT + 1))
      CRED_LINES="${CRED_LINES}| CRED-$(printf '%02d' $CRED_COUNT) | $VAR_NAME | $VAR_NAME | <!-- uso --> | Verificar .env |\n"
      ENV_TEMPLATE_LINES="${ENV_TEMPLATE_LINES}${VAR_NAME}=\n"
    fi
  done < "$PROJECT_PATH/.env.template"
  print_ok "$CRED_COUNT credenciais importadas do .env.template"
else
  print_skip "Nenhum .env.example encontrado"
  echo ""
  echo "  Adicionar credenciais manualmente (Enter vazio para parar):"
  while true; do
    ask "Nome da variavel (ex: DATABASE_URL)" "" "CRED_VAR"
    [ -z "$CRED_VAR" ] && break
    ask "Para que serve" "" "CRED_USE"
    CRED_COUNT=$((CRED_COUNT + 1))
    CRED_LINES="${CRED_LINES}| CRED-$(printf '%02d' $CRED_COUNT) | $CRED_VAR | $CRED_VAR | $CRED_USE | A configurar |\n"
    ENV_TEMPLATE_LINES="${ENV_TEMPLATE_LINES}${CRED_VAR}=\n"
    print_ok "CRED-$(printf '%02d' $CRED_COUNT): $CRED_VAR"
  done
fi

if [ $CRED_COUNT -eq 0 ]; then
  CRED_LINES="| CRED-01 | <!-- nome --> | <!-- VAR --> | <!-- uso --> | <!-- status --> |\n"
fi

# ============================================================================
# STEP 5: GUARDRAILS — Protecoes
# ============================================================================

print_step 5 "GUARDRAILS — Protecoes do Projeto"

if ask_yn "Usar senha para acoes criticas (delete, deploy, etc.)?" "s"; then
  ask "Senha para acoes criticas" "CONFIRMAR_ACAO_CRITICA" "GUARDRAIL_PASSWORD"
  GUARDRAIL_SECTION="## Guardrails\n\nSenha para acoes criticas: $GUARDRAIL_PASSWORD\n\n### Acoes que REQUEREM senha:\n- Deletar recursos em producao\n- Deploy em producao\n- Sobrescrever dados existentes\n\n### PROIBIDO SEMPRE:\n- Expor API keys, tokens ou credenciais\n- Modificar producao sem backup previo"
else
  GUARDRAIL_SECTION="## Guardrails\n\n- Nao expor API keys, tokens ou credenciais\n- Nao modificar producao sem backup previo"
  GUARDRAIL_PASSWORD=""
fi

# ============================================================================
# STEP 6: POPs DE PROJETO — Automatizar o que precisa
# ============================================================================

print_step 6 "POPs DE PROJETO — O que automatizar"

echo "  POPs universais ja incluidos:"
echo -e "  ${GREEN}[OK]${NC} POP-000: Diagnostico de inicio de sessao"
echo -e "  ${GREEN}[OK]${NC} POP-001: Save de fim de sessao"
echo -e "  ${GREEN}[OK]${NC} POP-002: Checkpoint mid-session"
echo -e "  ${GREEN}[OK]${NC} POP-INIT: Bootstrap (este onboarding)"
echo ""
echo "  POPs de projeto (baseado na deteccao):"

POP_PROJECT_LIST=""
POP_INDEX_LINES=""
POP_COUNT=0

# POP de banco de dados
if [ -n "$HAS_DB" ]; then
  if ask_yn "  Criar POP de auditoria de banco ($HAS_DB)?" "s"; then
    POP_COUNT=$((POP_COUNT + 1))
    POP_ID="POP-P$(printf '%02d' $POP_COUNT)"
    POP_INDEX_LINES="${POP_INDEX_LINES}| [$POP_ID]($POP_ID.md) | Auditoria de Banco | Semanal ou erro de dados | Nivel 1 |\n"
    POP_PROJECT_LIST="${POP_PROJECT_LIST}db "
    print_ok "$POP_ID: Auditoria de Banco"
  fi
fi

# POP de testes
if [ -n "$HAS_TESTS" ]; then
  if ask_yn "  Criar POP de execucao de testes?" "s"; then
    POP_COUNT=$((POP_COUNT + 1))
    POP_ID="POP-P$(printf '%02d' $POP_COUNT)"
    POP_INDEX_LINES="${POP_INDEX_LINES}| [$POP_ID]($POP_ID.md) | Executar Testes | Antes de commit/deploy | Nivel 2 (auto) |\n"
    POP_PROJECT_LIST="${POP_PROJECT_LIST}test "
    print_ok "$POP_ID: Executar Testes"
  fi
fi

# POP de deploy
if [ -n "$HAS_CI" ] || [ "$ENV_PROD" != "local" ]; then
  if ask_yn "  Criar POP de deploy/monitoramento pos-deploy?" "s"; then
    POP_COUNT=$((POP_COUNT + 1))
    POP_ID="POP-P$(printf '%02d' $POP_COUNT)"
    POP_INDEX_LINES="${POP_INDEX_LINES}| [$POP_ID]($POP_ID.md) | Monitoramento Pos-Deploy | 24h/48h apos deploy | Nivel 1 |\n"
    POP_PROJECT_LIST="${POP_PROJECT_LIST}deploy "
    print_ok "$POP_ID: Monitoramento Pos-Deploy"
  fi
fi

# POP de backup
if ask_yn "  Criar POP de backup antes de modificacao?" "s"; then
  POP_COUNT=$((POP_COUNT + 1))
  POP_ID="POP-P$(printf '%02d' $POP_COUNT)"
  POP_INDEX_LINES="${POP_INDEX_LINES}| [$POP_ID]($POP_ID.md) | Backup Pre-Modificacao | Antes de modificar | Nivel 2 (auto) |\n"
  POP_PROJECT_LIST="${POP_PROJECT_LIST}backup "
  print_ok "$POP_ID: Backup Pre-Modificacao"
fi

if [ $POP_COUNT -eq 0 ]; then
  print_skip "Nenhum POP de projeto criado (pode adicionar depois)"
fi

# ============================================================================
# STEP 7: INSTALACAO — Copiar e personalizar
# ============================================================================

print_step 7 "INSTALACAO — Criando estrutura"

# --- Copiar template ---
cp -r "$TEMPLATE_DIR" "$CONTEXT_DIR"
print_ok "Template copiado para .context/"

# --- Renomear templates ---
for TMPL in "$CONTEXT_DIR"/*.template.md; do
  if [ -f "$TMPL" ]; then
    TARGET="${TMPL%.template.md}.md"
    mv "$TMPL" "$TARGET"
  fi
done
print_ok "Templates renomeados"

# --- Substituir placeholders basicos ---
find "$CONTEXT_DIR" -name "*.md" -exec sed -i \
  -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
  -e "s/{{DATE}}/$DATE/g" \
  {} +
print_ok "Placeholders substituidos"

# --- Personalizar MANIFEST ---
MANIFEST="$CONTEXT_DIR/MANIFEST.md"

# Substituir Identity
sed -i "s|<!-- O que este projeto faz -->|$PROJECT_DESC|g" "$MANIFEST"
sed -i "s|<!-- Linguagens, frameworks, servicos -->|$DETECTED_STACK|g" "$MANIFEST"

# Adicionar ambientes
ENV_SECTION="- **Producao:** $ENV_PROD\n- **Desenvolvimento:** $ENV_DEV"
if [ -n "$ENV_STAGING" ]; then
  ENV_SECTION="${ENV_SECTION}\n- **Staging:** $ENV_STAGING"
fi
sed -i "s|<!-- dev, staging, producao -->|$(echo -e "$ENV_SECTION")|g" "$MANIFEST"

# Substituir credenciais
if [ $CRED_COUNT -gt 0 ]; then
  # Remover linha placeholder e inserir credenciais reais
  sed -i "/CRED-01.*<!-- nome -->/c\\$(echo -e "$CRED_LINES")" "$MANIFEST"
fi

# Adicionar guardrails
if [ -n "$GUARDRAIL_PASSWORD" ]; then
  sed -i "/## Constraints/i\\$(echo -e "$GUARDRAIL_SECTION")\n" "$MANIFEST"
fi

print_ok "MANIFEST.md personalizado"

# --- Personalizar SNAPSHOT ---
SNAPSHOT="$CONTEXT_DIR/SNAPSHOT.md"
sed -i "s|Inicializacao do GENOMA no projeto {{PROJECT_NAME}}|Inicializacao do GENOMA no projeto $PROJECT_NAME|g" "$SNAPSHOT"
print_ok "SNAPSHOT.md personalizado"

# --- Personalizar pops/INDEX.md com POPs de projeto ---
if [ $POP_COUNT -gt 0 ]; then
  POPS_INDEX="$CONTEXT_DIR/pops/INDEX.md"
  sed -i "/<!-- Adicionar POPs especificos/c\\$(echo -e "$POP_INDEX_LINES")" "$POPS_INDEX"
  print_ok "pops/INDEX.md atualizado com $POP_COUNT POPs de projeto"
fi

# --- Criar POPs de projeto ---
for pop_type in $POP_PROJECT_LIST; do
  case "$pop_type" in
    db)
      cat > "$CONTEXT_DIR/pops/POP-P01.md" << 'POPEOF'
# POP-P01: Auditoria de Banco de Dados

- **Trigger:** Ultimo audit > 7 dias OU erro relacionado a dados
- **Autonomia:** Nivel 1 (propor com tudo preparado)
- **Requer:** Credenciais de banco via .env
- **Risco:** Baixo (somente leitura)

## Procedimento

1. Verificar credenciais no .env
2. Conectar ao banco
3. Verificar integridade das tabelas principais
4. Comparar com ultimo audit (deep/audit-NNN.md)
5. Gerar relatorio em deep/audit-NNN.md
6. Atualizar SNAPSHOT com resultado

## Commit

`audit(db): POP-P01 audit - [resultado]`
POPEOF
      print_ok "pops/POP-P01.md criado"
      ;;
    test)
      cat > "$CONTEXT_DIR/pops/POP-P02.md" << 'POPEOF'
# POP-P02: Executar Testes

- **Trigger:** Antes de commit significativo ou deploy
- **Autonomia:** Nivel 2 (auto-executar)
- **Requer:** Suite de testes configurada

## Procedimento

1. Executar suite de testes completa
2. Se falhar: identificar e corrigir antes de prosseguir
3. Se passar: registrar no SNAPSHOT

## Commit

`test(scope): POP-P02 - all tests passing`
POPEOF
      print_ok "pops/POP-P02.md criado"
      ;;
    deploy)
      cat > "$CONTEXT_DIR/pops/POP-P03.md" << 'POPEOF'
# POP-P03: Monitoramento Pos-Deploy

- **Trigger:** 24h e 48h apos deploy
- **Autonomia:** Nivel 1 (propor ao usuario)
- **Requer:** Acesso ao ambiente de producao

## Procedimento

1. Verificar logs de erro no ambiente
2. Conferir metricas basicas (uptime, tempo de resposta)
3. Comparar com baseline pre-deploy
4. Atualizar SNAPSHOT com resultado

## Commit

`audit(deploy): POP-P03 post-deploy check - [resultado]`
POPEOF
      print_ok "pops/POP-P03.md criado"
      ;;
    backup)
      cat > "$CONTEXT_DIR/pops/POP-P04.md" << 'POPEOF'
# POP-P04: Backup Pre-Modificacao

- **Trigger:** Antes de qualquer modificacao significativa
- **Autonomia:** Nivel 2 (auto-executar)
- **Requer:** Nada (operacao local)

## Procedimento

1. Identificar arquivos que serao modificados
2. Criar save point: `git commit -m "snapshot(safety): save point before [acao]"`
3. Registrar hash do save point
4. Prosseguir com modificacao

## Rollback

`git revert $SAVE_HASH`
POPEOF
      print_ok "pops/POP-P04.md criado"
      ;;
  esac
done

# --- Gerar rotas especificas baseado no tipo de projeto ---
ROUTES="$CONTEXT_DIR/ROUTES.md"
PROJECT_ROUTES=""

case "$PROJECT_TYPE" in
  webapp)
    PROJECT_ROUTES='### "Adicionar nova pagina/componente"\n**Tempo:** ~10 min | **Tokens:** ~8k\n\n1. MANIFEST.md -> architecture + file map\n2. Identificar padrao de componentes existente\n3. Criar componente seguindo padrao\n4. Adicionar rota se necessario\n5. Testar\n\n### "Corrigir bug de layout/UI"\n**Tempo:** ~5 min | **Tokens:** ~5k\n\n1. SNAPSHOT.md -> estado atual\n2. Identificar componente afetado\n3. Inspecionar CSS/estilos\n4. Corrigir e testar responsividade'
    ;;
  api)
    PROJECT_ROUTES='### "Adicionar novo endpoint"\n**Tempo:** ~10 min | **Tokens:** ~8k\n\n1. MANIFEST.md -> architecture + constraints\n2. DECISIONS.md -> padroes de API\n3. Definir rota, metodo, payload, response\n4. Implementar + validacao de entrada\n5. Testar com curl/Postman\n\n### "Debug de request falhando"\n**Tempo:** ~5 min | **Tokens:** ~5k\n\n1. SNAPSHOT.md -> estado atual\n2. Verificar logs de erro\n3. Testar endpoint isoladamente\n4. Checar middleware/auth'
    ;;
  automation)
    PROJECT_ROUTES='### "Criar novo workflow"\n**Tempo:** ~20 min | **Tokens:** ~10k\n\n1. MANIFEST.md -> instancia + constraints\n2. Consultar n8n-skills relevantes\n3. Plano no a no + aprovacao\n4. Construir + validar + deploy inativo\n\n### "Corrigir workflow com erro"\n**Tempo:** ~5 min | **Tokens:** ~5k\n\n1. SNAPSHOT.md -> status dos workflows\n2. Verificar executions com erro\n3. Identificar no com falha\n4. Corrigir e testar'
    ;;
  cli)
    PROJECT_ROUTES='### "Adicionar novo comando"\n**Tempo:** ~10 min | **Tokens:** ~8k\n\n1. MANIFEST.md -> architecture\n2. Identificar padrao de comandos existente\n3. Implementar comando + help text\n4. Adicionar testes\n\n### "Corrigir flag/argumento"\n**Tempo:** ~3 min | **Tokens:** ~3k\n\n1. Identificar comando afetado\n2. Verificar parsing de argumentos\n3. Corrigir + testar'
    ;;
esac

if [ -n "$PROJECT_ROUTES" ]; then
  sed -i "/<!-- Adicionar rotas especificas/c\\$(echo -e "$PROJECT_ROUTES")" "$ROUTES"
  print_ok "ROUTES.md com rotas especificas para $PROJECT_TYPE"
fi

# --- Instalar git hooks ---
if [ -d "$PROJECT_PATH/.git" ]; then
  cp "$CONTEXT_DIR/hooks/commit-msg.sh" "$PROJECT_PATH/.git/hooks/commit-msg"
  cp "$CONTEXT_DIR/hooks/post-commit.sh" "$PROJECT_PATH/.git/hooks/post-commit"
  cp "$CONTEXT_DIR/hooks/pre-push.sh" "$PROJECT_PATH/.git/hooks/pre-push"
  chmod +x "$PROJECT_PATH/.git/hooks/commit-msg" 2>/dev/null
  chmod +x "$PROJECT_PATH/.git/hooks/post-commit" 2>/dev/null
  chmod +x "$PROJECT_PATH/.git/hooks/pre-push" 2>/dev/null
  print_ok "Git hooks instalados (commit-msg, post-commit, pre-push)"
elif ask_yn "Nao e um repo git. Inicializar?" "s"; then
  git init "$PROJECT_PATH"
  cp "$CONTEXT_DIR/hooks/commit-msg.sh" "$PROJECT_PATH/.git/hooks/commit-msg"
  cp "$CONTEXT_DIR/hooks/post-commit.sh" "$PROJECT_PATH/.git/hooks/post-commit"
  cp "$CONTEXT_DIR/hooks/pre-push.sh" "$PROJECT_PATH/.git/hooks/pre-push"
  chmod +x "$PROJECT_PATH/.git/hooks/commit-msg" 2>/dev/null
  chmod +x "$PROJECT_PATH/.git/hooks/post-commit" 2>/dev/null
  chmod +x "$PROJECT_PATH/.git/hooks/pre-push" 2>/dev/null
  print_ok "Git inicializado + hooks instalados"
fi

# --- Verificar .gitignore ---
if [ -f "$PROJECT_PATH/.gitignore" ]; then
  if ! grep -q "^\.env$" "$PROJECT_PATH/.gitignore" 2>/dev/null; then
    echo ".env" >> "$PROJECT_PATH/.gitignore"
    print_ok ".env adicionado ao .gitignore"
  fi
else
  echo ".env" > "$PROJECT_PATH/.gitignore"
  print_ok ".gitignore criado com .env"
fi

# --- Commit inicial ---
if [ -d "$PROJECT_PATH/.git" ]; then
  echo ""
  if ask_yn "Criar commit inicial do GENOMA?" "s"; then
    cd "$PROJECT_PATH"
    git add .context/
    git add .gitignore 2>/dev/null
    git commit -m "context(genoma): initialize PGP GENOMA v2.0 for $PROJECT_NAME" 2>/dev/null || true
    print_ok "Commit inicial criado"
  fi
fi

# ============================================================================
# RESUMO FINAL
# ============================================================================

echo ""
echo -e "${CYAN}   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BOLD}${GREEN}     GENOMA v2.0 ATIVO!${NC}"
echo ""
echo -e "     ${CYAN}Projeto guarnecido. Contexto perpetuo.${NC}"
echo ""
echo -e "${CYAN}   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BOLD}Projeto:${NC} $PROJECT_NAME"
echo -e "${BOLD}Stack:${NC}   $DETECTED_STACK"
echo -e "${BOLD}Tipo:${NC}    $PROJECT_TYPE"
echo -e "${BOLD}Idioma:${NC}  $PROJECT_LANG"
echo ""
echo -e "${BOLD}Instalado automaticamente:${NC}"
echo -e "  ${GREEN}[OK]${NC} Kernel GENOMA (README, hooks, POPs universais)"
echo -e "  ${GREEN}[OK]${NC} Git hooks (commit-msg, post-commit, pre-push)"
echo -e "  ${GREEN}[OK]${NC} Templates (sessao, deep/)"
echo ""
echo -e "${BOLD}Personalizado:${NC}"
echo -e "  ${GREEN}[OK]${NC} MANIFEST.md (identity, stack, credenciais)"
echo -e "  ${GREEN}[OK]${NC} SNAPSHOT.md (estado inicial)"
echo -e "  ${GREEN}[OK]${NC} ROUTES.md (universais + $PROJECT_TYPE)"
[ $POP_COUNT -gt 0 ] && echo -e "  ${GREEN}[OK]${NC} $POP_COUNT POPs de projeto"
[ -n "$GUARDRAIL_PASSWORD" ] && echo -e "  ${GREEN}[OK]${NC} Guardrails com senha"
echo ""
echo -e "${BOLD}Proximos passos:${NC}"
echo -e "  1. Revisar ${CYAN}.context/MANIFEST.md${NC} — dados corretos?"
echo -e "  2. Revisar ${CYAN}.context/ROUTES.md${NC} — falta algum cenario?"
echo -e "  3. Ou pedir ao Claude: ${CYAN}\"Executar POP-INIT\"${NC}"
echo -e "     (ele analisa o projeto e refina tudo automaticamente)"
echo ""
echo -e "Para comecar, o Claude executa ${CYAN}POP-000${NC} automaticamente."
echo ""
