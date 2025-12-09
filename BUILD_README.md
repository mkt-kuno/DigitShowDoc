# ビルドスクリプトの使い方 / Build Script Usage

このディレクトリには、MarkdownファイルからHTMLを生成するためのビルドスクリプトが含まれています。

## 前提条件 / Prerequisites

- **Node.js** がインストールされていること（バージョン 14 以上推奨）
- または **Docker** がインストールされていること

## 使い方 / Usage

### Windows の場合

PowerShellを使用してビルドスクリプトを実行します：

```powershell
# PowerShellで実行
.\build-html.ps1
```

または、VSCodeのタスクから実行：
1. `Ctrl+Shift+P` でコマンドパレットを開く
2. "Tasks: Run Task" を選択
3. "Build HTML from Markdown (Windows)" を選択

### Linux/Mac の場合

Bashスクリプトを実行します：

```bash
# ターミナルで実行
./build-html.sh
```

または、VSCodeのタスクから実行：
1. `Ctrl+Shift+P` でコマンドパレットを開く
2. "Tasks: Run Task" を選択
3. "Build HTML from Markdown (Linux/Mac)" を選択

### Docker を使用する場合

どのOSでも同じように動作します：

```bash
# Dockerで実行
docker run --rm -v $(pwd):/work -w /work node:20-alpine sh -c "apk add --no-cache bash && chmod +x build-html.sh && ./build-html.sh"
```

または、VSCodeのタスクから実行：
1. `Ctrl+Shift+P` でコマンドパレットを開く
2. "Tasks: Run Task" を選択
3. "Build HTML from Markdown (Docker)" を選択

## VSCode タスク / VSCode Tasks

`.vscode/tasks.json` に以下のタスクが定義されています：

### 利用可能なタスク / Available Tasks

1. **Build HTML from Markdown (Windows)** - デフォルトビルドタスク
   - `Ctrl+Shift+B` で実行可能
   - PowerShellスクリプトを使用

2. **Build HTML from Markdown (Linux/Mac)**
   - Bashスクリプトを使用

3. **Build HTML from Markdown (Docker)**
   - Dockerコンテナ内でビルド
   - クリーンな環境で実行

4. **Open documentation in browser**
   - 生成されたHTMLをブラウザで開く

5. **Build and Open**
   - ビルドしてからブラウザで開く（連続実行）

### デフォルトビルドタスク

`Ctrl+Shift+B` (Windows) または `Cmd+Shift+B` (Mac) でデフォルトビルドタスクを実行できます。

## 生成されるファイル / Generated Files

スクリプトを実行すると、`docs/` ディレクトリに以下のファイルが生成されます：

- `docs/index.html` - メインページ
- `docs/quickstart.html` - クイックスタート
- `docs/user_manual.html` - ユーザーマニュアル
- `docs/developer_manual.html` - デベロッパーマニュアル
- `docs/markdown_guide.html` - Markdown編集ガイド
- `docs/img/` - 画像ディレクトリ（コピー）

## スクリプトの動作 / How It Works

1. `marked` パッケージをインストール（初回のみ）
2. `docs/` ディレクトリを作成
3. `img/` ディレクトリを `docs/` にコピー
4. すべての `.md` ファイルをHTMLに変換
5. 各HTMLファイルにナビゲーションメニューとスタイルを追加
6. 内部リンク（`.md`）を `.html` に自動変換

## トラブルシューティング / Troubleshooting

### Windows で実行できない場合

PowerShellの実行ポリシーを確認してください：

```powershell
# 現在の実行ポリシーを確認
Get-ExecutionPolicy

# 必要に応じて実行ポリシーを変更（管理者権限が必要）
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### marked がインストールできない場合

手動でインストールしてください：

```bash
npm install marked
```

### Docker が起動しない場合

Dockerデーモンが起動しているか確認してください：

```bash
docker --version
docker ps
```

## GitHub Actions との連携

これらのスクリプトは、GitHub Actionsワークフロー (`.github/workflows/build.yml`) と同じロジックを使用しています。ローカルでビルドした結果は、GitHub Pagesにデプロイされる内容と同じになります。
