---
title: 剑指 Offer II 070-排序数组中只出现一次的数字
categories:
  - 中等
tags:
  - 数组
  - 二分查找
abbrlink: 1001699740
date: 2021-12-03 21:28:21
---

> 原文链接: https://leetcode-cn.com/problems/skFtm2




## 中文题目
<div><p>给定一个只包含整数的有序数组 <code>nums</code>&nbsp;，每个元素都会出现两次，唯有一个数只会出现一次，请找出这个唯一的数字。</p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<pre>
<strong>输入:</strong> nums = [1,1,2,3,3,4,4,8,8]
<strong>输出:</strong> 2
</pre>

<p><strong>示例 2:</strong></p>

<pre>
<strong>输入:</strong> nums =  [3,3,7,7,10,11,11]
<strong>输出:</strong> 10
</pre>

<p>&nbsp;</p>

<p>&nbsp;</p>

<p><meta charset="UTF-8" /></p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 10<sup>5</sup></code></li>
	<li><code>0 &lt;= nums[i]&nbsp;&lt;= 10<sup>5</sup></code></li>
</ul>

<p>&nbsp;</p>

<p><strong>进阶:</strong>&nbsp;采用的方案可以在 <code>O(log n)</code> 时间复杂度和 <code>O(1)</code> 空间复杂度中运行吗？</p>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 540&nbsp;题相同：<a href="https://leetcode-cn.com/problems/single-element-in-a-sorted-array/">https://leetcode-cn.com/problems/single-element-in-a-sorted-array/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
首先我们得想到二分，但是要做到这一点感觉需要一定的刷题经验，比如看到**查找目标值、有序、时间复杂度O(logn)等信息**，大概率就是二分了。

其次我们再来回答以下问题，

1. 数组的特征？
    - 数组长度为奇数
    - 递增排列
    - 只有一个数数量为1，其余为2
    - **每一对数字的下标要么是(奇数，偶数)，要么是(偶数，奇数)**
2. 目标值的特征？
    - 只有一个，也就是说它跟前后两个都不相同
3. 二分查找过程中中间值`nums[mid]`的特征？有三种情况
    - 它跟它后面一个数字相同
    - 它跟它前面一个数字相同
    - 它就是答案
4. 如何判断答案在哪一个可行区间内，也就是如何淘汰不可能的答案？
    - 前面提到了下标的奇偶性，聪明的你一定想到了二分的关键，那就是如果`mid`所对应的一对数字下标是`(奇数，偶数)`，那么目标一定在`mid`之前，如果下标是`(偶数，奇数)`，目标一定在`mid`之后

``` java
class Solution {
    public int singleNonDuplicate(int[] nums) {
        int n = nums.length, l = 0, r = n - 1;
        int ans = -1;
        while (l <= r) {
            int mid = l + (r - l) / 2;
            if (mid < n - 1 && nums[mid] == nums[mid + 1]) {
                if (mid % 2 == 0) {
                    l = mid + 2;
                } else {
                    r = mid - 1;
                }
            } else if (mid > 0 && nums[mid] == nums[mid - 1]) {
                if (mid % 2 == 0) {
                    r = mid - 2;
                } else {
                    l = mid + 1;
                }
            } else {
                ans = nums[mid];
                break;
            }
        }
        // 由于题目的性质，ans一定会被找到，所以不会返回-1
        return ans;
    }
}
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    4236    |    6526    |   64.9%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
