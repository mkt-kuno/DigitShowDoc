# DigitShow Modbus（v4.6.x）のいろは

DigitShow Modbusは、生研式の三軸試験装置やねじりせん断試験装置を制御するためのソフトウェアです。

## 著者

- **Makoto KUNO** - 東京大学生産技術研究所桑野研究室技術職員 - [GitHub](https://github.com/mkt-kuno)
- **Hiroyuki HASHIMOTO** - 東京大学生産技術研究所桑野研究室博士課程 - [GitHub](https://github.com/Hiroyuki-Hashimoto)
- **Kohei MASHITA** - 東京大学生産技術研究所桑野研究室修士課程 - [GitHub](https://github.com/k-mashita)

![桑野研究室ロゴ](img/kuwanolab-logo.png)

## 目次

本ドキュメントは以下の章で構成されています：

1. **[クイックスタート](quickstart.md)** - 基本的な使い方と試験の実施手順
2. **[ユーザーマニュアル](user_manual.md)** - 詳細な機能説明と操作方法
3. **[デベロッパーマニュアル](developer_manual.md)** - ハードウェア設計者・ソフトウェア開発者向け情報
4. **[Markdown編集ガイド](markdown_guide.md)** - 本ドキュメントの編集方法

## クイックスタート

生研式の三軸試験装置を用いて飽和供試体の三軸圧縮試験を行う際の基本的な使い方は、[クイックスタート](quickstart.md)を参照してください。

主な手順：

1. ショートカットの作成と起動時変数の設定
2. アプリケーションの起動
3. センサーのキャリブレーション
4. 供試体寸法の入力
5. 圧密の実施
6. 軸圧縮試験の実施

## ユーザーマニュアル

より詳細な機能説明、各ウィンドウの説明、制御コマンドの詳細については、[ユーザーマニュアル](user_manual.md)を参照してください。

主な内容：

- 動作モードと背景色
- 起動時変数の設定
- センサーと入出力チャンネル構成
- 供試体寸法・ひずみ・応力の計算式
- 各ウィンドウの説明
- コントロール機能の詳細

## デベロッパーマニュアル

ハードウェア設計者やソフトウェア開発者向けの情報は、[デベロッパーマニュアル](developer_manual.md)を参照してください。

主な内容：

- すべての起動時変数の詳細
- Visual Studio 2022 環境構築
- ソースコードの取得とビルド方法
- コントロールの追加・修正方法
- Modbusボードの仕様と説明
- 各ICの性能と詳細
- Webサーバー機能

## ソフトウェアのダウンロード

- **メインソフトウェア**: [DigitShowModbus](https://github.com/mkt-kuno/DigitShowModbus)
- **Webビューアー**: [DigitShowWebview](https://github.com/mkt-kuno/DigitShowWebview)

## Published PDF（過去版）

過去のLaTeX版PDFドキュメントは以下を参照してください：
https://mkt-kuno.github.io/DigitShowDoc/

## ライセンス

本ドキュメントの詳細については、各ソフトウェアリポジトリを参照してください。

## お問い合わせ

質問や問題がある場合は、以下の方法でお問い合わせください：

- GitHubのIssueを作成
- 著者に直接連絡

---

**最終更新**: 2024年

**ドキュメントバージョン**: Markdown版（LaTeXから移行）
