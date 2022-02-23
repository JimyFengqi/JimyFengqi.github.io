---
title: 712-两个字符串的最小ASCII删除和(Minimum ASCII Delete Sum for Two Strings)
date: 2021-12-03 22:39:05
categories:
  - 中等
tags:
  - 字符串
  - 动态规划
---

> 原文链接: https://leetcode-cn.com/problems/minimum-ascii-delete-sum-for-two-strings


## 英文原文
<div><p>Given two strings <code>s1</code> and&nbsp;<code>s2</code>, return <em>the lowest <strong>ASCII</strong> sum of deleted characters to make two strings equal</em>.</p>

<p>&nbsp;</p>
<p><strong>Example 1:</strong></p>

<pre>
<strong>Input:</strong> s1 = &quot;sea&quot;, s2 = &quot;eat&quot;
<strong>Output:</strong> 231
<strong>Explanation:</strong> Deleting &quot;s&quot; from &quot;sea&quot; adds the ASCII value of &quot;s&quot; (115) to the sum.
Deleting &quot;t&quot; from &quot;eat&quot; adds 116 to the sum.
At the end, both strings are equal, and 115 + 116 = 231 is the minimum sum possible to achieve this.
</pre>

<p><strong>Example 2:</strong></p>

<pre>
<strong>Input:</strong> s1 = &quot;delete&quot;, s2 = &quot;leet&quot;
<strong>Output:</strong> 403
<strong>Explanation:</strong> Deleting &quot;dee&quot; from &quot;delete&quot; to turn the string into &quot;let&quot;,
adds 100[d] + 101[e] + 101[e] to the sum.
Deleting &quot;e&quot; from &quot;leet&quot; adds 101[e] to the sum.
At the end, both strings are equal to &quot;let&quot;, and the answer is 100+101+101+101 = 403.
If instead we turned both strings into &quot;lee&quot; or &quot;eet&quot;, we would get answers of 433 or 417, which are higher.
</pre>

<p>&nbsp;</p>
<p><strong>Constraints:</strong></p>

<ul>
	<li><code>1 &lt;= s1.length, s2.length &lt;= 1000</code></li>
	<li><code>s1</code> and <code>s2</code> consist of lowercase English letters.</li>
</ul>
</div>

## 中文题目
<div><p>给定两个字符串<code>s1, s2</code>，找到使两个字符串相等所需删除字符的ASCII值的最小和。</p>

<p><strong>示例 1:</strong></p>

<pre>
<strong>输入:</strong> s1 = &quot;sea&quot;, s2 = &quot;eat&quot;
<strong>输出:</strong> 231
<strong>解释:</strong> 在 &quot;sea&quot; 中删除 &quot;s&quot; 并将 &quot;s&quot; 的值(115)加入总和。
在 &quot;eat&quot; 中删除 &quot;t&quot; 并将 116 加入总和。
结束时，两个字符串相等，115 + 116 = 231 就是符合条件的最小和。
</pre>

<p><strong>示例&nbsp;2:</strong></p>

<pre>
<strong>输入:</strong> s1 = &quot;delete&quot;, s2 = &quot;leet&quot;
<strong>输出:</strong> 403
<strong>解释:</strong> 在 &quot;delete&quot; 中删除 &quot;dee&quot; 字符串变成 &quot;let&quot;，
将 100[d]+101[e]+101[e] 加入总和。在 &quot;leet&quot; 中删除 &quot;e&quot; 将 101[e] 加入总和。
结束时，两个字符串都等于 &quot;let&quot;，结果即为 100+101+101+101 = 403 。
如果改为将两个字符串转换为 &quot;lee&quot; 或 &quot;eet&quot;，我们会得到 433 或 417 的结果，比答案更大。
</pre>

<p><strong>注意:</strong></p>

<ul>
	<li><code>0 &lt; s1.length, s2.length &lt;= 1000</code>。</li>
	<li>所有字符串中的字符ASCII值在<code>[97, 122]</code>之间。</li>
</ul>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 官方题解
#### 方法一：动态规划

我们用 `dp[i][j]` 表示字符串 `s1[i:]` 和 `s2[j:]`（`s1[i:]` 表示字符串 `s1` 从第 $i$ 位到末尾的子串，`s2[j:]` 表示字符串 `s2` 从第 $j$ 位到末尾的子串，字符串下标从 0 开始）达到相等所需删除的字符的 ASCII 值的最小和，最终的答案为 `dp[0][0]`。

当 `s1[i:]` 和 `s2[j:]` 中的某一个字符串为空时，`dp[i][j]` 的值即为另一个非空字符串的所有字符的 ASCII 值之和。例如当 `s2[j:]` 为空时，此时有 `j = s2.length()`，状态转移方程为

    dp[i][j] = s1.asciiSumFromPos(i)

也可以写成递推的形式，即

    dp[i][j] = dp[i + 1][j] + s1.asciiAtPos(i)

对于其余的情况，即两个字符串都非空时，如果有 `s1[i] == s2[j]`，那么当前位置的两个字符相同，它们不需要被删除，状态转移方程为

    dp[i][j] = dp[i + 1][j + 1]

如果 `s1[i] != s2[j]`，那么我们至少要删除 `s1[i]` 和 `s2[j]` 两个字符中的一个，因此状态转移方程为

    dp[i][j] = min(dp[i + 1][j] + s1.asciiAtPos(i), dp[i][j + 1] + s2.asciiAtPos(j))

```Python [sol1]
class Solution(object):
    def minimumDeleteSum(self, s1, s2):
        dp = [[0] * (len(s2) + 1) for _ in xrange(len(s1) + 1)]

        for i in xrange(len(s1) - 1, -1, -1):
            dp[i][len(s2)] = dp[i+1][len(s2)] + ord(s1[i])
        for j in xrange(len(s2) - 1, -1, -1):
            dp[len(s1)][j] = dp[len(s1)][j+1] + ord(s2[j])

        for i in xrange(len(s1) - 1, -1, -1):
            for j in xrange(len(s2) - 1, -1, -1):
                if s1[i] == s2[j]:
                    dp[i][j] = dp[i+1][j+1]
                else:
                    dp[i][j] = min(dp[i+1][j] + ord(s1[i]),
                                   dp[i][j+1] + ord(s2[j]))

        return dp[0][0]
```

```Java [sol1]
class Solution {
    public int minimumDeleteSum(String s1, String s2) {
        int[][] dp = new int[s1.length() + 1][s2.length() + 1];

        for (int i = s1.length() - 1; i >= 0; i--) {
            dp[i][s2.length()] = dp[i+1][s2.length()] + s1.codePointAt(i);
        }
        for (int j = s2.length() - 1; j >= 0; j--) {
            dp[s1.length()][j] = dp[s1.length()][j+1] + s2.codePointAt(j);
        }
        for (int i = s1.length() - 1; i >= 0; i--) {
            for (int j = s2.length() - 1; j >= 0; j--) {
                if (s1.charAt(i) == s2.charAt(j)) {
                    dp[i][j] = dp[i+1][j+1];
                } else {
                    dp[i][j] = Math.min(dp[i+1][j] + s1.codePointAt(i),
                                        dp[i][j+1] + s2.codePointAt(j));
                }
            }
        }
        return dp[0][0];
    }
}
```

**复杂度分析**

* 时间复杂度：$O(|S_1|* |S_2|)$。动态规划中用到了两重循环，它们的时间复杂度分别为 $O(|S_1|)$ 和 $O(|S_2|)$，因此总的时间复杂度为 $O(|S_1|* |S_2|)$。
* 空间复杂度：$O(|S_1|* |S_2|)$。动态规划中用到的 `dp` 为 $|S_1| * |S_2|$ 的二维数组。

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    16203    |    23989    |   67.5%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |


## 相似题目
|                             题目                             | 难度 |
| :----------------------------------------------------------: | :---------: |
| [编辑距离](https://leetcode-cn.com/problems/edit-distance/) | 困难|
| [最长递增子序列](https://leetcode-cn.com/problems/longest-increasing-subsequence/) | 中等|
| [两个字符串的删除操作](https://leetcode-cn.com/problems/delete-operation-for-two-strings/) | 中等|
