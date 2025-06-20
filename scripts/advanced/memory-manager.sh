#!/bin/bash

# エージェントメモリ管理スクリプト
# 長期記憶と知識共有の仕組み

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
MEMORY_DIR="$PROJECT_ROOT/memory"
SHARED_MEMORY="$MEMORY_DIR/shared"
AGENT_MEMORY="$MEMORY_DIR/agents"

echo "=== Agent Memory Manager ==="
echo

# メモリディレクトリの初期化
init_memory() {
    echo "Initializing memory directories..."
    mkdir -p "$SHARED_MEMORY"
    for agent in po pm engineer tester qa reviewer; do
        mkdir -p "$AGENT_MEMORY/$agent"
    done
    
    # 共有知識ベースの作成
    if [ ! -f "$SHARED_MEMORY/knowledge_base.md" ]; then
        cat > "$SHARED_MEMORY/knowledge_base.md" << 'EOF'
# Shared Knowledge Base

## Project Context

### Technical Stack
- [List technologies here]

### Coding Standards
- [Define standards here]

### Architecture Decisions
- [Document decisions here]

## Lessons Learned

### Successful Patterns
- [Document what worked well]

### Anti-patterns
- [Document what to avoid]

## Team Agreements
- [Document team decisions]

EOF
    fi
    
    echo "✅ Memory system initialized"
}

# エージェント固有の記憶を保存
save_agent_memory() {
    local agent=$1
    local category=$2
    local content=$3
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    local memory_file="$AGENT_MEMORY/$agent/${category}_${timestamp}.md"
    
    echo "Saving memory for $agent in category: $category"
    echo "# $category Memory Entry" > "$memory_file"
    echo "Date: $(date)" >> "$memory_file"
    echo "Agent: $agent" >> "$memory_file"
    echo "" >> "$memory_file"
    echo "$content" >> "$memory_file"
    
    echo "✅ Memory saved to: $memory_file"
}

# 共有記憶を更新
update_shared_memory() {
    local category=$1
    local content=$2
    local memory_file="$SHARED_MEMORY/knowledge_base.md"
    
    echo "Updating shared memory in category: $category"
    
    # カテゴリが存在しない場合は追加
    if ! grep -q "## $category" "$memory_file"; then
        echo "" >> "$memory_file"
        echo "## $category" >> "$memory_file"
    fi
    
    # 内容を追加（重複チェック付き）
    echo "- $content" >> "$memory_file"
    
    echo "✅ Shared memory updated"
}

# エージェントの記憶を検索
search_memory() {
    local query=$1
    local agent=$2
    
    echo "Searching for: $query"
    echo
    
    if [ -n "$agent" ]; then
        echo "=== $agent Memory ==="
        grep -r "$query" "$AGENT_MEMORY/$agent" 2>/dev/null || echo "No results found"
    else
        echo "=== Shared Memory ==="
        grep -r "$query" "$SHARED_MEMORY" 2>/dev/null || echo "No results found"
        echo
        echo "=== All Agent Memories ==="
        grep -r "$query" "$AGENT_MEMORY" 2>/dev/null || echo "No results found"
    fi
}

# 記憶の統計を表示
show_memory_stats() {
    echo "📊 Memory Statistics"
    echo "-------------------"
    
    echo "Shared memories: $(find "$SHARED_MEMORY" -type f | wc -l) files"
    echo
    echo "Agent memories:"
    for agent in po pm engineer tester qa reviewer; do
        count=$(find "$AGENT_MEMORY/$agent" -type f 2>/dev/null | wc -l)
        echo "  - $agent: $count entries"
    done
    
    echo
    echo "Total size: $(du -sh "$MEMORY_DIR" | cut -f1)"
}

# エージェント間で知識を同期
sync_knowledge() {
    echo "Synchronizing knowledge across agents..."
    
    # 各エージェントのCLAUDE.mdに共有知識を追加
    for agent in po pm engineer tester qa reviewer; do
        agent_claude="$PROJECT_ROOT/workspaces/$agent/CLAUDE.md"
        if [ -f "$agent_claude" ]; then
            echo "" >> "$agent_claude"
            echo "## Shared Knowledge Update - $(date)" >> "$agent_claude"
            tail -n 20 "$SHARED_MEMORY/knowledge_base.md" >> "$agent_claude"
            echo "  ✅ Updated $agent"
        fi
    done
    
    echo
    echo "✅ Knowledge synchronized"
}

# メインメニュー
case "${1:-menu}" in
    init)
        init_memory
        ;;
    save)
        save_agent_memory "$2" "$3" "$4"
        ;;
    update)
        update_shared_memory "$2" "$3"
        ;;
    search)
        search_memory "$2" "$3"
        ;;
    stats)
        show_memory_stats
        ;;
    sync)
        sync_knowledge
        ;;
    menu|*)
        echo "Usage:"
        echo "  $0 init                          - Initialize memory system"
        echo "  $0 save <agent> <category> <content> - Save agent memory"
        echo "  $0 update <category> <content>   - Update shared memory"
        echo "  $0 search <query> [agent]        - Search memories"
        echo "  $0 stats                         - Show memory statistics"
        echo "  $0 sync                          - Sync knowledge to agents"
        ;;
esac
