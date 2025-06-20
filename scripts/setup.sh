#!/bin/bash

# マルチエージェントAI開発環境のセットアップスクリプト

set -e

echo "=== Multi-Agent AI Development Environment Setup ==="
echo

# プロジェクトルートディレクトリ
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.."; pwd)"
cd "$PROJECT_ROOT"

# 1. 必要なディレクトリの作成
echo "Creating directory structure..."
mkdir -p workspaces/{po,pm,engineer,tester,qa,reviewer}
mkdir -p config/agent-roles
mkdir -p templates/agents
mkdir -p shared
mkdir -p scripts/utils

# 2. Claude設定ファイルの作成
echo "Creating Claude configuration..."
if [ ! -f config/claude-settings.json ]; then
    cat > config/claude-settings.json << 'EOF'
{
  "allowedTools": [
    "Edit",
    "Write",
    "Bash(git add:*)",
    "Bash(git commit:*)",
    "Bash(git push:*)",
    "Bash(git checkout:*)",
    "Bash(git branch:*)",
    "Bash(git status:*)",
    "Bash(git pull:*)",
    "Bash(gh pr create:*)",
    "Bash(gh pr view:*)",
    "Bash(gh pr merge:*)",
    "Bash(npm test:*)",
    "Bash(npm run:*)",
    "Bash(pytest:*)",
    "Bash(make:*)"
  ],
  "model": "claude-opus-4-20250514",
  "maxTokens": 4096,
  "temperature": 0.7
}
EOF
fi

# 3. 共有ドキュメントの初期化
echo "Initializing shared documents..."
if [ ! -f shared/PROJECT_PLAN.md ]; then
    cat > shared/PROJECT_PLAN.md << 'EOF'
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
fi

# 4. CLAUDE.mdファイルの作成（全エージェント共通の記憶）
echo "Creating CLAUDE.md for agent memory..."
if [ ! -f CLAUDE.md ]; then
    cat > CLAUDE.md << 'EOF'
# Multi-Agent AI Development Team Configuration

## Team Structure

This is a multi-agent AI development environment where 6 Claude agents work collaboratively:

1. **Product Owner (PO)**: Defines product vision and requirements
2. **Project Manager (PM)**: Manages tasks and schedules
3. **Engineer**: Implements code and technical solutions
4. **Tester**: Designs and implements automated tests
5. **QA**: Ensures quality and performs acceptance testing
6. **Reviewer**: Reviews code and ensures quality standards

## Working Rules

- Each agent works in their own git branch
- Communication happens through `shared/PROJECT_PLAN.md`
- All changes must be committed with meaningful messages
- Pull requests are used for integration
- Regular synchronization through the shared document

## Important Notes

- **IMPORTANT**: Always check `shared/PROJECT_PLAN.md` before starting work
- **IMPORTANT**: Update your section in the shared document after completing tasks
- **IMPORTANT**: Coordinate with other agents through comments in the shared document
EOF
fi

# 5. 各エージェント用のCLAUDE.mdをワークスペースにコピー
echo "Setting up agent workspaces..."
for agent in po pm engineer tester qa reviewer; do
    cp CLAUDE.md "workspaces/$agent/"
    # .claude ディレクトリを作成して設定をコピー
    mkdir -p "workspaces/$agent/.claude"
    cp config/claude-settings.json "workspaces/$agent/.claude/settings.json"
done

# 6. Gitワークツリーのセットアップ（既存のGitリポジトリ内で作業する場合）
if [ -d .git ]; then
    echo "Setting up Git worktrees..."
    for agent in po pm engineer tester qa reviewer; do
        branch_name="agent/$agent/main"
        if ! git show-ref --verify --quiet "refs/heads/$branch_name"; then
            git branch "$branch_name" 2>/dev/null || true
        fi
        if [ ! -d "../multi-agent-$agent" ]; then
            git worktree add "../multi-agent-$agent" "$branch_name" 2>/dev/null || true
        fi
    done
fi

# 7. 実行権限の付与
echo "Setting executable permissions..."
chmod +x scripts/*.sh
chmod +x scripts/utils/*.sh 2>/dev/null || true

echo
echo "✅ Setup completed successfully!"
echo
echo "Next steps:"
echo "1. Configure your Anthropic API key or authenticate with Claude"
echo "2. Run './scripts/start-agents.sh' to start the multi-agent environment"
echo "3. Use tmux commands to navigate between agent panes"
echo
