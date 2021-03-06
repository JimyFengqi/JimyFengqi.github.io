---
title: 剑指 Offer 19-正则表达式匹配(正则表达式匹配 LCOF)
categories:
  - 困难
tags:
  - 递归
  - 字符串
  - 动态规划
abbrlink: 1673282631
date: 2021-12-03 21:39:20
---

> 原文链接: https://leetcode-cn.com/problems/zheng-ze-biao-da-shi-pi-pei-lcof




## 中文题目
<div><p>请实现一个函数用来匹配包含<code>&#39;. &#39;</code>和<code>&#39;*&#39;</code>的正则表达式。模式中的字符<code>&#39;.&#39;</code>表示任意一个字符，而<code>&#39;*&#39;</code>表示它前面的字符可以出现任意次（含0次）。在本题中，匹配是指字符串的所有字符匹配整个模式。例如，字符串<code>&quot;aaa&quot;</code>与模式<code>&quot;a.a&quot;</code>和<code>&quot;ab*ac*a&quot;</code>匹配，但与<code>&quot;aa.a&quot;</code>和<code>&quot;ab*a&quot;</code>均不匹配。</p>

<p><strong>示例 1:</strong></p>

<pre><strong>输入:</strong>
s = &quot;aa&quot;
p = &quot;a&quot;
<strong>输出:</strong> false
<strong>解释:</strong> &quot;a&quot; 无法匹配 &quot;aa&quot; 整个字符串。
</pre>

<p><strong>示例 2:</strong></p>

<pre><strong>输入:</strong>
s = &quot;aa&quot;
p = &quot;a*&quot;
<strong>输出:</strong> true
<strong>解释:</strong>&nbsp;因为 &#39;*&#39; 代表可以匹配零个或多个前面的那一个元素, 在这里前面的元素就是 &#39;a&#39;。因此，字符串 &quot;aa&quot; 可被视为 &#39;a&#39; 重复了一次。
</pre>

<p><strong>示例&nbsp;3:</strong></p>

<pre><strong>输入:</strong>
s = &quot;ab&quot;
p = &quot;.*&quot;
<strong>输出:</strong> true
<strong>解释:</strong>&nbsp;&quot;.*&quot; 表示可匹配零个或多个（&#39;*&#39;）任意字符（&#39;.&#39;）。
</pre>

<p><strong>示例 4:</strong></p>

<pre><strong>输入:</strong>
s = &quot;aab&quot;
p = &quot;c*a*b&quot;
<strong>输出:</strong> true
<strong>解释:</strong>&nbsp;因为 &#39;*&#39; 表示零个或多个，这里 &#39;c&#39; 为 0 个, &#39;a&#39; 被重复一次。因此可以匹配字符串 &quot;aab&quot;。
</pre>

<p><strong>示例 5:</strong></p>

<pre><strong>输入:</strong>
s = &quot;mississippi&quot;
p = &quot;mis*is*p*.&quot;
<strong>输出:</strong> false</pre>

<ul>
	<li><code>s</code>&nbsp;可能为空，且只包含从&nbsp;<code>a-z</code>&nbsp;的小写字母。</li>
	<li><code>p</code>&nbsp;可能为空，且只包含从&nbsp;<code>a-z</code>&nbsp;的小写字母以及字符&nbsp;<code>.</code>&nbsp;和&nbsp;<code>*</code>，无连续的 <code>&#39;*&#39;</code>。</li>
</ul>

<p>注意：本题与主站 10&nbsp;题相同：<a href="https://leetcode-cn.com/problems/regular-expression-matching/">https://leetcode-cn.com/problems/regular-expression-matching/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
### 解题思路
假设主串为 $A$，模式串为 $B$ 从最后一步出发，需要关注最后进来的字符。假设 $A$ 的长度为 $n$ ，$B$ 的长度为 $m$ ，关注正则表达式 $B$ 的最后一个字符是谁，它有三种可能，正常字符、$*$ 和 .（点），那针对这三种情况讨论即可，如下：

1. 如果 $B$ 的最后一个字符是`正常字符`，那就是看 $A[n-1]$ 是否等于 $B[m-1]$，相等则看 $A_{0..n-2}$ 与 $B_{0..m-2}$，不等则是不能匹配，这就是子问题。

2. 如果 $B$ 的最后一个字符是`.`，它能匹配任意字符，直接看 $A_{0..n-2}$ 与 $B_{0..m-2}$

3. 如果 $B$ 的最后一个字符是`*`它代表 $B[m-2]=c$ 可以重复0次或多次，它们是一个整体 $c*$
   - 情况一：$A[n-1]$ 是 $0$ 个 $c$，$B$ 最后两个字符废了，能否匹配取决于 $A_{0..n-1}$ 和 $B_{0..m-3}$ 是否匹配
   - 情况二：$A[n-1]$ 是多个 $c$ 中的最后一个（这种情况必须 $A[n-1]=c$ 或者 $c='.'$），所以 $A$ 匹配完往前挪一个，$B$ 继续匹配，因为可以匹配多个，继续看 $A_{0..n-2}$ 和 $B_{0..m-1}$是否匹配。

### 转移方程
$f[i] [j]$ 代表 $A$ 的前 $i$ 个和 $B$ 的前 $j$ 个能否匹配

- 对于前面两个情况，可以合并成一种情况 $f[i][j] = f[i-1][j-1]$

- 对于第三种情况，对于 $c*$ 分为看和不看两种情况

  - 不看：直接砍掉正则串的后面两个， $f[i][j] = f[i][j-2]$
  - 看：正则串不动，主串前移一个，$f[i][j] = f[i-1][j]$

### 初始条件
特判：需要考虑空串空正则

- 空串和空正则是匹配的，$f[0][0] = true$
- 空串和非空正则，不能直接定义 $true$ 和 $false$，必须要计算出来。（比如$A=$ '' '' ,$B=a*b*c*$）
- 非空串和空正则必不匹配，$f[1][0]=...=f[n][0]=false$
- 非空串和非空正则，那肯定是需要计算的了。

大体上可以分为空正则和非空正则两种，空正则也是比较好处理的，对非空正则我们肯定需要计算，非空正则的三种情况，前面两种可以合并到一起讨论，第三种情况是单独一种，那么也就是分为当前位置是 $*$ 和不是 $*$ 两种情况了。

### 结果
我们开数组要开 $n+1$ ，这样对于空串的处理十分方便。结果就是 $f[n][m]$



### 代码如下
```java
class Solution {
    public boolean isMatch(String A, String B) {
        int n = A.length();
        int m = B.length();
        boolean[][] f = new boolean[n + 1][m + 1];

        for (int i = 0; i <= n; i++) {
            for (int j = 0; j <= m; j++) {
                //分成空正则和非空正则两种
                if (j == 0) {
                    f[i][j] = i == 0;
                } else {
                    //非空正则分为两种情况 * 和 非*
                    if (B.charAt(j - 1) != '*') {
                        if (i > 0 && (A.charAt(i - 1) == B.charAt(j - 1) || B.charAt(j - 1) == '.')) {
                            f[i][j] = f[i - 1][j - 1];
                        }
                    } else {
                        //碰到 * 了，分为看和不看两种情况
                        //不看
                        if (j >= 2) {
                            f[i][j] |= f[i][j - 2];
                        }
                        //看
                        if (i >= 1 && j >= 2 && (A.charAt(i - 1) == B.charAt(j - 2) || B.charAt(j - 2) == '.')) {
                            f[i][j] |= f[i - 1][j];
                        }
                    }
                }
            }
        }
        return f[n][m];
    }
}
```

### 可供选择的递归思路
```java
class Solution {
    public boolean isMatch(String A, String B) {
        // 如果字符串长度为0，需要检测下正则串
        if (A.length() == 0) {
            // 如果正则串长度为奇数，必定不匹配，比如 "."、"ab*",必须是 a*b*这种形式，*在奇数位上
            if (B.length() % 2 != 0) return false;
            int i = 1;
            while (i < B.length()) {
                if (B.charAt(i) != '*') return false;
                i += 2;
            }
            return true;
        }
        // 如果字符串长度不为0，但是正则串没了，return false
        if (B.length() == 0) return false;
        // c1 和 c2 分别是两个串的当前位，c3是正则串当前位的后一位，如果存在的话，就更新一下
        char c1 = A.charAt(0), c2 = B.charAt(0), c3 = 'a';
        if (B.length() > 1) {
            c3 = B.charAt(1);
        }
        // 和dp一样，后一位分为是 '*' 和不是 '*' 两种情况
        if (c3 != '*') {
            // 如果该位字符一样，或是正则串该位是 '.',也就是能匹配任意字符，就可以往后走
            if (c1 == c2 || c2 == '.') {
                return isMatch(A.substring(1), B.substring(1));
            } else {
                // 否则不匹配
                return false;
            }
        } else {
            // 如果该位字符一样，或是正则串该位是 '.'，和dp一样，有看和不看两种情况
            if (c1 == c2 || c2 == '.') {
                return isMatch(A.substring(1), B) || isMatch(A, B.substring(2));
            } else {
                // 不一样，那么正则串这两位就废了，直接往后走
                return isMatch(A, B.substring(2));
            }
        }
    }
}
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    71016    |    187565    |   37.9%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
