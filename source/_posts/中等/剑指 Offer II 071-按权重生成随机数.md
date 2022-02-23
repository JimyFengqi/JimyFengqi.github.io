---
title: 剑指 Offer II 071-按权重生成随机数
date: 2021-12-03 21:28:20
categories:
  - 中等
tags:
  - 数学
  - 二分查找
  - 前缀和
  - 随机化
---

> 原文链接: https://leetcode-cn.com/problems/cuyjEf




## 中文题目
<div><p>给定一个正整数数组&nbsp;<code>w</code> ，其中&nbsp;<code>w[i]</code>&nbsp;代表下标 <code>i</code>&nbsp;的权重（下标从 <code>0</code> 开始），请写一个函数&nbsp;<code>pickIndex</code>&nbsp;，它可以随机地获取下标 <code>i</code>，选取下标 <code>i</code>&nbsp;的概率与&nbsp;<code>w[i]</code>&nbsp;成正比。</p>

<ol>
</ol>

<p>例如，对于 <code>w = [1, 3]</code>，挑选下标 <code>0</code> 的概率为 <code>1 / (1 + 3)&nbsp;= 0.25</code> （即，25%），而选取下标 <code>1</code> 的概率为 <code>3 / (1 + 3)&nbsp;= 0.75</code>（即，75%）。</p>

<p>也就是说，选取下标 <code>i</code> 的概率为 <code>w[i] / sum(w)</code> 。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>
inputs = [&quot;Solution&quot;,&quot;pickIndex&quot;]
inputs = [[[1]],[]]
<strong>输出：</strong>
[null,0]
<strong>解释：</strong>
Solution solution = new Solution([1]);
solution.pickIndex(); // 返回 0，因为数组中只有一个元素，所以唯一的选择是返回下标 0。</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>
inputs = [&quot;Solution&quot;,&quot;pickIndex&quot;,&quot;pickIndex&quot;,&quot;pickIndex&quot;,&quot;pickIndex&quot;,&quot;pickIndex&quot;]
inputs = [[[1,3]],[],[],[],[],[]]
<strong>输出：</strong>
[null,1,1,1,1,0]
<strong>解释：</strong>
Solution solution = new Solution([1, 3]);
solution.pickIndex(); // 返回 1，返回下标 1，返回该下标概率为 3/4 。
solution.pickIndex(); // 返回 1
solution.pickIndex(); // 返回 1
solution.pickIndex(); // 返回 1
solution.pickIndex(); // 返回 0，返回下标 0，返回该下标概率为 1/4 。

由于这是一个随机问题，允许多个答案，因此下列输出都可以被认为是正确的:
[null,1,1,1,1,0]
[null,1,1,1,1,1]
[null,1,1,1,0,0]
[null,1,1,1,0,1]
[null,1,0,1,0,0]
......
诸若此类。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= w.length &lt;= 10000</code></li>
	<li><code>1 &lt;= w[i] &lt;= 10^5</code></li>
	<li><code>pickIndex</code>&nbsp;将被调用不超过&nbsp;<code>10000</code>&nbsp;次</li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 528&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/random-pick-with-weight/">https://leetcode-cn.com/problems/random-pick-with-weight/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# **二分查找**
以权重数组 [1, 2, 3, 4] 为例，那么选择下标 0 的概率为 10% (1/10)，选择下标 1 、2 和 3 的概率一次为 20% 、30% 和40%。考虑如何根据权重比例随机选择一个下标，先按等概率生成 1 ~ 10，则每个数字的概率的都为 10%。如果生成 1 则选择下标 0，概率为 10%；如果生成 2 或 3 则选择下标 1，概率为 20%；如果生成 4、5 或 6 则选择下标 2，概率为 30%；如果生成 7、8、9 或 10 则选择下标 3，概率为 40%。

通过上面的例子可以发现，可以创建一个和权重数组一样长度的数组 acc，新数组的第 i 个数值 acc[i] 就是权重数组的前 i 个数组之和。有了这个数组就可以很方便的根据随机等概生成的数字选则对应的下标。方式如下：
1. 等概率在区间 [1, acc.back()] 上随机生成数字 n;
2. 找到区间 n <= acc[m] && (m == 0 || n > acc[m - 1])，则下标 m 就是输出的下标值。

因为数组 acc 是一个递增数组，所以可以使用二分查找找到目标区间。

完整的代码如下，函数 pickIndex 的时间复杂度为 O(logn)。

```
class Solution {
private:
    vector<int> acc;
public:
    Solution(vector<int>& w) {
        acc.resize(w.size(), 0);
        int sum = 0;
        for (int i = 0; i < w.size(); ++i) {
            sum += w[i];
            acc[i] = sum;
        }
    }
    
    int pickIndex() {
        int rad = rand() % acc.back() + 1;
        int left = 0;
        int right = acc.size() - 1;
        while (left <= right) {
            int mid = left + ((right - left) >> 1);
            if (rad <= acc[mid]) {
                if (mid == 0 || rad > acc[mid - 1]) {
                    return mid;
                }
                right = mid - 1;
            }
            else {
                left = mid + 1;
            }
        }
        return -1;
    }
};
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    1905    |    3752    |   50.8%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
