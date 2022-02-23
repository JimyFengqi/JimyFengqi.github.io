---
title: 168-Excel表列名称(Excel Sheet Column Title)
date: 2021-12-03 22:54:01
categories:
  - 简单
tags:
  - 数学
  - 字符串
---

> 原文链接: https://leetcode-cn.com/problems/excel-sheet-column-title


## 英文原文
<div><p>Given an integer <code>columnNumber</code>, return <em>its corresponding column title as it appears in an Excel sheet</em>.</p>

<p>For example:</p>

<pre>
A -&gt; 1
B -&gt; 2
C -&gt; 3
...
Z -&gt; 26
AA -&gt; 27
AB -&gt; 28 
...
</pre>

<p>&nbsp;</p>
<p><strong>Example 1:</strong></p>

<pre>
<strong>Input:</strong> columnNumber = 1
<strong>Output:</strong> &quot;A&quot;
</pre>

<p><strong>Example 2:</strong></p>

<pre>
<strong>Input:</strong> columnNumber = 28
<strong>Output:</strong> &quot;AB&quot;
</pre>

<p><strong>Example 3:</strong></p>

<pre>
<strong>Input:</strong> columnNumber = 701
<strong>Output:</strong> &quot;ZY&quot;
</pre>

<p><strong>Example 4:</strong></p>

<pre>
<strong>Input:</strong> columnNumber = 2147483647
<strong>Output:</strong> &quot;FXSHRXW&quot;
</pre>

<p>&nbsp;</p>
<p><strong>Constraints:</strong></p>

<ul>
	<li><code>1 &lt;= columnNumber &lt;= 2<sup>31</sup> - 1</code></li>
</ul>
</div>

## 中文题目
<div><p>给你一个整数 <code>columnNumber</code> ，返回它在 Excel 表中相对应的列名称。</p>

<p>例如：</p>

<pre>
A -> 1
B -> 2
C -> 3
...
Z -> 26
AA -> 27
AB -> 28 
...
</pre>

<p> </p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>columnNumber = 1
<strong>输出：</strong>"A"
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>columnNumber = 28
<strong>输出：</strong>"AB"
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>columnNumber = 701
<strong>输出：</strong>"ZY"
</pre>

<p><strong>示例 4：</strong></p>

<pre>
<strong>输入：</strong>columnNumber = 2147483647
<strong>输出：</strong>"FXSHRXW"
</pre>

<p> </p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 <= columnNumber <= 2<sup>31</sup> - 1</code></li>
</ul>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
## 模拟

这是一道从 $1$ 开始的的 $26$ 进制转换题。

对于一般性的进制转换题目，只需要不断地对 $columnNumber$ 进行 `%` 运算取得最后一位，然后对 $columnNumber$ 进行 `/` 运算，将已经取得的位数去掉，直到 $columnNumber$ 为 $0$ 即可。

一般性的进制转换题目无须进行额外操作，是因为我们是在「每一位数值范围在 $[0,x)$」的前提下进行「逢 $x$ 进一」。

但本题需要我们将从 $1$ 开始，因此在执行「进制转换」操作前，我们需要先对 $columnNumber$ 执行减一操作，从而实现整体偏移。

代码：
```Java []
class Solution {
    public String convertToTitle(int cn) {
        StringBuilder sb = new StringBuilder();
        while (cn > 0) {
            cn--;
            sb.append((char)(cn % 26 + 'A'));
            cn /= 26;
        }
        sb.reverse();
        return sb.toString();
    }
}
```
* 时间复杂度：$O(\log_{26}{cn})$
* 空间复杂度：不算构造答案所消耗的空间，复杂度为 $O(1)$

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    89042    |    205406    |   43.3%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |


## 相似题目
|                             题目                             | 难度 |
| :----------------------------------------------------------: | :---------: |
| [Excel 表列序号](https://leetcode-cn.com/problems/excel-sheet-column-number/) | 简单|
