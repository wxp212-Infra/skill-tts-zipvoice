#!/bin/bash

# TTS语音生成脚本 - 使用ZipVoice零样本中英文模型
#
# 用法:
#   ./tts_zipvoice.sh "要转换的文本" [输出文件名] [参考音频] [参考文本]
#
# 参数说明:
#   $1 - 要转换的文本（必须）
#   $2 - 输出文件名（可选，默认：./generated_zipvoice.wav）
#   $3 - 参考音频文件（可选，用于声音克隆）
#   $4 - 参考音频对应文本（可选）
#
# 示例:
#   ./tts_zipvoice.sh "你好，世界"
#   ./tts_zipvoice.sh "你好，世界" ./output.wav
#   ./tts_zipvoice.sh "你好" ./out.wav ./my_voice.wav "这是我的声音"
#

# 检查参数
if [ $# -eq 0 ]; then
    echo "用法: $0 \"文本\" [输出文件名] [参考音频] [参考文本]"
    echo ""
    echo "示例:"
    echo "  $0 \"你好，世界\""
    echo "  $0 \"你好\" ./output.wav"
    echo "  $0 \"你好\" ./out.wav ./my_voice.wav \"这是我的声音\""
    echo ""
    echo "说明: 支持中英文混合文本，可使用参考音频克隆声音"
    exit 1
fi

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 设置模型路径
MODEL_DIR="$SCRIPT_DIR/../model/sherpa-onnx-zipvoice-distill-zh-en-emilia"
ENCODER="$MODEL_DIR/text_encoder.onnx"
DECODER="$MODEL_DIR/fm_decoder.onnx"
VOCODER="$MODEL_DIR/vocos_24khz.onnx"
TOKENS="$MODEL_DIR/tokens.txt"
LEXICON="$MODEL_DIR/lexicon.txt"
DATA_DIR="$MODEL_DIR/espeak-ng-data"
BINARY="$SCRIPT_DIR/sherpa-onnx-offline-zeroshot-tts"

# 默认参考音频（林志玲声音，8.82秒组合音频）
DEFAULT_PROMPT_AUDIO="$SCRIPT_DIR/../template/linzhiling_combined.wav"
DEFAULT_PROMPT_TEXT="志玲可不是花瓶，人家也是有枪法的。快来救救人家。你很厉害吗？可以带我吃鸡吗？"

# 检查文件是否存在
check_files() {
    for file in "$BINARY" "$ENCODER" "$DECODER" "$VOCODER" "$TOKENS" "$LEXICON" "$DATA_DIR"; do
        if [ ! -e "$file" ]; then
            echo "错误: 文件不存在: $file"
            exit 1
        fi
    done
}

check_files

# 解析参数
TEXT="$1"
OUTPUT="${2:-$PWD/generated_zipvoice.wav}"
PROMPT_AUDIO="${3:-$DEFAULT_PROMPT_AUDIO}"
PROMPT_TEXT="${4:-$DEFAULT_PROMPT_TEXT}"

# 显示输入信息
echo "================================================"
echo "  Sherpa ONNX TTS - ZipVoice零样本模型"
echo "================================================"
echo "文本: $TEXT"
echo "输出: $OUTPUT"
echo "参考音频: $PROMPT_AUDIO"
echo "支持: 中英文混合，声音克隆"
echo "================================================"
echo ""

# 运行TTS
"$BINARY" \
    --zipvoice-encoder="$ENCODER" \
    --zipvoice-decoder="$DECODER" \
    --zipvoice-vocoder="$VOCODER" \
    --zipvoice-tokens="$TOKENS" \
    --zipvoice-lexicon="$LEXICON" \
    --zipvoice-data-dir="$DATA_DIR" \
    --prompt-audio="$PROMPT_AUDIO" \
    --prompt-text="$PROMPT_TEXT" \
    --num-steps=4 \
    --num-threads=4 \
    --output-filename="$OUTPUT" \
    "$TEXT" 2>&1

# 检查是否成功
EXIT_CODE=$?
echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo "✓ 语音生成成功！"
    echo "  文件保存在: $OUTPUT"

    # 检查文件是否生成
    if [ -f "$OUTPUT" ]; then
        SIZE=$(du -h "$OUTPUT" | cut -f1)
        echo "  文件大小: $SIZE"
    fi
else
    echo "✗ 语音生成失败！"
    echo ""
    echo "故障排除提示:"
    echo "1. 检查模型文件是否完整"
    echo "2. 确保有足够的系统内存"
    echo "3. 尝试使用更短的文本"
    echo "4. 检查参考音频格式（需要24kHz单声道PCM WAV）"
    exit 1
fi