---
title: 剑指 Offer II 068-查找插入位置
categories:
  - 简单
tags:
  - 数组
  - 二分查找
abbrlink: 2525176081
date: 2021-12-03 21:28:22
---

> 原文链接: https://leetcode-cn.com/problems/N6YdxV




## 中文题目
<div><p>给定一个排序的整数数组 <code>nums</code>&nbsp;和一个整数目标值<code> target</code> ，请在数组中找到&nbsp;<code>target&nbsp;</code>，并返回其下标。如果目标值不存在于数组中，返回它将会被按顺序插入的位置。</p>

<p>请必须使用时间复杂度为 <code>O(log n)</code> 的算法。</p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<pre>
<strong>输入:</strong> nums = [1,3,5,6], target = 5
<strong>输出:</strong> 2
</pre>

<p><strong>示例&nbsp;2:</strong></p>

<pre>
<strong>输入:</strong> nums = [1,3,5,6], target = 2
<strong>输出:</strong> 1
</pre>

<p><strong>示例 3:</strong></p>

<pre>
<strong>输入:</strong> nums = [1,3,5,6], target = 7
<strong>输出:</strong> 4
</pre>

<p><strong>示例 4:</strong></p>

<pre>
<strong>输入:</strong> nums = [1,3,5,6], target = 0
<strong>输出:</strong> 0
</pre>

<p><strong>示例 5:</strong></p>

<pre>
<strong>输入:</strong> nums = [1], target = 0
<strong>输出:</strong> 0
</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 10<sup>4</sup></code></li>
	<li><code>-10<sup>4</sup> &lt;= nums[i] &lt;= 10<sup>4</sup></code></li>
	<li><code>nums</code> 为<strong>无重复元素</strong>的<strong>升序</strong>排列数组</li>
	<li><code>-10<sup>4</sup> &lt;= target &lt;= 10<sup>4</sup></code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 35&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/search-insert-position/">https://leetcode-cn.com/problems/search-insert-position/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# **二分查找**
这道题就是标准二分查找的一个变型，代码比较简单，主要说明两点：
1. mid = left + ((right - left) >> 1) 的写法比 mid = (left + right) / 2 好，因为 left + right 可能会溢出，同时位运算的效率更高；
2. 当出现 nums[mid] >= target 的情况，还需要加一个判断 mid == 0 || nums[mid - 1] < target，若成立则说明，前一个数比 target 小，那么就找到了位置。若在 while 循环内都未找到符合要求的位置，那么说明 target 比所有的数都要大，需要插入到数组的最后一个数字之后，即返回 nums.size()。


```
class Solution {
public:
    int searchInsert(vector<int>& nums, int target) {
        int left = 0;
        int right = nums.size() - 1;
        while (left <= right) {
            int mid = left + ((right - left) >> 1);
            if (nums[mid] >= target) {
                if (mid == 0 || nums[mid - 1] < target) {
                    return mid;
                }
                right = mid - 1;
            }
            else {
                left = mid + 1;
            }
        }
        return nums.size();
    }
};
```
提供一下二分查找的标准模板，不建议用递归的形式实现，用迭代比较好。
```
int left = 0;
int right = nums.size() - 1;
while (left <= right) {
    int mid = left + ((right - left) >> 1);
    if (nums[mid] == target) {
        return mid;
    }
    nums[mid] > target ? right = mid - 1 : left = mid + 1;
}
return -1;
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    4617    |    9174    |   50.3%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
