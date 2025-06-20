# マルチエージェントAI開発環境

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js Version](https://img.shields.io/badge/node-%3E%3D18.0.0-brightgreen)](https://nodejs.org)
[![Claude](https://img.shields.io/badge/Claude-Opus%204-blue)](https://www.anthropic.com)

Claude Code CLIとtmuxを用いて、複数のAIエージェントが協働する開発環境を構築するためのツールセットです。

## 🌟 特徴

- **6つの専門エージェント**: PO、PM、エンジニア、テスター、QA、レビュアーが協働
- **自動化されたワークフロー**: Git連携、テスト実行、コードレビューを自動化
- **トークン管理**: APIレート制限を考慮した効率的なリソース管理
- **拡張可能**: カスタムエージェントやワークフローの追加が容易
- **リアルタイム協調**: tmuxによる並列実行と共有ドキュメントによる連携

## 📋 必要な環境

- Node.js 18以上
- Claude Code CLI (`@anthropic-ai/claude-code`)
- tmux
- Git
- GitHub CLI (`gh`)
- Anthropic APIキー または Claude.ai Pro/Maxアカウント

## 🚀 クイックスタート

### 1. インストール

```bash
# リポジトリをクローン
git clone https://github.com/atnagayama/multi-agent-claude-dev.git
cd multi-agent-claude-dev

# 依存関係をインストール
npm install -g @anthropic-ai/claude-code

# セットアップを実行
./scripts/setup.sh
```

### 2. 認証設定

```bash
# Claude認証
claude login  # ブラウザ認証

# または APIキー設定
export ANTHROPIC_API_KEY="your-api-key"

# GitHub認証
gh auth login
```

### 3. エージェントの起動

```bash
# マルチエージェント環境を起動
./scripts/start-agents.sh
```

## 📁 プロジェクト構造

```
.
├── scripts/              # 実行スクリプト
│   ├── setup.sh         # 初期セットアップ
│   ├── start-agents.sh  # エージェント起動
│   ├── demo.sh          # デモ実行
│   ├── advanced/        # 高度な機能
│   └── utils/           # ユーティリティ
├── config/              # 設定ファイル
│   ├── claude-settings.json
│   ├── token-limits.json
│   └── orchestrator.json
├── templates/           # エージェントテンプレート
│   └── agents/          # 各役割の定義
├── docs/                # ドキュメント
│   ├── ARCHITECTURE.md
│   ├── SETUP_GUIDE.md
│   ├── BEST_PRACTICES.md
│   └── FAQ.md
├── examples/            # サンプルプロジェクト
│   └── todo-app/        # TODOアプリの例
├── shared/              # 共有ドキュメント
│   └── PROJECT_PLAN.md  # プロジェクト計画
└── workspaces/          # エージェント作業領域
    ├── po/              # Product Owner
    ├── pm/              # Project Manager
    ├── engineer/        # Engineer
    ├── tester/          # Tester
    ├── qa/              # Quality Assurance
    └── reviewer/        # Code Reviewer
```

## 🎯 使用方法

### 基本的なワークフロー

1. **要件定義**: POエージェントが要件を作成
2. **計画**: PMエージェントがタスクを分割・割り当て
3. **実装**: エンジニアエージェントがコードを作成
4. **テスト**: テスターエージェントがテストを実装
5. **レビュー**: レビュアーエージェントがコード品質を確認
6. **品質保証**: QAエージェントが最終確認

### デモの実行

```bash
# Hello Worldアプリのデモを実行
./scripts/demo.sh
```

### 高度な機能

```bash
# エージェント間の同期
./scripts/utils/sync-agents.sh

# メモリシステムの管理
./scripts/advanced/memory-manager.sh

# オーケストレーション
python3 ./scripts/advanced/agent-orchestrator.py
```

## ⚙️ カスタマイズ

### エージェントの役割変更

`templates/agents/`内のYAMLファイルを編集：

```yaml
role: "Custom Agent"
description: |
  カスタムエージェントの説明
guidelines:
  - ガイドライン1
  - ガイドライン2
workflow:
  1: "ステップ1"
  2: "ステップ2"
```

### Claude設定の調整

`config/claude-settings.json`を編集：

```json
{
  "model": "claude-opus-4-20250514",
  "maxTokens": 4096,
  "temperature": 0.7
}
```

### トークン制限の管理

`config/token-limits.json`で各エージェントの制限を設定：

```json
{
  "agents": {
    "engineer": {
      "max_tokens_per_request": 4096,
      "cooldown_seconds": 20
    }
  }
}
```

## 📚 ドキュメント

- [アーキテクチャ説明書](docs/ARCHITECTURE.md) - システム構成の詳細
- [セットアップガイド](docs/SETUP_GUIDE.md) - 詳細なインストール手順
- [ベストプラクティス](docs/BEST_PRACTICES.md) - 効果的な使用方法
- [FAQ](docs/FAQ.md) - よくある質問と回答

## 🤝 コントリビューション

プルリクエストを歓迎します！以下の手順でご協力ください：

1. このリポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

## 📝 ライセンス

このプロジェクトはMITライセンスの下で公開されています。詳細は[LICENSE](LICENSE)ファイルを参照してください。

## 🙏 謝辞

- [Anthropic](https://www.anthropic.com) - Claude APIの提供
- [tmux](https://github.com/tmux/tmux) - ターミナルマルチプレクサ
- コミュニティの皆様 - フィードバックと改善提案

## 📞 サポート

- **Issues**: [GitHub Issues](https://github.com/atnagayama/multi-agent-claude-dev/issues)
- **Discussions**: [GitHub Discussions](https://github.com/atnagayama/multi-agent-claude-dev/discussions)
- **Wiki**: [プロジェクトWiki](https://github.com/atnagayama/multi-agent-claude-dev/wiki)

---

<p align="center">
  Made with ❤️ by Multi-Agent AI Team
</p>
