---
title: 剑指 Offer II 079-所有子集
categories:
  - 中等
tags:
  - 位运算
  - 数组
  - 回溯
abbrlink: 1726941184
date: 2021-12-03 21:28:11
---

> 原文链接: https://leetcode-cn.com/problems/TVdhkn




## 中文题目
<div><p>给定一个整数数组&nbsp;<code>nums</code> ，数组中的元素 <strong>互不相同</strong> 。返回该数组所有可能的子集（幂集）。</p>

<p>解集 <strong>不能</strong> 包含重复的子集。你可以按 <strong>任意顺序</strong> 返回解集。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>nums = [1,2,3]
<strong>输出：</strong>[[],[1],[2],[1,2],[3],[1,3],[2,3],[1,2,3]]
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>nums = [0]
<strong>输出：</strong>[[],[0]]
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 10</code></li>
	<li><code>-10 &lt;= nums[i] &lt;= 10</code></li>
	<li><code>nums</code> 中的所有元素 <strong>互不相同</strong></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 78&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/subsets/">https://leetcode-cn.com/problems/subsets/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
二进制枚举（更多的时候我们叫其为`状态压缩`）是在一些题目中常见的技巧，例如本体中，`nums.length <= 10`，所以我们可以**用10个bit来表示每个下标的元素取或者不取**，而Java中的int有32位，所以足够我们来进行状态枚举了。

``` java
class Solution {
    public static List<List<Integer>> subsets(int[] nums) {
        List<List<Integer>> res = new ArrayList<>();
        // i 就是枚举的状态，取值范围[0, 2^nums.length)
        for (int i = 0; i < Math.pow(2, nums.length); i++) {
            List<Integer> subRes = new ArrayList<>();
            for (int j = 0; j < nums.length; j++) {
                if ((i & (1 << j)) > 0) {
                    subRes.add(nums[j]);
                }
            }
            res.add(subRes);
        }
        return res;
    }
}
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    4548    |    5350    |   85.0%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
