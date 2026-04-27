#!/bin/bash
# ============================================================================
# genoma-init-v3.sh — Instalador Completo PGP GENOMA v3.0
# ============================================================================
#
# Evolucao do genoma-init.sh original com:
#   - Estrutura completa de specs/ (invariantes, state machines, side effects)
#   - Glossario de dominio (linguagem ubiqua)
#   - Error taxonomy, security model, observability
#   - Session history e post-mortems
#   - CLAUDE.md template v3 com 15 blocos de alta performance
#   - Anti-patterns e calibracao
#   - Performance baselines
#
# Uso:
#   ./genoma-init-v3.sh                        # Projeto no diretorio atual
#   ./genoma-init-v3.sh /caminho/do/projeto    # Projeto em outro diretorio
#
# ============================================================================

set -e

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
  echo -e "     ${BOLD}PGP — Protocolo GENOMA Perpetuo v3.0${NC}"
  echo -e "     ${MAGENTA}Framework de Alta Performance para Claude${NC}"
  echo ""
  echo -e "     ${CYAN}Projeto guarnecido. Contexto perpetuo. Performance maxima.${NC}"
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
  echo -ne "  ${YELLOW}>${NC} $prompt ${CYAN}[$default]${NC}: "
  read -r input
  input="${input:-$default}"
  [[ "$input" =~ ^[SsYy]$ ]]
}

ask_choice() {
  local prompt="$1"; shift
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
SPECS_DIR="$PROJECT_PATH/specs"
DOCS_DIR="$PROJECT_PATH/docs"
CLAUDE_DIR="$PROJECT_PATH/.claude"
DATE=$(date +%Y-%m-%d)
TOTAL_STEPS=9

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
echo "O GENOMA v3.0 instala a estrutura completa de alta performance:"
echo -e "  ${GREEN}*${NC} .context/    — Kernel GENOMA (MANIFEST, SNAPSHOT, POPs, hooks)"
echo -e "  ${GREEN}*${NC} specs/       — Contratos, invariantes, state machines, glossario"
echo -e "  ${GREEN}*${NC} docs/        — Decisoes, post-mortems, anti-patterns, sessoes"
echo -e "  ${GREEN}*${NC} .claude/     — Commands, settings"
echo -e "  ${GREEN}*${NC} CLAUDE.md    — Framework completo de 15 blocos"
echo ""
echo -e "Pressione ${CYAN}Enter${NC} para aceitar valores padrao entre [colchetes]."
echo ""
read -p "Iniciar? (Enter para continuar, Ctrl+C para cancelar) "

# ============================================================================
# STEP 1: IDENTITY
# ============================================================================

print_step 1 $TOTAL_STEPS "IDENTITY — Dados do Projeto"

FOLDER_NAME=$(basename "$PROJECT_PATH")
ask "Nome do projeto" "$FOLDER_NAME" "PROJECT_NAME"
print_ok "Projeto: $PROJECT_NAME"

ask "Descricao curta (o que faz)" "" "PROJECT_DESC"
print_ok "Descricao: $PROJECT_DESC"

ask "Visao do projeto (por que existe)" "" "PROJECT_VISION"

LANG_CHOICE=$(ask_choice "Idioma principal" "Portugues Brasileiro (pt-BR) [recomendado]" "English (en)" "Espanol (es)")
case "$LANG_CHOICE" in
  1) PROJECT_LANG="pt-BR" ;;
  2) PROJECT_LANG="en" ;;
  3) PROJECT_LANG="es" ;;
  *) PROJECT_LANG="pt-BR" ;;
esac
print_ok "Idioma: $PROJECT_LANG"

# ============================================================================
# STEP 2: STACK (identico ao v2 — auto-deteccao)
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

# --- Detectar linguagens e frameworks ---

if [ -f "$PROJECT_PATH/package.json" ]; then
  print_auto "Node.js detectado (package.json)"
  DETECTED_STACK_LIST+=("Node.js")
  DETECTED_LANG="typescript"

  if grep -q '"next"' "$PROJECT_PATH/package.json" 2>/dev/null; then
    print_auto "  Next.js detectado"; DETECTED_STACK_LIST+=("Next.js"); PROJECT_TYPE="webapp"
  fi
  if grep -q '"react"' "$PROJECT_PATH/package.json" 2>/dev/null; then
    print_auto "  React detectado"; DETECTED_STACK_LIST+=("React"); PROJECT_TYPE="${PROJECT_TYPE:-webapp}"
  fi
  if grep -q '"vue"' "$PROJECT_PATH/package.json" 2>/dev/null; then
    print_auto "  Vue.js detectado"; DETECTED_STACK_LIST+=("Vue.js"); PROJECT_TYPE="${PROJECT_TYPE:-webapp}"
  fi
  if grep -q '"express"' "$PROJECT_PATH/package.json" 2>/dev/null; then
    print_auto "  Express detectado"; DETECTED_STACK_LIST+=("Express"); PROJECT_TYPE="${PROJECT_TYPE:-api}"
  fi
  if grep -q '"typescript"' "$PROJECT_PATH/package.json" 2>/dev/null; then
    print_auto "  TypeScript detectado"; DETECTED_STACK_LIST+=("TypeScript")
  fi
  if grep -q '"jest"\|"vitest"\|"mocha"\|"cypress"\|"playwright"' "$PROJECT_PATH/package.json" 2>/dev/null; then
    print_auto "  Suite de testes detectada"; HAS_TESTS="sim"
  fi
fi

if [ -f "$PROJECT_PATH/requirements.txt" ] || [ -f "$PROJECT_PATH/pyproject.toml" ] || [ -f "$PROJECT_PATH/setup.py" ]; then
  print_auto "Python detectado"; DETECTED_STACK_LIST+=("Python"); DETECTED_LANG="python"
  if [ -f "$PROJECT_PATH/requirements.txt" ]; then
    grep -qi "django" "$PROJECT_PATH/requirements.txt" 2>/dev/null && { print_auto "  Django detectado"; DETECTED_STACK_LIST+=("Django"); PROJECT_TYPE="${PROJECT_TYPE:-webapp}"; }
    grep -qi "fastapi\|flask" "$PROJECT_PATH/requirements.txt" 2>/dev/null && { print_auto "  FastAPI/Flask detectado"; DETECTED_STACK_LIST+=("FastAPI"); PROJECT_TYPE="${PROJECT_TYPE:-api}"; }
    grep -qi "pytest" "$PROJECT_PATH/requirements.txt" 2>/dev/null && HAS_TESTS="sim"
  fi
fi

[ -f "$PROJECT_PATH/go.mod" ] && { print_auto "Go detectado"; DETECTED_STACK_LIST+=("Go"); DETECTED_LANG="go"; PROJECT_TYPE="${PROJECT_TYPE:-api}"; }
[ -f "$PROJECT_PATH/Cargo.toml" ] && { print_auto "Rust detectado"; DETECTED_STACK_LIST+=("Rust"); DETECTED_LANG="rust"; }
[ -f "$PROJECT_PATH/pom.xml" ] || [ -f "$PROJECT_PATH/build.gradle" ] && { print_auto "Java detectado"; DETECTED_STACK_LIST+=("Java"); DETECTED_LANG="java"; }

# n8n
if [ -f "$PROJECT_PATH/.mcp.json" ] || ls "$PROJECT_PATH"/workflows/*.json >/dev/null 2>&1; then
  print_auto "n8n detectado"; DETECTED_STACK_LIST+=("n8n"); PROJECT_TYPE="${PROJECT_TYPE:-automation}"
fi

# Docker
if [ -f "$PROJECT_PATH/Dockerfile" ] || [ -f "$PROJECT_PATH/docker-compose.yml" ] || [ -f "$PROJECT_PATH/docker-compose.yaml" ]; then
  print_auto "Docker detectado"; DETECTED_STACK_LIST+=("Docker"); HAS_DOCKER="sim"
fi

# CI/CD
[ -d "$PROJECT_PATH/.github/workflows" ] && { print_auto "GitHub Actions detectado"; HAS_CI="github-actions"; }
[ -f "$PROJECT_PATH/.gitlab-ci.yml" ] && { print_auto "GitLab CI detectado"; HAS_CI="gitlab-ci"; }
[ -f "$PROJECT_PATH/Jenkinsfile" ] && { print_auto "Jenkins detectado"; HAS_CI="jenkins"; }

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
# STEP 3: AMBIENTES
# ============================================================================

print_step 3 $TOTAL_STEPS "AMBIENTES — Onde roda"

ask "URL/ambiente de producao (ou 'local')" "local" "ENV_PROD"
ask "URL/ambiente de desenvolvimento" "local" "ENV_DEV"

if ask_yn "Tem ambiente de staging/homologacao?" "n"; then
  ask "URL/ambiente de staging" "" "ENV_STAGING"
else
  ENV_STAGING=""
fi

# ============================================================================
# STEP 4: CREDENCIAIS (identico ao v2)
# ============================================================================

print_step 4 $TOTAL_STEPS "CREDENCIAIS — Segredos e acessos"

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
      CRED_LINES="${CRED_LINES}| CRED-$(printf '%02d' $CRED_COUNT) | $VAR_NAME | $VAR_NAME | <!-- uso --> | Verificar .env |\n"
    fi
  done < "$PROJECT_PATH/.env.example"
  print_ok "$CRED_COUNT credenciais importadas"
else
  print_skip "Nenhum .env.example encontrado"
  echo "  Adicionar credenciais manualmente (Enter vazio para parar):"
  while true; do
    ask "Nome da variavel (ex: DATABASE_URL)" "" "CRED_VAR"
    [ -z "$CRED_VAR" ] && break
    ask "Para que serve" "" "CRED_USE"
    CRED_COUNT=$((CRED_COUNT + 1))
    CRED_LINES="${CRED_LINES}| CRED-$(printf '%02d' $CRED_COUNT) | $CRED_VAR | $CRED_VAR | $CRED_USE | A configurar |\n"
    print_ok "CRED-$(printf '%02d' $CRED_COUNT): $CRED_VAR"
  done
fi

# ============================================================================
# STEP 5: GUARDRAILS
# ============================================================================

print_step 5 $TOTAL_STEPS "GUARDRAILS — Protecoes do Projeto"

if ask_yn "Usar senha para acoes criticas?" "s"; then
  ask "Senha para acoes criticas" "CONFIRMAR_ACAO_CRITICA" "GUARDRAIL_PASSWORD"
  GUARDRAIL_SECTION="Senha para acoes criticas: $GUARDRAIL_PASSWORD

### Acoes que REQUEREM senha:
- Deletar recursos em producao
- Deploy em producao
- Sobrescrever dados existentes"
else
  GUARDRAIL_SECTION="Sem senha configurada. Cuidado com acoes destrutivas."
  GUARDRAIL_PASSWORD=""
fi

# ============================================================================
# STEP 6: GLOSSARIO (NOVO em v3)
# ============================================================================

print_step 6 $TOTAL_STEPS "GLOSSARIO — Linguagem Ubiqua do Dominio"

echo ""
echo -e "  ${CYAN}O glossario elimina ambiguidade de vocabulario.${NC}"
echo -e "  ${CYAN}Defina os termos mais importantes do seu dominio.${NC}"
echo ""

GLOSSARY_LINES=""
GLOSSARY_COUNT=0

echo "  Adicionar termos (Enter vazio para parar):"
while true; do
  ask "Termo do dominio (ex: Fatura)" "" "GLOSS_TERM"
  [ -z "$GLOSS_TERM" ] && break
  ask "Significado exato" "" "GLOSS_DEF"
  ask "NAO confundir com" "" "GLOSS_NOT"
  GLOSSARY_COUNT=$((GLOSSARY_COUNT + 1))
  GLOSSARY_LINES="${GLOSSARY_LINES}| $GLOSS_TERM | $GLOSS_DEF | $GLOSS_NOT |\n"
  print_ok "$GLOSS_TERM definido"
done

if [ $GLOSSARY_COUNT -eq 0 ]; then
  print_skip "Nenhum termo adicionado (pode preencher depois em specs/glossary.md)"
fi

# ============================================================================
# STEP 7: INVARIANTES (NOVO em v3)
# ============================================================================

print_step 7 $TOTAL_STEPS "INVARIANTES — Leis Inviolaveis do Dominio"

echo ""
echo -e "  ${CYAN}Invariantes sao regras que NUNCA podem ser violadas.${NC}"
echo -e "  ${CYAN}Ex: 'Saldo nunca negativo', 'Fatura paga e imutavel'${NC}"
echo ""

INVARIANT_LINES=""
INVARIANT_COUNT=0

echo "  Adicionar invariantes (Enter vazio para parar):"
while true; do
  ask "Invariante (ex: Saldo nunca negativo)" "" "INV_TEXT"
  [ -z "$INV_TEXT" ] && break
  ask "Modulo afetado (ex: financeiro)" "" "INV_MODULE"
  INVARIANT_COUNT=$((INVARIANT_COUNT + 1))
  INVARIANT_LINES="${INVARIANT_LINES}| INV-$(printf '%02d' $INVARIANT_COUNT) | $INV_TEXT | $INV_MODULE |\n"
  print_ok "INV-$(printf '%02d' $INVARIANT_COUNT): $INV_TEXT"
done

if [ $INVARIANT_COUNT -eq 0 ]; then
  print_skip "Nenhum invariante adicionado (pode preencher depois em specs/invariants.md)"
fi

# ============================================================================
# STEP 8: POPs DE PROJETO
# ============================================================================

print_step 8 $TOTAL_STEPS "POPs DE PROJETO — O que automatizar"

echo "  POPs universais ja incluidos:"
echo -e "  ${GREEN}[OK]${NC} POP-000: Diagnostico de inicio de sessao"
echo -e "  ${GREEN}[OK]${NC} POP-001: Save de fim de sessao"
echo -e "  ${GREEN}[OK]${NC} POP-002: Checkpoint mid-session"
echo -e "  ${GREEN}[OK]${NC} POP-003: Autocorrecao de erros"
echo -e "  ${GREEN}[OK]${NC} POP-INIT: Bootstrap (este onboarding)"
echo ""

POP_COUNT=0
POP_PROJECT_LIST=""

[ -n "$HAS_DB" ] && ask_yn "  Criar POP de auditoria de banco ($HAS_DB)?" "s" && { POP_COUNT=$((POP_COUNT + 1)); POP_PROJECT_LIST="${POP_PROJECT_LIST}db "; print_ok "POP-P0$POP_COUNT: Auditoria de Banco"; }
[ -n "$HAS_TESTS" ] && ask_yn "  Criar POP de execucao de testes?" "s" && { POP_COUNT=$((POP_COUNT + 1)); POP_PROJECT_LIST="${POP_PROJECT_LIST}test "; print_ok "POP-P0$POP_COUNT: Executar Testes"; }
[ -n "$HAS_CI" ] || [ "$ENV_PROD" != "local" ] && ask_yn "  Criar POP de deploy/monitoramento?" "s" && { POP_COUNT=$((POP_COUNT + 1)); POP_PROJECT_LIST="${POP_PROJECT_LIST}deploy "; print_ok "POP-P0$POP_COUNT: Monitoramento Pos-Deploy"; }
ask_yn "  Criar POP de backup pre-modificacao?" "s" && { POP_COUNT=$((POP_COUNT + 1)); POP_PROJECT_LIST="${POP_PROJECT_LIST}backup "; print_ok "POP-P0$POP_COUNT: Backup Pre-Modificacao"; }

# ============================================================================
# STEP 9: INSTALACAO
# ============================================================================

print_step 9 $TOTAL_STEPS "INSTALACAO — Criando estrutura completa"

# --- 1. .context/ (do template original) ---
cp -r "$TEMPLATE_DIR" "$CONTEXT_DIR"
print_ok ".context/ criado (kernel GENOMA)"

# Renomear templates
for TMPL in "$CONTEXT_DIR"/*.template.md; do
  [ -f "$TMPL" ] && mv "$TMPL" "${TMPL%.template.md}.md"
done

# Substituir placeholders
find "$CONTEXT_DIR" -name "*.md" -exec sed -i \
  -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
  -e "s/{{DATE}}/$DATE/g" \
  {} +
print_ok "Placeholders substituidos"

# --- 2. specs/ (NOVO em v3) ---
mkdir -p "$SPECS_DIR"
mkdir -p "$SPECS_DIR/schemas"
mkdir -p "$SPECS_DIR/state-machines"
mkdir -p "$SPECS_DIR/data-flows"
mkdir -p "$SPECS_DIR/side-effects"

# Glossario
cat > "$SPECS_DIR/glossary.md" << GLOSSEOF
# Glossario — Linguagem Ubiqua de $PROJECT_NAME

> Termos do dominio com significado exato. Elimina ambiguidade.
> CRITICO: ambiguidade de vocabulario causa mais bugs que ambiguidade tecnica.

| Termo | Significado Exato | NAO confundir com |
|-------|--------------------|--------------------|
$(echo -e "$GLOSSARY_LINES")

<!-- Adicionar termos conforme o projeto evolui -->
<!-- Formato: | Termo | Significado exato | O que NAO e | -->
GLOSSEOF
print_ok "specs/glossary.md criado ($GLOSSARY_COUNT termos)"

# Invariantes
cat > "$SPECS_DIR/invariants.md" << INVEOF
# Invariantes — Leis Inviolaveis de $PROJECT_NAME

> Regras que NUNCA podem ser violadas em nenhuma circunstancia.
> O Claude verifica invariantes ANTES de gerar codigo.

| ID | Invariante | Modulo |
|----|------------|--------|
$(echo -e "$INVARIANT_LINES")

<!-- Adicionar invariantes conforme o dominio exige -->
<!-- Formato: | INV-XX | Descricao da lei | Modulo afetado | -->
INVEOF
print_ok "specs/invariants.md criado ($INVARIANT_COUNT invariantes)"

# Error Taxonomy
cat > "$SPECS_DIR/error-taxonomy.md" << ERREOF
# Error Taxonomy — $PROJECT_NAME

> Catalogo de erros categorizados com estrategia de tratamento.

## Categorias

| Tipo | HTTP | Retentavel | Estrategia | Exemplo |
|------|------|------------|------------|---------|
| Validacao | 400 | Nao | Retornar campos invalidos | Input mal formatado |
| Autenticacao | 401 | Nao | Redirecionar para login | Token expirado |
| Autorizacao | 403 | Nao | Log + notificar | Sem permissao |
| Nao encontrado | 404 | Nao | Mensagem amigavel | Recurso inexistente |
| Conflito | 409 | Nao | Informar estado atual | Duplicata |
| Negocio | 422 | Nao | Mensagem explicativa | Regra de negocio violada |
| Rate limit | 429 | Sim | Backoff exponencial | Muitas requests |
| Infraestrutura | 503 | Sim | Retry 3x com backoff | Servico fora |

## Formato de Erro Padrao

\`\`\`json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Descricao legivel para o usuario",
    "details": [
      { "field": "email", "message": "Formato invalido" }
    ]
  }
}
\`\`\`

<!-- Personalizar conforme o projeto -->
ERREOF
print_ok "specs/error-taxonomy.md criado"

# Security Model
cat > "$SPECS_DIR/security-model.md" << SECEOF
# Security Model — $PROJECT_NAME

> O que e sensivel, onde validar, trust boundaries.

## Dados Sensiveis (PII)

| Dado | Classificacao | Tratamento |
|------|--------------|------------|
| Email | PII | Criptografar at rest |
| Senha | Segredo | Hash bcrypt, nunca em log |
| Token | Segredo | Nunca em log, response body limitado |
| CPF/CNPJ | PII | Criptografar, mascarar em logs |

## Trust Boundaries

| Fronteira | Nivel de Confianca | Acao |
|-----------|-------------------|------|
| Input do usuario | Nao confiavel | Validar tudo |
| API externa | Nao confiavel | Validar response schema |
| Entre services internos | Semi-confiavel | Validar tipos |
| Banco de dados | Confiavel | Constraints ja validam |

## Regras

- Tokens: nunca em log, nunca em URL query params
- Senhas: bcrypt com salt, minimo 10 rounds
- CORS: configurar origins explicitamente
- Rate limiting: em todas as rotas publicas

<!-- Personalizar conforme o projeto -->
SECEOF
print_ok "specs/security-model.md criado"

# Observability
cat > "$SPECS_DIR/observability.md" << OBSEOF
# Observability — $PROJECT_NAME

> O que logar, medir, alertar.

## Logs

| Evento | Nivel | Obrigatorio | Dados |
|--------|-------|-------------|-------|
| Request recebido | INFO | Sim | method, path, ip |
| Request completado | INFO | Sim | method, path, status, duration_ms |
| Erro de negocio | WARN | Sim | code, message, context |
| Erro de infra | ERROR | Sim | stack trace, context |
| Operacao financeira | INFO | Sim | tipo, valor, entity_id |
| Autenticacao | INFO | Sim | user_id, success/fail |

## NUNCA logar

- Senhas (nem hash)
- Tokens completos
- Dados de cartao
- Corpos de request com PII sem mascarar

## Metricas

| Metrica | Tipo | Alerta quando |
|---------|------|---------------|
| Response time p95 | Histogram | > 500ms |
| Error rate | Counter | > 5% em 5min |
| Queue depth | Gauge | > 1000 |

<!-- Personalizar conforme o projeto -->
OBSEOF
print_ok "specs/observability.md criado"

# Performance
cat > "$SPECS_DIR/performance.md" << PERFEOF
# Performance Baselines — $PROJECT_NAME

> Targets e limites aceitaveis.

| Metrica | Target | Limite | Acao se exceder |
|---------|--------|--------|-----------------|
| API response (p95) | < 200ms | < 500ms | Otimizar query |
| Query DB | < 50ms | < 200ms | Adicionar indice |
| Build time | < 30s | < 60s | Revisar deps |
| Bundle size | < 500kb | < 1mb | Code split |
| Time to first byte | < 100ms | < 300ms | Cache |

<!-- Personalizar conforme o projeto -->
PERFEOF
print_ok "specs/performance.md criado"

# State machine placeholder
cat > "$SPECS_DIR/state-machines/README.md" << SMEOF
# State Machines — $PROJECT_NAME

> Diagramas de estado por entidade.
> Eu NUNCA gero transicoes invalidas quando tenho o state machine.

## Como criar

Um arquivo por entidade. Exemplo:

\`\`\`markdown
# Invoice State Machine

\\\`\\\`\\\`
draft --> sent --> viewed --> paid
                         --> cancelled
draft --> cancelled
\\\`\\\`\\\`

## Transicoes

| De | Para | Trigger | Side Effects |
|----|------|---------|-------------|
| draft | sent | usuario envia | Gera PDF, envia email |
| sent | viewed | cliente abre link | Notifica freelancer |
| viewed | paid | pagamento confirmado | Atualiza saldo, envia recibos |
| * | cancelled | usuario cancela | Notifica partes |
\`\`\`

Criar arquivos como: \`invoice.md\`, \`order.md\`, \`user.md\`
SMEOF
print_ok "specs/state-machines/ criado"

# Side effects placeholder
cat > "$SPECS_DIR/side-effects/README.md" << SEEOF
# Side Effects Map — $PROJECT_NAME

> O que cada operacao dispara alem da acao primaria.
> Eu implemento TODOS os side effects listados.

## Formato

\`\`\`markdown
## createEntity

Acao primaria: Cria registro no banco

Side effects:
  1. Cria audit log
  2. Envia notificacao
  3. Invalida cache
  4. Dispara webhook EVENT_CREATED
\`\`\`

Criar um arquivo por modulo: \`auth.md\`, \`payments.md\`, etc.
SEEOF
print_ok "specs/side-effects/ criado"

# Data flow placeholder
cat > "$SPECS_DIR/data-flows/README.md" << DFEOF
# Data Flows — $PROJECT_NAME

> Como dados fluem pelo sistema, de ponta a ponta.

## Formato

\`\`\`
Input --> Validacao --> Service --> Repository --> DB
                                              --> Cache
                                   Service --> Notification
                                           --> Webhook
\`\`\`

Criar um arquivo por fluxo principal.
DFEOF
print_ok "specs/data-flows/ criado"

# OpenAPI placeholder
cat > "$SPECS_DIR/openapi.yaml" << APIEOF
# OpenAPI Spec — $PROJECT_NAME
# Preencher com endpoints da API

openapi: '3.0.3'
info:
  title: $PROJECT_NAME API
  version: '1.0.0'
  description: $PROJECT_DESC

paths: {}
  # Adicionar endpoints conforme o projeto evolui

components:
  schemas: {}
    # Adicionar schemas conforme o projeto evolui
APIEOF
print_ok "specs/openapi.yaml criado (placeholder)"

# --- 3. docs/ (NOVO em v3) ---
mkdir -p "$DOCS_DIR/decisions"
mkdir -p "$DOCS_DIR/post-mortems"
mkdir -p "$DOCS_DIR/session-history"

# Anti-patterns
cat > "$DOCS_DIR/anti-patterns.md" << APEOF
# Anti-patterns — $PROJECT_NAME

> O que NUNCA fazer neste projeto.

## Codigo

- <!-- Adicionar anti-patterns de codigo -->

## Arquitetura

- <!-- Adicionar anti-patterns de arquitetura -->

## Processo

- <!-- Adicionar anti-patterns de processo -->

## Formato para novos anti-patterns

\`\`\`markdown
### AP-XX: Nome do Anti-pattern
- **O que e:** Descricao do que e feito errado
- **Por que e ruim:** Consequencia
- **Fazer em vez disso:** Alternativa correta
- **Exemplo ruim:** \`codigo ruim\`
- **Exemplo bom:** \`codigo bom\`
\`\`\`
APEOF
print_ok "docs/anti-patterns.md criado"

# Post-mortems README
cat > "$DOCS_DIR/post-mortems/README.md" << PMEOF
# Post-Mortems — $PROJECT_NAME

> Bugs graves resolvidos. Eu herdo a experiencia que nao tenho.

## Formato

\`\`\`markdown
# PM-001: Titulo do Bug

- **Data:** YYYY-MM-DD
- **Severidade:** Critica/Alta/Media
- **Impacto:** O que aconteceu com o usuario
- **Causa raiz:** O que causou
- **Fix:** O que foi feito
- **Prevencao:** O que mudou para nunca repetir
\`\`\`
PMEOF
print_ok "docs/post-mortems/ criado"

# Session history README
cat > "$DOCS_DIR/session-history/README.md" << SHEOF
# Session History — $PROJECT_NAME

> Historico de sessoes para continuidade perfeita entre sessoes.

## Formato

Arquivo: \`session-NNN-YYYY-MM-DD.md\`

\`\`\`markdown
## Sessao NNN — YYYY-MM-DD

### Concluido
- [o que foi feito]

### Pendente
- [o que falta]

### Decisoes Tomadas
- [decisoes e rationale]

### Contexto para Proxima Sessao
- Comecar por: [arquivo/modulo]
- Seguir padrao de: [referencia]
- Spec relevante: [link]
\`\`\`
SHEOF
print_ok "docs/session-history/ criado"

# Decisions README
cat > "$DOCS_DIR/decisions/README.md" << DECEOF
# Architecture Decision Records — $PROJECT_NAME

> Por que decisoes foram tomadas. Eu nao sugiro o que ja foi rejeitado.

## Formato ADR

Arquivo: \`NNN-titulo-da-decisao.md\`

\`\`\`markdown
# ADR-NNN: Titulo

## Contexto
Qual problema ou situacao motivou a decisao

## Decisao
O que foi decidido

## Razao
Por que esta opcao e a melhor

## Alternativas Rejeitadas
- Opcao A: motivo da rejeicao
- Opcao B: motivo da rejeicao

## Consequencias
O que muda no projeto
\`\`\`
DECEOF
print_ok "docs/decisions/ criado"

# --- 4. .claude/commands/ ---
mkdir -p "$CLAUDE_DIR/commands"

# Copiar commands do template se existirem
if [ -d "$TEMPLATE_DIR/commands" ]; then
  cp "$TEMPLATE_DIR/commands/"*.md "$CLAUDE_DIR/commands/" 2>/dev/null || true
  print_ok ".claude/commands/ copiados do template"
else
  # Criar commands basicos
  cat > "$CLAUDE_DIR/commands/pop-000.md" << 'CMDEOF'
---
description: "POP-000: Diagnostico de Inicio de Sessao"
---

Executar POP-000 (Diagnostico de Inicio de Sessao) AGORA.

Procedimento OBRIGATORIO — executar TODOS os passos em sequencia:

1. Ler `CLAUDE.md` — regras e estrutura do projeto
2. Ler `.context/SNAPSHOT.md` — estado atual completo
3. Ler `specs/glossary.md` — linguagem do dominio
4. Executar `git log --oneline -10` — timeline recente
5. Executar `git status` — verificar mudancas nao commitadas
6. Se `.env` existe — verificar credenciais disponiveis
7. Ler ultimo historico em `docs/session-history/`

Apos coletar TUDO, gerar relatorio proativo:
- Identificar o que e CRITICO, ATRASADO, BLOQUEADO
- Priorizar por: urgencia > criticidade > dependencias > impacto
- Incluir proximos passos concretos e acionaveis

Finalizar perguntando: "Qual sera o foco desta sessao?"
CMDEOF

  cat > "$CLAUDE_DIR/commands/pop-001.md" << 'CMDEOF'
---
description: "POP-001: Save de Sessao / Protecao Anti-Compressao"
---

Executar POP-001 (Save de Sessao) AGORA.

PRIORIDADE ABSOLUTA — parar qualquer tarefa e executar:

1. `git status` — verificar mudancas nao commitadas
2. Commitar TUDO pendente com conventional format
3. Atualizar `.context/SNAPSHOT.md` completo e AUTOCONTIDO
4. Criar/atualizar historico em `docs/session-history/session-NNN-YYYY-MM-DD.md`
5. `git add` todos os arquivos alterados
6. `git commit -m "session(save): session NNN - [resumo]"`
7. Informar: "Checkpoint salvo. Contexto preservado."
CMDEOF

  cat > "$CLAUDE_DIR/commands/pop-002.md" << 'CMDEOF'
---
description: "POP-002: Checkpoint Mid-Session"
---

Executar POP-002 (Checkpoint) AGORA.

Modo: $ARGUMENTS (LIGHT, FULL, ou SAFETY)

LIGHT: Apenas atualizar SNAPSHOT.md
FULL: SNAPSHOT + DECISIONS se houve decisao
SAFETY: Save point antes de acao arriscada

1. Atualizar `.context/SNAPSHOT.md` com estado atual
2. Se FULL: verificar se houve decisoes nao registradas
3. Se SAFETY: criar save point git
4. Commit: `checkpoint($ARGUMENTS): [motivo]`
CMDEOF

  cat > "$CLAUDE_DIR/commands/pop-003.md" << 'CMDEOF'
---
description: "POP-003: Autocorrecao de Erros — diagnosticar e corrigir"
---

Executar POP-003 (Autocorrecao) para: $ARGUMENTS

1. Identificar tipo de erro e causa raiz
2. Classificar: erro meu (safe to fix) ou erro do sistema (perguntar)
3. Se safe: corrigir automaticamente
4. Se risky: apresentar opcoes ao usuario
5. Maximo 2 tentativas — se falhar 2x, escalar para usuario
6. Registrar no SNAPSHOT o que aconteceu
CMDEOF

  cat > "$CLAUDE_DIR/commands/marcha.md" << 'CMDEOF'
---
description: "#marcha: Modo autonomo — trabalhar sem pedir permissao para operacoes seguras"
---

Modo #marcha ATIVADO.

Pre-aprovacao total concedida para:
- Ler qualquer arquivo do projeto
- Consultar APIs externas em modo READ-ONLY
- Criar/editar arquivos locais
- Commitar no git
- Executar todos os POPs automaticamente
- Ler specs, docs, glossario

NAO inclui (ainda precisa perguntar):
- Alterar dados em bancos de producao
- Ativar/modificar recursos em producao
- Apagar arquivos
- Push para repositorios remotos
- Operacoes que violam invariantes

Trabalhar autonomamente e entregar resultado pronto.
Foco atual: $ARGUMENTS
CMDEOF

  print_ok ".claude/commands/ criados"
fi

# --- 5. Personalizar MANIFEST ---
MANIFEST="$CONTEXT_DIR/MANIFEST.md"
if [ -f "$MANIFEST" ]; then
  # Usar awk para substituicoes seguras (sem problemas com caracteres especiais)
  awk -v old="<!-- O que este projeto faz -->" -v new="$PROJECT_DESC" '{gsub(old,new)}1' "$MANIFEST" > "${MANIFEST}.tmp" && mv "${MANIFEST}.tmp" "$MANIFEST"
  awk -v old="<!-- Linguagens, frameworks, servicos -->" -v new="$DETECTED_STACK" '{gsub(old,new)}1' "$MANIFEST" > "${MANIFEST}.tmp" && mv "${MANIFEST}.tmp" "$MANIFEST"

  ENV_LINE="Producao: $ENV_PROD | Dev: $ENV_DEV"
  [ -n "$ENV_STAGING" ] && ENV_LINE="$ENV_LINE | Staging: $ENV_STAGING"
  awk -v old="<!-- dev, staging, producao -->" -v new="$ENV_LINE" '{gsub(old,new)}1' "$MANIFEST" > "${MANIFEST}.tmp" && mv "${MANIFEST}.tmp" "$MANIFEST"

  print_ok "MANIFEST.md personalizado"
fi

# --- 6. Gerar CLAUDE.md ---
if [ -f "$SCRIPT_DIR/CLAUDE.template.md" ]; then
  cp "$SCRIPT_DIR/CLAUDE.template.md" "$PROJECT_PATH/CLAUDE.md"

  CLAUDE_FILE="$PROJECT_PATH/CLAUDE.md"

  # Funcao segura para substituir placeholders usando awk (sem problemas com / | \ &)
  safe_replace() {
    local placeholder="$1"
    local value="$2"
    local file="$3"
    awk -v old="$placeholder" -v new="$value" '{gsub(old,new)}1' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
  }

  safe_replace "{{PROJECT_NAME}}" "$PROJECT_NAME" "$CLAUDE_FILE"
  safe_replace "{{PROJECT_DESC}}" "$PROJECT_DESC" "$CLAUDE_FILE"
  safe_replace "{{DETECTED_STACK}}" "$DETECTED_STACK" "$CLAUDE_FILE"
  safe_replace "{{PROJECT_TYPE}}" "$PROJECT_TYPE" "$CLAUDE_FILE"
  safe_replace "{{PROJECT_VISION}}" "$PROJECT_VISION" "$CLAUDE_FILE"
  safe_replace "{{ENV_DEV}}" "$ENV_DEV" "$CLAUDE_FILE"
  safe_replace "{{ENV_STAGING}}" "${ENV_STAGING:-N/A}" "$CLAUDE_FILE"
  safe_replace "{{ENV_PROD}}" "$ENV_PROD" "$CLAUDE_FILE"
  safe_replace "{{DETECTED_LANG:-typescript}}" "${DETECTED_LANG:-typescript}" "$CLAUDE_FILE"
  safe_replace "{{LANG}}" "${DETECTED_LANG:-typescript}" "$CLAUDE_FILE"
  safe_replace "{{DATE}}" "$DATE" "$CLAUDE_FILE"
  safe_replace "{{GUARDRAIL_SECTION}}" "$GUARDRAIL_SECTION" "$CLAUDE_FILE"

  print_ok "CLAUDE.md v3 gerado (15 blocos de alta performance)"
else
  print_warn "CLAUDE.template.md nao encontrado — CLAUDE.md nao gerado"
fi

# --- 7. Git hooks ---
if [ -d "$PROJECT_PATH/.git" ]; then
  if [ -d "$CONTEXT_DIR/hooks" ]; then
    cp "$CONTEXT_DIR/hooks/commit-msg.sh" "$PROJECT_PATH/.git/hooks/commit-msg" 2>/dev/null
    cp "$CONTEXT_DIR/hooks/post-commit.sh" "$PROJECT_PATH/.git/hooks/post-commit" 2>/dev/null
    cp "$CONTEXT_DIR/hooks/pre-push.sh" "$PROJECT_PATH/.git/hooks/pre-push" 2>/dev/null
    chmod +x "$PROJECT_PATH/.git/hooks/commit-msg" 2>/dev/null
    chmod +x "$PROJECT_PATH/.git/hooks/post-commit" 2>/dev/null
    chmod +x "$PROJECT_PATH/.git/hooks/pre-push" 2>/dev/null
    print_ok "Git hooks instalados"
  fi
elif ask_yn "Nao e um repo git. Inicializar?" "s"; then
  git init "$PROJECT_PATH"
  if [ -d "$CONTEXT_DIR/hooks" ]; then
    cp "$CONTEXT_DIR/hooks/commit-msg.sh" "$PROJECT_PATH/.git/hooks/commit-msg" 2>/dev/null
    cp "$CONTEXT_DIR/hooks/post-commit.sh" "$PROJECT_PATH/.git/hooks/post-commit" 2>/dev/null
    cp "$CONTEXT_DIR/hooks/pre-push.sh" "$PROJECT_PATH/.git/hooks/pre-push" 2>/dev/null
    chmod +x "$PROJECT_PATH/.git/hooks/commit-msg" 2>/dev/null
    chmod +x "$PROJECT_PATH/.git/hooks/post-commit" 2>/dev/null
    chmod +x "$PROJECT_PATH/.git/hooks/pre-push" 2>/dev/null
  fi
  print_ok "Git inicializado + hooks instalados"
fi

# .gitignore
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

# --- 8. Commit inicial ---
if [ -d "$PROJECT_PATH/.git" ]; then
  echo ""
  if ask_yn "Criar commit inicial do GENOMA v3?" "s"; then
    cd "$PROJECT_PATH"
    git add .context/ specs/ docs/ .claude/commands/ CLAUDE.md .gitignore 2>/dev/null
    git commit -m "context(genoma): initialize PGP GENOMA v3.0 for $PROJECT_NAME

Estrutura completa:
- .context/ (kernel GENOMA: MANIFEST, SNAPSHOT, POPs, hooks)
- specs/ (glossario, invariantes, error taxonomy, security, observability)
- docs/ (decisions, post-mortems, session-history, anti-patterns)
- .claude/commands/ (pop-000 a pop-003, marcha)
- CLAUDE.md (framework 15 blocos de alta performance)" 2>/dev/null || true
    print_ok "Commit inicial criado"
  fi
fi

# ============================================================================
# RESUMO FINAL
# ============================================================================

echo ""
echo -e "${CYAN}   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BOLD}${GREEN}     GENOMA v3.0 — FRAMEWORK DE ALTA PERFORMANCE ATIVO!${NC}"
echo ""
echo -e "     ${CYAN}Projeto guarnecido. Contexto perpetuo. Performance maxima.${NC}"
echo ""
echo -e "${CYAN}   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BOLD}Projeto:${NC}  $PROJECT_NAME"
echo -e "${BOLD}Stack:${NC}    $DETECTED_STACK"
echo -e "${BOLD}Tipo:${NC}     $PROJECT_TYPE"
echo -e "${BOLD}Idioma:${NC}   $PROJECT_LANG"
echo ""
echo -e "${BOLD}Estrutura instalada:${NC}"
echo ""
echo -e "  ${GREEN}[OK]${NC} ${BOLD}.context/${NC} — Kernel GENOMA"
echo -e "       MANIFEST, SNAPSHOT, ROUTES, DECISIONS, GRAPH, POPs, hooks"
echo ""
echo -e "  ${GREEN}[OK]${NC} ${BOLD}specs/${NC} — Contratos e Especificacoes"
echo -e "       glossary ($GLOSSARY_COUNT termos), invariants ($INVARIANT_COUNT regras)"
echo -e "       error-taxonomy, security-model, observability, performance"
echo -e "       openapi, schemas/, state-machines/, data-flows/, side-effects/"
echo ""
echo -e "  ${GREEN}[OK]${NC} ${BOLD}docs/${NC} — Documentacao Viva"
echo -e "       decisions/, post-mortems/, session-history/, anti-patterns"
echo ""
echo -e "  ${GREEN}[OK]${NC} ${BOLD}.claude/commands/${NC} — Slash Commands"
echo -e "       /pop-000, /pop-001, /pop-002, /pop-003, /marcha"
echo ""
echo -e "  ${GREEN}[OK]${NC} ${BOLD}CLAUDE.md${NC} — Framework 15 Blocos de Alta Performance"
echo -e "       Context Loading, Glossario, Specs, Calibracao, Pontos Cegos"
echo -e "       Guardrails, Verificacao, Sessao, Autonomia, Orquestracao"
echo ""

[ $POP_COUNT -gt 0 ] && echo -e "  ${GREEN}[OK]${NC} $POP_COUNT POPs de projeto criados"
[ -n "$GUARDRAIL_PASSWORD" ] && echo -e "  ${GREEN}[OK]${NC} Guardrails com senha ativa"
echo ""

echo -e "${BOLD}Proximos passos:${NC}"
echo ""
echo -e "  1. ${CYAN}Revisar CLAUDE.md${NC} — preencher placeholders {{...}} restantes"
echo -e "  2. ${CYAN}Preencher specs/${NC} — glossario, invariantes, state machines"
echo -e "  3. ${CYAN}Definir modulo de referencia${NC} — o padrao vivo do projeto"
echo -e "  4. ${CYAN}Adicionar exemplos de calibracao${NC} — bom/ruim no CLAUDE.md"
echo -e "  5. Ou pedir ao Claude: ${CYAN}\"Executar POP-INIT\"${NC}"
echo ""
echo -e "${DIM}O Claude executa POP-000 automaticamente no inicio de cada sessao.${NC}"
echo ""

# Arvore final
echo -e "${BOLD}Arvore completa:${NC}"
echo ""
echo -e "${CYAN}"
cat << 'TREEEOF'
  projeto/
  ├── CLAUDE.md                          # Framework 15 blocos
  ├── .context/
  │   ├── MANIFEST.md                    # DNA do projeto
  │   ├── SNAPSHOT.md                    # Estado atual (perpetuo)
  │   ├── DECISIONS.md                   # Log de decisoes
  │   ├── ROUTES.md                      # GPS de navegacao
  │   ├── GRAPH.md                       # Diagramas visuais
  │   ├── pops/                          # Procedimentos operacionais
  │   │   ├── INDEX.md
  │   │   ├── POP-000..003.md            # Universais
  │   │   └── POP-INIT.md               # Bootstrap
  │   ├── hooks/                         # Git hooks
  │   ├── templates/                     # Templates reutilizaveis
  │   └── deep/                          # Investigacoes profundas
  ├── specs/
  │   ├── glossary.md                    # Linguagem ubiqua
  │   ├── invariants.md                  # Leis inviolaveis
  │   ├── error-taxonomy.md              # Catalogo de erros
  │   ├── security-model.md              # Trust boundaries
  │   ├── observability.md               # Logs, metricas, alertas
  │   ├── performance.md                 # Baselines e SLAs
  │   ├── openapi.yaml                   # Contrato da API
  │   ├── schemas/                       # JSON Schemas
  │   ├── state-machines/                # Diagramas de estado
  │   ├── data-flows/                    # Fluxos de dados
  │   └── side-effects/                  # Mapa de efeitos colaterais
  ├── docs/
  │   ├── decisions/                     # ADRs
  │   ├── post-mortems/                  # Bugs resolvidos
  │   ├── session-history/               # Historico de sessoes
  │   └── anti-patterns.md              # O que nunca fazer
  └── .claude/
      └── commands/                      # Slash commands
          ├── pop-000.md
          ├── pop-001.md
          ├── pop-002.md
          ├── pop-003.md
          └── marcha.md
TREEEOF
echo -e "${NC}"
