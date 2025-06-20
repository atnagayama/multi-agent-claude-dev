#!/bin/bash

# マルチエージェント環境を起動するスクリプト

set -e

# セッション名
SESSION="claude_agents"

# プロジェクトディレクトリ
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.."; pwd)"

echo "=== Starting Multi-Agent Claude Development Environment ==="
echo

# 既存のセッションがあれば削除
if tmux has-session -t $SESSION 2>/dev/null; then
    echo "Killing existing session..."
    tmux kill-session -t $SESSION
fi

# 新規tmuxセッション作成
echo "Creating new tmux session: $SESSION"
tmux new-session -d -s $SESSION -c "$PROJECT_ROOT"

# ウィンドウの名前を設定
tmux rename-window -t $SESSION:0 'Multi-Agent AI Team'

# ペインを作成（6つのエージェント用）
# 最初に3x2のグリッドレイアウトを作成

# 垂直に3分割
tmux split-window -h -t $SESSION:0 -c "$PROJECT_ROOT"
tmux split-window -h -t $SESSION:0.1 -c "$PROJECT_ROOT"

# 各列を水平に2分割
tmux split-window -v -t $SESSION:0.0 -c "$PROJECT_ROOT"
tmux split-window -v -t $SESSION:0.2 -c "$PROJECT_ROOT"
tmux split-window -v -t $SESSION:0.4 -c "$PROJECT_ROOT"

# レイアウトを整える
tmux select-layout -t $SESSION:0 tiled

# 各エージェントのプロンプトを定義
PO_PROMPT='あなたはProduct Ownerです。プロダクトのビジョンと要求を定義する役割を担います。\n\n主な責任:\n- ユーザーストーリーの作成\n- 要件の優先順位付け\n- ステークホルダーとの調整\n\n最初のタスク: shared/PROJECT_PLAN.md を確認し、プロダクトの要件定義を開始してください。'

PM_PROMPT='あなたはProject Managerです。プロジェクト全体の計画と進行管理を担当します。\n\n主な責任:\n- タスクの分割と割り当て\n- スケジュール管理\n- チーム間の調整\n\n最初のタスク: shared/PROJECT_PLAN.md を確認し、POの要件に基づいてタスク計画を作成してください。'

ENGINEER_PROMPT='あなたはEngineerです。技術的な実装を担当します。\n\n主な責任:\n- コードの実装\n- 技術的課題の解決\n- テスト可能なコードの作成\n\n最初のタスク: shared/PROJECT_PLAN.md を確認し、割り当てられたタスクの実装を開始してください。'

TESTER_PROMPT='あなたはTesterです。品質保証のためのテスト設計と実装を担当します。\n\n主な責任:\n- テストケースの設計\n- 自動テストの実装\n- バグの発見と報告\n\n最初のタスク: shared/PROJECT_PLAN.md を確認し、実装されたコードに対するテストを作成してください。'

QA_PROMPT='あなたはQAです。プロダクト全体の品質保証を担当します。\n\n主な責任:\n- 受け入れテストの実施\n- 品質基準の確認\n- リリース判定\n\n最初のタスク: shared/PROJECT_PLAN.md を確認し、品質保証プロセスを開始してください。'

REVIEWER_PROMPT='あなたはReviewerです。コードレビューと技術的な品質向上を担当します。\n\n主な責任:\n- コードレビュー\n- ベストプラクティスの確認\n- 改善提案\n\n最初のタスク: shared/PROJECT_PLAN.md を確認し、提出されたコードのレビューを開始してください。'

# 各ペインでエージェントを起動
echo "Starting agents..."

# Product Owner (ペイン0)
tmux send-keys -t $SESSION:0.0 "cd workspaces/po && claude \"$PO_PROMPT\"" C-m
sleep 2

# Project Manager (ペイン1)
tmux send-keys -t $SESSION:0.1 "cd workspaces/pm && claude \"$PM_PROMPT\"" C-m
sleep 2

# Engineer (ペイン2)
tmux send-keys -t $SESSION:0.2 "cd workspaces/engineer && claude \"$ENGINEER_PROMPT\"" C-m
sleep 2

# Tester (ペイン3)
tmux send-keys -t $SESSION:0.3 "cd workspaces/tester && claude \"$TESTER_PROMPT\"" C-m
sleep 2

# QA (ペイン4)
tmux send-keys -t $SESSION:0.4 "cd workspaces/qa && claude \"$QA_PROMPT\"" C-m
sleep 2

# Reviewer (ペイン5)
tmux send-keys -t $SESSION:0.5 "cd workspaces/reviewer && claude \"$REVIEWER_PROMPT\"" C-m

# セッションにアタッチ
echo
echo "✅ All agents started successfully!"
echo
echo "Attaching to tmux session..."
echo
echo "Tmux key bindings:"
echo "  - Ctrl+b → : Switch between panes with arrow keys"
echo "  - Ctrl+b z : Zoom in/out of current pane"
echo "  - Ctrl+b d : Detach from session"
echo "  - Ctrl+b [ : Enter scroll mode (q to exit)"
echo

tmux attach-session -t $SESSION
