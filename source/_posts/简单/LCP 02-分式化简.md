---
title: LCP 02-分式化简(Deep Dark Fraction)
categories:
  - 简单
tags:
  - 数组
  - 数学
  - 数论
  - 模拟
abbrlink: 1048391933
date: 2021-12-03 21:55:48
---

> 原文链接: https://leetcode-cn.com/problems/deep-dark-fraction




## 中文题目
<div><p>有一个同学在学习分式。他需要将一个连分数化成最简分数，你能帮助他吗？</p>

<p><img alt="" src="https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2019/09/09/fraction_example_1.jpg" style="height: 195px; width: 480px;" /></p>

<p>连分数是形如上图的分式。在本题中，所有系数都是大于等于0的整数。</p>

<p> </p>

<p>输入的<code>cont</code>代表连分数的系数（<code>cont[0]</code>代表上图的<code>a<sub>0</sub></code>，以此类推）。返回一个长度为2的数组<code>[n, m]</code>，使得连分数的值等于<code>n / m</code>，且<code>n, m</code>最大公约数为1。</p>

<p> </p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>cont = [3, 2, 0, 2]
<strong>输出：</strong>[13, 4]
<strong>解释：</strong>原连分数等价于3 + (1 / (2 + (1 / (0 + 1 / 2))))。注意[26, 8], [-13, -4]都不是正确答案。</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>cont = [0, 0, 3]
<strong>输出：</strong>[3, 1]
<strong>解释：</strong>如果答案是整数，令分母为1即可。</pre>

<p> </p>

<p><strong>限制：</strong></p>

<ol>
	<li><code>cont[i] >= 0</code></li>
	<li><code>1 <= cont的长度 <= 10</code></li>
	<li><code>cont</code>最后一个元素不等于0</li>
	<li>答案的<code>n, m</code>的取值都能被32位int整型存下（即不超过<code>2 ^ 31 - 1</code>）。</li>
</ol>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
最开始（最里面一项），整数 $a_{n-2}$，分子 $1$，分母 $a_{n-1}$，分子分母已经约分。

假设第 $k$ 次 化简，需要计算 $a + \frac{n}{d}$ 中 $n$ 与 $d$ 已经约分。

化简后分子为 $a*d+n$，分母为 $d$。

如果需要约分，那么 $a*d+n$ 和 $d$ 可以写成 $x*c$ 与 $y*c$ 的形式， $c$ 是公约数，且不为 $1$。

$$
x*c = a*d+n = a*(y*c)+n
$$

那么 $n = (x - a*y)*c$，与 $d$ 有非 $1$ 公约数 $c$ 与之前假设 $n$ 与 $d$ 已经约分矛盾。

所以，不用约分。

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    14114    |    20416    |   69.1%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
