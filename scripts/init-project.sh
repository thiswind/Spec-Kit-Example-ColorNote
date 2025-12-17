#!/bin/bash

# init-project.sh
# 初始化项目：删除模板仓库的 .git/，重新初始化 Git 并连接到用户的项目仓库
# 从 project.config.json 读取配置信息
#
# 使用方法：
#   ./scripts/init-project.sh

set -e  # 遇到错误立即退出

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PROJECT_ROOT"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}项目初始化脚本${NC}"
echo -e "${BLUE}========================================${NC}\n"

# 检查 project.config.json 是否存在
CONFIG_FILE="$PROJECT_ROOT/project.config.json"
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${RED}错误：找不到 project.config.json${NC}"
    echo -e "${YELLOW}请先创建并填写 project.config.json 文件${NC}"
    exit 1
fi

# 读取 project.config.json
echo -e "${GREEN}读取 project.config.json...${NC}"

# 检查是否安装了 jq
if command -v jq &> /dev/null; then
    GITHUB_OWNER=$(jq -r '.github_owner' "$CONFIG_FILE")
    REPO_NAME=$(jq -r '.repo_name' "$CONFIG_FILE")
    BRANCH_NAME=$(jq -r '.default_branch' "$CONFIG_FILE")
    VERCEL_PROJECT_NAME=$(jq -r '.vercel_project_name' "$CONFIG_FILE" 2>/dev/null || echo "")
elif command -v python3 &> /dev/null; then
    GITHUB_OWNER=$(python3 -c "import json; print(json.load(open('$CONFIG_FILE'))['github_owner'])")
    REPO_NAME=$(python3 -c "import json; print(json.load(open('$CONFIG_FILE'))['repo_name'])")
    BRANCH_NAME=$(python3 -c "import json; print(json.load(open('$CONFIG_FILE'))['default_branch'])")
    VERCEL_PROJECT_NAME=$(python3 -c "import json; c=json.load(open('$CONFIG_FILE')); print(c.get('vercel_project_name', ''))" 2>/dev/null || echo "")
else
    echo -e "${RED}错误：需要安装 jq 或 python3 来解析 JSON${NC}"
    echo -e "${YELLOW}请安装其中一个：${NC}"
    echo -e "  macOS: brew install jq"
    echo -e "  或使用 Python3（通常已预装）"
    exit 1
fi

# 验证必需的配置项
if [ -z "$GITHUB_OWNER" ] || [ "$GITHUB_OWNER" == "null" ]; then
    echo -e "${RED}错误：project.config.json 中缺少或无效的 github_owner${NC}"
    exit 1
fi

if [ -z "$REPO_NAME" ] || [ "$REPO_NAME" == "null" ]; then
    echo -e "${RED}错误：project.config.json 中缺少或无效的 repo_name${NC}"
    exit 1
fi

if [ -z "$BRANCH_NAME" ] || [ "$BRANCH_NAME" == "null" ]; then
    BRANCH_NAME="main"  # 默认值
    echo -e "${YELLOW}警告：未指定 default_branch，使用默认值：main${NC}"
fi

echo -e "${GREEN}配置信息：${NC}"
echo -e "  GitHub Owner: ${GREEN}$GITHUB_OWNER${NC}"
echo -e "  Repository Name: ${GREEN}$REPO_NAME${NC}"
echo -e "  Default Branch: ${GREEN}$BRANCH_NAME${NC}"
echo ""

# 检查是否已经存在 .git 目录
if [ -d ".git" ]; then
    echo -e "${YELLOW}检测到 .git/ 目录${NC}"
    
    # 检查是否是模板仓库的 Git
    CURRENT_REMOTE=$(git remote get-url origin 2>/dev/null || echo "")
    
    if [[ "$CURRENT_REMOTE" == *"Spec-Kit-Example-ColorNote"* ]] || [[ "$CURRENT_REMOTE" == *"thiswind/Spec-Kit-Example-ColorNote"* ]]; then
        echo -e "${YELLOW}这是模板仓库的 Git 历史，需要删除并重新初始化${NC}"
        echo -e "${GREEN}删除 .git/ 目录...${NC}"
        rm -rf .git
        echo -e "${GREEN}✓ 已删除模板仓库的 Git 历史${NC}"
    else
        echo -e "${YELLOW}警告：检测到已存在的 Git 仓库${NC}"
        echo -e "  当前 remote origin: $CURRENT_REMOTE"
        read -p "是否继续删除并重新初始化？(y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}已取消操作${NC}"
            exit 0
        fi
        rm -rf .git
        echo -e "${GREEN}✓ 已删除现有 Git 历史${NC}"
    fi
else
    echo -e "${GREEN}未检测到 .git/ 目录，直接初始化${NC}"
fi

# 初始化 Git 仓库
echo -e "\n${GREEN}初始化 Git 仓库...${NC}"
git init

# 设置默认分支
echo -e "${GREEN}设置默认分支为 $BRANCH_NAME...${NC}"
git branch -M "$BRANCH_NAME"

# 添加远程仓库
REMOTE_URL="https://github.com/$GITHUB_OWNER/$REPO_NAME.git"
echo -e "${GREEN}添加远程仓库...${NC}"
echo -e "  origin: $REMOTE_URL"
git remote add origin "$REMOTE_URL"

# 验证 project.config.json 配置是否正确
echo -e "\n${GREEN}验证 project.config.json 配置...${NC}"
echo -e "  github_owner: ${GREEN}$GITHUB_OWNER${NC}"
echo -e "  repo_name: ${GREEN}$REPO_NAME${NC}"
echo -e "  default_branch: ${GREEN}$BRANCH_NAME${NC}"
if [ -n "$VERCEL_PROJECT_NAME" ] && [ "$VERCEL_PROJECT_NAME" != "null" ]; then
    echo -e "  vercel_project_name: ${GREEN}$VERCEL_PROJECT_NAME${NC}"
fi

# 验证 Git 配置
echo -e "\n${GREEN}验证 Git 配置...${NC}"
CURRENT_REMOTE=$(git remote get-url origin)
CURRENT_BRANCH=$(git branch --show-current)

echo -e "  Remote origin: ${GREEN}$CURRENT_REMOTE${NC}"
echo -e "  Current branch: ${GREEN}$CURRENT_BRANCH${NC}"

if [[ "$CURRENT_REMOTE" == *"$GITHUB_OWNER/$REPO_NAME"* ]]; then
    echo -e "\n${GREEN}✓ Git 配置正确！${NC}"
else
    echo -e "\n${RED}✗ Git 配置可能不正确，请检查${NC}"
    exit 1
fi

echo -e "\n${BLUE}========================================${NC}"
echo -e "${GREEN}项目初始化完成！${NC}"
echo -e "${BLUE}========================================${NC}\n"

echo -e "${YELLOW}下一步：${NC}"
echo -e "1. 确保 GitHub 仓库 $GITHUB_OWNER/$REPO_NAME 已创建"
echo -e "2. 填写 project.config.json（如果还未完成）"
echo -e "3. 运行 ./scripts/render-spec.sh 替换占位符"
echo -e "4. 创建 .env 文件（参考 env.example）"
echo -e "5. 运行 specify init . 初始化 Spec-Kit"

