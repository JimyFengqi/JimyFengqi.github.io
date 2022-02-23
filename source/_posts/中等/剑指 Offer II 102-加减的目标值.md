---
title: 剑指 Offer II 102-加减的目标值
categories:
  - 中等
tags:
  - 数组
  - 动态规划
  - 回溯
abbrlink: 1477372695
date: 2021-12-03 21:31:03
---

> 原文链接: https://leetcode-cn.com/problems/YaVDxD




## 中文题目
<div><p>给定一个正整数数组 <code>nums</code> 和一个整数 <code>target</code> 。</p>

<p>向数组中的每个整数前添加&nbsp;<code>&#39;+&#39;</code> 或 <code>&#39;-&#39;</code> ，然后串联起所有整数，可以构造一个 <strong>表达式</strong> ：</p>

<ul>
	<li>例如，<code>nums = [2, 1]</code> ，可以在 <code>2</code> 之前添加 <code>&#39;+&#39;</code> ，在 <code>1</code> 之前添加 <code>&#39;-&#39;</code> ，然后串联起来得到表达式 <code>&quot;+2-1&quot;</code> 。</li>
</ul>

<p>返回可以通过上述方法构造的、运算结果等于 <code>target</code> 的不同 <strong>表达式</strong> 的数目。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>nums = [1,1,1,1,1], target = 3
<strong>输出：</strong>5
<strong>解释：</strong>一共有 5 种方法让最终目标和为 3 。
-1 + 1 + 1 + 1 + 1 = 3
+1 - 1 + 1 + 1 + 1 = 3
+1 + 1 - 1 + 1 + 1 = 3
+1 + 1 + 1 - 1 + 1 = 3
+1 + 1 + 1 + 1 - 1 = 3
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>nums = [1], target = 1
<strong>输出：</strong>1
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 20</code></li>
	<li><code>0 &lt;= nums[i] &lt;= 1000</code></li>
	<li><code>0 &lt;= sum(nums[i]) &lt;= 1000</code></li>
	<li><code>-1000 &lt;= target &lt;= 1000</code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 494&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/target-sum/">https://leetcode-cn.com/problems/target-sum/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
我总结了剑指Offer专项训练的所有题目类型，并给出了刷题建议和所有题解。

在github上开源了，不来看看吗？顺道一提：还有C++、数据结构与算法、计算机网络、操作系统、数据库的秋招知识总结，求求star了，这对我真的很重要？

$\Rightarrow$[通关剑2](https://github.com/muluoleiguo/interview/tree/master/%E9%9D%A2%E8%AF%95/%E7%AE%97%E6%B3%95%E4%B8%8E%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/%E5%89%91%E6%8C%87Offer%E4%B8%93%E9%A1%B9%E8%AE%AD%E7%BB%83%EF%BC%88%E5%89%912%EF%BC%89)

### 解题思路
[背包问题串讲](https://leetcode-cn.com/problems/D0F0SV/solution/tong-guan-jian-2-shuang-bai-bei-bao-dp-b-f33v/)
这道题的关键是看出来可以用背包来做，否则搜索就只有回家凉快去了。
假设加上'+'的**数字之和**是pos，前面加'-'**数字之和**neg， 所有数字之和为sum
符合条件的情况有：
pos - neg = target
等价：
pos - (sum - pos) = tar
2pos - sum = tar
pos = (target + sum) / 2 

需要注意的是这里都是整数运算，不能舍，因此如果target + sum是奇数，则一定不可能，直接返回0

因此我们的物品还是nums数组，但是背包容量变成了pos，这就是我们要凑成的情况，并且这道题是组合，先遍历物品（见上面超链接里解析）



### 代码
执行用时：0 ms, 在所有 C++ 提交中击败了100.00%

```cpp
class Solution {
public:
    int findTargetSumWays(vector<int>& nums, int target) {
        int sum = accumulate(nums.begin(), nums.end(), 0);
        if ((target + sum) & 1) return 0;
        int cap = (sum + target >> 1);
        vector<int> dp(cap + 1);
        dp[0] = 1;
        for (const int& num : nums)
            for (int i = cap; i >= num; --i) {
                dp[i] += dp[i - num];
            }
        return dp[cap];       
    }
};
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    2438    |    4105    |   59.4%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
