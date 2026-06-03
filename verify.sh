#!/usr/bin/env bash
# verify.sh — wechat-html 12 项验证清单自动跑
# 用法：./verify.sh <article.html>

set -e

if [ -z "$1" ]; then
  echo "用法: $0 <article.html>"
  echo ""
  echo "示例:"
  echo "  $0 ../test-articles/Claudian_Obsidian_*.html"
  echo "  $0 D:/wechat/排版/Dynamic-Workflow-Agent-范式跃迁.html"
  exit 1
fi

FILE="$1"

if [ ! -f "$FILE" ]; then
  echo "❌ 文件不存在: $FILE"
  exit 1
fi

PASS=0
FAIL=0
WARN=0

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 安全的 count 函数（避免 grep -c 0 命中时输出 0\n0 的问题）
count() {
  local n
  n=$(grep "$2" "$1" 2>/dev/null | wc -l | tr -d ' ')
  echo "${n:-0}"
}

check() {
  local desc="$1"
  local result="$2"
  local detail="$3"
  if [ "$result" = "PASS" ]; then
    echo -e "  ${GREEN}✓${NC} $desc ${BLUE}（$detail）${NC}"
    PASS=$((PASS+1))
  elif [ "$result" = "WARN" ]; then
    echo -e "  ${YELLOW}⚠${NC} $desc ${YELLOW}（$detail）${NC}"
    WARN=$((WARN+1))
  else
    echo -e "  ${RED}✗${NC} $desc ${RED}（$detail）${NC}"
    FAIL=$((FAIL+1))
  fi
}

echo ""
echo -e "${BLUE}━━━ wechat-html 12 项验证 ━━━${NC}"
echo -e "${BLUE}文件: $FILE${NC}"
echo -e "${BLUE}大小: $(wc -c < "$FILE" 2>/dev/null || echo 0) bytes${NC}"
echo ""

# 1. 容器宽度 max-width:680px
CNT=$(count "$FILE" "max-width:680px")
if [ "$CNT" -ge 3 ]; then
  check "1. 容器宽度 max-width:680px" "PASS" "$CNT 处"
else
  check "1. 容器宽度 max-width:680px" "FAIL" "仅 $CNT 处（至少 3 处：封面/主内容/封底/底部）"
fi

# 2. 327px 表格不破框
# 合规列宽：50% (2列) / 100% / 48px (单列卡)/ 30%-34% (3列表格) / 22% (3列表格"性质"列)
WIDE_TDS=$(grep -oE 'width:[0-9]+%' "$FILE" 2>/dev/null | grep -vE "width:(50%|100%|30%|32%|33%|34%|22%|48px)" | wc -l | tr -d ' ')
if [ "${WIDE_TDS:-0}" -eq 0 ]; then
  check "2. 327px 表格不破框" "PASS" "无非预期列宽"
else
  check "2. 327px 表格不破框" "WARN" "发现 $WIDE_TDS 个非预期列宽（人工复查）"
fi

# 3. 代码块 word-break:break-all
# 真代码块检测：橙底 + Menlo + padding 模式（排除 inline <code> 短片段）
REAL_CODE_BLOCKS=$(grep -cE 'background:#B66B45[^"]*font-family:Menlo' "$FILE" 2>/dev/null | head -1)
WORD_BREAK=$(count "$FILE" "word-break:break-all")
if [ "${REAL_CODE_BLOCKS:-0}" -eq 0 ] || [ "$WORD_BREAK" -ge 1 ]; then
  check "3. 代码块 word-break:break-all" "PASS" "$WORD_BREAK 处 word-break（$REAL_CODE_BLOCKS 个真代码块）"
else
  check "3. 代码块 word-break:break-all" "FAIL" "$REAL_CODE_BLOCKS 个真代码块但 0 处 word-break"
fi

# 4. 无禁用属性
BANNED=$(grep -cE "box-shadow|text-shadow|transform:|backdrop-filter|linear-gradient|radial-gradient|position:\s*(fixed|absolute)" "$FILE" 2>/dev/null || echo 0)
BANNED=$(echo "$BANNED" | head -1 | tr -d ' \n')
if [ "${BANNED:-0}" -eq 0 ]; then
  check "4. 无禁用属性" "PASS" "0 命中"
else
  check "4. 无禁用属性" "FAIL" "$BANNED 处违规"
fi

# 5. 无外链 <img>
EXT_IMGS=$(grep -cE '<img[^>]*src="https?://' "$FILE" 2>/dev/null || echo 0)
EXT_IMGS=$(echo "$EXT_IMGS" | head -1 | tr -d ' \n')
if [ "${EXT_IMGS:-0}" -eq 0 ]; then
  check "5. 无外链 <img>" "PASS" "0 个"
else
  check "5. 无外链 <img>" "WARN" "$EXT_IMGS 个外链图（需手动上传）"
fi

# 6. border-radius ≤ 12px
RADIUS_OVER=$(count "$FILE" "width:28px;height:28px")
if [ "${RADIUS_OVER:-0}" -eq 0 ]; then
  check "6. border-radius ≤ 12px" "PASS" "0 个超 12px 半径的编号圆"
else
  check "6. border-radius ≤ 12px" "WARN" "$RADIUS_OVER 个 28px 编号圆（半径 14px > 12px）"
fi

# 7. 章节大标 18px
H2_COUNT=$(count "$FILE" "font-size:18px;font-weight:700;color:#1a1a1a")
if [ "$H2_COUNT" -ge 3 ]; then
  check "7. 章节大标 18px + 2px 下边框" "PASS" "$H2_COUNT 个 H2"
else
  check "7. 章节大标 18px + 2px 下边框" "FAIL" "仅 $H2_COUNT 个 H2"
fi

# 8. 主色 #B66B45
MAIN_COLOR=$(count "$FILE" "#B66B45")
if [ "$MAIN_COLOR" -ge 10 ]; then
  check "8. 主色 #B66B45 统一" "PASS" "$MAIN_COLOR 处使用"
else
  check "8. 主色 #B66B45 统一" "WARN" "仅 $MAIN_COLOR 处使用"
fi

# 9. 字体统一
FONT_COUNT=$(count "$FILE" "font-family:-apple-system,BlinkMacSystemFont")
if [ "$FONT_COUNT" -ge 5 ]; then
  check "9. 字体统一" "PASS" "$FONT_COUNT 处使用系统字体栈"
else
  check "9. 字体统一" "WARN" "仅 $FONT_COUNT 处使用统一字体"
fi

# 10. 封面 / 封底对仗
HAS_FINIS=$(count "$FILE" "FINIS\|F I N I S")
if grep -q "AGENT VAULT STANDARD" "$FILE" 2>/dev/null && [ "$HAS_FINIS" -gt 0 ]; then
  check "10. 封面 / 封底对仗" "PASS" "封面 caps + 封底 FINIS 都在"
elif [ "$HAS_FINIS" -gt 0 ]; then
  check "10. 封面 / 封底对仗" "PASS" "封面 + 封底结构都在"
else
  check "10. 封面 / 封底对仗" "WARN" "未检测到对仗结构"
fi

# 11. 品牌标识首尾两处
BRAND_COUNT=$(count "$FILE" "木 汝 科 技")
if [ "$BRAND_COUNT" -ge 2 ]; then
  check "11. 品牌标识首尾两处" "PASS" "$BRAND_COUNT 处"
else
  check "11. 品牌标识首尾两处" "FAIL" "仅 $BRAND_COUNT 处（封面+底部各 1 处为合规）"
fi

# 12. 5 大模式齐全
HAS_COVER=$(count "$FILE" "padding:56px 24px")
HAS_GRID=$(count "$FILE" "width:50%")
HAS_STACK=$(count "$FILE" "width:48px")
HAS_H2=$(count "$FILE" "border-bottom:2px solid #1a1a1a")
HAS_CONCL=$(count "$FILE" "核心结论")
MODES_USED=0
[ "$HAS_COVER" -gt 0 ] && MODES_USED=$((MODES_USED+1))
[ "$HAS_GRID" -gt 0 ] && MODES_USED=$((MODES_USED+1))
[ "$HAS_STACK" -gt 0 ] && MODES_USED=$((MODES_USED+1))
[ "$HAS_H2" -gt 0 ] && MODES_USED=$((MODES_USED+1))
[ "$HAS_CONCL" -gt 0 ] && MODES_USED=$((MODES_USED+1))
if [ "$MODES_USED" -ge 3 ]; then
  check "12. 5 大模式齐全" "PASS" "$MODES_USED / 5 模式使用"
else
  check "12. 5 大模式齐全" "WARN" "仅 $MODES_USED / 5 模式使用"
fi

echo ""
echo -e "${BLUE}━━━ 总结 ━━━${NC}"
echo -e "  通过: ${GREEN}$PASS${NC} / 12"
echo -e "  警告: ${YELLOW}$WARN${NC} / 12"
echo -e "  失败: ${RED}$FAIL${NC} / 12"
echo ""

if [ "$FAIL" -eq 0 ] && [ "$WARN" -eq 0 ]; then
  echo -e "${GREEN}✅ 12/12 完美通过，可导入 mp.weixin.qq.com${NC}"
  exit 0
elif [ "$FAIL" -eq 0 ]; then
  echo -e "${YELLOW}⚠ 通过但有警告，建议人工复查${NC}"
  exit 0
else
  echo -e "${RED}❌ 有 $FAIL 项失败，必须修复后重跑${NC}"
  exit 1
fi
