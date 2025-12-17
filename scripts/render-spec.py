#!/usr/bin/env python3
"""
render-spec.py
使用 Jinja2 模板引擎自动替换 spec-template.md 中的占位符，基于 project.config.json 的值

使用方法：
    python3 scripts/render-spec.py
    或
    ./scripts/render-spec.py

输出：
    - spec-template-rendered.md：替换占位符后的文件（保留原模板不变）
"""

import json
import sys
from pathlib import Path

try:
    from jinja2 import Template, Environment, FileSystemLoader
except ImportError:
    print("错误：未安装 Jinja2")
    print("请运行：pip install jinja2")
    sys.exit(1)


def main():
    # 获取脚本所在目录和项目根目录
    script_dir = Path(__file__).parent
    project_root = script_dir.parent

    # 切换到项目根目录
    import os
    os.chdir(project_root)

    print("开始渲染 spec-template.md...")

    # 检查必要文件是否存在
    config_file = project_root / "project.config.json"
    template_file = project_root / "spec-template.md"

    if not config_file.exists():
        print(f"错误：找不到 {config_file}")
        sys.exit(1)

    if not template_file.exists():
        print(f"错误：找不到 {template_file}")
        sys.exit(1)

    # 读取 project.config.json
    try:
        with open(config_file, 'r', encoding='utf-8') as f:
            config = json.load(f)
    except json.JSONDecodeError as e:
        print(f"错误：无法解析 {config_file}: {e}")
        sys.exit(1)

    # 验证必需的配置项
    required_keys = ['github_owner', 'repo_name', 'default_branch', 'vercel_project_name']
    missing_keys = [key for key in required_keys if key not in config or not config[key]]

    if missing_keys:
        print(f"错误：缺少必需的配置项: {', '.join(missing_keys)}")
        sys.exit(1)

    print("配置值：")
    for key in required_keys:
        print(f"  {key}: {config[key]}")

    # 读取模板文件
    try:
        with open(template_file, 'r', encoding='utf-8') as f:
            template_content = f.read()
    except Exception as e:
        print(f"错误：无法读取 {template_file}: {e}")
        sys.exit(1)

    # 使用 Jinja2 渲染模板
    try:
        template = Template(template_content)
        rendered_content = template.render(**config)
    except Exception as e:
        print(f"错误：模板渲染失败: {e}")
        sys.exit(1)

    # 写入渲染后的文件
    output_file = project_root / "spec-template-rendered.md"
    try:
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(rendered_content)
    except Exception as e:
        print(f"错误：无法写入 {output_file}: {e}")
        sys.exit(1)

    # 验证是否还有未替换的占位符
    import re
    remaining_placeholders = re.findall(r'\{\{[^}]+\}\}', rendered_content)

    if remaining_placeholders:
        print("\n警告：发现未替换的占位符：")
        for placeholder in set(remaining_placeholders):
            print(f"  {placeholder}")
    else:
        print("\n✓ 所有占位符已成功替换")

    # 统计替换次数
    print("\n替换统计：")
    for key in required_keys:
        count = rendered_content.count(config[key])
        print(f"  {key}: {count} 处")

    print(f"\n✓ 渲染完成！")
    print(f"输出文件：{output_file}")
    print("提示：原模板文件 spec-template.md 保持不变")


if __name__ == '__main__':
    main()

