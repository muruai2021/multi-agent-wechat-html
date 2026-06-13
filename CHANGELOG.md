# Changelog

multi-agent-wechat-html 公众号文章多 Agent 写作 + HTML 排版 skill 的所有重要变更记录。

## [3.0.0] - 2026-06-03

### 破坏性变更（Breaking Changes）

- 🗑 **合并** `multi-agent-wechat` v2.0 + `wechat-html` v1.0 为单一 skill `multi-agent-wechat-html` v3.0
- 🗑 **删除** 旧的 `multi-agent-wechat` skill 目录
- 🗑 **删除** 旧的 `wechat-html` skill 目录
- 🆕 **新触发词**：`多 Agent 公众号写作 + HTML 排版` / `多 Agent 写作` / `/创作 [主题]`
- 🆕 **新工作流**：6 步合并（写作 + 排版 + 验证一气呵成）
- 🆕 **自动化**：Step 6 调用 `verify.sh` 跑 12 项（无需人工 grep）

### 从 multi-agent-wechat v2.0 继承

- ✅ 5 个 Agent 团队（主编 + 调研员 + 评估员 + 写手 + 评审）
- ✅ Step 1 主题三件套 + 人在回路门控
- ✅ 6 维评审（120 分制，主题/结构/案例/洞察/人味去 AI 味/结构化可读性）
- ✅ 写手硬约束（去 AI 味 + 0 第一人称 + 人味细节 + 结构化）
- ✅ AI 味诊断 + 结构化审计 段
- ✅ 11 条已知陷阱 + 10 条最佳实践
- ✅ TC-001 ~ TC-015 测试用例
- ✅ `{cwd}/articles/` 输出路径

### 从 wechat-html v1.0 继承

- ✅ 5 大排版模式（封面封底对仗 / 2×2 网格 / 单列堆叠 / 章节大标 / 核心结论）
- ✅ 7 大手机端雷区 + 修法
- ✅ 12 项验证清单
- ✅ 设计令牌（爱马仕橙 `#B66B45` / 浅橙 `#F2E5DA` / 字体栈 / 字号阶梯）
- ✅ 6 大 PRD 禁用属性
- ✅ `verify.sh` 自动化验证脚本
- ✅ `template-cover.html` 完整样板

### 新增（v3.0 独有）

- 🆕 **统一工作流** —— 从"白纸"到"可导入草稿"无需切换 skill
- 🆕 **5 大排版模式代码内嵌** —— 在 SKILL.md 即可查阅，无需翻 reference
- 🆕 **统一 verify.sh** —— 嵌入主流程 Step 6
- 🆕 **目录结构统一** —— `references/` + `template-cover.html` + `verify.sh` 一站式

---

## [2.0.0] - 2026-06-03

发布于独立的 `multi-agent-wechat` skill（现已并入 v3.0）。

### 关键改动

- ✅ 评审 5 维 → 6 维（加"人味与去 AI 味"和"结构化可读性"）
- ✅ 评分 100 → 120 分制
- ✅ Step 1 主题三件套 + 人在回路门控
- ✅ 写手去 AI 味硬约束（9 条禁用套话）
- ✅ 写手去第一人称硬约束（v2.0 末加）
- ✅ 5 大排版模式（最初来自 wechat-html v1.0）

---

## [1.0.0] - 2026-06-03

发布于独立的 `wechat-html` skill（现已并入 v3.0）。

### 关键功能

- ✅ 5 大排版模式 + 7 大手机端雷区
- ✅ 12 项验证清单（手动 grep 时代）
- ✅ 设计令牌
- ✅ `template-cover.html` 完整样板

---

## 升级指南

### 如果你之前在用 v1.0（wechat-html）或 v2.0（multi-agent-wechat）

**无破坏性操作需要**：旧目录直接删除，迁移已自动完成。

- ✅ 文章 HTML 文件保持不变（兼容）
- ✅ 设计令牌不变（向后兼容）
- ✅ 评审 120 分制不变
- ✅ verify.sh 12 项不变
- ✅ D 盘输出路径不变

### 触发词变化

| 旧 | 新 |
|---|---|
| `公众号文章 html 排版`（wechat-html）| `多 Agent 公众号写作 + HTML 排版`（v3.0 总触发）|
| `公众号文章 html 排版多 Agent 协作`（multi-agent-wechat）| 同上 |
| `多 Agent 写作`（multi-agent-wechat v2.0）| 同上 |

如果你在 prompt 中硬编码了 `公众号文章 html 排版`，需要改为新的总触发词。

---

## 版本约定

- **主版本号**（X.0.0）：破坏性变更（skill 合并 / 评分体系 / 工作流）
- **次版本号**（0.X.0）：新功能（新增 Agent / 新维度 / 新模式）
- **修订号**（0.0.X）：bug 修复 / 文案调整
