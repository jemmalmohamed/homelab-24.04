#!/usr/bin/env bash
set -euo pipefail

agent_secret="${1:-}"
agent_name="${2:-dev-host}"
work_dir="${3:-/home/jemmal/jenkins}"

if [ -z "$agent_secret" ]; then
  echo "Usage: $0 <agent-secret> [agent-name] [work-dir]" >&2
  exit 1
fi

curl -fsSLO "http://localhost:18080/jnlpJars/agent.jar"
java -jar agent.jar \
  -url "http://localhost:18080/" \
  -secret "$agent_secret" \
  -name "$agent_name" \
  -webSocket \
  -workDir "$work_dir"