# 内容创作数据源可靠性参考

> 本次实操验证的数据源可用性汇总（2026-05-15）

---

## 验证结论

| 数据源 | 获取方式 | 可用性 | 备注 |
|--------|----------|--------|------|
| Hacker News | `curl -s "https://hnrss.org/frontpage"` | ✅ 可靠 | 返回完整RSS，含标题/分数/评论数/URL |
| ArXiv cs.AI | `curl -s "https://rss.arxiv.org/rss/cs.AI"` | ✅ 可靠 | 返回最新论文列表，含标题/摘要/日期 |
| GitHub Trending | GitHub API / HTML爬取 | ❌ 频繁超时/限流 | API需要认证，HTML爬取易触发反爬 |
| Anthropic新闻 | `curl -s "https://www.anthropic.com/news"` | ✅ 可用 | 有标题但摘要信息有限 |
| 机器之心/量子位 | `rsshub.app/jiqizhixin/news` | ❌ 超时 | rsshub.app国内访问不稳定 |
| Twitter/X | 网页爬取 | ❌ 不可用 | 页面需要JS渲染，curl无法获取 |

---

## 验证命令

### Hacker News
```bash
curl -s "https://hnrss.org/frontpage"
# 提取AI相关帖子
curl -s "https://hnrss.org/newest?q=AI%20OR%20LLM%20OR%20agent&limit=10"
```

### ArXiv
```bash
curl -s "https://rss.arxiv.org/rss/cs.AI"
curl -s "https://rss.arxiv.org/rss/cs.CL"
```

### GitHub (备选方案)
```bash
# GitHub API (需要token，公开接口频繁限流)
curl -s "https://api.github.com/search/repositories?q=AI+created:>2026-01-01&sort=stars"
# HTML爬取 (不稳定)
curl -s --max-time 10 -A "Mozilla/5.0" "https://github.com/trending"
```

---

## 降级策略

当多个数据源不可用时：
1. **HN + ArXiv 组合**可独立支撑AI领域选题池（两者合计可提取10-15个高质量候选）
2. 评估Agent可基于HN热度数据推断趋势，不需要Twitter/X的补充
3. GitHub Trending对AI选题价值有限，主要用于开发者工具类选题

---

## 补充数据源（未经本次验证）

- **Google Scholar Alerts**: 适合学术类选题，但需要账号配置
- **Product Hunt**: `curl -s "https://api.producthunt.com/v1/posts"` (需API key)
- **Reddit r/MachineLearning**: `curl -s "https://www.reddit.com/r/MachineLearning/.rss"`
