#!/bin/bash

# トークン使用量を制限・監視するスクリプト

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
CONFIG_FILE="$PROJECT_ROOT/config/token-limits.json"

echo "=== Token Usage Limiter ==="
echo

# デフォルトのトークン制限設定を作成
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Creating default token limit configuration..."
    mkdir -p "$(dirname "$CONFIG_FILE")"
    cat > "$CONFIG_FILE" << 'EOF'
{
  "global": {
    "max_tokens_per_minute": 40000,
    "max_tokens_per_hour": 200000,
    "max_tokens_per_agent_per_request": 4096
  },
  "agents": {
    "po": {
      "priority": 1,
      "max_tokens_per_request": 4096,
      "cooldown_seconds": 10
    },
    "pm": {
      "priority": 2,
      "max_tokens_per_request": 3072,
      "cooldown_seconds": 15
    },
    "engineer": {
      "priority": 3,
      "max_tokens_per_request": 4096,
      "cooldown_seconds": 20
    },
    "tester": {
      "priority": 4,
      "max_tokens_per_request": 3072,
      "cooldown_seconds": 20
    },
    "qa": {
      "priority": 5,
      "max_tokens_per_request": 2048,
      "cooldown_seconds": 30
    },
    "reviewer": {
      "priority": 6,
      "max_tokens_per_request": 3072,
      "cooldown_seconds": 25
    }
  },
  "strategies": {
    "burst_protection": true,
    "adaptive_throttling": true,
    "priority_queue": true
  }
}
EOF
fi

# トークン使用量の推定値を表示
echo "📊 Token Limit Configuration:"
echo "-----------------------------"
jq -r '.agents | to_entries[] | "\(.key): max \(.value.max_tokens_per_request) tokens, \(.value.cooldown_seconds)s cooldown"' "$CONFIG_FILE"

echo
echo "🎯 Strategies enabled:"
jq -r '.strategies | to_entries[] | select(.value == true) | "- \(.key)"' "$CONFIG_FILE"

echo
echo "💡 Tips for token management:"
echo "- Use shorter prompts when possible"
echo "- Implement request queuing between agents"
echo "- Monitor API rate limit responses"
echo "- Consider using Claude Sonnet for less critical tasks"
echo
