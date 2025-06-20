# マルチエージェントAI開発環境

Claude Code CLIとtmuxを用いて、複数のAIエージェントが協働する開発環境を構築するためのツールセットです。

## 概要

このプロジェクトでは、以下の6つの役割を持つAIエージェントが並行して作業します：

- **Product Owner (PO)**: プロダクトビジョンと要求定義
- **Project Manager (PM)**: タスク管理とスケジュール策定
- **Engineer**: コード実装
- **Tester**: テストコード作成と実行
- **QA**: 品質保証と受け入れテスト
- **Reviewer**: コードレビュー

## 必要な環境

- Node.js 18以上
- Claude Code CLI (`@anthropic-ai/claude-code`)
- tmux
- Git
- GitHub CLI (`gh`)

## セットアップ

### 1. 依存関係のインストール

```bash
# Claude Code CLIをインストール
npm install -g @anthropic-ai/claude-code

# tmuxをインストール (Ubuntu/Debian)
sudo apt install tmux

# tmuxをインストール (macOS)
brew install tmux

# GitHub CLIをインストール
# https://cli.github.com/ の手順に従ってインストール

# 認証設定
gh auth login
```

### 2. プロジェクトのセットアップ

```bash
# リポジトリをクローン
git clone https://github.com/atnagayama/multi-agent-claude-dev.git
cd multi-agent-claude-dev

# セットアップスクリプトを実行
./scripts/setup.sh
```

### 3. エージェントの起動

```bash
# マルチエージェント環境を起動
./scripts/start-agents.sh
```

## ディレクトリ構造

```
.
├── README.md
├── scripts/              # 各種スクリプト
│   ├── setup.sh         # 初期セットアップ
│   ├── start-agents.sh  # エージェント起動
│   └── utils/           # ユーティリティスクリプト
├── config/              # 設定ファイル
│   ├── claude-settings.json
│   └── agent-roles/     # エージェント役割定義
├── templates/           # プロンプトテンプレート
│   └── agents/          # 各エージェント用テンプレート
├── shared/              # 共有ドキュメント
│   └── PROJECT_PLAN.md  # プロジェクト計画書
└── workspaces/          # エージェント別作業ディレクトリ
    ├── po/
    ├── pm/
    ├── engineer/
    ├── tester/
    ├── qa/
    └── reviewer/
```

## 使い方

### 基本的な使用方法

1. `./scripts/start-agents.sh` でエージェントを起動
2. tmuxセッション内で各エージェントと対話
3. 共有ドキュメント (`shared/PROJECT_PLAN.md`) で進捗を管理
4. GitHubでコードレビューとマージを実施

### カスタマイズ

- エージェントの役割: `config/agent-roles/` 内のファイルを編集
- プロンプトテンプレート: `templates/agents/` 内のファイルを編集
- Claude設定: `config/claude-settings.json` を編集

## トークン管理

API制限を避けるため、以下の対策を実施しています：

- エージェントの起動タイミングをずらす
- 出力トークン数の制限
- 定期的な同期による負荷分散

## ライセンス

MIT License
