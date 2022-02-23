---
title: 剑指 Offer II 080-含有 k 个元素的组合
date: 2021-12-03 21:28:10
categories:
  - 中等
tags:
  - 数组
  - 回溯
---

> 原文链接: https://leetcode-cn.com/problems/uUsW3B




## 中文题目
<div><p>给定两个整数 <code>n</code> 和 <code>k</code>，返回 <code>1 ... n</code> 中所有可能的 <code>k</code> 个数的组合。</p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<pre>
<strong>输入:</strong>&nbsp;n = 4, k = 2
<strong>输出:</strong>
[
  [2,4],
  [3,4],
  [2,3],
  [1,2],
  [1,3],
  [1,4],
]</pre>

<p><strong>示例 2:</strong></p>

<pre>
<strong>输入:</strong>&nbsp;n = 1, k = 1
<strong>输出: </strong>[[1]]</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>1 &lt;= n &lt;= 20</code></li>
	<li><code>1 &lt;= k &lt;= n</code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 77&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/combinations/">https://leetcode-cn.com/problems/combinations/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
使用递归解题大家应该都知道，本题关键点还是在于要**知道和理解剪枝可以减少很多不必要的运算量**，例如该题无剪枝执行用时15ms，加了剪枝直接变成1ms。

``` java
class Solution {

    List<List<Integer>> ans;

    public List<List<Integer>> combine(int n, int k) {
        ans = new ArrayList<>();
        dfs(n, 1, k, new ArrayList<>());
        return ans;
    }

    public void dfs(int n, int th, int k, List<Integer> list) {
        // 剪枝：即使把从th开始的所有数都放入list也凑不齐k个，所以直接返回
        if (n - th + 1 < k) return ;
        if (k == 0) {
            ans.add(new ArrayList<>(list));
            return ;
        }
        // 搜索策略一：组合中有第th个
        list.add(th);
        dfs(n, th + 1, k - 1, list);
        list.remove(list.size() - 1);
        // 搜索策略二：组合中没有第th个
        dfs(n, th + 1, k, list);
    }
}
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    3697    |    4505    |   82.1%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
