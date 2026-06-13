---
name: multi-agent-wechat-html
description: Use when 需要创作公众号文章、写文章、/创作 [主题]、多Agent写作，或需要对文章进行HTML排版和去AI味优化。
version: 3.0.0
author: Muru AI
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [multi-agent, wechat, article-writing, html-formatting, anti-ai-flavor, humanized, content-creation]
    related_skills: [multi-agent--skills-factory]
---

# multi-agent-wechat-html v3.0

> 公众号文章"写作 + 排版 + 验证"一体化工作流。
> 由原 `multi-agent-wechat` v2.0 + `wechat-html` v1.0 合并而来。

## Overview

用户给主题 → 主编出"主题三件套" → 用户确认 → 并行调研+评估 → 写手出稿 → 6 维评审 → 5 大排版模式渲染 → verify.sh 跑 12 项 → D 盘归档

**一句话**：从"白纸"到"可直接导入公众号草稿"的完整链路。

## When to Use

**触发词（满足任一即可）**：
- "多 Agent 写作"
- "/创作 [主题]"
- "写文章"
- "公众号文章"
- "帮我写一篇"
- "创作内容"

**不适用于**：
- "多 Agent 做项目" → 用 `delegate_task` 直连 Agent，或 `kanban-orchestrator` 做任务分解
- "帮我建个 Skill/技能" → 用 `multi-agent--skills-factory`
- "深化/重新解读已有素材" → 主编直接深度写作，不调用调研员
- "只排版一篇已有 HTML" → 主编直接调内部 `verify.sh` + 5 大模式，**不**走完整多 Agent 流程

## v3.0 关键变更（相对 v2.0 + v1.0）

- ✅ **合并** `multi-agent-wechat` v2.0 + `wechat-html` v1.0 为单一 skill
- ✅ **5 大排版模式** 嵌进工作流 Step 5
- ✅ **12 项验证** 自动化（`verify.sh`）嵌进 Step 6
- ✅ **去第一人称** 硬约束保留
- ✅ **去 AI 味** 硬约束保留
- ❌ **删除** 旧 `wechat-html` skill 独立入口（避免与 `/创作` 撞车）

## 6 步工作流

```
Step 1  主编出"主题三件套"
        ├─ 标题（2-3 个备选）
        ├─ 文章框架（章节大纲 + 字数分配）
        └─ 开头钩子（前 150 字，3 种风格备选）
        ↓ ⏸️ 用户确认 / 微调（必须！不可跳过）
Step 2  并行启动：调研员 + 评估员
        ↓
Step 3  写手出初稿
        ├─ 主编【必须完整告知写手预审 6 条】（见 agents.md「预审清单告知》节）
        ├─ 套用 Step 1 三件套
        ├─ 套用 Step 2 素材
        └─ 强约束：去 AI 味 + 去第一人称 + 人味细节 + 结构化
        ↓
Step 4  评审打分（6 维 × 20 分 = 120 分）
        ↓
      ┌─ ≥108 ─┐   ┌─ <108 ─┐
      ↓           ↓
   Step 5     返回 Step 3 改稿（最多 3 轮）
      ↓
Step 5  5 大排版模式渲染（主编执行）
        - 封面/封底对仗
        - 2×2 卡片网格 / 单列卡片堆叠 / 章节大标 / 核心结论
        ↓
Step 6  verify.sh 跑 12 项验证 + D 盘归档
        - 全 PASS → 输出 `D:\wechat\排版\{标题}.html`
        - 有 FAIL → 修完重跑
```

## Agent 团队配置

| Agent | 模板 | 输出 | 职责 |
|-------|------|------|------|
| 主编（我） | 内置 | 主题三件套 | Step 1 出标题 / 框架 / 钩子，等待用户确认；Step 5 调排版模式；Step 6 调 verify.sh |
| 调研员 | [references/agents.md](references/agents.md) | 素材汇总 | 按主编框架搜索每章节支撑素材 |
| 评估员 | [references/agents.md](references/agents.md) | 受众 + AI 味诊断 + 细节密度 | 不参与结构设计，专注诊断 |
| 写手 | [references/agents.md](references/agents.md) | 完整文章 | 套用三件套 + 强去 AI 味 + 0 第一人称 |
| 评审 | [references/agents.md](references/agents.md) | 评分报告 | 6 维评分，AI 味诊断 + 结构化审计 |

## 模板文件

| 文件 | 说明 |
|------|------|
| [references/agents.md](references/agents.md) | 5 个 Agent 系统提示词 |
| [references/templates.md](references/templates.md) | 评审 / 交付报告模板 |
| [references/article-writing-principles.md](references/article-writing-principles.md) | 写作原则 + 去 AI 味清单 + 人味细节 + **去第一人称** |
| [references/subagent-output-handling.md](references/subagent-output-handling.md) | 子 Agent 输出处理 + 失败模式 |
| [references/content-data-sources.md](references/content-data-sources.md) | 内容创作数据源可靠性 |
| [references/article_draft.md](references/article_draft.md) | 文章范例 |
| [references/test_pool.md](references/test_pool.md) | 测试用例（含 TC-009~TC-015） |
| [references/template.html](references/template.html) | **LEGACY** 旧蓝色模板，新流程不用 |
| [template-cover.html](template-cover.html) | 完整样板（封面 + 主内容 + 封底 + 底部） |
| [verify.sh](verify.sh) | **自动化** 12 项验证清单脚本 |

## 6 维评审（120 分制）

| # | 维度 | 满分 | 评估重点 |
|---|------|------|----------|
| 1 | 主题契合度 | 20 | 主题紧扣、回应 Step 1 框架 |
| 2 | 结构清晰度 | 20 | 章节合理、过渡流畅、首尾有力 |
| 3 | 案例质量与细节真实性 | 20 | 案例具体 + 含数字/时间/场景/感官细节 |
| 4 | 洞察深度 | 20 | 独特角度、超越素材的延伸思考 |
| 5 | **人味与去 AI 味** | 20 | 无套话、无 AI 模板句、有第一人称体验感 |
| 6 | **结构化可读性** | 20 | 避免 200+ 字长段、用列表/表格/小标题断句 |

总分 120，及格 72（60%），目标 108（90%）。

## 评分迭代规则

| 轮次 | 分数 | 动作 |
|------|------|------|
| 第 1-2 轮 | <108 | 写手根据评审意见修改 |
| 第 3 轮 | <108 | 结束迭代，输出当前最高分版本 |
| 任何轮 | ≥108 | ✅ 达标 → 进入 Step 5 排版 |

**最多 3 轮迭代。**

## 5 大排版模式（Step 5 使用）

### 模式 1：封面 / 封底对仗
```html
<!-- 封面：26px 主标 + 14px 副标 + 13px 橙金句 × 2 -->
<!-- 封底：镜像结构，FINIS 顶标 + 主标 + 副标 + 2 行金句 -->
```
- 叙事弧线：封面提出问题 → 中间给出方案 → 封底兑现承诺

### 模式 2：2×2 卡片网格（4 个并列项）
- 列宽 50% + 50%
- 编号圆 24px（半径 12px 刚好 PRD 上限）
- 浅橙 `#F2E5DA` 背景

### 模式 3：单列卡片堆叠（N 个并列项）
- 编号列 48px + 内容列自适应
- 奇偶行浅橙/白底交替
- 用于 5+ 项（坑/步骤/要点）

### 模式 4：章节大标
- 18px + `border-bottom:2px solid #1a1a1a`
- 子节标 14px 橙色 `① ② ③ ④`

### 模式 5：核心结论
- 3 条带编号圆 + 加粗标题 + 缩进描述
- 缩进 24px（不是 28px）
- 浅灰底 + 左侧 3px 橙条

## 12 项验证清单（Step 6 自动化）

由 [verify.sh](verify.sh) 自动跑，输出 PASS/WARN/FAIL 报告：

| # | 验证项 | 检测逻辑 |
|---|--------|----------|
| 1 | 容器宽度 max-width:680px | 至少 3 处（封面/主内容/封底/底部）|
| 2 | 327px 表格不破框 | 无 50%/100%/30-34%/22%/48px 之外的列宽 |
| 3 | 代码块 word-break:break-all | 真代码块（橙底+Menlo）≥ 1 处 word-break |
| 4 | 无禁用属性 | box-shadow / text-shadow / transform / 渐变 / backdrop-filter / position fixed/absolute 全部 0 命中 |
| 5 | 无外链 `<img>` | 0 个 http(s) 外链 |
| 6 | border-radius ≤ 12px | 0 个 28px 编号圆（半径 14px 超标） |
| 7 | 章节大标 18px + 2px 下边框 | 至少 3 个 H2 |
| 8 | 主色 #B66B45 统一 | ≥ 10 处使用 |
| 9 | 字体统一 | ≥ 5 处使用系统字体栈 |
| 10 | 封面 / 封底对仗 | 封面 caps + 封底 FINIS 都在 |
| 11 | 品牌标识首尾两处 | ≥ 2 处"出品 · 木汝科技 · Muru AI" |
| 12 | 5 大模式齐全 | 至少 3 个模式被使用 |

**使用方式**：
```bash
bash ~/.claude/skills/multi-agent-wechat-html/verify.sh <article.html>
```

## 设计令牌（v1.0 from wechat-html 合并）

### 色系
| 用途 | 色值 | 应用场景 |
|---|---|---|
| **主色**（橙哑光） | `#B66B45` | 编号圆、强调金句、链接下划线、橙底卡片 |
| **浅底** | `#F2E5DA` | 卡片 / 表格行的浅色背景 |
| 浅灰底 | `#f5f5f5` | 信息性弱化卡片、引言块、表头 |
| 章节大标 | `#1a1a1a` | + 2px 下边框 |
| 正文 | `#333` / `#555` | |
| 辅文 | `#666` / `#999` | |

### 字体
- 正文：`-apple-system, BlinkMacSystemFont, 'PingFang SC', 'Microsoft YaHei', sans-serif`
- 代码：`Menlo, Monaco, Consolas, monospace`
- 大引号装饰：`Georgia, 'Times New Roman', serif`

## 7 大手机端雷区（v1.0 from wechat-html 合并）

| 雷区 | 修法 |
|---|---|
| **代码块超长路径破框** | 11px + `word-break:break-all` + 相对路径 + `$` 前缀 + 注释行 |
| **4+ 列横排表** | 4 项 → 2×2 网格；5+ 项 → 单列卡片堆叠 |
| **7 列横排流程图** | 单列竖排，# 大圆 + 标题 + 描述 |
| **3 列宽表（11+ 字文案）** | 合并右两列用 `→` 连接，或文案 ≤ 11 字 |
| **列宽 32/auto/18 失衡** | 改成 30/auto/22（"性质"列 22% ≈ 72px）|
| **长英文引文** | 拆 3 行短句 + 56px 衬线大引号 " 装饰 |
| **3 列横排卡片** | 评估是否 2×2 或单列堆叠 |

## 写手硬约束（去 AI 味 + 0 第一人称）

### 去 AI 味（v2.0）
- 禁用 9 条套话（在这个时代 / 值得注意的是 / 综上所述 / 我们不禁要问 / 不是 X，而是 Y / 提供了无限可能 / 你 get 到了吗）
- 禁用空洞排比（连续 3+ 句同结构 → 1-2 处点睛即可）
- 禁用"AI 友好"结构（3 段式套话、伪结论、空洞升华）

### 去第一人称（v2.0）
- ❌ 禁用：我 / 我的 / 我们 / 笔者
- ✅ 改用：通俗技术文档人称（阮一峰 / 酷壳 / 美团技术博客）
  - 无主语陈述
  - 用"你"代入读者
  - "常见的 / 实际项目中 / 踩过坑的常见节奏"

### 人味细节技法（v2.0）
每篇 ≥ 3 个：具体数字 / 时间 / 场景 / 感官 / 情绪 / 口语

详细对照表见 [references/article-writing-principles.md](references/article-writing-principles.md)。

## 输出路径

**所有由本 skill 产出的文章 HTML，统一保存到：**

```
D:\wechat\排版\
```

- **Windows**（主力）：直接使用
- **macOS / Linux**：主编应主动询问用户指定输出目录
- **文件命名**：`{文章标题}.html`（中文标题保留原字符）
- **旧版直接覆盖**，无需按版本号管理

## 快捷指令

```
/创作 [主题] [字数要求] [目标读者]
```

示例：`/创作 商业模式进化：从人到 AI Agent 2000字 创业者`

## 已知陷阱

1. **HTML 必须全内联 CSS** —— 微信编辑器过滤 `<style>` 标签
2. **手机端优先** —— 327px 视口宽，所有内嵌表格按 5 大模式设计
3. **子 Agent 不执行文件操作** —— 写手直接输出文章内容
4. **保持用户大纲** —— 用户提供详细大纲/内容时严格遵循
5. **评审 ≠ 写手反馈** —— 评审只打分，不同时给修改建议
6. **Step 1 不能跳** —— 主编未确认三件套就启动调研 = 失败模式
7. **写手不能"AI 风"** —— 命中禁用套话 > 5 次 = 直接 0-5 分
8. **写手必须有细节** —— 人味细节 < 3 个 = 不通过
9. **写手禁用第一人称** —— Ctrl+F 扫"我/我们/笔者" 必须 0 命中
10. **verify.sh 必须跑** —— Step 6 不可跳过，FAIL 项必须修
11. **用户说"深化/重新解读"** —— 主编直接深度写作，不调用调研员

## 最佳实践

1. **主编主动出三件套** —— 给 2-3 备选让用户挑
2. **并行启动调研 + 评估** —— 节省一半时间
3. **明确指出所有问题** —— 每轮评审列具体位置
4. **达标立即交付** —— 达到 108 分不继续修改
5. **记录迭代历史** —— 交付报告记录每轮评分
6. **一轮达标是常态** —— 实测多篇 108+ 分
7. **禁止虚假完成** —— 评审未被调用必须如实告知
8. **严格去 AI 味** —— Ctrl+F 扫禁用套话
9. **严格去第一人称** —— Ctrl+F 扫"我/我们/笔者"
10. **必须 verify.sh 验收** —— 不允许手动跳过

## 目录结构

```
multi-agent-wechat-html/
├── SKILL.md              ← 主入口（本文档）
├── README.md             ← 项目说明
├── CHANGELOG.md          ← 变更记录
├── template-cover.html   ← 完整样板（封面 + 主内容 + 封底 + 底部）
├── verify.sh             ← 12 项验证自动化脚本
└── references/
    ├── agents.md                   ← 5 个 Agent 系统提示词
    ├── article-writing-principles.md  ← 写作原则 + 去 AI 味 + 去第一人称
    ├── article_draft.md            ← 文章范例
    ├── content-data-sources.md
    ├── subagent-output-handling.md
    ├── template.html              ← LEGACY（旧蓝色模板，新流程不用）
    ├── templates.md               ← 评审/交付报告模板
    └── test_pool.md               ← 测试用例（TC-001~TC-015）
```

## 验证清单（每篇文章发布前过一遍）

- [ ] description 以"多 Agent 公众号写作 + HTML 排版"开头
- [ ] frontmatter 包含完整字段
- [ ] 所有 content 文件在 references/ 目录
- [ ] references/test_pool.md 存在并包含 TC-009 ~ TC-015
- [ ] 内部链接已更新为 references/ 路径
- [ ] 评审 6 维度、AI 味诊断、结构化审计段齐全
- [ ] 输出路径锁定 D:\wechat\排版\
- [ ] **verify.sh 跑 12 项 0 FAIL**
