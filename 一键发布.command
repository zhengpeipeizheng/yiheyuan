#!/bin/bash
# 颐和园放映页 · 一键发布到 GitHub Pages
# 双击运行即可。会把当前文件夹上传到公开仓库 yiheyuan，并开启网页服务。

cd "$(dirname "$0")" || exit 1

echo "======================================"
echo "  颐和园放映页 · 发布到 GitHub Pages"
echo "======================================"
echo
echo "将要执行："
echo "  1. 提交本地修改"
echo "  2. 创建/更新公开仓库 zhengpeipeizheng/yiheyuan"
echo "  3. 开启 GitHub Pages"
echo
echo "按 Ctrl+C 可以取消，按回车继续……"
read -r

echo
echo "--- 1/3 提交 ---"
git add -A
git commit -m "更新颐和园放映页" 2>/dev/null || echo "（没有新改动）"

echo
echo "--- 2/3 上传 ---"
if gh repo create yiheyuan --public --source=. --remote=origin --push 2>/dev/null; then
  echo "仓库已创建并推送"
else
  echo "仓库可能已存在，改为推送更新"
  git remote get-url origin >/dev/null 2>&1 || git remote add origin "https://github.com/zhengpeipeizheng/yiheyuan.git"
  git push -u origin main
fi

echo
echo "--- 3/3 开启 Pages ---"
gh api -X POST repos/zhengpeipeizheng/yiheyuan/pages \
  -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
  && echo "Pages 已开启" \
  || echo "Pages 可能已经开过了"

echo
echo "======================================"
echo "  完成。等 1–2 分钟后打开："
echo
echo "  https://zhengpeipeizheng.github.io/yiheyuan/"
echo
echo "======================================"
echo
read -n 1 -s -r -p "按任意键关闭这个窗口……"
