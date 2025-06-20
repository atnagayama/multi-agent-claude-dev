#!/bin/bash

# Git ワークフロー管理スクリプト
# 各エージェントのブランチ管理とPR作成を自動化

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.."; pwd)"
cd "$PROJECT_ROOT"

echo "=== Git Workflow Manager ==="
echo

# 関数: エージェント用ブランチを作成
create_agent_branch() {
    local agent=$1
    local feature=$2
    local branch_name="agent/$agent/$feature"
    
    echo "Creating branch: $branch_name"
    git checkout -b "$branch_name" main 2>/dev/null || git checkout "$branch_name"
}

# 関数: エージェントの変更をコミット
commit_agent_changes() {
    local agent=$1
    local message=$2
    
    echo "Committing changes for $agent: $message"
    git add .
    git commit -m "[$agent] $message" || echo "No changes to commit"
}

# 関数: プルリクエストを作成
create_pull_request() {
    local agent=$1
    local feature=$2
    local branch_name="agent/$agent/$feature"
    
    echo "Creating pull request for $branch_name"
    gh pr create \
        --base main \
        --head "$branch_name" \
        --title "[$agent] $feature implementation" \
        --body "## Description\n\nImplemented by $agent agent.\n\n## Changes\n\n- Add $feature functionality\n\n## Testing\n\n- [ ] Unit tests passed\n- [ ] Integration tests passed\n- [ ] Code review completed" \
        2>/dev/null || echo "PR already exists or error occurred"
}

# 関数: エージェント間でのコードレビュー
assign_review() {
    local pr_number=$1
    local reviewer_agent=$2
    
    echo "Assigning PR #$pr_number to $reviewer_agent for review"
    # レビュアーをアサイン（実際のGitHubユーザー名が必要）
    # gh pr edit $pr_number --add-reviewer "reviewer-username"
}

# メインメニュー
while true; do
    echo
    echo "Git Workflow Options:"
    echo "1. Create feature branch for agent"
    echo "2. Commit agent changes"
    echo "3. Create pull request"
    echo "4. List all agent branches"
    echo "5. Show PR status"
    echo "6. Exit"
    echo
    read -p "Select option (1-6): " option
    
    case $option in
        1)
            read -p "Agent name (po/pm/engineer/tester/qa/reviewer): " agent
            read -p "Feature name: " feature
            create_agent_branch "$agent" "$feature"
            ;;
        2)
            read -p "Agent name: " agent
            read -p "Commit message: " message
            commit_agent_changes "$agent" "$message"
            ;;
        3)
            read -p "Agent name: " agent
            read -p "Feature name: " feature
            create_pull_request "$agent" "$feature"
            ;;
        4)
            echo "\nAgent branches:"
            git branch -a | grep "agent/" | sort
            ;;
        5)
            echo "\nPull Request Status:"
            gh pr list --state all --limit 10
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
