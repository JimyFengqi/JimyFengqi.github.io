---
title: 984-不含 AAA 或 BBB 的字符串(String Without AAA or BBB)
date: 2021-12-03 22:27:32
categories:
  - 中等
tags:
  - 贪心
  - 字符串
---

> 原文链接: https://leetcode-cn.com/problems/string-without-aaa-or-bbb


## 英文原文
<div><p>Given two integers <code>a</code> and <code>b</code>, return <strong>any</strong> string <code>s</code> such that:</p>

<ul>
	<li><code>s</code> has length <code>a + b</code> and contains exactly <code>a</code> <code>&#39;a&#39;</code> letters, and exactly <code>b</code> <code>&#39;b&#39;</code> letters,</li>
	<li>The substring <code>&#39;aaa&#39;</code> does not occur in <code>s</code>, and</li>
	<li>The substring <code>&#39;bbb&#39;</code> does not occur in <code>s</code>.</li>
</ul>

<p>&nbsp;</p>
<p><strong>Example 1:</strong></p>

<pre>
<strong>Input:</strong> a = 1, b = 2
<strong>Output:</strong> &quot;abb&quot;
<strong>Explanation:</strong> &quot;abb&quot;, &quot;bab&quot; and &quot;bba&quot; are all correct answers.
</pre>

<p><strong>Example 2:</strong></p>

<pre>
<strong>Input:</strong> a = 4, b = 1
<strong>Output:</strong> &quot;aabaa&quot;
</pre>

<p>&nbsp;</p>
<p><strong>Constraints:</strong></p>

<ul>
	<li><code>0 &lt;= a, b &lt;= 100</code></li>
	<li>It is guaranteed such an <code>s</code> exists for the given <code>a</code> and <code>b</code>.</li>
</ul>
</div>

## 中文题目
<div><p>给定两个整数&nbsp;<code>A</code>&nbsp;和&nbsp;<code>B</code>，返回<strong>任意</strong>字符串 <code>S</code>，要求满足：</p>

<ul>
	<li><code>S</code> 的长度为&nbsp;<code>A + B</code>，且正好包含&nbsp;<code>A</code>&nbsp;个 <code>&#39;a&#39;</code>&nbsp;字母与&nbsp;<code>B</code>&nbsp;个 <code>&#39;b&#39;</code>&nbsp;字母；</li>
	<li>子串&nbsp;<code>&#39;aaa&#39;</code>&nbsp;没有出现在&nbsp;<code>S</code>&nbsp;中；</li>
	<li>子串&nbsp;<code>&#39;bbb&#39;</code> 没有出现在&nbsp;<code>S</code>&nbsp;中。</li>
</ul>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre><strong>输入：</strong>A = 1, B = 2
<strong>输出：</strong>&quot;abb&quot;
<strong>解释：</strong>&quot;abb&quot;, &quot;bab&quot; 和 &quot;bba&quot; 都是正确答案。
</pre>

<p><strong>示例 2：</strong></p>

<pre><strong>输入：</strong>A = 4, B = 1
<strong>输出：</strong>&quot;aabaa&quot;</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ol>
	<li><code>0 &lt;= A &lt;= 100</code></li>
	<li><code>0 &lt;= B &lt;= 100</code></li>
	<li>对于给定的 <code>A</code> 和 <code>B</code>，保证存在满足要求的 <code>S</code>。</li>
</ol>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 官方题解
#### 方法：贪心

**思路**

直观感觉，我们应该先选择当前所剩最多的待写字母写入字符串中。举一个例子，如果  `A = 6, B = 2`，那么我们期望写出 `'aabaabaa'`。进一步说，设当前所剩最多的待写字母为 `x`，只有前两个已经写下的字母都是 `x` 的时候，下一个写入字符串中的字母才不应该选择它。

**算法**

我们定义 `A, B`：待写的 `'a'` 与 `'b'` 的数量。

设当前还需要写入字符串的 `'a'` 与 `'b'` 中较多的那一个为 `x`，如果我们已经连续写了两个 `x` 了，下一次我们应该写另一个字母。否则，我们应该继续写 `x`。

```java [xe7TWkmP-Java]
class Solution {
    public String strWithout3a3b(int A, int B) {
        StringBuilder ans = new StringBuilder();

        while (A > 0 || B > 0) {
            boolean writeA = false;
            int L = ans.length();
            if (L >= 2 && ans.charAt(L-1) == ans.charAt(L-2)) {
                if (ans.charAt(L-1) == 'b')
                    writeA = true;
            } else {
                if (A >= B)
                    writeA = true;
            }

            if (writeA) {
                A--;
                ans.append('a');
            } else {
                B--;
                ans.append('b');
            }
        }

        return ans.toString();
    }
}
```
```python [xe7TWkmP-Python]
class Solution(object):
    def strWithout3a3b(self, A, B):
        ans = []

        while A or B:
            if len(ans) >= 2 and ans[-1] == ans[-2]:
                writeA = ans[-1] == 'b'
            else:
                writeA = A >= B

            if writeA:
                A -= 1
                ans.append('a')
            else:
                B -= 1
                ans.append('b')

        return "".join(ans)
```


**复杂度分析**

* 时间复杂度：$O(A+B)$。

* 空间复杂度：$O(A+B)$。





## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    9415    |    22442    |   42.0%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
