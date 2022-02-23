---
title: 剑指 Offer II 086-分割回文子字符串
date: 2021-12-03 21:32:52
categories:
  - 中等
tags:
  - 字符串
  - 动态规划
  - 回溯
---

> 原文链接: https://leetcode-cn.com/problems/M99OJA




## 中文题目
<div><p>给定一个字符串 <code>s</code> ，请将 <code>s</code> 分割成一些子串，使每个子串都是 <strong>回文串</strong> ，返回 s 所有可能的分割方案。</p>

<p><meta charset="UTF-8" /><strong>回文串</strong>&nbsp;是正着读和反着读都一样的字符串。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>s =<strong> </strong>&quot;google&quot;
<strong>输出：</strong>[[&quot;g&quot;,&quot;o&quot;,&quot;o&quot;,&quot;g&quot;,&quot;l&quot;,&quot;e&quot;],[&quot;g&quot;,&quot;oo&quot;,&quot;g&quot;,&quot;l&quot;,&quot;e&quot;],[&quot;goog&quot;,&quot;l&quot;,&quot;e&quot;]]
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>s = &quot;aab&quot;
<strong>输出：</strong>[[&quot;a&quot;,&quot;a&quot;,&quot;b&quot;],[&quot;aa&quot;,&quot;b&quot;]]
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>s = &quot;a&quot;
<strong>输出：</strong>[[&quot;a&quot;]<span style="font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 14px; background-color: rgb(255, 255, 255);">&nbsp;</span></pre>

<p>&nbsp;</p>

<p><b>提示：</b></p>

<ul>
	<li><code>1 &lt;= s.length &lt;= 16</code></li>
	<li><code>s </code>仅由小写英文字母组成</li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 131&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/palindrome-partitioning/">https://leetcode-cn.com/problems/palindrome-partitioning/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
本题需要一点前置知识，那就是**给定下标[i, j] (i <= j)需要在O(1)时间复杂度内判断该范围内的子串是否是回文**。如果不知道怎么做，请先尝试解决[647. 回文子串](https://leetcode-cn.com/problems/palindromic-substrings/)。

如果清楚了以上问题，我们就可以使用动态规划预处理字符串，得到一张映射表，然后用回溯算法就可以解决该问题了（其实就是不断枚举不相交的区间）。

``` java
class Solution {
    public String[][] partition(String s) {
        int n = s.length();
        char[] arr = s.toCharArray();
        // 预处理
        boolean[][] dp = new boolean[n][n];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                dp[i][j] = true;
            }
        }
        for (int i = n - 1; i >= 0; i--) {
            for (int j = i + 1; j < n; j++) {
                dp[i][j] = (arr[i] == arr[j] && dp[i + 1][j - 1]);
            }
        }
        List<List<String>> res = new ArrayList<>();
        List<String> path = new ArrayList<>();
        dfs(res, path, s, n, dp, 0);
        // List<List<String>> 转 String[][]，这里不重要
        String[][] ans = new String[res.size()][];
        for (int i = 0; i < res.size(); i++) {
            ans[i] = new String[res.get(i).size()];
            for (int j = 0; j < ans[i].length; j++) {
                ans[i][j] = res.get(i).get(j);
            }
        }
        return ans;
    }

    public void dfs(List<List<String>> res, List<String> path, String s, int n, boolean[][] dp, int pos) {
        if (pos == n) {
            res.add(new ArrayList<>(path));
            return;
        }
        for (int i = pos; i < n; i++) {
            // s[pos:i] （闭区间）是一个回文，所以递归搜索s[i+1, s.length()-1] 
            if (dp[pos][i]) {
                path.add(s.substring(pos, i + 1));
                dfs(res, path, s, n, dp, i + 1);
                path.remove(path.size() - 1);
            }
        }
    }
}
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    3264    |    4344    |   75.1%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
