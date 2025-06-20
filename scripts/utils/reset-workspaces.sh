#!/bin/bash

# ワークスペースをリセットするスクリプト

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"

echo "=== Resetting Agent Workspaces ==="
echo
echo "⚠️  WARNING: This will delete all files in agent workspaces!"
echo "Press Ctrl+C to cancel, or Enter to continue..."
read

# 各エージェントのワークスペースをクリーンアップ
echo "🧹 Cleaning workspaces..."
for agent in po pm engineer tester qa reviewer; do
    workspace="$PROJECT_ROOT/workspaces/$agent"
    if [ -d "$workspace" ]; then
        # CLAUDE.mdと.claudeディレクトリは保持
        find "$workspace" -type f ! -name "CLAUDE.md" ! -path "*/.claude/*" -delete 2>/dev/null
        echo "  - Cleaned $agent workspace"
    fi
done

# 共有ドキュメントをリセット
echo
echo "📄 Resetting shared documents..."
if [ -f "$PROJECT_ROOT/shared/PROJECT_PLAN.md" ]; then
    # バックアップを作成
    cp "$PROJECT_ROOT/shared/PROJECT_PLAN.md" "$PROJECT_ROOT/shared/PROJECT_PLAN.md.bak.$(date +%Y%m%d_%H%M%S)"
    
    # テンプレートに戻す
    cat > "$PROJECT_ROOT/shared/PROJECT_PLAN.md" << 'EOF'
# プロジェクト計画書

## プロジェクト概要

[プロジェクトの目的と概要をここに記載]

## エージェント構成

| 役割 | 担当者 | 責任範囲 |
|------|--------|----------|
| Product Owner | PO Agent | プロダクトビジョン、要求定義 |
| Project Manager | PM Agent | タスク管理、スケジュール策定 |
| Engineer | Engineer Agent | コード実装、技術的解決 |
| Tester | Tester Agent | テスト設計、自動テスト実装 |
| QA | QA Agent | 品質保証、受け入れテスト |
| Reviewer | Reviewer Agent | コードレビュー、品質チェック |

## タスク管理

### 進行中のタスク

（ここにタスクを追加）

### 完了したタスク

（完了したタスクをここに移動）

## コミュニケーションログ

### エージェント間メッセージ

（エージェント間のやり取りをここに記録）

## 更新履歴

- [日付] [エージェント名]: [更新内容]
EOF
    echo "  - Reset PROJECT_PLAN.md (backup created)"
fi

echo
echo "✅ Workspace reset completed!"
echo "💡 Run './scripts/setup.sh' if you need to recreate the full structure"
echo
