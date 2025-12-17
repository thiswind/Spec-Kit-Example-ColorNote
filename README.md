# Spec-Kit 示例模板：ColorNote 项目

> **这是一个 Spec-Kit 示例模板仓库**，用于演示如何通过 Spec-Kit 进行规范驱动的项目开发。

本仓库提供了完整的 Spec-Kit 规范模板（Constitution / Specify / Plan），帮助你快速开始使用 Spec-Kit 进行 ColorNote 项目的开发。本 README 将指导你如何在自己的项目中使用这些模板文件。

## 🎯 项目目的

本仓库是一个**示例模板项目**，旨在：

- 展示如何使用 Spec-Kit 进行规范驱动开发
- 提供完整的规范模板（Constitution / Specify / Plan）
- 演示如何通过 AI 助手与 Spec-Kit 协作进行开发
- 作为学习 Spec-Kit 的实践案例

## 📋 如何使用本模板

1. **Fork 或 Clone 本仓库**，获取模板文件
2. **创建你自己的 ColorNote 项目**（在 GitHub 上创建新仓库）
3. **在你的项目中初始化 Spec-Kit**：`specify init .`
4. **使用 AI 助手命令**，将 `spec-template.md` 中的内容复制到相应的 Spec-Kit 命令中
5. **开始使用 Spec-Kit 进行开发**

---

## 📁 模板文件说明

本仓库包含以下模板文件：

```text
.
├── env.example              # 环境变量模板（需复制为 .env 并填写）
├── project.config.json      # 项目配置（需填写你的项目信息）
├── spec-template.md         # Spec-Kit 三件套模板（包含占位符）
└── README.md               # 本文件
```

### 文件用途

- **`env.example`**：环境变量配置模板，包含数据库连接、应用环境等配置项
- **`project.config.json`**：项目元信息配置，用于替换 `spec-template.md` 中的占位符
- **`spec-template.md`**：包含 Constitution（项目宪章）、Specify（需求规格）、Plan（实现计划）三个章节的完整模板，包含占位符需要替换

---

## 🚀 使用流程

### 第一步：准备前置条件

在开始之前，请确保以下条件已满足：

#### 1. 安装 Spec-Kit CLI

```bash
# 使用 uv 安装（推荐）
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

# 验证安装
specify init --help
```

#### 2. 准备 GitHub 仓库

- **重要**：本仓库是模板示例，你需要创建**你自己的** ColorNote 项目仓库
- 在 GitHub 上创建目标仓库（可以命名为 `ColorNote` 或其他你喜欢的名称）
- 记录以下信息：
  - 仓库 owner（你的 GitHub 用户名或组织名）
  - 仓库名称（例如 `ColorNote`）
  - 默认分支名（通常是 `main`）

#### 3. 准备 Vercel 项目

- 注册/登录 Vercel 账号
- 创建或准备创建 Vercel Project
- 安装 Vercel CLI（用于本地开发）：

  ```bash
  npm i -g vercel
  ```

#### 4. 准备 TiDB Cloud 数据库

- 注册 TiDB Cloud 账号
- 创建数据库集群，获取连接信息：
  - Host
  - Port（默认 4000）
  - Username
  - Password
- 创建两个数据库：
  - 业务数据库（如 `colornote_db`）
  - 测试数据库（如 `colornote_test_db`，必须与业务库不同）

---

### 第二步：配置项目信息

#### 2.1 填写 `project.config.json`

编辑 `project.config.json`，将占位符替换为你的实际项目信息：

```json
{
    "github_owner": "your-github-username",
    "repo_name": "ColorNote",
    "default_branch": "main",
    "vercel_project_name": "colornote"
}
```

**重要**：这个文件是模板渲染的单一事实来源（SSOT），所有占位符替换都基于此文件。

#### 2.2 处理 `spec-template.md` 中的占位符

在 `spec-template.md` 中，将所有占位符替换为 `project.config.json` 中的实际值：

- `{{github_owner}}` → `project.config.json` 中的 `github_owner`
- `{{repo_name}}` → `project.config.json` 中的 `repo_name`
- `{{default_branch}}` → `project.config.json` 中的 `default_branch`
- `{{vercel_project_name}}` → `project.config.json` 中的 `vercel_project_name`

你可以使用文本编辑器的查找替换功能，或使用命令行工具（如 `sed`）完成替换。

#### 2.3 创建并填写 `.env` 文件

```bash
# 复制模板
cp env.example .env
```

编辑 `.env`，填写真实的数据库连接信息：

```bash
APP_ENV=local
FLASK_ENV=development

DB_HOST=your-tidb-host.tidbcloud.com
DB_PORT=4000
DB_USERNAME=your-username
DB_PASSWORD=your-password

DB_DATABASE=colornote_db
DB_TEST_DATABASE=colornote_test_db

DB_POOL_SIZE=5
DB_MAX_OVERFLOW=10
DB_POOL_RECYCLE=300
DB_CONNECT_TIMEOUT=10
```

**注意**：

- `DB_DATABASE` 和 `DB_TEST_DATABASE` 必须非空且不相同
- 不要将 `.env` 文件提交到 Git（建议添加到 `.gitignore`）

---

### 第三步：在你的项目中初始化 Spec-Kit

在你的 ColorNote 项目目录中，运行以下命令初始化 Spec-Kit：

```bash
# 进入你的项目目录
cd /path/to/your/ColorNote

# 初始化 Spec-Kit
specify init .
```

在初始化过程中，你将被提示选择所使用的 AI 助手（如 Claude、Copilot、Gemini、Codebuddy 等）。

初始化完成后，Spec-Kit 会在你的项目中创建必要的配置文件和目录结构。

---

### 第四步：使用 AI 助手命令导入规范

**这是关键步骤**：使用 AI 助手的 Spec-Kit 命令，将 `spec-template.md` 中已处理好的内容复制到相应的命令中。

#### 4.1 导入 Constitution（项目宪章）

在你的 AI 助手中，使用以下命令：

```text
/speckit.constitution
```

然后将 `spec-template.md` 中 **Constitution 章节**的内容（从 `## Constitution` 开始，到 `---` 之前）复制粘贴到命令中。

**示例**：

```text
/speckit.constitution

## Constitution

**项目名称**：ColorNote - 全栈便利贴应用

**GitHub 仓库名**：`ColorNote`  
**Vercel 项目名**：`colornote`

### 项目元信息（强约束）

- GitHub repository: `your-username/ColorNote`
- Default branch: `main`
- Git remote (origin): `https://github.com/your-username/ColorNote.git`

...（继续复制完整的 Constitution 章节内容）
```

#### 4.2 导入 Specify（需求规格）

在你的 AI 助手中，使用以下命令：

```text
/speckit.specify
```

然后将 `spec-template.md` 中 **Specify 章节**的内容（从 `## Specify` 开始，到 `---` 之前）复制粘贴到命令中。

#### 4.3 导入 Plan（实现计划）

在你的 AI 助手中，使用以下命令：

```text
/speckit.plan
```

然后将 `spec-template.md` 中 **Plan 章节**的内容（从 `## Plan` 开始，到文件末尾）复制粘贴到命令中。

---

### 第五步：使用 Spec-Kit 进行开发

当规范导入完成后，你可以开始使用 Spec-Kit 进行项目开发。

#### 5.1 生成开发任务

使用以下命令将实现计划分解为具体的开发任务：

```text
/speckit.tasks
```

Spec-Kit 会根据你导入的 Plan 内容，生成可执行的开发任务列表。

#### 5.2 开始实现

根据生成的任务列表，开始编写代码。你可以：

- 使用 `/speckit.constitution` 查看项目宪章
- 使用 `/speckit.specify` 查看需求规格
- 使用 `/speckit.plan` 查看实现计划
- 使用 `/speckit.tasks` 查看和管理开发任务

#### 5.3 重要提醒

在开始实现之前，务必完成 Plan 中提到的 Preflight 校验，确保：

- Git 仓库配置正确
- 环境变量配置完整
- 数据库连接正常
- Vercel 本地环境可用

---

## 📝 模板文件详细说明

### `spec-template.md` 结构

模板文件包含三个主要章节：

1. **Constitution（项目宪章）**
   - 项目元信息和强约束（Guardrail）
   - 项目描述与范围
   - 技术栈选型
   - 质量与交付红线

2. **Specify（需求规格）**
   - 功能模块详细需求（CRUD 操作）
   - 移动端适配要求
   - 部署与环境一致性要求
   - 性能要求

3. **Plan（实现计划）**
   - 开发前置校验
   - 架构设计
   - 数据模型设计
   - API 设计
   - 测试方案
   - CI/CD 配置

### 占位符说明

模板中使用的占位符及其来源：

| 占位符 | 来源 | 说明 |
|--------|------|------|
| `{{github_owner}}` | `project.config.json` | GitHub 用户名或组织名 |
| `{{repo_name}}` | `project.config.json` | 仓库名称 |
| `{{default_branch}}` | `project.config.json` | 默认分支名（如 `main`） |
| `{{vercel_project_name}}` | `project.config.json` | Vercel 项目名称 |

---

## ❓ 常见问题

### Q1: 为什么需要提前准备 GitHub / Vercel / TiDB？

因为 Constitution 和 Plan 中将仓库信息、分支名、Vercel 运行方式、TiDB 环境变量校验写成了"强约束/红线"。如果不提前准备，Preflight 校验将无法通过，导致无法开始开发。

### Q2: 为什么要使用 AI 助手命令而不是直接生成文件？

Spec-Kit 的设计理念是通过 AI 助手进行交互式开发。使用 `/speckit.constitution`、`/speckit.specify`、`/speckit.plan` 等命令，可以让 AI 助手理解项目规范，并在后续开发过程中持续引用这些规范，确保实现与规范一致。

### Q3: 如何验证占位符替换是否正确？

替换完成后，检查 `spec-template.md` 中：

- 不再包含任何 `{{...}}` 格式的占位符
- 所有 GitHub 仓库 URL 指向正确的仓库
- 所有分支名与实际仓库分支一致
- Vercel 项目名与实际项目一致

### Q4: 如果修改了 `project.config.json`，需要重新导入吗？

是的。如果修改了 `project.config.json`，需要：

1. 重新替换 `spec-template.md` 中的占位符
2. 重新使用 AI 助手命令导入更新后的规范内容

### Q5: `.env` 文件应该提交到 Git 吗？

**不应该**。`.env` 包含敏感信息（数据库密码等），应该添加到 `.gitignore` 中。只提交 `env.example` 作为模板。

### Q6: 这个仓库是实际项目还是模板？

这是一个**示例模板仓库**（`Spec-Kit-Example-ColorNote`），用于学习和演示 Spec-Kit 的使用方法。你需要：

1. Fork 或 Clone 本仓库，获取模板文件
2. 创建你自己的 ColorNote 项目仓库
3. 在你的项目中初始化 Spec-Kit：`specify init .`
4. 使用 AI 助手命令，将模板内容导入到 Spec-Kit
5. 开始实际的项目开发

本仓库本身不包含实际运行的项目代码，只包含模板文件和配置示例。

### Q7: 支持哪些 AI 助手？

Spec-Kit 支持多种 AI 助手，包括但不限于：

- Claude（Anthropic）
- GitHub Copilot
- Gemini（Google）
- Codebuddy CLI

在运行 `specify init .` 时，你可以选择使用的 AI 助手。

---

## 🔗 相关资源

- [Spec-Kit 官方仓库](https://github.com/github/spec-kit)
- [Spec-Kit 文档](https://github.github.com/spec-kit/)
- [Vercel CLI 文档](https://vercel.com/docs/cli)
- [TiDB Cloud 文档](https://docs.pingcap.com/tidbcloud/)
- [Flask 文档](https://flask.palletsprojects.com/)

---

## 📄 许可证

本项目模板文件遵循相应的开源许可证。使用本模板时，请遵守相关许可证要求。
