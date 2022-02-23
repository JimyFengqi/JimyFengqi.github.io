---
title: 剑指 Offer II 082-含有重复元素集合的组合
categories:
  - 中等
tags:
  - 数组
  - 回溯
abbrlink: 3772141861
date: 2021-12-03 21:33:03
---

> 原文链接: https://leetcode-cn.com/problems/4sjJUc




## 中文题目
<div><p>给定一个可能有重复数字的整数数组&nbsp;<code>candidates</code>&nbsp;和一个目标数&nbsp;<code>target</code>&nbsp;，找出&nbsp;<code>candidates</code>&nbsp;中所有可以使数字和为&nbsp;<code>target</code>&nbsp;的组合。</p>

<p><code>candidates</code>&nbsp;中的每个数字在每个组合中只能使用一次，解集不能包含重复的组合。&nbsp;</p>

<p>&nbsp;</p>

<p><strong>示例&nbsp;1:</strong></p>

<pre>
<strong>输入:</strong> candidates =&nbsp;<code>[10,1,2,7,6,1,5]</code>, target =&nbsp;<code>8</code>,
<strong>输出:</strong>
[
[1,1,6],
[1,2,5],
[1,7],
[2,6]
]</pre>

<p><strong>示例&nbsp;2:</strong></p>

<pre>
<strong>输入:</strong> candidates =&nbsp;[2,5,2,1,2], target =&nbsp;5,
<strong>输出:</strong>
[
[1,2,2],
[5]
]</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>1 &lt;=&nbsp;candidates.length &lt;= 100</code></li>
	<li><code>1 &lt;=&nbsp;candidates[i] &lt;= 50</code></li>
	<li><code>1 &lt;= target &lt;= 30</code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 40&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/combination-sum-ii/">https://leetcode-cn.com/problems/combination-sum-ii/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
我们定义`dfs(idx, target)`为：

> 选中candidate[idx]，同时与从下标为[idx + 1, candidate.length)中选取元素一起构成和为target的所有不重复组合的集合。

本题难点有二：

### 一、避免重复答案

为了避免重复的答案，首先我们要做的就是给数组排序，如果说我**在同一级递归中，遇到两个相同的数**，我们应该只dfs靠前的那一个一次。原因的话，我们可以这样理解，如果现在遇到下标位`idx`，`idx + 1`的两个数是相同的，那么对于集合`dfs(idx, target)` 和 `dfs(idx + 1, target)`，后者就是前者的一个子集，所以**我们在同一级递归中，对于相同的数，只应该dfs一次，并且是下标最小的那一个**。

### 二、剪枝

剪枝就是基于很直接的思想，例如：**前面已经给数组排序了，如果递归的过程中当前值比target大，那么说明后面的值不可能再找出一组元素和为target，所以此时就可以立即结束递归返回。**

```java
class Solution {
    public List<List<Integer>> combinationSum2(int[] candidates, int target) {
        int n = candidates.length;
        List<List<Integer>> ans = new ArrayList<>();
        Arrays.sort(candidates);
        dfs(candidates, n, 0, target, new ArrayList<>(), ans);
        return  ans;
    }

    public void dfs(int[] candidate, int n, int idx, int target, List<Integer> list, List<List<Integer>> ans) {
        if (target == 0) {
            ans.add(new ArrayList<>(list));
            return ;
        }
        for (int i = idx; i < n; i++) {
            if (candidate[i] > target) { // 剪枝
                break;
            }
            if (i > idx && candidate[i] == candidate[i - 1]) { // 剪枝、避免重复
                // 因为前面那个同样的数已经经历过dfs，再拿同样的数dfs就会得到重复的答案
                continue;
            }
            list.add(candidate[i]);
            dfs(candidate, n, i + 1, target - candidate[i], list, ans);
            list.remove(list.size() - 1);
        }
    }
}
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    4203    |    6508    |   64.6%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
