# multi-agent-wechat-html

[English](#english) | [中文](#中文)

---

## English

### Overview

**multi-agent-wechat-html v3.0** is an all-in-one WeChat public account content solution. It merges the previous `multi-agent-wechat` v2.0 (writing pipeline) and `wechat-html` v1.0 (HTML rendering) into a single end-to-end workflow.

**Core Features:**
- **6-step pipeline** — Topic Trio → User Gate → Parallel Research + Eval → Drafting → 6-dim Review → Layout + Verify
- **5 agents** — Editor (in-chief) + Researcher + Evaluator + Writer + Reviewer
- **Hard constraints** — Anti-AI-flavor + 0 first-person + humanized details + structured readability
- **12-item verification** — Automated via `verify.sh`, catches 12 common mobile/PRD issues
- **5 layout patterns** — Cover/封底 mirror / 2×2 grid / Vertical card stack / Chapter heading / Core conclusion
- **Design tokens** — Hermès orange `#B66B45` / light tint `#F2E5DA` / 12px border-radius cap / 327px mobile viewport

### Workflow

```
Step 1: Editor proposes "Topic Trio"
        ├─ Title (2-3 options)
        ├─ Framework (chapter outline + word allocation)
        └─ Opening hook (first 150 chars, 3 styles)
         ↓ ⏸️ USER MUST CONFIRM ⏸️
Step 2: Parallel search (Researcher + Evaluator)
         ↓
Step 3: Writer produces draft
        ├─ Apply Step 1 Trio
        ├─ Apply Step 2 materials
        └─ Hard constraints: anti-AI + 0-first-person + details + structure
         ↓
Step 4: Reviewer scores (6 dims × 20pts = 120pts)
         ↓
      ┌── ≥108pts ──┐
      ↓              ↓
  Step 5      <108 → Return to Step 3 (max 3 rounds)
      ↓
Step 5: Layout (5 patterns applied)
         ↓
Step 6: verify.sh + D:\wechat\排版\ archive
```

### Trigger Words

Any of these triggers the skill:
- "多 Agent 写作"
- "/创作 [主题]"
- "写文章" / "公众号文章" / "帮我写一篇" / "创作内容"

### Output Path

All articles saved to `D:\wechat\排版\` (Windows; macOS/Linux requires user to specify).

### Verification

```bash
bash ~/.claude/skills/multi-agent-wechat-html/verify.sh <article.html>
```

Outputs 12-item pass/warn/fail report. All PASS = ready to import to mp.weixin.qq.com.

---

## 中文

### 概述

**multi-agent-wechat-html v3.0** 是公众号文章"写作 + 排版 + 验证"一体化解决方案。合并了原 `multi-agent-wechat` v2.0（写作流水线）和 `wechat-html` v1.0（HTML 排版）为单一端到端工作流。

**核心特性：**
- **6 步流水线** —— 主题三件套 → 用户门控 → 调研+评估并行 → 写稿 → 6 维评审 → 排版+验证
- **5 个 Agent** —— 主编 + 调研员 + 评估员 + 写手 + 评审
- **硬约束** —— 去 AI 味 + 0 第一人称 + 人味细节 + 结构化
- **12 项验证** —— `verify.sh` 自动化，捕获 12 类常见手机/PRD 问题
- **5 大排版模式** —— 封面封底对仗 / 2×2 网格 / 单列堆叠 / 章节大标 / 核心结论
- **设计令牌** —— 爱马仕橙 `#B66B45` / 浅橙 `#F2E5DA` / border-radius ≤ 12px / 327px 视口

### 工作流程

```
Step 1: 主编出"主题三件套"
        ├─ 标题（2-3 备选）
        ├─ 文章框架（章节大纲 + 字数分配）
        └─ 开头钩子（前 150 字，3 种风格）
         ↓ ⏸️ 用户必须确认 ⏸️
Step 2: 并行搜索（调研员 + 评估员）
         ↓
Step 3: 写手出稿
        ├─ 套用 Step 1 三件套
        ├─ 套用 Step 2 素材
        └─ 硬约束：去 AI 味 + 0 第一人称 + 细节 + 结构化
         ↓
Step 4: 评审打分（6 维 × 20 = 120）
         ↓
      ┌─ ≥108 ─┐   ┌─ <108 ─┐
      ↓          ↓
  Step 5     返回 Step 3 改稿（最多 3 轮）
      ↓
Step 5: 5 大排版模式渲染
      ↓
Step 6: verify.sh 跑 12 项 + D 盘归档
```

### 触发词

满足任一即触发：
- "多 Agent 写作"
- "/创作 [主题]"
- "写文章" / "公众号文章" / "帮我写一篇" / "创作内容"

### 输出路径

`D:\wechat\排版\`（Windows 主力，macOS/Linux 需主编主动询问）

### 验证

```bash
bash ~/.claude/skills/multi-agent-wechat-html/verify.sh <article.html>
```

输出 12 项 pass/warn/fail 报告。全 PASS = 可导入 mp.weixin.qq.com。

---

MIT License
