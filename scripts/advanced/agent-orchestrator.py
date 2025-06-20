#!/usr/bin/env python3
"""
マルチエージェントオーケストレーター
エージェント間の協調と依存関係を管理
"""

import json
import time
import subprocess
import os
from datetime import datetime
from typing import Dict, List, Optional
from dataclasses import dataclass
from enum import Enum

class AgentStatus(Enum):
    IDLE = "idle"
    WORKING = "working"
    WAITING = "waiting"
    COMPLETED = "completed"
    ERROR = "error"

@dataclass
class AgentTask:
    agent: str
    task_id: str
    description: str
    dependencies: List[str]
    status: AgentStatus
    started_at: Optional[datetime] = None
    completed_at: Optional[datetime] = None

class AgentOrchestrator:
    def __init__(self, config_path: str):
        self.config_path = config_path
        self.agents = ["po", "pm", "engineer", "tester", "qa", "reviewer"]
        self.tasks: Dict[str, AgentTask] = {}
        self.load_config()
    
    def load_config(self):
        """設定ファイルを読み込む"""
        with open(self.config_path, 'r') as f:
            self.config = json.load(f)
    
    def create_task(self, agent: str, task_id: str, description: str, dependencies: List[str] = None):
        """新しいタスクを作成"""
        task = AgentTask(
            agent=agent,
            task_id=task_id,
            description=description,
            dependencies=dependencies or [],
            status=AgentStatus.IDLE
        )
        self.tasks[task_id] = task
        return task
    
    def can_start_task(self, task_id: str) -> bool:
        """タスクが開始可能かチェック"""
        task = self.tasks.get(task_id)
        if not task:
            return False
        
        # 依存タスクがすべて完了しているかチェック
        for dep_id in task.dependencies:
            dep_task = self.tasks.get(dep_id)
            if not dep_task or dep_task.status != AgentStatus.COMPLETED:
                return False
        
        return task.status == AgentStatus.IDLE
    
    def start_task(self, task_id: str):
        """タスクを開始"""
        task = self.tasks[task_id]
        task.status = AgentStatus.WORKING
        task.started_at = datetime.now()
        
        # エージェントにタスクを送信
        self.send_task_to_agent(task)
    
    def send_task_to_agent(self, task: AgentTask):
        """エージェントにタスクを送信"""
        message = f"新しいタスク: {task.task_id}\n{task.description}"
        
        # tmuxペインにメッセージを送信
        pane_index = self.agents.index(task.agent)
        cmd = f'tmux send-keys -t claude_agents:0.{pane_index} "{message}" C-m'
        subprocess.run(cmd, shell=True)
    
    def complete_task(self, task_id: str):
        """タスクを完了"""
        task = self.tasks[task_id]
        task.status = AgentStatus.COMPLETED
        task.completed_at = datetime.now()
        
        # 依存しているタスクをチェック
        self.check_and_start_waiting_tasks()
    
    def check_and_start_waiting_tasks(self):
        """待機中のタスクで開始可能なものを開始"""
        for task_id, task in self.tasks.items():
            if self.can_start_task(task_id):
                self.start_task(task_id)
    
    def get_status_report(self) -> str:
        """現在の状態レポートを生成"""
        report = "=== Task Status Report ===\n\n"
        
        for status in AgentStatus:
            tasks = [t for t in self.tasks.values() if t.status == status]
            if tasks:
                report += f"{status.value.upper()}:\n"
                for task in tasks:
                    report += f"  - [{task.agent}] {task.task_id}: {task.description}\n"
                report += "\n"
        
        return report
    
    def create_dependency_graph(self):
        """依存関係グラフを生成（Mermaid形式）"""
        graph = "graph TD\n"
        
        for task_id, task in self.tasks.items():
            # ノードを追加
            graph += f"    {task_id}[{task.agent}: {task.description}]\n"
            
            # 依存関係を追加
            for dep_id in task.dependencies:
                graph += f"    {dep_id} --> {task_id}\n"
        
        return graph

def main():
    # サンプルワークフローの実行
    orchestrator = AgentOrchestrator("config/orchestrator.json")
    
    # タスクの定義
    orchestrator.create_task("po", "REQ001", "ユーザー認証機能の要件定義")
    orchestrator.create_task("pm", "PLAN001", "認証機能の実装計画", ["REQ001"])
    orchestrator.create_task("engineer", "IMPL001", "認証APIの実装", ["PLAN001"])
    orchestrator.create_task("engineer", "IMPL002", "認証UIの実装", ["PLAN001"])
    orchestrator.create_task("tester", "TEST001", "認証APIのテスト", ["IMPL001"])
    orchestrator.create_task("tester", "TEST002", "認証UIのテスト", ["IMPL002"])
    orchestrator.create_task("qa", "QA001", "認証機能の統合テスト", ["TEST001", "TEST002"])
    orchestrator.create_task("reviewer", "REV001", "認証実装のコードレビュー", ["IMPL001", "IMPL002"])
    
    # 依存関係グラフを出力
    print("\n=== Dependency Graph ===\n")
    print(orchestrator.create_dependency_graph())
    
    # 最初のタスクを開始
    orchestrator.start_task("REQ001")
    
    # ステータスレポートを表示
    print(orchestrator.get_status_report())

if __name__ == "__main__":
    main()
