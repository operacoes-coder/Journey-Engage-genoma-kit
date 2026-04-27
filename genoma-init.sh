#!/bin/bash
# ============================================================================
# genoma-init.sh — Instalador Definitivo PGP GENOMA v4.0
# ============================================================================
#
# Evolucao completa com:
#   - 3 modos: rapido, intermediario, completo
#   - Deteccao automatica de projeto existente vs novo
#   - history/ (sessoes com data+hora real)
#   - tasks/ (grupos com data+hora real)
#   - plans/ (planos de implementacao)
#   - tools/ (Playwright, MCP, APIs pre-configurados)
#   - Banco de dados (pergunta e configura)
#   - Design system (para webapps)
#   - specs/ completo (glossario, invariantes, error taxonomy, etc)
#   - docs/ (decisions, post-mortems, anti-patterns)
#   - CLAUDE.md template v4 com 17 blocos
#   - Rotas especificas por tipo de projeto
#   - POPs de projeto com arquivos criados
#   - Decisoes com triggers de analise
#   - Todos os timestamps do relogio do computador
#
# Uso:
#   ./genoma-init.sh                           # Projeto no diretorio atual (interativo)
#   ./genoma-init.sh /caminho/do/projeto       # Projeto em outro diretorio (interativo)
#   ./genoma-init.sh --auto /caminho/do/projeto  # Modo automatico (sem perguntas)
#   ./genoma-init.sh --auto --mode completo /caminho  # Auto + modo especifico
#   ./genoma-init.sh --config genoma.conf /caminho     # Usando arquivo de config
#
# Flags:
#   --auto              Modo nao-interativo (usa defaults inteligentes)
#   --mode MODE         rapido|intermediario|completo (default: completo)
#   --config FILE       Arquivo de configuracao (key=value)
#   --yes               Aceitar tudo sem perguntas (alias de --auto)
#
# Arquivo de config (.genoma-config ou passado com --config):
#   PROJECT_NAME=meu-projeto
#   PROJECT_DESC=Descricao do projeto
#   INSTALL_MODE=completo
#   PROJECT_LANG=pt-BR
#   DB_TYPE=postgresql
#   DB_PROVIDER=supabase
#   DESIGN_SYSTEM=Tailwind CSS
#   DESIGN_COMPONENTS=shadcn/ui
#   GUARDRAIL_PASSWORD=CONFIRMAR_ACAO_CRITICA
#   TOOLS_PLAYWRIGHT=s
#   TOOLS_MCP=s
#   TOOLS_API=s
#   GIT_INIT=s
#   GIT_COMMIT=s
#
# ============================================================================

set -e

# ---------- Modo nao-interativo ----------
AUTO_MODE="n"
CONFIG_FILE=""
CLI_MODE=""
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --auto|--yes|-y)
      AUTO_MODE="s"
      shift
      ;;
    --mode)
      CLI_MODE="$2"
      shift 2
      ;;
    --config)
      CONFIG_FILE="$2"
      shift 2
      ;;
    -*)
      echo "Flag desconhecida: $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1")
      shift
      ;;
  esac
done

# Restaurar argumentos posicionais
set -- "${POSITIONAL_ARGS[@]}"

# Auto-detectar se nao tem TTY (ex: rodando de pipe, Claude Code, CI/CD)
if [ ! -t 0 ] && [ "$AUTO_MODE" = "n" ]; then
  AUTO_MODE="s"
  echo "[INFO] Terminal interativo nao detectado — ativando modo --auto automaticamente"
fi

# Carregar arquivo de config se existir
_load_config() {
  local file="$1"
  if [ -f "$file" ]; then
    while IFS='=' read -r key value; do
      [[ "$key" =~ ^#.*$ ]] && continue
      [[ -z "$key" ]] && continue
      value="${value%\"}"
      value="${value#\"}"
      export "CFG_${key}=${value}"
    done < "$file"
  fi
}

if [ -n "$CONFIG_FILE" ]; then
  _load_config "$CONFIG_FILE"
fi

# Fallback: buscar .genoma-config no diretorio do projeto
_PROJ_ARG="${1:-.}"
if [ -z "$CONFIG_FILE" ] && [ -f "$_PROJ_ARG/.genoma-config" ]; then
  _load_config "$_PROJ_ARG/.genoma-config"
fi

# ---------- Cores ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# ---------- Funcoes utilitarias ----------

print_header() {
  clear 2>/dev/null || true
  echo ""
  echo -e "${CYAN}   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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
  echo -e "     ${BOLD}PGP — Protocolo GENOMA Perpetuo v4.0${NC}"
  echo -e "     ${MAGENTA}Instalador Definitivo de Alta Performance${NC}"
  echo ""
  echo -e "     ${BOLD}G${NC}estao ${BOLD}E${NC}struturada ${BOLD}N${NC}ormalizada ${BOLD}O${NC}rientada por ${BOLD}M${NC}etricas e ${BOLD}A${NC}tualizacao"
  echo ""
  echo -e "${CYAN}   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
}

print_step() {
  local current=$1
  local total=$2
  local title="$3"
  echo ""
  echo -e "${BLUE}[$current/$total]${NC} ${BOLD}$title${NC}"
  echo -e "${BLUE}$(printf '%.0s─' {1..60})${NC}"
}

print_auto() { echo -e "  ${GREEN}[AUTO]${NC} $1"; }
print_ok()   { echo -e "  ${GREEN}[OK]${NC} $1"; }
print_skip() { echo -e "  ${YELLOW}[SKIP]${NC} $1"; }
print_info() { echo -e "  ${CYAN}[i]${NC} $1"; }
print_warn() { echo -e "  ${YELLOW}[!]${NC} $1"; }

ask() {
  local prompt="$1" default="$2" var_name="$3"
  if [ "$AUTO_MODE" = "s" ]; then
    local cfg_val
    cfg_val=$(eval echo "\${CFG_${var_name}:-}")
    if [ -n "$cfg_val" ]; then
      eval "$var_name=\"$cfg_val\""
      print_auto "$prompt → $cfg_val (config)"
    elif [ -n "$default" ]; then
      eval "$var_name=\"$default\""
      print_auto "$prompt → $default"
    else
      eval "$var_name=\"\""
    fi
    return
  fi
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
  local prompt="$1" default="$2"
  if [ "$AUTO_MODE" = "s" ]; then
    print_auto "$prompt → $default"
    [[ "$default" =~ ^[SsYy]$ ]]
    return $?
  fi
  echo -ne "  ${YELLOW}>${NC} $prompt ${CYAN}[$default]${NC}: "
  read -r input
  input="${input:-$default}"
  [[ "$input" =~ ^[SsYy]$ ]]
}

ask_choice() {
  local prompt="$1"; shift
  local options=("$@")
  if [ "$AUTO_MODE" = "s" ]; then
    # Em modo auto, retorna 1 (primeira opcao) ou o valor mais completo
    print_auto "$prompt → ${options[0]}"
    echo "1"
    return
  fi
  echo -e "  ${YELLOW}>${NC} $prompt"
  for i in "${!options[@]}"; do
    echo -e "    ${CYAN}$((i+1)))${NC} ${options[$i]}"
  done
  echo -ne "  ${YELLOW}>${NC} Escolha (numero): "
  read -r choice
  echo "$choice"
}

safe_replace() {
  local placeholder="$1"
  local value="$2"
  local file="$3"
  awk -v old="$placeholder" -v new="$value" '{gsub(old,new)}1' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
}

# ---------- Parametros ----------

PROJECT_PATH="${1:-.}"
PROJECT_PATH="$(cd "$PROJECT_PATH" 2>/dev/null && pwd)" || {
  echo -e "${RED}ERRO: Diretorio '${1:-.}' nao existe.${NC}"
  exit 1
}

# Aplicar modo via --mode ou config
if [ -n "$CLI_MODE" ]; then
  CFG_INSTALL_MODE="$CLI_MODE"
fi
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/template"
CONTEXT_DIR="$PROJECT_PATH/.context"
SPECS_DIR="$PROJECT_PATH/specs"
DOCS_DIR="$PROJECT_PATH/docs"
CLAUDE_DIR="$PROJECT_PATH/.claude"
DATE=$(date +%Y-%m-%d)
HORA=$(date +%H:%M)

# ---------- Validacoes ----------

if [ ! -d "$TEMPLATE_DIR" ]; then
  echo -e "${RED}ERRO: template/ nao encontrado em $SCRIPT_DIR${NC}"
  exit 1
fi

if [ -d "$CONTEXT_DIR" ]; then
  if [ "$AUTO_MODE" = "s" ]; then
    echo -e "${YELLOW}AVISO: .context/ ja existe — sobrescrevendo (modo auto)${NC}"
    rm -rf "$CONTEXT_DIR"
  else
    echo -e "${YELLOW}AVISO: .context/ ja existe em $PROJECT_PATH${NC}"
    if ! ask_yn "Sobrescrever?" "n"; then
      echo "Cancelado."
      exit 0
    fi
    rm -rf "$CONTEXT_DIR"
  fi
fi

# ============================================================================
# BANNER + MODO DE INSTALACAO
# ============================================================================

print_header

echo -e "Projeto em: ${BOLD}$PROJECT_PATH${NC}"
echo ""

# ---------- Detectar projeto existente vs novo ----------

IS_EXISTING="n"
HAS_FILES=0

if [ -f "$PROJECT_PATH/package.json" ] || [ -f "$PROJECT_PATH/requirements.txt" ] || \
   [ -f "$PROJECT_PATH/go.mod" ] || [ -f "$PROJECT_PATH/Cargo.toml" ] || \
   [ -f "$PROJECT_PATH/.mcp.json" ] || [ -f "$PROJECT_PATH/README.md" ] || \
   [ -d "$PROJECT_PATH/.git" ]; then
  HAS_FILES=1
fi

if [ $HAS_FILES -eq 1 ]; then
  print_auto "Projeto existente detectado — vou analisar e preencher automaticamente"
  IS_EXISTING="s"
else
  print_info "Pasta vazia ou projeto novo — vou fazer perguntas para configurar"
  IS_EXISTING="n"
fi

# ---------- Escolher modo ----------

if [ "$AUTO_MODE" = "s" ]; then
  # Modo auto: usar config ou default completo
  _cfg_mode="${CFG_INSTALL_MODE:-completo}"
  case "$_cfg_mode" in
    rapido) INSTALL_MODE="rapido"; TOTAL_STEPS=7 ;;
    intermediario) INSTALL_MODE="intermediario"; TOTAL_STEPS=10 ;;
    *) INSTALL_MODE="completo"; TOTAL_STEPS=13 ;;
  esac
  print_auto "Modo: $INSTALL_MODE"
else
  echo ""
  echo -e "${BOLD}Escolha o modo de instalacao:${NC}"
  echo ""
  MODE_CHOICE=$(ask_choice "Modo" \
    "Rapido — So .context/ com core (MANIFEST, SNAPSHOT, POPs, hooks)" \
    "Intermediario — Core + tools/ + history/ + tasks/ + plans/ + commands" \
    "Completo — Tudo: core + specs/ + docs/ + tools/ + CLAUDE.md 17 blocos")

  case "$MODE_CHOICE" in
    1) INSTALL_MODE="rapido"; TOTAL_STEPS=7 ;;
    2) INSTALL_MODE="intermediario"; TOTAL_STEPS=10 ;;
    3) INSTALL_MODE="completo"; TOTAL_STEPS=13 ;;
    *) INSTALL_MODE="completo"; TOTAL_STEPS=13 ;;
  esac

  print_ok "Modo: ${BOLD}$INSTALL_MODE${NC}"
  echo ""
  echo -e "Pressione ${CYAN}Enter${NC} para aceitar valores padrao entre [colchetes]."
  echo ""
  read -p "Iniciar? (Enter para continuar, Ctrl+C para cancelar) "
fi

# ============================================================================
# STEP 1: IDENTITY
# ============================================================================

print_step 1 $TOTAL_STEPS "IDENTITY — Dados do Projeto"

FOLDER_NAME=$(basename "$PROJECT_PATH")
ask "Nome do projeto" "$FOLDER_NAME" "PROJECT_NAME"
print_ok "Projeto: $PROJECT_NAME"

# Auto-detectar descricao de README se existente
DEFAULT_DESC=""
if [ "$IS_EXISTING" = "s" ] && [ -f "$PROJECT_PATH/README.md" ]; then
  DEFAULT_DESC=$(head -5 "$PROJECT_PATH/README.md" | grep -v "^#" | grep -v "^$" | head -1 | cut -c1-100)
fi
ask "Descricao curta (o que faz)" "$DEFAULT_DESC" "PROJECT_DESC"
print_ok "Descricao: $PROJECT_DESC"

PROJECT_VISION=""
if [ "$INSTALL_MODE" != "rapido" ]; then
  ask "Visao do projeto (por que existe)" "" "PROJECT_VISION"
fi

LANG_CHOICE=$(ask_choice "Idioma principal" "Portugues Brasileiro (pt-BR) [recomendado]" "English (en)" "Espanol (es)")
case "$LANG_CHOICE" in
  1) PROJECT_LANG="pt-BR" ;; 2) PROJECT_LANG="en" ;; 3) PROJECT_LANG="es" ;; *) PROJECT_LANG="pt-BR" ;;
esac
print_ok "Idioma: $PROJECT_LANG"

# ============================================================================
# STEP 2: STACK (auto-deteccao)
# ============================================================================

print_step 2 $TOTAL_STEPS "STACK — Detectando Tecnologias"

DETECTED_STACK=""
DETECTED_STACK_LIST=()
HAS_DB=""
HAS_TESTS=""
HAS_CI=""
HAS_DOCKER=""
PROJECT_TYPE=""
DETECTED_LANG=""

# --- Linguagens e frameworks ---

if [ -f "$PROJECT_PATH/package.json" ]; then
  print_auto "Node.js detectado (package.json)"
  DETECTED_STACK_LIST+=("Node.js")
  DETECTED_LANG="typescript"

  grep -q '"next"' "$PROJECT_PATH/package.json" 2>/dev/null && { print_auto "  Next.js"; DETECTED_STACK_LIST+=("Next.js"); PROJECT_TYPE="webapp"; }
  grep -q '"react"' "$PROJECT_PATH/package.json" 2>/dev/null && { print_auto "  React"; DETECTED_STACK_LIST+=("React"); PROJECT_TYPE="${PROJECT_TYPE:-webapp}"; }
  grep -q '"vue"' "$PROJECT_PATH/package.json" 2>/dev/null && { print_auto "  Vue.js"; DETECTED_STACK_LIST+=("Vue.js"); PROJECT_TYPE="${PROJECT_TYPE:-webapp}"; }
  grep -q '"express"' "$PROJECT_PATH/package.json" 2>/dev/null && { print_auto "  Express"; DETECTED_STACK_LIST+=("Express"); PROJECT_TYPE="${PROJECT_TYPE:-api}"; }
  grep -q '"typescript"' "$PROJECT_PATH/package.json" 2>/dev/null && { print_auto "  TypeScript"; DETECTED_STACK_LIST+=("TypeScript"); }
  grep -q '"jest"\|"vitest"\|"mocha"\|"cypress"\|"playwright"' "$PROJECT_PATH/package.json" 2>/dev/null && { print_auto "  Suite de testes detectada"; HAS_TESTS="sim"; }
fi

if [ -f "$PROJECT_PATH/requirements.txt" ] || [ -f "$PROJECT_PATH/pyproject.toml" ] || [ -f "$PROJECT_PATH/setup.py" ]; then
  print_auto "Python detectado"; DETECTED_STACK_LIST+=("Python"); DETECTED_LANG="python"
  if [ -f "$PROJECT_PATH/requirements.txt" ]; then
    grep -qi "django" "$PROJECT_PATH/requirements.txt" 2>/dev/null && { print_auto "  Django"; DETECTED_STACK_LIST+=("Django"); PROJECT_TYPE="${PROJECT_TYPE:-webapp}"; }
    grep -qi "fastapi\|flask" "$PROJECT_PATH/requirements.txt" 2>/dev/null && { print_auto "  FastAPI/Flask"; DETECTED_STACK_LIST+=("FastAPI"); PROJECT_TYPE="${PROJECT_TYPE:-api}"; }
    grep -qi "pytest" "$PROJECT_PATH/requirements.txt" 2>/dev/null && HAS_TESTS="sim"
    grep -qi "playwright" "$PROJECT_PATH/requirements.txt" 2>/dev/null && { print_auto "  Playwright (Python)"; DETECTED_STACK_LIST+=("Playwright"); }
  fi
fi

[ -f "$PROJECT_PATH/go.mod" ] && { print_auto "Go detectado"; DETECTED_STACK_LIST+=("Go"); DETECTED_LANG="go"; PROJECT_TYPE="${PROJECT_TYPE:-api}"; }
[ -f "$PROJECT_PATH/Cargo.toml" ] && { print_auto "Rust detectado"; DETECTED_STACK_LIST+=("Rust"); DETECTED_LANG="rust"; }
([ -f "$PROJECT_PATH/pom.xml" ] || [ -f "$PROJECT_PATH/build.gradle" ]) && { print_auto "Java detectado"; DETECTED_STACK_LIST+=("Java"); DETECTED_LANG="java"; }

# n8n
if [ -f "$PROJECT_PATH/.mcp.json" ] || ls "$PROJECT_PATH"/workflows/*.json >/dev/null 2>&1; then
  print_auto "n8n detectado"; DETECTED_STACK_LIST+=("n8n"); PROJECT_TYPE="${PROJECT_TYPE:-automation}"
fi

# Docker
if [ -f "$PROJECT_PATH/Dockerfile" ] || [ -f "$PROJECT_PATH/docker-compose.yml" ] || [ -f "$PROJECT_PATH/docker-compose.yaml" ]; then
  print_auto "Docker detectado"; DETECTED_STACK_LIST+=("Docker"); HAS_DOCKER="sim"
fi

# CI/CD
[ -d "$PROJECT_PATH/.github/workflows" ] && { print_auto "GitHub Actions"; HAS_CI="github-actions"; }
[ -f "$PROJECT_PATH/.gitlab-ci.yml" ] && { print_auto "GitLab CI"; HAS_CI="gitlab-ci"; }
[ -f "$PROJECT_PATH/Jenkinsfile" ] && { print_auto "Jenkins"; HAS_CI="jenkins"; }

# Banco de dados
if [ -d "$PROJECT_PATH/supabase" ] || [ -d "$PROJECT_PATH/migrations" ]; then
  print_auto "Supabase/Migrations detectado"; HAS_DB="supabase"
elif [ -f "$PROJECT_PATH/prisma/schema.prisma" ]; then
  print_auto "Prisma detectado"; HAS_DB="prisma"
elif ls "$PROJECT_PATH"/*.sqlite >/dev/null 2>&1; then
  print_auto "SQLite detectado"; HAS_DB="sqlite"
fi

# Montar string
if [ ${#DETECTED_STACK_LIST[@]} -eq 0 ]; then
  print_skip "Nenhuma tecnologia detectada automaticamente"
  ask "Qual e a stack do projeto?" "" "DETECTED_STACK"
  ask "Linguagem principal (js, ts, python, go, rust, java)" "typescript" "DETECTED_LANG"
else
  DETECTED_STACK=$(IFS=", "; echo "${DETECTED_STACK_LIST[*]}")
  echo ""
  print_ok "Stack detectada: $DETECTED_STACK"
  ask "Stack (edite ou Enter para aceitar)" "$DETECTED_STACK" "DETECTED_STACK"
fi

if [ -z "$PROJECT_TYPE" ]; then
  TYPE_CHOICE=$(ask_choice "Tipo de projeto" "Web App" "API/Backend" "CLI/Tool" "Automacao/Workflows" "Data/Analytics" "Mobile" "Outro")
  case "$TYPE_CHOICE" in
    1) PROJECT_TYPE="webapp" ;; 2) PROJECT_TYPE="api" ;; 3) PROJECT_TYPE="cli" ;;
    4) PROJECT_TYPE="automation" ;; 5) PROJECT_TYPE="data" ;; 6) PROJECT_TYPE="mobile" ;; *) PROJECT_TYPE="other" ;;
  esac
fi
print_ok "Tipo: $PROJECT_TYPE"

# ============================================================================
# STEP 3: BANCO DE DADOS
# ============================================================================

print_step 3 $TOTAL_STEPS "BANCO DE DADOS — Persistencia"

DB_TYPE=""
DB_PROVIDER=""

if [ -n "$HAS_DB" ]; then
  print_auto "Banco detectado: $HAS_DB"
  DB_TYPE="$HAS_DB"
  DB_PROVIDER="$HAS_DB"
elif [ "$AUTO_MODE" = "s" ] && [ -n "$CFG_DB_TYPE" ]; then
  DB_TYPE="$CFG_DB_TYPE"
  DB_PROVIDER="${CFG_DB_PROVIDER:-$DB_TYPE}"
  print_auto "Banco (config): $DB_TYPE ($DB_PROVIDER)"
elif [ "$AUTO_MODE" = "s" ]; then
  print_skip "Sem banco configurado (modo auto sem config)"
  DB_TYPE=""
  DB_PROVIDER=""
else
  if ask_yn "O projeto usa banco de dados?" "s"; then
    DB_CHOICE=$(ask_choice "Tipo de banco" "Supabase (PostgreSQL)" "PostgreSQL (direto)" "MySQL/MariaDB" "MongoDB" "SQLite" "Firebase/Firestore" "Redis" "Outro" "Nenhum")
    case "$DB_CHOICE" in
      1) DB_TYPE="postgresql"; DB_PROVIDER="supabase" ;;
      2) DB_TYPE="postgresql"; DB_PROVIDER="postgresql" ;;
      3) DB_TYPE="mysql"; DB_PROVIDER="mysql" ;;
      4) DB_TYPE="mongodb"; DB_PROVIDER="mongodb" ;;
      5) DB_TYPE="sqlite"; DB_PROVIDER="sqlite" ;;
      6) DB_TYPE="firestore"; DB_PROVIDER="firebase" ;;
      7) DB_TYPE="redis"; DB_PROVIDER="redis" ;;
      8) ask "Qual banco?" "" "DB_TYPE"; DB_PROVIDER="$DB_TYPE" ;;
      9) DB_TYPE=""; DB_PROVIDER="" ;;
    esac
    if [ -n "$DB_TYPE" ]; then
      print_ok "Banco: $DB_TYPE ($DB_PROVIDER)"
    fi
  else
    print_skip "Sem banco de dados"
  fi
fi

# ============================================================================
# STEP 4: AMBIENTES
# ============================================================================

print_step 4 $TOTAL_STEPS "AMBIENTES — Onde roda"

ask "URL/ambiente de producao (ou 'local')" "local" "ENV_PROD"
ask "URL/ambiente de desenvolvimento" "local" "ENV_DEV"

if ask_yn "Tem ambiente de staging/homologacao?" "n"; then
  ask "URL/ambiente de staging" "" "ENV_STAGING"
else
  ENV_STAGING=""
fi

# ============================================================================
# STEP 5: CREDENCIAIS
# ============================================================================

print_step 5 $TOTAL_STEPS "CREDENCIAIS — Segredos e acessos"

CRED_LINES=""
CRED_COUNT=0

if [ -f "$PROJECT_PATH/.env.example" ]; then
  print_auto "Detectado .env.example — importando variaveis"
  while IFS= read -r line; do
    [[ "$line" =~ ^#.*$ ]] && continue
    [[ -z "$line" ]] && continue
    VAR_NAME=$(echo "$line" | cut -d'=' -f1)
    if [ -n "$VAR_NAME" ]; then
      CRED_COUNT=$((CRED_COUNT + 1))
      CRED_LINES="${CRED_LINES}| CRED-$(printf '%02d' $CRED_COUNT) | $VAR_NAME | $VAR_NAME | <!-- uso --> | API Key | Verificar .env |\n"
    fi
  done < "$PROJECT_PATH/.env.example"
  print_ok "$CRED_COUNT credenciais importadas"
elif [ -f "$PROJECT_PATH/.env.template" ]; then
  print_auto "Detectado .env.template — importando variaveis"
  while IFS= read -r line; do
    [[ "$line" =~ ^#.*$ ]] && continue
    [[ -z "$line" ]] && continue
    VAR_NAME=$(echo "$line" | cut -d'=' -f1)
    if [ -n "$VAR_NAME" ]; then
      CRED_COUNT=$((CRED_COUNT + 1))
      CRED_LINES="${CRED_LINES}| CRED-$(printf '%02d' $CRED_COUNT) | $VAR_NAME | $VAR_NAME | <!-- uso --> | API Key | Verificar .env |\n"
    fi
  done < "$PROJECT_PATH/.env.template"
  print_ok "$CRED_COUNT credenciais importadas"
else
  if [ "$AUTO_MODE" = "s" ]; then
    print_skip "Nenhum .env.example/.env.template encontrado (preencher depois)"
  else
    print_skip "Nenhum .env.example/.env.template encontrado"
    echo "  Adicionar credenciais manualmente (Enter vazio para parar):"
    while true; do
      ask "Nome da variavel (ex: DATABASE_URL)" "" "CRED_VAR"
      [ -z "$CRED_VAR" ] && break
      ask "Para que serve" "" "CRED_USE"
      CRED_COUNT=$((CRED_COUNT + 1))
      CRED_LINES="${CRED_LINES}| CRED-$(printf '%02d' $CRED_COUNT) | $CRED_VAR | $CRED_VAR | $CRED_USE | API Key | A configurar |\n"
      print_ok "CRED-$(printf '%02d' $CRED_COUNT): $CRED_VAR"
    done
  fi
fi

# ============================================================================
# STEP 6: GUARDRAILS
# ============================================================================

print_step 6 $TOTAL_STEPS "GUARDRAILS — Protecoes do Projeto"

if ask_yn "Usar senha para acoes criticas?" "s"; then
  ask "Senha para acoes criticas" "CONFIRMAR_ACAO_CRITICA" "GUARDRAIL_PASSWORD"
  GUARDRAIL_SECTION="Senha para acoes criticas: $GUARDRAIL_PASSWORD"
else
  GUARDRAIL_SECTION="Sem senha configurada. Cuidado com acoes destrutivas."
  GUARDRAIL_PASSWORD=""
fi

# ============================================================================
# STEP 7: FERRAMENTAS (intermediario + completo)
# ============================================================================

TOOLS_PLAYWRIGHT="n"
TOOLS_MCP="n"
TOOLS_API="n"

if [ "$INSTALL_MODE" != "rapido" ]; then
  print_step 7 $TOTAL_STEPS "FERRAMENTAS — Tools e Integracoes"

  if ask_yn "Usar Playwright (browser, scraping, screenshots)?" "s"; then
    TOOLS_PLAYWRIGHT="s"
    print_ok "Playwright configurado"
  fi

  if ask_yn "Configurar MCP servers (Claude tools)?" "s"; then
    TOOLS_MCP="s"
    print_ok "MCP config incluido"
  fi

  if ask_yn "Documentar APIs externas?" "s"; then
    TOOLS_API="s"
    print_ok "API docs incluido"
  fi
fi

# ============================================================================
# STEP 8: DESIGN SYSTEM (intermediario + completo, se webapp)
# ============================================================================

DESIGN_SYSTEM=""
DESIGN_COMPONENTS=""

if [ "$INSTALL_MODE" != "rapido" ] && [ "$PROJECT_TYPE" = "webapp" ]; then
  print_step 8 $TOTAL_STEPS "DESIGN SYSTEM — UI/UX"

  if [ "$AUTO_MODE" = "s" ] && [ -n "$CFG_DESIGN_SYSTEM" ]; then
    DESIGN_SYSTEM="$CFG_DESIGN_SYSTEM"
    DESIGN_COMPONENTS="${CFG_DESIGN_COMPONENTS:-}"
    print_auto "Design System: $DESIGN_SYSTEM ${DESIGN_COMPONENTS:+($DESIGN_COMPONENTS)}"
  else
    DS_CHOICE=$(ask_choice "Framework CSS" "Tailwind CSS" "Bootstrap" "Material UI" "Chakra UI" "Styled Components" "CSS Modules" "Nenhum/Outro")
    case "$DS_CHOICE" in
      1) DESIGN_SYSTEM="Tailwind CSS" ;; 2) DESIGN_SYSTEM="Bootstrap" ;;
      3) DESIGN_SYSTEM="Material UI" ;; 4) DESIGN_SYSTEM="Chakra UI" ;;
      5) DESIGN_SYSTEM="Styled Components" ;; 6) DESIGN_SYSTEM="CSS Modules" ;;
      7) ask "Qual framework?" "" "DESIGN_SYSTEM" ;;
    esac

    if [ -n "$DESIGN_SYSTEM" ]; then
      print_ok "CSS: $DESIGN_SYSTEM"
      COMP_CHOICE=$(ask_choice "Biblioteca de componentes" "shadcn/ui" "Radix UI" "Headless UI" "Ant Design" "Nenhum/Outro")
      case "$COMP_CHOICE" in
        1) DESIGN_COMPONENTS="shadcn/ui" ;; 2) DESIGN_COMPONENTS="Radix UI" ;;
        3) DESIGN_COMPONENTS="Headless UI" ;; 4) DESIGN_COMPONENTS="Ant Design" ;;
        5) ask "Qual biblioteca?" "" "DESIGN_COMPONENTS" ;;
      esac
      [ -n "$DESIGN_COMPONENTS" ] && print_ok "Componentes: $DESIGN_COMPONENTS"
    fi
  fi
fi

# ============================================================================
# STEP 9: GLOSSARIO + INVARIANTES (completo apenas)
# ============================================================================

GLOSSARY_LINES=""
GLOSSARY_COUNT=0
INVARIANT_LINES=""
INVARIANT_COUNT=0

if [ "$INSTALL_MODE" = "completo" ]; then
  print_step 9 $TOTAL_STEPS "GLOSSARIO + INVARIANTES"

  if [ "$AUTO_MODE" = "s" ]; then
    print_auto "Glossario e invariantes vazios (preencher depois com Claude)"
  else
    echo ""
    echo -e "  ${CYAN}Glossario = elimina ambiguidade. Invariantes = leis inviolaveis.${NC}"
    echo ""

    echo "  Termos do dominio (Enter vazio para parar):"
    while true; do
      ask "Termo (ex: Fatura)" "" "GLOSS_TERM"
      [ -z "$GLOSS_TERM" ] && break
      ask "Significado exato" "" "GLOSS_DEF"
      ask "NAO confundir com" "" "GLOSS_NOT"
      GLOSSARY_COUNT=$((GLOSSARY_COUNT + 1))
      GLOSSARY_LINES="${GLOSSARY_LINES}| $GLOSS_TERM | $GLOSS_DEF | $GLOSS_NOT |\n"
      print_ok "$GLOSS_TERM definido"
    done

    echo ""
    echo "  Invariantes — regras que NUNCA podem ser violadas (Enter vazio para parar):"
    while true; do
      ask "Invariante (ex: Saldo nunca negativo)" "" "INV_TEXT"
      [ -z "$INV_TEXT" ] && break
      ask "Modulo afetado" "" "INV_MODULE"
      INVARIANT_COUNT=$((INVARIANT_COUNT + 1))
      INVARIANT_LINES="${INVARIANT_LINES}| INV-$(printf '%02d' $INVARIANT_COUNT) | $INV_TEXT | $INV_MODULE |\n"
      print_ok "INV-$(printf '%02d' $INVARIANT_COUNT): $INV_TEXT"
    done
  fi
fi

# ============================================================================
# STEP 10: POPs DE PROJETO
# ============================================================================

STEP_POPS=$((TOTAL_STEPS - 3))
[ "$INSTALL_MODE" = "rapido" ] && STEP_POPS=7

print_step $STEP_POPS $TOTAL_STEPS "POPs DE PROJETO"

echo "  POPs universais incluidos:"
echo -e "  ${GREEN}[OK]${NC} POP-000: Diagnostico (com tasks + planos + tools)"
echo -e "  ${GREEN}[OK]${NC} POP-001: Save (com historico + decisoes + tasks)"
echo -e "  ${GREEN}[OK]${NC} POP-002: Checkpoint mid-session"
echo -e "  ${GREEN}[OK]${NC} POP-003: Autocorrecao de erros"
echo -e "  ${GREEN}[OK]${NC} POP-INIT: Bootstrap (uso unico)"
echo ""

POP_COUNT=0
POP_PROJECT_LIST=""

[ -n "$HAS_DB" ] || [ -n "$DB_TYPE" ] && ask_yn "  Criar POP de auditoria de banco?" "s" && { POP_COUNT=$((POP_COUNT + 1)); POP_PROJECT_LIST="${POP_PROJECT_LIST}db "; print_ok "POP-P0$POP_COUNT: Auditoria de Banco"; }
[ -n "$HAS_TESTS" ] && ask_yn "  Criar POP de execucao de testes?" "s" && { POP_COUNT=$((POP_COUNT + 1)); POP_PROJECT_LIST="${POP_PROJECT_LIST}test "; print_ok "POP-P0$POP_COUNT: Executar Testes"; }
([ -n "$HAS_CI" ] || [ "$ENV_PROD" != "local" ]) && ask_yn "  Criar POP de deploy/monitoramento?" "s" && { POP_COUNT=$((POP_COUNT + 1)); POP_PROJECT_LIST="${POP_PROJECT_LIST}deploy "; print_ok "POP-P0$POP_COUNT: Monitoramento Pos-Deploy"; }
ask_yn "  Criar POP de backup pre-modificacao?" "s" && { POP_COUNT=$((POP_COUNT + 1)); POP_PROJECT_LIST="${POP_PROJECT_LIST}backup "; print_ok "POP-P0$POP_COUNT: Backup Pre-Modificacao"; }

# ============================================================================
# INSTALACAO
# ============================================================================

STEP_INSTALL=$((TOTAL_STEPS - 2))
print_step $STEP_INSTALL $TOTAL_STEPS "INSTALACAO — Criando estrutura"

# --- 1. .context/ (do template) ---
cp -r "$TEMPLATE_DIR" "$CONTEXT_DIR"
# Remover commands/ de dentro de .context/ (ficam em .claude/commands/)
rm -rf "$CONTEXT_DIR/commands" 2>/dev/null
print_ok ".context/ criado (kernel GENOMA v4)"

# Renomear templates
for TMPL in "$CONTEXT_DIR"/*.template.md; do
  [ -f "$TMPL" ] && mv "$TMPL" "${TMPL%.template.md}.md"
done

# Substituir placeholders basicos
find "$CONTEXT_DIR" -name "*.md" -exec sed -i \
  -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
  -e "s/{{DATE}}/$DATE/g" \
  {} +
print_ok "Placeholders substituidos"

# Personalizar MANIFEST
MANIFEST="$CONTEXT_DIR/MANIFEST.md"
if [ -f "$MANIFEST" ]; then
  safe_replace "<!-- O que este projeto faz -->" "$PROJECT_DESC" "$MANIFEST"
  safe_replace "<!-- Linguagens, frameworks, servicos -->" "$DETECTED_STACK" "$MANIFEST"

  ENV_LINE="Producao: $ENV_PROD | Dev: $ENV_DEV"
  [ -n "$ENV_STAGING" ] && ENV_LINE="$ENV_LINE | Staging: $ENV_STAGING"
  safe_replace "<!-- dev, staging, producao -->" "$ENV_LINE" "$MANIFEST"

  if [ -n "$DB_TYPE" ]; then
    safe_replace "<!-- Tipo, provider, projeto -->" "$DB_TYPE ($DB_PROVIDER)" "$MANIFEST"
  fi

  if [ -n "$DESIGN_SYSTEM" ]; then
    safe_replace "<!-- Tailwind, Bootstrap, Material, etc -->" "$DESIGN_SYSTEM" "$MANIFEST"
    [ -n "$DESIGN_COMPONENTS" ] && safe_replace "<!-- shadcn/ui, Radix, Chakra, etc -->" "$DESIGN_COMPONENTS" "$MANIFEST"
  fi

  print_ok "MANIFEST.md personalizado"
fi

# --- 2. Rotas especificas por tipo ---
ROUTES="$CONTEXT_DIR/ROUTES.md"
PROJECT_ROUTES=""

case "$PROJECT_TYPE" in
  webapp)
    PROJECT_ROUTES='### "Adicionar nova pagina/componente"
**Tempo:** ~10 min | **Tokens:** ~8k

1. MANIFEST.md -> architecture + file map
2. Identificar padrao de componentes existente
3. Criar componente seguindo padrao do design system
4. Adicionar rota se necessario
5. Testar responsividade
6. Criar task se necessario

### "Corrigir bug de layout/UI"
**Tempo:** ~5 min | **Tokens:** ~5k

1. SNAPSHOT.md -> estado atual
2. Identificar componente afetado
3. Inspecionar CSS/estilos (design system tokens)
4. Corrigir e testar responsividade'
    ;;
  api)
    PROJECT_ROUTES='### "Adicionar novo endpoint"
**Tempo:** ~10 min | **Tokens:** ~8k

1. MANIFEST.md -> architecture + constraints
2. DECISIONS.md -> padroes de API
3. specs/openapi.yaml -> contrato existente
4. Definir rota, metodo, payload, response
5. Implementar + validacao de entrada
6. Testar com curl/Postman

### "Debug de request falhando"
**Tempo:** ~5 min | **Tokens:** ~5k

1. SNAPSHOT.md -> estado atual
2. Verificar logs de erro
3. Testar endpoint isoladamente
4. Checar middleware/auth'
    ;;
  automation)
    PROJECT_ROUTES='### "Criar novo workflow"
**Tempo:** ~20 min | **Tokens:** ~10k

1. MANIFEST.md -> instancia + constraints
2. tools/ -> MCP e credenciais disponiveis
3. Plano no a no + aprovacao
4. Construir + validar + deploy inativo

### "Corrigir workflow com erro"
**Tempo:** ~5 min | **Tokens:** ~5k

1. SNAPSHOT.md -> status dos workflows
2. Verificar executions com erro
3. Identificar no com falha
4. Corrigir e testar'
    ;;
  cli)
    PROJECT_ROUTES='### "Adicionar novo comando"
**Tempo:** ~10 min | **Tokens:** ~8k

1. MANIFEST.md -> architecture
2. Identificar padrao de comandos existente
3. Implementar comando + help text
4. Adicionar testes

### "Corrigir flag/argumento"
**Tempo:** ~3 min | **Tokens:** ~3k

1. Identificar comando afetado
2. Verificar parsing de argumentos
3. Corrigir + testar'
    ;;
esac

if [ -n "$PROJECT_ROUTES" ] && [ -f "$ROUTES" ]; then
  # Inserir rotas substituindo o bloco de comentarios por conteudo real
  ROUTES_TMP="${ROUTES}.tmp"
  awk -v routes="$PROJECT_ROUTES" '
    /<!-- Adicionar rotas especificas/ { print routes; next }
    /<!-- Formato:/ { next }
    /<!-- ### / { next }
    /<!-- \*\*Tempo/ { next }
    /<!-- 1\. Passo/ { next }
    /<!-- 2\. Passo/ { next }
    { print }
  ' "$ROUTES" > "$ROUTES_TMP" && mv "$ROUTES_TMP" "$ROUTES"
  print_ok "ROUTES.md com rotas para $PROJECT_TYPE"
fi

# --- 3. Criar POPs de projeto ---
POP_NUM=0
for pop_type in $POP_PROJECT_LIST; do
  POP_NUM=$((POP_NUM + 1))
  case "$pop_type" in
    db)
      cat > "$CONTEXT_DIR/pops/POP-P0${POP_NUM}.md" << POPEOF
# POP-P0${POP_NUM}: Auditoria de Banco de Dados

- **Trigger:** Ultimo audit > 7 dias OU erro de dados
- **Autonomia:** Nivel 1 (propor com tudo preparado)
- **Requer:** Credenciais de banco via .env
- **Risco:** Baixo (somente leitura)

## Procedimento

1. Verificar credenciais no .env
2. Conectar ao banco ($DB_TYPE via $DB_PROVIDER)
3. Verificar integridade das tabelas principais
4. Comparar com ultimo audit (deep/audit-NNN.md)
5. Gerar relatorio em deep/audit-NNN.md
6. Criar task se encontrar problema
7. Atualizar SNAPSHOT com resultado

## Commit

\`audit(db): POP-P0${POP_NUM} audit - [resultado]\`
POPEOF
      print_ok "pops/POP-P0${POP_NUM}.md (Auditoria DB)"
      ;;
    test)
      cat > "$CONTEXT_DIR/pops/POP-P0${POP_NUM}.md" << POPEOF
# POP-P0${POP_NUM}: Executar Testes

- **Trigger:** Antes de commit significativo ou deploy
- **Autonomia:** Nivel 2 (auto-executar)
- **Requer:** Suite de testes configurada

## Procedimento

1. Executar suite de testes completa
2. Se falhar: identificar causa, criar task se necessario
3. Se passar: registrar no SNAPSHOT
4. Atualizar historico da sessao

## Commit

\`test(scope): POP-P0${POP_NUM} - all tests passing\`
POPEOF
      print_ok "pops/POP-P0${POP_NUM}.md (Testes)"
      ;;
    deploy)
      cat > "$CONTEXT_DIR/pops/POP-P0${POP_NUM}.md" << POPEOF
# POP-P0${POP_NUM}: Monitoramento Pos-Deploy

- **Trigger:** 24h e 48h apos deploy
- **Autonomia:** Nivel 1 (propor ao usuario)
- **Requer:** Acesso ao ambiente de producao

## Procedimento

1. Verificar logs de erro no ambiente
2. Conferir metricas (uptime, tempo de resposta)
3. Comparar com baseline pre-deploy
4. Se problema: criar task urgente
5. Atualizar SNAPSHOT com resultado

## Commit

\`audit(deploy): POP-P0${POP_NUM} post-deploy check - [resultado]\`
POPEOF
      print_ok "pops/POP-P0${POP_NUM}.md (Deploy)"
      ;;
    backup)
      cat > "$CONTEXT_DIR/pops/POP-P0${POP_NUM}.md" << POPEOF
# POP-P0${POP_NUM}: Backup Pre-Modificacao

- **Trigger:** Antes de qualquer modificacao significativa
- **Autonomia:** Nivel 2 (auto-executar)
- **Requer:** Nada (operacao local)

## Procedimento

1. Identificar arquivos que serao modificados
2. Criar save point: \`git commit -m "snapshot(safety): save point before [acao]"\`
3. Registrar hash do save point no SNAPSHOT
4. Prosseguir com modificacao

## Rollback

\`git revert \$SAVE_HASH\`
POPEOF
      print_ok "pops/POP-P0${POP_NUM}.md (Backup)"
      ;;
  esac
done

# --- 4. specs/ (intermediario + completo) ---
if [ "$INSTALL_MODE" != "rapido" ]; then
  mkdir -p "$SPECS_DIR" "$SPECS_DIR/schemas" "$SPECS_DIR/state-machines" "$SPECS_DIR/data-flows" "$SPECS_DIR/side-effects"

  # Glossario
  cat > "$SPECS_DIR/glossary.md" << GEOF
# Glossario — $PROJECT_NAME

> Termos do dominio com significado exato. Elimina ambiguidade.

| Termo | Significado Exato | NAO confundir com |
|-------|--------------------|--------------------|
$(echo -e "$GLOSSARY_LINES")

<!-- Adicionar termos conforme o projeto evolui -->
GEOF
  print_ok "specs/glossary.md ($GLOSSARY_COUNT termos)"

  # Invariantes
  cat > "$SPECS_DIR/invariants.md" << IEOF
# Invariantes — $PROJECT_NAME

> Regras que NUNCA podem ser violadas.

| ID | Invariante | Modulo |
|----|------------|--------|
$(echo -e "$INVARIANT_LINES")

<!-- Adicionar invariantes conforme o dominio exige -->
IEOF
  print_ok "specs/invariants.md ($INVARIANT_COUNT regras)"

  if [ "$INSTALL_MODE" = "completo" ]; then
    # Error Taxonomy
    cat > "$SPECS_DIR/error-taxonomy.md" << EEOF
# Error Taxonomy — $PROJECT_NAME

| Tipo | HTTP | Retentavel | Estrategia | Exemplo |
|------|------|------------|------------|---------|
| Validacao | 400 | Nao | Retornar campos invalidos | Input mal formatado |
| Autenticacao | 401 | Nao | Redirecionar para login | Token expirado |
| Autorizacao | 403 | Nao | Log + notificar | Sem permissao |
| Nao encontrado | 404 | Nao | Mensagem amigavel | Recurso inexistente |
| Negocio | 422 | Nao | Mensagem explicativa | Regra violada |
| Rate limit | 429 | Sim | Backoff exponencial | Muitas requests |
| Infraestrutura | 503 | Sim | Retry 3x com backoff | Servico fora |
EEOF
    print_ok "specs/error-taxonomy.md"

    # Security, Observability, Performance
    cat > "$SPECS_DIR/security-model.md" << SEOF
# Security Model — $PROJECT_NAME

## Dados Sensiveis
| Dado | Classificacao | Tratamento |
|------|--------------|------------|
| Email | PII | Criptografar at rest |
| Senha | Segredo | Hash bcrypt, nunca em log |
| Token | Segredo | Nunca em log |

## Trust Boundaries
| Fronteira | Confianca | Acao |
|-----------|----------|------|
| Input usuario | Nao | Validar tudo |
| API externa | Nao | Validar response |
| Services internos | Semi | Validar tipos |
| Banco | Sim | Constraints validam |
SEOF

    cat > "$SPECS_DIR/observability.md" << OEOF
# Observability — $PROJECT_NAME

## Logs Obrigatorios
| Evento | Nivel | Dados |
|--------|-------|-------|
| Request recebido | INFO | method, path, ip |
| Request completado | INFO | method, path, status, duration_ms |
| Erro de negocio | WARN | code, message, context |
| Erro de infra | ERROR | stack trace, context |

## NUNCA logar
- Senhas, tokens completos, dados de cartao, PII sem mascarar
OEOF

    cat > "$SPECS_DIR/performance.md" << PEOF
# Performance Baselines — $PROJECT_NAME

| Metrica | Target | Limite | Acao se exceder |
|---------|--------|--------|-----------------|
| API response (p95) | < 200ms | < 500ms | Otimizar query |
| Query DB | < 50ms | < 200ms | Adicionar indice |
| Build time | < 30s | < 60s | Revisar deps |
PEOF

    cat > "$SPECS_DIR/openapi.yaml" << AEOF
openapi: '3.0.3'
info:
  title: $PROJECT_NAME API
  version: '1.0.0'
  description: $PROJECT_DESC
paths: {}
components:
  schemas: {}
AEOF

    for DIR in state-machines data-flows side-effects schemas; do
      cat > "$SPECS_DIR/$DIR/README.md" << REOF
# ${DIR} — $PROJECT_NAME

Criar arquivos neste diretorio conforme o projeto evolui.
REOF
    done

    print_ok "specs/ completo (error-taxonomy, security, observability, performance, openapi)"
  fi
fi

# --- 5. docs/ (completo) ---
if [ "$INSTALL_MODE" = "completo" ]; then
  mkdir -p "$DOCS_DIR/decisions" "$DOCS_DIR/post-mortems" "$DOCS_DIR/session-history"

  cat > "$DOCS_DIR/anti-patterns.md" << APEOF
# Anti-patterns — $PROJECT_NAME

> O que NUNCA fazer neste projeto.

## Formato
\`\`\`markdown
### AP-XX: Nome
- **O que e:** Descricao
- **Por que e ruim:** Consequencia
- **Fazer em vez disso:** Alternativa
\`\`\`
APEOF

  for DIR in decisions post-mortems session-history; do
    cat > "$DOCS_DIR/$DIR/README.md" << REOF
# ${DIR} — $PROJECT_NAME

Criar arquivos neste diretorio conforme o projeto evolui.
Ver .context/ para templates e formatos.
REOF
  done

  print_ok "docs/ criado (decisions, post-mortems, anti-patterns)"
fi

# --- 6. .claude/commands/ ---
mkdir -p "$CLAUDE_DIR/commands"
if [ -d "$TEMPLATE_DIR/commands" ]; then
  cp "$TEMPLATE_DIR/commands/"*.md "$CLAUDE_DIR/commands/" 2>/dev/null || true
  print_ok ".claude/commands/ copiados (pop-000..003, marcha, plan, tasks)"
fi

# --- 7. CLAUDE.md ---
if [ "$INSTALL_MODE" != "rapido" ] && [ -f "$SCRIPT_DIR/CLAUDE.template.md" ]; then
  cp "$SCRIPT_DIR/CLAUDE.template.md" "$PROJECT_PATH/CLAUDE.md"
  CLAUDE_FILE="$PROJECT_PATH/CLAUDE.md"

  safe_replace "{{PROJECT_NAME}}" "$PROJECT_NAME" "$CLAUDE_FILE"
  safe_replace "{{PROJECT_DESC}}" "$PROJECT_DESC" "$CLAUDE_FILE"
  safe_replace "{{DETECTED_STACK}}" "$DETECTED_STACK" "$CLAUDE_FILE"
  safe_replace "{{PROJECT_TYPE}}" "$PROJECT_TYPE" "$CLAUDE_FILE"
  safe_replace "{{PROJECT_VISION}}" "${PROJECT_VISION:-<!-- preencher visao -->}" "$CLAUDE_FILE"
  safe_replace "{{ENV_DEV}}" "$ENV_DEV" "$CLAUDE_FILE"
  safe_replace "{{ENV_STAGING}}" "${ENV_STAGING:-N/A}" "$CLAUDE_FILE"
  safe_replace "{{ENV_PROD}}" "$ENV_PROD" "$CLAUDE_FILE"
  safe_replace "{{LANG}}" "${DETECTED_LANG:-typescript}" "$CLAUDE_FILE"
  safe_replace "{{DATE}}" "$DATE" "$CLAUDE_FILE"
  safe_replace "{{GUARDRAIL_SECTION}}" "$GUARDRAIL_SECTION" "$CLAUDE_FILE"
  safe_replace "{{DB_TYPE}}" "${DB_TYPE:-N/A}" "$CLAUDE_FILE"
  safe_replace "{{DB_PROVIDER}}" "${DB_PROVIDER:-N/A}" "$CLAUDE_FILE"
  safe_replace "{{DESIGN_SYSTEM}}" "${DESIGN_SYSTEM:-N/A}" "$CLAUDE_FILE"
  safe_replace "{{DESIGN_COMPONENTS}}" "${DESIGN_COMPONENTS:-N/A}" "$CLAUDE_FILE"

  print_ok "CLAUDE.md v4 gerado (17 blocos)"
fi

# --- 8. Git hooks ---
if [ -d "$PROJECT_PATH/.git" ]; then
  if [ -d "$CONTEXT_DIR/hooks" ]; then
    for HOOK in commit-msg post-commit pre-push; do
      cp "$CONTEXT_DIR/hooks/${HOOK}.sh" "$PROJECT_PATH/.git/hooks/$HOOK" 2>/dev/null || true
      chmod +x "$PROJECT_PATH/.git/hooks/$HOOK" 2>/dev/null || true
    done
    print_ok "Git hooks instalados"
  fi
elif ask_yn "Nao e um repo git. Inicializar?" "s"; then
  git init "$PROJECT_PATH"
  if [ -d "$CONTEXT_DIR/hooks" ]; then
    for HOOK in commit-msg post-commit pre-push; do
      cp "$CONTEXT_DIR/hooks/${HOOK}.sh" "$PROJECT_PATH/.git/hooks/$HOOK" 2>/dev/null || true
      chmod +x "$PROJECT_PATH/.git/hooks/$HOOK" 2>/dev/null || true
    done
  fi
  print_ok "Git inicializado + hooks instalados"
fi

# --- 9. .gitignore ---
if [ -f "$PROJECT_PATH/.gitignore" ]; then
  grep -q "^\.env$" "$PROJECT_PATH/.gitignore" 2>/dev/null || echo ".env" >> "$PROJECT_PATH/.gitignore"
else
  cat > "$PROJECT_PATH/.gitignore" << 'GIEOF'
.env
.env.local
node_modules/
__pycache__/
.claude/*
!.claude/commands/
GIEOF
  print_ok ".gitignore criado"
fi

# --- 10. Commit inicial ---
if [ -d "$PROJECT_PATH/.git" ]; then
  echo ""
  if ask_yn "Criar commit inicial do GENOMA v4?" "s"; then
    cd "$PROJECT_PATH"
    git add .context/ .claude/commands/ .gitignore 2>/dev/null
    [ -d "$SPECS_DIR" ] && git add specs/ 2>/dev/null
    [ -d "$DOCS_DIR" ] && git add docs/ 2>/dev/null
    [ -f "$PROJECT_PATH/CLAUDE.md" ] && git add CLAUDE.md 2>/dev/null
    git commit -m "context(genoma): initialize PGP GENOMA v4.0 ($INSTALL_MODE) for $PROJECT_NAME

Modo: $INSTALL_MODE
Stack: $DETECTED_STACK
Tipo: $PROJECT_TYPE
$([ -n "$DB_TYPE" ] && echo "Banco: $DB_TYPE ($DB_PROVIDER)")
$([ -n "$DESIGN_SYSTEM" ] && echo "Design: $DESIGN_SYSTEM + $DESIGN_COMPONENTS")" 2>/dev/null || true
    print_ok "Commit inicial criado"
  fi
fi

# ============================================================================
# RESUMO FINAL
# ============================================================================

echo ""
echo -e "${CYAN}   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BOLD}${GREEN}     GENOMA v4.0 — INSTALADOR DEFINITIVO ATIVO!${NC}"
echo ""
echo -e "     ${CYAN}Modo: ${BOLD}$INSTALL_MODE${NC}"
echo ""
echo -e "${CYAN}   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BOLD}Projeto:${NC}  $PROJECT_NAME"
echo -e "${BOLD}Stack:${NC}    $DETECTED_STACK"
echo -e "${BOLD}Tipo:${NC}     $PROJECT_TYPE"
echo -e "${BOLD}Idioma:${NC}   $PROJECT_LANG"
[ -n "$DB_TYPE" ] && echo -e "${BOLD}Banco:${NC}    $DB_TYPE ($DB_PROVIDER)"
[ -n "$DESIGN_SYSTEM" ] && echo -e "${BOLD}Design:${NC}   $DESIGN_SYSTEM + ${DESIGN_COMPONENTS:-nenhum}"
echo ""

echo -e "${BOLD}Estrutura instalada:${NC}"
echo ""
echo -e "  ${GREEN}[OK]${NC} ${BOLD}.context/${NC} — Kernel GENOMA v4"
echo -e "       MANIFEST, SNAPSHOT, ROUTES, DECISIONS, GRAPH, POPs, hooks"

if [ "$INSTALL_MODE" != "rapido" ]; then
  echo -e "       ${CYAN}+ history/${NC} (sessoes com data+hora)"
  echo -e "       ${CYAN}+ tasks/${NC} (grupos com data+hora)"
  echo -e "       ${CYAN}+ plans/${NC} (planos de implementacao)"
  echo -e "       ${CYAN}+ tools/${NC} (Playwright, MCP, APIs)"
fi

if [ "$INSTALL_MODE" != "rapido" ]; then
  echo ""
  echo -e "  ${GREEN}[OK]${NC} ${BOLD}specs/${NC} — Contratos"
  echo -e "       glossary ($GLOSSARY_COUNT), invariants ($INVARIANT_COUNT)"
  [ "$INSTALL_MODE" = "completo" ] && echo -e "       + error-taxonomy, security, observability, performance, openapi"
fi

[ "$INSTALL_MODE" = "completo" ] && echo "" && echo -e "  ${GREEN}[OK]${NC} ${BOLD}docs/${NC} — decisions/, post-mortems/, anti-patterns"

echo ""
echo -e "  ${GREEN}[OK]${NC} ${BOLD}.claude/commands/${NC} — /pop-000..003, /marcha, /plan, /tasks"

[ "$INSTALL_MODE" != "rapido" ] && echo "" && echo -e "  ${GREEN}[OK]${NC} ${BOLD}CLAUDE.md${NC} — Framework 17 Blocos"

[ $POP_COUNT -gt 0 ] && echo "" && echo -e "  ${GREEN}[OK]${NC} $POP_COUNT POPs de projeto criados"
[ -n "$GUARDRAIL_PASSWORD" ] && echo -e "  ${GREEN}[OK]${NC} Guardrails com senha ativa"
echo ""

echo -e "${BOLD}Proximos passos:${NC}"
echo ""
echo -e "  1. ${CYAN}Revisar CLAUDE.md${NC} — preencher campos <!-- preencher -->"
echo -e "  2. ${CYAN}Preencher specs/${NC} — glossario, invariantes"
echo -e "  3. ${CYAN}Configurar tools/${NC} — MCP, APIs, Playwright"
echo -e "  4. Ou pedir ao Claude: ${CYAN}\"Executar POP-INIT\"${NC}"
echo ""
echo -e "${DIM}POP-000 executa automaticamente no inicio de cada sessao.${NC}"
echo -e "${DIM}POP-001 salva historico + tasks + decisoes automaticamente.${NC}"
echo ""

# --- Arvore final ---
echo -e "${BOLD}Arvore completa (modo $INSTALL_MODE):${NC}"
echo ""
echo -e "${CYAN}"

if [ "$INSTALL_MODE" = "rapido" ]; then
cat << 'TREE'
  projeto/
  ├── .context/
  │   ├── MANIFEST.md              # DNA do projeto
  │   ├── SNAPSHOT.md              # Estado atual
  │   ├── DECISIONS.md             # Decisoes com triggers
  │   ├── ROUTES.md                # GPS de navegacao
  │   ├── GRAPH.md                 # Diagramas
  │   ├── pops/                    # POPs universais + projeto
  │   ├── hooks/                   # Git hooks
  │   ├── deep/                    # Investigacoes
  │   └── templates/               # Templates
  └── .claude/commands/            # Slash commands
TREE
elif [ "$INSTALL_MODE" = "intermediario" ]; then
cat << 'TREE'
  projeto/
  ├── CLAUDE.md                    # Framework 17 blocos
  ├── .context/
  │   ├── MANIFEST.md              # DNA do projeto
  │   ├── SNAPSHOT.md              # Estado atual
  │   ├── DECISIONS.md             # Decisoes com triggers
  │   ├── ROUTES.md                # GPS de navegacao
  │   ├── GRAPH.md                 # Diagramas
  │   ├── history/                 # Sessoes (data+hora)
  │   ├── tasks/                   # Tasks (data+hora)
  │   ├── plans/                   # Planos
  │   ├── tools/                   # Ferramentas + APIs
  │   ├── pops/                    # POPs
  │   ├── hooks/                   # Git hooks
  │   ├── deep/                    # Investigacoes
  │   └── templates/               # Templates
  ├── specs/
  │   ├── glossary.md              # Linguagem ubiqua
  │   └── invariants.md            # Leis inviolaveis
  └── .claude/commands/            # Slash commands
TREE
else
cat << 'TREE'
  projeto/
  ├── CLAUDE.md                    # Framework 17 blocos
  ├── .context/
  │   ├── MANIFEST.md              # DNA do projeto
  │   ├── SNAPSHOT.md              # Estado atual
  │   ├── DECISIONS.md             # Decisoes com triggers
  │   ├── ROUTES.md                # GPS + rotas por tipo
  │   ├── GRAPH.md                 # Diagramas + fluxo GENOMA
  │   ├── history/                 # Sessoes (data+hora real)
  │   ├── tasks/                   # Tasks (data+hora real)
  │   ├── plans/                   # Planos de implementacao
  │   ├── tools/                   # Ferramentas, MCP, APIs
  │   │   ├── playwright.md        # Browser/scraping
  │   │   ├── mcp-config.md        # MCP servers
  │   │   └── api-docs.md          # APIs externas
  │   ├── pops/                    # POPs universais + projeto
  │   ├── hooks/                   # Git hooks
  │   ├── deep/                    # Investigacoes
  │   └── templates/               # Templates
  ├── specs/
  │   ├── glossary.md              # Linguagem ubiqua
  │   ├── invariants.md            # Leis inviolaveis
  │   ├── error-taxonomy.md        # Catalogo de erros
  │   ├── security-model.md        # Trust boundaries
  │   ├── observability.md         # Logs e metricas
  │   ├── performance.md           # Baselines
  │   ├── openapi.yaml             # Contrato API
  │   ├── state-machines/          # Estados
  │   ├── data-flows/              # Fluxos
  │   └── side-effects/            # Efeitos colaterais
  ├── docs/
  │   ├── decisions/               # ADRs
  │   ├── post-mortems/            # Bugs resolvidos
  │   └── anti-patterns.md         # O que nunca fazer
  └── .claude/commands/            # Slash commands
      ├── pop-000..003.md          # POPs
      ├── marcha.md                # Modo autonomo
      ├── plan.md                  # Gerenciar planos
      └── tasks.md                 # Gerenciar tasks
TREE
fi

echo -e "${NC}"
