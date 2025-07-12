#!/bin/bash

# 三年计划连续性协议生成器
# 作者：DeepSeek-R1
# 创建日期：2025-07-12

# 设置工作目录
WORK_DIR=$(pwd)
DATE=$(date +%Y-%m-%d)
JOURNAL_FILE="$WORK_DIR/Daily-Journal/$DATE.md"
PROTOCOL_FILE="$WORK_DIR/continuity-protocol-$DATE.md"

# 检查日志文件是否存在
if [ ! -f "$JOURNAL_FILE" ]; then
  echo "错误：今日日志文件不存在 - $JOURNAL_FILE"
  echo "请先创建今日日志"
  exit 1
fi

# 获取最新提交信息
COMMIT_INFO=$(git log -1 --pretty=format:"%h - %s")

# 提取今日目标完成情况
extract_goals() {
  sed -n '/## 🎯 今日目标/,/## 📚/p' "$JOURNAL_FILE" | 
    grep -E '^- \[( |x)\]' | 
    sed -e 's/^- \[ \]/✗/' -e 's/^- \[x\]/✓/' -e 's/^- \[X\]/✓/' -e 's/^[[:space:]]*//'
}

# 提取反思与改进
extract_reflection() {
  sed -n '/## 💡 反思与改进/,/## 📝/p' "$JOURNAL_FILE" | 
    grep -v '##' | 
    sed '/^$/d' | 
    sed 's/^- //'
}

# 提取明日计划
extract_plans() {
  sed -n '/## 📝 明日计划/,//p' "$JOURNAL_FILE" | 
    grep -v '##' | 
    sed '/^$/d' | 
    sed 's/^[0-9]\. //'
}

# 生成上下文摘要
generate_summary() {
  echo "【今日进展】"
  extract_goals
  echo ""
  echo "【反思改进】"
  extract_reflection
  echo ""
  echo "【明日计划】"
  extract_plans
}

# 创建协议文件
create_protocol() {
  SUMMARY=$(generate_summary)
  
  cat > "$PROTOCOL_FILE" <<EOF
# 三年计划连续性协议

**当前日期**：$DATE  
**仓库地址**：https://github.com/xjfjhdb/USTC-2028-Knowledge-Base  
**最新提交**：\`$COMMIT_INFO\`  
**今日重点**：$(grep -m1 '# [0-9]' "$JOURNAL_FILE" | cut -d'-' -f2 | sed 's/^ *//')

**上下文摘要**：
\`\`\`
$SUMMARY
\`\`\`

**待解决问题**：
1. 
2. 
3. 

**长期目标进度**：
- 数学：▢▢▢▢▢
- 英语：▢▢▢▢▢
- 408专业课：▢▢▢▢▢
- C++/项目：▢▢▢▢▢
EOF

  echo "✅ 连续性协议已生成：$PROTOCOL_FILE"
}

# 主执行流程
create_protocol
