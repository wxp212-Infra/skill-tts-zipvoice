# TTS ZipVoice

基于 Sherpa-ONNX ZipVoice 的零样本 TTS 语音合成工具。

## 音频格式转换

参考音频需要转换为 WAV 格式才能被 sherpa-onnx 正确读取。

### FFmpeg 转换命令

```bash
# 转换为 24kHz 单声道 PCM WAV（推荐）
ffmpeg -i input.mp3 -acodec pcm_s16le -ar 24000 -ac 1 output.wav
```

### 参数说明

| 参数 | 说明 |
|------|------|
| `-acodec pcm_s16le` | 使用 PCM 16-bit 小端编码 |
| `-ar 24000` | 采样率 24kHz，与 ZipVoice 模型匹配，避免内部重采样 |
| `-ac 1` | 单声道，TTS 参考音频通常使用单声道 |

### 示例

```bash
# 批量转换 temple 目录下的 mp3 文件
for f in temple/*.mp3; do
    ffmpeg -i "$f" -acodec pcm_s16le -ar 24000 -ac 1 "${f%.mp3}.wav"
done
```

## 使用方法

```bash
./tts_zipvoice.sh "要合成的文本" [输出文件] [参考音频] [参考文本]

# 示例
./tts_zipvoice.sh "你好，世界"
./tts_zipvoice.sh "你好" ./output.wav ./temple/linzhiling14.wav "你很厉害吗？可以带我吃鸡吗？"
```