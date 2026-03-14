---
name: tts-zipvoice
description: Local zero-shot text-to-speech using sherpa-onnx ZipVoice model (Chinese & English, voice cloning, offline)
---

# TTS ZipVoice - Local Zero-Shot Text-to-Speech

离线零样本文本转语音工具，使用 sherpa-onnx ZipVoice 模型，支持中英文混合输入和声音克隆。

## Usage

```bash
.claude/skills/sherpa-onnx-tts-zipvoice/bin/tts_zipvoice.sh "要转换的文本" [输出文件名] [参考音频] [参考文本]
```

**参数说明:**
- 第一个参数: 要转换的文本（必须）
- 第二个参数: 输出文件名（可选，默认在当前目录生成 generated_zipvoice.wav）
- 第三个参数: 参考音频文件（可选，用于声音克隆，默认使用林志玲声音）
- 第四个参数: 参考音频对应文本（可选）

**示例:**

```bash
# 基本用法 - 使用默认参考音频（林志玲）生成语音
.claude/skills/sherpa-onnx-tts-zipvoice/bin/tts_zipvoice.sh "你好，世界！"

# 指定输出文件
.claude/skills/sherpa-onnx-tts-zipvoice/bin/tts_zipvoice.sh "Hello World" ./output.wav

# 使用自定义参考音频克隆声音
.claude/skills/sherpa-onnx-tts-zipvoice/bin/tts_zipvoice.sh "你好" ./out.wav ./my_voice.wav "这是我的声音"

# 中英文混合
.claude/skills/sherpa-onnx-tts-zipvoice/bin/tts_zipvoice.sh "Hello 你好，This is a test 这是个测试"
```

## Features

- 纯离线运行，无需联网
- 支持中文和英文混合输入
- 零样本声音克隆：提供几秒参考音频即可模仿音色
- 便携设计：整个 skill 目录可复制到其他项目直接使用

## Directory Structure

```
sherpa-onnx-tts-zipvoice/
├── bin/
│   ├── sherpa-onnx-offline-zeroshot-tts  # TTS 可执行文件
│   └── tts_zipvoice.sh                   # 执行脚本
├── model/
│   └── sherpa-onnx-zipvoice-distill-zh-en-emilia/  # ZipVoice 模型
├── template/
│   └── linzhiling_combined.wav           # 默认参考音频（林志玲）
└── SKILL.md
```

## Notes

- 目前仅支持 Linux x86_64 平台
- 参考音频需要 24kHz 单声道 WAV 格式
- 如需其他平台，请从 [sherpa-onnx releases](https://github.com/k2-fsa/sherpa-onnx/releases) 下载对应平台的可执行文件

## Audio Format Conversion

参考音频必须是 WAV 格式，使用以下 ffmpeg 命令转换：

```bash
ffmpeg -i input.mp3 -acodec pcm_s16le -ar 24000 -ac 1 output.wav
```

参数说明：
- `-acodec pcm_s16le`: PCM 16-bit 编码
- `-ar 24000`: 24kHz 采样率（与模型匹配）
- `-ac 1`: 单声道