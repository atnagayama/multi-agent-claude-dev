# よくある質問 (FAQ)

## 一般的な質問

### Q: このシステムは何ですか？

**A:** Claude Code CLIとtmuxを使用して、複数のAIエージェントが協働してソフトウェア開発を行う環境です。人間の開発チームのように、各エージェントが特定の役割（PO、PM、エンジニアなど）を担います。

### Q: どのようなプロジェクトに適していますか？

**A:** 以下のようなプロジェクトに適しています：
- Webアプリケーション開発
- API開発
- プロトタイプ作成
- コードリファクタリング
- ドキュメント作成

### Q: 人間の介入は必要ですか？

**A:** はい、特に以下の場面では人間の介入が推奨されます：
- 初期要件の明確化
- 重要な意思決定
- 最終的な品質確認
- エージェント間の調整

## セットアップ関連

### Q: Claude Code CLIがインストールできません

**A:** 以下を確認してください：
1. Node.js v18以上がインストールされているか
2. npmが正しく動作しているか
3. 管理者権限が必要な場合は`sudo`を使用

```bash
# Node.jsバージョン確認
node --version

# npmで再試行
sudo npm install -g @anthropic-ai/claude-code
```

### Q: 認証エラーが発生します

**A:** 以下の方法を試してください：

1. **Claude.aiアカウントの場合**：
   ```bash
   claude logout
   claude login
   ```

2. **APIキーの場合**：
   ```bash
   export ANTHROPIC_API_KEY="your-key-here"
   ```

### Q: tmuxセッションが作成されません

**A:** 
1. tmuxがインストールされているか確認：`which tmux`
2. 既存セッションを削除：`tmux kill-session -t claude_agents`
3. スクリプトに実行権限を付与：`chmod +x scripts/*.sh`

## 使用方法関連

### Q: エージェントが応答しません

**A:** 以下を確認してください：
1. APIレート制限に達していないか
2. エージェントが正しく起動しているか
3. 共有ドキュメントにタスクが記載されているか

### Q: エージェント間の連携がうまくいきません

**A:** 
1. `shared/PROJECT_PLAN.md`が正しく更新されているか確認
2. 同期コマンドを実行：`./scripts/utils/sync-agents.sh`
3. 各エージェントのCLAUDE.mdを確認

### Q: トークン制限エラーが発生します

**A:** 以下の対策を試してください：
1. `config/token-limits.json`で制限を調整
2. エージェントの起動間隔を増やす
3. 同時実行エージェント数を減らす
4. Claude Sonnetへの切り替えを検討

## トラブルシューティング

### Q: Gitコンフリクトが発生しました

**A:** 
1. 各エージェントが異なるブランチで作業しているか確認
2. ワークツリーを使用して分離
3. マージ前にコンフリクトを解決

```bash
# コンフリクト確認
git status

# ブランチ確認
git branch -a

# ワークツリー確認
git worktree list
```

### Q: エージェントがファイルを編集できません

**A:** 
1. Claude設定でEdit権限が許可されているか確認
2. ファイルのパーミッションを確認
3. ワークスペースが正しく設定されているか確認

### Q: 環境をリセットしたい

**A:** 以下の手順でリセットできます：

```bash
# 1. エージェントを停止
./scripts/utils/stop-agents.sh

# 2. ワークスペースをリセット
./scripts/utils/reset-workspaces.sh

# 3. 再セットアップ
./scripts/setup.sh

# 4. エージェントを再起動
./scripts/start-agents.sh
```

## カスタマイズ関連

### Q: エージェントを追加したい

**A:** 以下の手順で追加できます：

1. テンプレート作成：`templates/agents/new-role.yaml`
2. ワークスペース追加：`workspaces/new-role/`
3. `start-agents.sh`にペイン追加
4. tmuxレイアウト調整

### Q: 特定のモデルを使いたい

**A:** `config/claude-settings.json`で変更できます：

```json
{
  "model": "claude-sonnet-4-20250514",
  "maxTokens": 2048
}
```

### Q: プロンプトをカスタマイズしたい

**A:** 
1. `templates/agents/`内のYAMLファイルを編集
2. `CLAUDE.md`にプロジェクト固有の情報を追加
3. 各エージェントの起動プロンプトを調整

## パフォーマンス関連

### Q: 処理が遅い

**A:** 
1. 同時実行エージェント数を減らす
2. タスクを小さく分割
3. 不要なログ出力を削減
4. キャッシュを活用

### Q: メモリ使用量が多い

**A:** 
1. 定期的にコンテキストをクリア
2. 不要なファイルを削除
3. `./scripts/utils/collect-outputs.sh`で出力を整理

## セキュリティ関連

### Q: APIキーを安全に管理したい

**A:** 
1. 環境変数を使用
2. `.env`ファイルで管理（.gitignoreに追加）
3. シークレット管理ツールの使用
4. 定期的なキーローテーション

### Q: プライベートリポジトリで使いたい

**A:** 
1. GitHub認証を設定
2. SSHキーを設定
3. 適切なアクセス権限を付与

## その他

### Q: ログはどこにありますか？

**A:** 
- tmuxセッション内：各ペインの出力
- 共有ドキュメント：`shared/PROJECT_PLAN.md`
- 収集した出力：`outputs/`ディレクトリ

### Q: バックアップを取りたい

**A:** 
```bash
# 出力を収集
./scripts/utils/collect-outputs.sh

# Gitでコミット
git add -A
git commit -m "Backup: $(date)"
git push
```

### Q: コミュニティサポートはありますか？

**A:** 
- GitHubのIssues: バグ報告や機能要望
- Discussions: 質問や議論
- Wiki: 追加ドキュメント

### Q: ライセンスは？

**A:** MITライセンスです。自由に使用、変更、配布できます。

## 連絡先

追加の質問がある場合は、GitHubリポジトリでIssueを作成してください：
https://github.com/atnagayama/multi-agent-claude-dev/issues
