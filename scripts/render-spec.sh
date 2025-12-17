#!/bin/bash

# render-spec.sh
# 自动替换 spec-template.md 中的占位符的便捷脚本
#
# 使用方法：
#   ./scripts/render-spec.sh
#   或
#   bash scripts/render-spec.sh

set -e  # 遇到错误立即退出

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PROJECT_ROOT"

echo -e "${GREEN}开始渲染 spec-template.md...${NC}"

# 检查 Python3 是否安装
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}错误：未安装 Python3${NC}"
    exit 1
fi

# 检查是否安装了 Jinja2
if ! python3 -c "import jinja2" &> /dev/null; then
    echo -e "${YELLOW}警告：未安装 Jinja2${NC}"
    echo -e "${GREEN}正在安装依赖...${NC}"
    
    # 检查是否有 requirements.txt
    if [ -f "$SCRIPT_DIR/requirements.txt" ]; then
        pip3 install -r "$SCRIPT_DIR/requirements.txt"
    else
        pip3 install jinja2
    fi
    
    echo -e "${GREEN}✓ 依赖安装完成${NC}"
fi

# 运行 Python 脚本
python3 "$SCRIPT_DIR/render-spec.py"

