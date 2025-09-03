set -euo pipefail
BR=ci-test/pr-$(date +%s)
git switch -c "$BR"
: > .github/workflows/_touch.$(date +%s)    # なんでも良い変更
git add . && git commit -m "CI test: $BR"
git push -u origin "$BR"

# PR作成（gh CLI）
PR_URL=$(gh pr create --fill --draft)
echo "Opened: $PR_URL"

# 実行を待ってログを覗く（任意）
gh pr checks --watch || true

# 後片付け（クローズ＆ブランチ削除）
gh pr close --delete-branch
git switch - 2>/dev/null || true
git branch -D "$BR" 2>/dev/null || true