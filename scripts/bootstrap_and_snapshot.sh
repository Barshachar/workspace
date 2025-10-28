#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
SCRIPT_DIR="$ROOT_DIR/scripts"
STATUS_FILE="$ROOT_DIR/STATUS.md"
mkdir -p "$SCRIPT_DIR"

log() {
  echo "[bootstrap] $1"
}

declare -a NODE_PROJECTS=()
declare -a NODE_MANAGERS=()
declare -a PYTHON_PROJECTS=()
declare -a PYTHON_TYPES=()
declare -a FLUTTER_PROJECTS=()

detect_node_projects() {
  if command -v find >/dev/null 2>&1; then
    while IFS= read -r pkg; do
      dir="$(dirname "$pkg")"
      case "$dir" in
        *node_modules*) continue ;;
      esac
      NODE_PROJECTS+=("$dir")
      if [ -f "$dir/pnpm-lock.yaml" ]; then
        NODE_MANAGERS+=("pnpm")
      elif [ -f "$dir/yarn.lock" ]; then
        NODE_MANAGERS+=("yarn")
      elif [ -f "$dir/package-lock.json" ]; then
        NODE_MANAGERS+=("npm")
      else
        NODE_MANAGERS+=("npm")
      fi
    done < <(find "$ROOT_DIR" -maxdepth 5 -type f -name package.json 2>/dev/null)
  fi
}

detect_python_projects() {
  if command -v find >/dev/null 2>&1; then
    while IFS= read -r pyproj; do
      dir="$(dirname "$pyproj")"
      PYTHON_PROJECTS+=("$dir")
      PYTHON_TYPES+=("pyproject")
    done < <(find "$ROOT_DIR" -maxdepth 5 -type f -name pyproject.toml 2>/dev/null)
    while IFS= read -r req; do
      dir="$(dirname "$req")"
      local found=false
      for existing in "${PYTHON_PROJECTS[@]:-}"; do
        if [ "$existing" = "$dir" ]; then
          found=true
          break
        fi
      done
      if [ "$found" = true ]; then
        continue
      fi
      PYTHON_PROJECTS+=("$dir")
      PYTHON_TYPES+=("requirements")
    done < <(find "$ROOT_DIR" -maxdepth 5 -type f -name requirements.txt 2>/dev/null)
  fi
}

detect_flutter_projects() {
  if command -v find >/dev/null 2>&1; then
    while IFS= read -r pubspec; do
      dir="$(dirname "$pubspec")"
      FLUTTER_PROJECTS+=("$dir")
    done < <(find "$ROOT_DIR" -maxdepth 5 -type f -name pubspec.yaml 2>/dev/null)
  fi
}

NODE=false
PYTHON=false
FLUTTER=false
ANDROID=false
IOS=false
DOCKER=false

if [ -f "$ROOT_DIR/docker-compose.yml" ] || [ -f "$ROOT_DIR/compose.yml" ]; then
  DOCKER=true
fi
if find "$ROOT_DIR" -maxdepth 5 \( -name build.gradle -o -name build.gradle.kts \) 2>/dev/null | grep -q .; then
  ANDROID=true
fi
if find "$ROOT_DIR" -maxdepth 3 -path "*/ios/*.xcodeproj" 2>/dev/null | grep -q .; then
  IOS=true
fi

detect_node_projects
if [ ${#NODE_PROJECTS[@]} -gt 0 ]; then
  NODE=true
fi

detect_python_projects
if [ ${#PYTHON_PROJECTS[@]} -gt 0 ]; then
  PYTHON=true
fi

detect_flutter_projects
if [ ${#FLUTTER_PROJECTS[@]} -gt 0 ]; then
  FLUTTER=true
fi

if $NODE; then
  log "Detected ${#NODE_PROJECTS[@]} Node.js project(s)."
  if command -v corepack >/dev/null 2>&1; then
    corepack enable || true
  fi
  for idx in "${!NODE_PROJECTS[@]}"; do
    dir="${NODE_PROJECTS[$idx]}"
    manager="${NODE_MANAGERS[$idx]}"
    log "Installing dependencies in $dir using $manager."
    pushd "$dir" >/dev/null
    case "$manager" in
      pnpm)
        if command -v pnpm >/dev/null 2>&1; then
          pnpm install --frozen-lockfile || true
        elif command -v corepack >/dev/null 2>&1; then
          corepack pnpm install --frozen-lockfile || true
        else
          log "pnpm unavailable; skipping install in $dir."
        fi
        ;;
      yarn)
        if command -v yarn >/dev/null 2>&1; then
          yarn install --frozen-lockfile || true
        elif command -v corepack >/dev/null 2>&1; then
          corepack yarn install --frozen-lockfile || true
        else
          log "yarn unavailable; skipping install in $dir."
        fi
        ;;
      npm)
        if command -v npm >/dev/null 2>&1; then
          if [ -f package-lock.json ]; then
            npm ci || true
          else
            npm install --no-audit --no-fund || true
          fi
        else
          log "npm unavailable; skipping install in $dir."
        fi
        ;;
      *)
        if command -v npm >/dev/null 2>&1; then
          npm install --no-audit --no-fund || true
        else
          log "No Node package manager available for $dir."
        fi
        ;;
    esac
    popd >/dev/null
  done
fi

if $PYTHON; then
  for idx in "${!PYTHON_PROJECTS[@]}"; do
    dir="${PYTHON_PROJECTS[$idx]}"
    kind="${PYTHON_TYPES[$idx]}"
    log "Setting up Python environment in $dir ($kind)."
    python_exec="python3"
    if command -v pyenv >/dev/null 2>&1; then
      python_exec="$(pyenv which python 2>/dev/null || echo python3)"
    fi
    "$python_exec" -m venv "$dir/.venv"
    source "$dir/.venv/bin/activate"
    pip install --upgrade pip >/dev/null || true
    if [ "$kind" = "pyproject" ]; then
      pip install . || true
    elif [ -f "$dir/requirements.txt" ]; then
      pip install -r "$dir/requirements.txt" || true
    fi
    deactivate || true
  done
fi

if $FLUTTER; then
  for dir in "${FLUTTER_PROJECTS[@]}"; do
    log "Fetching Flutter dependencies in $dir."
    pushd "$dir" >/dev/null
    if command -v flutter >/dev/null 2>&1; then
      flutter pub get || true
    else
      log "flutter command unavailable; skipping flutter pub get in $dir."
    fi
    popd >/dev/null
  done
fi

if $DOCKER; then
  compose_file="$ROOT_DIR/docker-compose.yml"
  if [ -f "$ROOT_DIR/compose.yml" ]; then
    compose_file="$ROOT_DIR/compose.yml"
  fi
  log "Starting services defined in $(basename "$compose_file")."
  if command -v docker >/dev/null 2>&1; then
    if docker compose version >/dev/null 2>&1; then
      docker compose -f "$compose_file" up -d --wait || true
    elif command -v docker-compose >/dev/null 2>&1; then
      docker-compose -f "$compose_file" up -d || true
    else
      log "Docker compose tooling unavailable."
    fi
  else
    log "Docker not installed; skipping compose startup."
  fi
fi

run_db_migrations() {
  local dir="$1"
  if [ -f "$dir/prisma/schema.prisma" ] && command -v npx >/dev/null 2>&1; then
    log "Running Prisma migrations in $dir."
    (cd "$dir" && npx prisma migrate deploy) || log "Prisma migration failed in $dir."
  fi
  if { [ -f "$dir/ormconfig.json" ] || [ -f "$dir/ormconfig.js" ]; } && command -v npx >/dev/null 2>&1; then
    log "Running TypeORM migrations in $dir."
    (cd "$dir" && npx typeorm migration:run) || log "TypeORM migration failed in $dir."
  fi
  if { [ -f "$dir/.sequelizerc" ] || { [ -d "$dir/migrations" ] && [ -f "$dir/package.json" ]; }; } && command -v npx >/dev/null 2>&1; then
    log "Running Sequelize migrations in $dir."
    (cd "$dir" && npx sequelize-cli db:migrate) || log "Sequelize migration failed in $dir."
  fi
  if [ -f "$dir/alembic.ini" ]; then
    local activate="$dir/.venv/bin/activate"
    if [ -f "$activate" ]; then
      source "$activate"
      log "Running Alembic migrations in $dir."
      (cd "$dir" && alembic upgrade head) || log "Alembic migration failed in $dir."
      deactivate || true
    elif command -v alembic >/dev/null 2>&1; then
      log "Running Alembic migrations in $dir using global interpreter."
      (cd "$dir" && alembic upgrade head) || log "Alembic migration failed in $dir."
    fi
  fi
  if [ -f "$dir/manage.py" ]; then
    local activate="$dir/.venv/bin/activate"
    if [ -f "$activate" ]; then
      source "$activate"
      log "Running Django migrations in $dir."
      (cd "$dir" && python manage.py migrate) || log "Django migration failed in $dir."
      deactivate || true
    elif command -v python3 >/dev/null 2>&1; then
      log "Running Django migrations in $dir using system Python."
      (cd "$dir" && python3 manage.py migrate) || log "Django migration failed in $dir."
    fi
  fi
}

for dir in "${NODE_PROJECTS[@]}"; do
  run_db_migrations "$dir"
done
for dir in "${PYTHON_PROJECTS[@]}"; do
  run_db_migrations "$dir"
done
for dir in "${FLUTTER_PROJECTS[@]}"; do
  run_db_migrations "$dir"
done

lint_status="SKIPPED"
lint_exit=0
lint_ran=false
lint_dir="$ROOT_DIR"
if [ ${#NODE_PROJECTS[@]} -gt 0 ]; then
  lint_dir="${NODE_PROJECTS[0]}"
elif [ ${#PYTHON_PROJECTS[@]} -gt 0 ]; then
  lint_dir="${PYTHON_PROJECTS[0]}"
elif [ ${#FLUTTER_PROJECTS[@]} -gt 0 ]; then
  lint_dir="${FLUTTER_PROJECTS[0]}"
fi

set +e
pushd "$lint_dir" >/dev/null 2>&1
if command -v npm >/dev/null 2>&1; then
  npm run lint --silent
  lint_exit=$?
  lint_ran=true
  if [ $lint_exit -eq 0 ]; then
    lint_status="OK (npm run lint)"
  fi
fi
if [ "$lint_status" != "OK (npm run lint)" ] && command -v ruff >/dev/null 2>&1; then
  if ruff --version >/dev/null 2>&1; then
    ruff check .
    lint_exit=$?
    lint_ran=true
    if [ $lint_exit -eq 0 ]; then
      lint_status="OK (ruff)"
    fi
  fi
fi
if [[ "$lint_status" != OK* ]] && command -v flake8 >/dev/null 2>&1; then
  flake8
  lint_exit=$?
  lint_ran=true
  if [ $lint_exit -eq 0 ]; then
    lint_status="OK (flake8)"
  fi
fi
popd >/dev/null 2>&1
set -e
if ! $lint_ran; then
  lint_status="SKIPPED"
elif [[ "$lint_status" != OK* ]] && [ $lint_exit -ne 0 ]; then
  lint_status="FAILED"
fi

test_status="SKIPPED"
test_exit=0
test_ran=false
set +e
pushd "$lint_dir" >/dev/null 2>&1
if command -v npm >/dev/null 2>&1; then
  npm test --silent
  test_exit=$?
  test_ran=true
  if [ $test_exit -eq 0 ]; then
    test_status="OK (npm test)"
  fi
fi
if [[ "$test_status" != OK* ]] && command -v pytest >/dev/null 2>&1; then
  pytest -q
  test_exit=$?
  test_ran=true
  if [ $test_exit -eq 0 ]; then
    test_status="OK (pytest)"
  elif [ $test_exit -eq 5 ]; then
    test_status="SKIPPED (pytest: no tests collected)"
    test_exit=0
  fi
fi
if [[ "$test_status" != OK* ]] && command -v flutter >/dev/null 2>&1; then
  flutter test
  test_exit=$?
  test_ran=true
  if [ $test_exit -eq 0 ]; then
    test_status="OK (flutter test)"
  fi
fi
if [[ "$test_status" != OK* ]]; then
  if [ -f "$lint_dir/gradlew" ]; then
    chmod +x "$lint_dir/gradlew" 2>/dev/null || true
    "$lint_dir/gradlew" test
    test_exit=$?
    test_ran=true
    if [ $test_exit -eq 0 ]; then
      test_status="OK (gradlew test)"
    fi
  elif [ -f "$ROOT_DIR/gradlew" ]; then
    chmod +x "$ROOT_DIR/gradlew" 2>/dev/null || true
    (cd "$ROOT_DIR" && ./gradlew test)
    test_exit=$?
    test_ran=true
    if [ $test_exit -eq 0 ]; then
      test_status="OK (gradlew test)"
    fi
  fi
fi
popd >/dev/null 2>&1
set -e
if ! $test_ran; then
  test_status="SKIPPED"
elif [[ "$test_status" != OK* ]] && [ $test_exit -ne 0 ]; then
  test_status="FAILED"
fi

branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo unknown)"
last_commit_info="$(git log -1 --pretty='%H %s' 2>/dev/null || echo unknown)"
commit_author="$(git log -1 --pretty='%an' 2>/dev/null || echo unknown)"
commit_date="$(git log -1 --pretty='%ad' 2>/dev/null || echo unknown)"

missing_env="None"
if [ -f "$ROOT_DIR/.env.example" ]; then
  mapfile -t example_keys < <(grep -E '^[^#].*=' "$ROOT_DIR/.env.example" | cut -d '=' -f1 | sort -u)
  if [ -f "$ROOT_DIR/.env" ]; then
    mapfile -t env_keys < <(grep -E '^[^#].*=' "$ROOT_DIR/.env" | cut -d '=' -f1 | sort -u)
    missing=$(comm -23 <(printf '%s\n' "${example_keys[@]}" | sort) <(printf '%s\n' "${env_keys[@]:-}" | sort))
    if [ -n "$missing" ]; then
      missing_env="$missing"
    else
      missing_env="None"
    fi
  else
    missing_env=$(printf '%s\n' "${example_keys[@]}")
  fi
fi

declare -a STACK_LIST=()
if $NODE; then STACK_LIST+=("Node.js"); fi
if $PYTHON; then STACK_LIST+=("Python"); fi
if $FLUTTER; then STACK_LIST+=("Flutter/Dart"); fi
if $ANDROID; then STACK_LIST+=("Android"); fi
if $IOS; then STACK_LIST+=("iOS"); fi
if $DOCKER; then STACK_LIST+=("Docker Compose"); fi

{
  echo "# Project Status Snapshot"
  echo
  echo "- **Branch:** $branch"
  echo "- **Last Commit:** $last_commit_info"
  echo "- **Author:** $commit_author"
  echo "- **Date:** $commit_date"
  echo
  echo "## Detected Stacks"
  if [ ${#STACK_LIST[@]} -gt 0 ]; then
    for stack in "${STACK_LIST[@]}"; do
      echo "- $stack"
    done
  else
    echo "- None"
  fi
  echo
  echo "## Lint Summary"
  echo "- $lint_status"
  echo
  echo "## Test Summary"
  echo "- $test_status"
  echo
  echo "## Missing Environment Keys"
  if [ "$missing_env" = "None" ]; then
    echo "- None"
  else
    while IFS= read -r key; do
      [ -n "$key" ] && echo "- $key"
    done <<< "$missing_env"
  fi
} > "$STATUS_FILE"

log "STATUS.md updated."

echo "Next steps:"
echo "- Review STATUS.md for the current project snapshot."
echo "- Resolve any lint or test failures reported above."
echo "- Populate missing environment variables if listed."
