# Claude Skill: TTS ZipVoice

本地离线零样本文本转语音 Claude Skill，使用 sherpa-onnx ZipVoice 模型，支持声音克隆。

## 安装

将此项目的 `.claude` 目录内容复制到以下位置之一：

**方式一：项目级别安装**
```bash
cp -r .claude/skills/sherpa-onnx-tts-zipvoice /path/to/your/project/.claude/skills/
```

**方式二：全局安装（推荐）**
```bash
cp -r .claude/skills/sherpa-onnx-tts-zipvoice ~/.claude/skills/
```

安装后重启 Claude Code session 即可使用。

## 使用方法

### 在 Claude 中使用

直接说：

> 给我用 skill 生成语音，内容是"我是林志玲，很高兴认识你"

Claude 会自动调用 tts-zipvoice skill 生成语音文件。

### 命令行使用

```bash
.claude/skills/sherpa-onnx-tts-zipvoice/bin/tts_zipvoice.sh "要合成的文本" [输出文件] [参考音频] [参考文本]

# 示例
.claude/skills/sherpa-onnx-tts-zipvoice/bin/tts_zipvoice.sh "你好，世界"
.claude/skills/sherpa-onnx-tts-zipvoice/bin/tts_zipvoice.sh "你好" ./output.wav ./my_voice.wav "这是我的声音"
```

## 功能特点

- 纯离线运行，无需联网
- 支持中文和英文混合输入
- 零样本声音克隆：提供几秒参考音频即可模仿音色
- 便携设计，可复制到其他项目直接使用

## 音频格式转换

参考音频需要转换为 WAV 格式才能被 sherpa-onnx 正确读取。

```bash
# 转换为 24kHz 单声道 PCM WAV（推荐）
ffmpeg -i input.mp3 -acodec pcm_s16le -ar 24000 -ac 1 output.wav
```

| 参数 | 说明 |
|------|------|
| `-acodec pcm_s16le` | 使用 PCM 16-bit 小端编码 |
| `-ar 24000` | 采样率 24kHz，与 ZipVoice 模型匹配，避免内部重采样 |
| `-ac 1` | 单声道，TTS 参考音频通常使用单声道 |

## Git LFS 使用说明

本项目使用 Git LFS 管理大型模型文件（*.onnx）。

### 安装 Git LFS

```bash
# Ubuntu/Debian
sudo apt install git-lfs

# macOS
brew install git-lfs

# 初始化
git lfs install
```

### 克隆仓库

```bash
# 正常克隆，会自动下载 LFS 文件
git clone <repo-url>

# 如果 LFS 文件未下载，手动拉取
git lfs pull
```

### 迁移已有仓库

如果仓库中已有大文件，需要迁移到 LFS：

```bash
# 追踪大文件类型
git lfs track "*.onnx"

# 迁移历史中的大文件到 LFS
git lfs migrate import --include="*.onnx" --everything

# 强制推送（历史已重写）
git push --force
```

## 平台支持

目前仅支持 Linux x86_64 平台。如需其他平台，请从 [sherpa-onnx releases](https://github.com/k2-fsa/sherpa-onnx/releases) 下载对应平台的可执行文件替换 `bin/sherpa-onnx-offline-zeroshot-tts`。