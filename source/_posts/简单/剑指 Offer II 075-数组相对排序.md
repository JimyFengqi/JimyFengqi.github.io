---
title: 剑指 Offer II 075-数组相对排序
date: 2021-12-03 21:28:14
categories:
  - 简单
tags:
  - 数组
  - 哈希表
  - 计数排序
  - 排序
---

> 原文链接: https://leetcode-cn.com/problems/0H97ZC




## 中文题目
<div><p>给定两个数组，<code>arr1</code> 和&nbsp;<code>arr2</code>，</p>

<ul>
	<li><code>arr2</code>&nbsp;中的元素各不相同</li>
	<li><code>arr2</code> 中的每个元素都出现在&nbsp;<code>arr1</code>&nbsp;中</li>
</ul>

<p>对 <code>arr1</code>&nbsp;中的元素进行排序，使 <code>arr1</code> 中项的相对顺序和&nbsp;<code>arr2</code>&nbsp;中的相对顺序相同。未在&nbsp;<code>arr2</code>&nbsp;中出现过的元素需要按照升序放在&nbsp;<code>arr1</code>&nbsp;的末尾。</p>

<p>&nbsp;</p>

<p><strong>示例：</strong></p>

<pre>
<strong>输入：</strong>arr1 = [2,3,1,3,2,4,6,7,9,2,19], arr2 = [2,1,4,3,9,6]
<strong>输出：</strong>[2,2,2,1,4,3,3,9,6,7,19]
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= arr1.length, arr2.length &lt;= 1000</code></li>
	<li><code>0 &lt;= arr1[i], arr2[i] &lt;= 1000</code></li>
	<li><code>arr2</code>&nbsp;中的元素&nbsp;<code>arr2[i]</code>&nbsp;各不相同</li>
	<li><code>arr2</code> 中的每个元素&nbsp;<code>arr2[i]</code>&nbsp;都出现在&nbsp;<code>arr1</code>&nbsp;中</li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 1122&nbsp;题相同：<a href="https://leetcode-cn.com/problems/relative-sort-array/">https://leetcode-cn.com/problems/relative-sort-array/</a>&nbsp;</p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# **计数排序**
题目中明确数组内数字的范围为 0 ~ 1000，据此可以考虑使用计数排序。首先使用一个长度为 1001 的数组 counts 统计数组 arr1 内每个数字的出现次数，之后根据题目要求先排序数组 arr2 内出现的数字，最后排序 counts 内剩下的数字。

由于题目中已经明确辅助数组的长度，所以空间复杂度可以认为是 O(1)，若数组 arr1 和 arr2 的长度分别为 m 和 n，那么算法的总时间复杂度为 O(n+m)。
```
class Solution {
public:
    vector<int> relativeSortArray(vector<int>& arr1, vector<int>& arr2) {
        vector<int> counts(1001, 0);
        for (auto& n : arr1) {
            counts[n]++;
        }

        int i = 0;
        // 排序 arr2 内的数字
        for (auto& n : arr2) {
            while (counts[n] > 0) {
                arr1[i++] = n;
                counts[n]--;
            }
        }
        // 排序剩下的数字
        for (int j = 0; j < counts.size(); ++j) {
            while (counts[j] > 0) {
                arr1[i++] = j;
                counts[j]--;
            }
        }
        return arr1;
    }
};
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    3919    |    5490    |   71.4%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
