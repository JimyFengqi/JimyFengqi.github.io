---
title: 剑指 Offer II 081-允许重复选择元素的组合
date: 2021-12-03 21:33:05
categories:
  - 中等
tags:
  - 数组
  - 回溯
---

> 原文链接: https://leetcode-cn.com/problems/Ygoe9J




## 中文题目
<div><p>给定一个<strong>无重复元素</strong>的正整数数组&nbsp;<code>candidates</code>&nbsp;和一个正整数&nbsp;<code>target</code>&nbsp;，找出&nbsp;<code>candidates</code>&nbsp;中所有可以使数字和为目标数&nbsp;<code>target</code>&nbsp;的唯一组合。</p>

<p><code>candidates</code>&nbsp;中的数字可以无限制重复被选取。如果至少一个所选数字数量不同，则两种组合是唯一的。&nbsp;</p>

<p>对于给定的输入，保证和为&nbsp;<code>target</code> 的唯一组合数少于 <code>150</code> 个。</p>

<p>&nbsp;</p>

<p><strong>示例&nbsp;1：</strong></p>

<pre>
<strong>输入: </strong>candidates = <code>[2,3,6,7], </code>target = <code>7</code>
<strong>输出: </strong>[[7],[2,2,3]]
</pre>

<p><strong>示例&nbsp;2：</strong></p>

<pre>
<strong>输入: </strong>candidates = [2,3,5]<code>, </code>target = 8
<strong>输出: </strong>[[2,2,2,2],[2,3,3],[3,5]]</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入: </strong>candidates = <code>[2], </code>target = <span style="white-space: pre-wrap;">1</span>
<strong>输出: </strong>[]
</pre>

<p><strong>示例 4：</strong></p>

<pre>
<strong>输入: </strong>candidates = <code>[1], </code>target = <code>1</code>
<strong>输出: </strong>[[1]]
</pre>

<p><strong>示例 5：</strong></p>

<pre>
<strong>输入: </strong>candidates = <code>[1], </code>target = <code>2</code>
<strong>输出: </strong>[[1,1]]
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= candidates.length &lt;= 30</code></li>
	<li><code>1 &lt;= candidates[i] &lt;= 200</code></li>
	<li><code>candidate</code> 中的每个元素都是独一无二的。</li>
	<li><code>1 &lt;= target &lt;= 500</code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 39&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/combination-sum/">https://leetcode-cn.com/problems/combination-sum/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# **回溯法 + 剪枝**
这道题与之前的唯一区别就是同一个数字可以多次选择。这道题中每一步都从集合中取出一个元素时，存在多个选择，一种是不添加该数字，其他选择就是选择 1 次该数字，2 次该数字...。

其实归根到底，也是两种选择，一种是选择不添加，另一种是选择添加。如果选择不添加，那么只需要调用递归函数判断下一个数字。如果选择添加，那么只需要调用递归函数继续判断该数字。这样的处理就可以与之前的题目完全统一，完整的代码如下。

```
class Solution {
private:
    void helper(vector<int>& candidates, int target, int index, vector<vector<int>>& ret, vector<int>& cur) {
        // 得到答案
        if (target == 0) {
            ret.emplace_back(cur);
            return;
        }
        // 超界
        if (target < 0 || index == candidates.size()) {
            return;
        }
        // 不加入 candidates[index]
        helper(candidates, target, index + 1, ret, cur);

        // 加入 candidates[index]
        cur.push_back(candidates[index]);
        helper(candidates, target - candidates[index], index, ret, cur);
        cur.pop_back();
    }

public:
    vector<vector<int>> combinationSum(vector<int>& candidates, int target) {
        vector<vector<int>> ret;
        vector<int> cur;
        helper(candidates, target, 0, ret, cur);
        return ret;
    }
};
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    5466    |    6978    |   78.3%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
