---
title: 1078-Bigram 分词(Occurrences After Bigram)
categories:
  - 简单
tags:
  - 字符串
abbrlink: 945362688
date: 2021-12-03 22:23:31
---

> 原文链接: https://leetcode-cn.com/problems/occurrences-after-bigram


## 英文原文
<div><p>Given two strings <code>first</code> and <code>second</code>, consider occurrences in some text of the form <code>&quot;first second third&quot;</code>, where <code>second</code> comes immediately after <code>first</code>, and <code>third</code> comes immediately after <code>second</code>.</p>

<p>Return <em>an array of all the words</em> <code>third</code> <em>for each occurrence of</em> <code>&quot;first second third&quot;</code>.</p>

<p>&nbsp;</p>
<p><strong>Example 1:</strong></p>
<pre><strong>Input:</strong> text = "alice is a good girl she is a good student", first = "a", second = "good"
<strong>Output:</strong> ["girl","student"]
</pre><p><strong>Example 2:</strong></p>
<pre><strong>Input:</strong> text = "we will we will rock you", first = "we", second = "will"
<strong>Output:</strong> ["we","rock"]
</pre>
<p>&nbsp;</p>
<p><strong>Constraints:</strong></p>

<ul>
	<li><code>1 &lt;= text.length &lt;= 1000</code></li>
	<li><code>text</code> consists of lowercase English letters and spaces.</li>
	<li>All the words in <code>text</code> a separated by <strong>a single space</strong>.</li>
	<li><code>1 &lt;= first.length, second.length &lt;= 10</code></li>
	<li><code>first</code> and <code>second</code> consist of lowercase English letters.</li>
</ul>
</div>

## 中文题目
<div><p>给出第一个词&nbsp;<code>first</code> 和第二个词&nbsp;<code>second</code>，考虑在某些文本&nbsp;<code>text</code>&nbsp;中可能以 &quot;<code>first second third</code>&quot; 形式出现的情况，其中&nbsp;<code>second</code>&nbsp;紧随&nbsp;<code>first</code>&nbsp;出现，<code>third</code>&nbsp;紧随&nbsp;<code>second</code>&nbsp;出现。</p>

<p>对于每种这样的情况，将第三个词 &quot;<code>third</code>&quot; 添加到答案中，并返回答案。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre><strong>输入：</strong>text = &quot;alice is a good girl she is a good student&quot;, first = &quot;a&quot;, second = &quot;good&quot;
<strong>输出：</strong>[&quot;girl&quot;,&quot;student&quot;]
</pre>

<p><strong>示例 2：</strong></p>

<pre><strong>输入：</strong>text = &quot;we will we will rock you&quot;, first = &quot;we&quot;, second = &quot;will&quot;
<strong>输出：</strong>[&quot;we&quot;,&quot;rock&quot;]
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ol>
	<li><code>1 &lt;= text.length &lt;= 1000</code></li>
	<li><code>text</code>&nbsp;由一些用空格分隔的单词组成，每个单词都由小写英文字母组成</li>
	<li><code>1 &lt;= first.length, second.length &lt;= 10</code></li>
	<li><code>first</code> 和&nbsp;<code>second</code>&nbsp;由小写英文字母组成</li>
</ol>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
1.split
2.zip(text, text[1:], text[2:])
3.列表推导式
```
class Solution:
    def findOcurrences(self, text: str, first: str, second: str) -> List[str]:
        text = text.split()
        return [trd for fst, sed, trd in zip(text, text[1:], text[2:]) if fst == first and sed == second]
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    12223    |    19682    |   62.1%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
