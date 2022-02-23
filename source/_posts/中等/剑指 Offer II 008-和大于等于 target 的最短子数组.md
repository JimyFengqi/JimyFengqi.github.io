---
title: 剑指 Offer II 008-和大于等于 target 的最短子数组
categories:
  - 中等
tags:
  - 数组
  - 二分查找
  - 前缀和
  - 滑动窗口
abbrlink: 2733052492
date: 2021-12-03 21:32:50
---

> 原文链接: https://leetcode-cn.com/problems/2VG8Kg




## 中文题目
<div><p>给定一个含有&nbsp;<code>n</code><strong>&nbsp;</strong>个正整数的数组和一个正整数 <code>target</code><strong> 。</strong></p>

<p>找出该数组中满足其和<strong> </strong><code>&ge; target</code><strong> </strong>的长度最小的 <strong>连续子数组</strong>&nbsp;<code>[nums<sub>l</sub>, nums<sub>l+1</sub>, ..., nums<sub>r-1</sub>, nums<sub>r</sub>]</code> ，并返回其长度<strong>。</strong>如果不存在符合条件的子数组，返回 <code>0</code> 。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>target = 7, nums = [2,3,1,2,4,3]
<strong>输出：</strong>2
<strong>解释：</strong>子数组&nbsp;<code>[4,3]</code>&nbsp;是该条件下的长度最小的子数组。
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>target = 4, nums = [1,4,4]
<strong>输出：</strong>1
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>target = 11, nums = [1,1,1,1,1,1,1,1]
<strong>输出：</strong>0
</pre>

<p>&nbsp;</p>

<p>提示：</p>

<ul>
	<li><code>1 &lt;= target &lt;= 10<sup>9</sup></code></li>
	<li><code>1 &lt;= nums.length &lt;= 10<sup>5</sup></code></li>
	<li><code>1 &lt;= nums[i] &lt;= 10<sup>5</sup></code></li>
</ul>

<p>&nbsp;</p>

<p>进阶：</p>

<ul>
	<li>如果你已经实现<em> </em><code>O(n)</code> 时间复杂度的解法, 请尝试设计一个 <code>O(n log(n))</code> 时间复杂度的解法。</li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 209&nbsp;题相同：<a href="https://leetcode-cn.com/problems/minimum-size-subarray-sum/">https://leetcode-cn.com/problems/minimum-size-subarray-sum/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
## 昨日回顾

上一篇文章，我们讲解了数据结构的分类，并对于学习到的第一种数据结构--**数组**进行了简单介绍。

在介绍解题时，向大家简述了双指针的解题思路。指针的解题思路一般分为三类：

- 首尾指针：范围查找，比如二分搜索等
- 滑动窗口：指针处在数组同一方向，根据条件移动左右指针，用于获取范围和等
- 快慢指针： 多用于链表计算时，判断是否有环等

那么今天针对滑动窗口的延伸，会再提供两道题目供大家深入理解。

## 滑动窗口解题模板

不同于咱们第一章学习的整数那般没有规律，滑动窗口可是有模板可套的。通过模板我们可以快速完成解题，但前提是，首先你要知道，题目属于滑动窗口的解题范围。那么滑窗的题目怎么识别呢？一般题目中都会有明确的“**连续子数组**”、“**连续子串**”等关键字，另外可能会附带**最大**、**最小**的限定词进行补充。

那么遇到这类型题目，该如何思考呢？分为以下几步：

1. 初始化窗口左边界为0，右边界可以为0，也可以根据题意固定大小。
2. 我们需要初始化一个ret的返回值，默认为0或者根据题意默认为最大值。
   - 最小值根据题意选择0 或者Java: Integer.MIN_VALUE ; Python:-float('inf')
   - 最大值根据题意选择 Java: Integer.MAX_VALUE Python： float('inf')
3. 窗口的大小需要根据题目条件进行调整
   - 最大连续...尽量扩张右边界，直到不满足题意再收缩左边界
   - 最小连续...尽量缩小左边界，直到不满足题意再扩大右边界
4. 在执行3操作的过程中，不断与ret进行比较
5. 最终返回ret结果即可。

具体模板如下：

```
初始化左边界 left = 0
初始化返回值 ret = 最小值 or 最大值
for 右边界 in 可迭代对象:
	更新窗口内部信息
	while 根据题意进行调整：
		比较并更新ret(收缩场景时)
		扩张或收缩窗口大小
	比较并更新ret(扩张场景时)
返回 ret
```

下面我就来看一道剑指offer的题目，是否可以通过套模板完成解题。

# [剑指OfferII008.和大于等于target的最短子数组](https://leetcode-cn.com/problems/2VG8Kg/solution/shua-chuan-jian-zhi-offer-day06-shu-zu-i-d5ne/)
> https://leetcode-cn.com/problems/2VG8Kg/solution/shua-chuan-jian-zhi-offer-day06-shu-zu-i-d5ne/
> 
> 难度：中等

## 题目

给定一个含有 n 个正整数的数组和一个正整数 target 。

找出该数组中满足其和 ≥ target 的长度**最小**的 **连续子数组** [numsl, numsl+1, ..., numsr-1, numsr] ，
并返回其长度。如果不存在符合条件的子数组，返回 0 。

提示：
- 1 <= target <= 10 ^ 9
- 1 <= nums.length <= 10 ^ 5
- 1 <= nums[i] <= 10 ^ 5

进阶：
如果你已经实现 O(n) 时间复杂度的解法, 请尝试设计一个 O(n log(n)) 时间复杂度的解法。

## 示例

```
示例 1：
输入：target = 7, nums = [2,3,1,2,4,3]
输出：2
解释：子数组 [4,3] 是该条件下的长度最小的子数组。

示例 2：
输入：target = 4, nums = [1,4,4]
输出：1

示例 3：
输入：target = 11, nums = [1,1,1,1,1,1,1,1]
输出：0
```

## 分析
根据题目，已经将刚才提到的关键字进行了加粗表示，首先看到连续子数组，我们就该考虑是否可以通过滑窗的思维去解题。
然后看到了长度最小的限制，分析题意滑窗思维没毛病。
那么刚才模板中说的题目条件时什么呢？满足滑窗内数字之和需要大于等于target。
返回值ret又是什么？符合条件的子数组长度。
模板中所有的架子都搭好了，往里面套代码吧！

## 解题

```python []
class Solution:
    def minSubArrayLen(self, target, nums):
        left = total = 0
        ret = float('inf')
        for right, num in enumerate(nums):
            total += num
            while total >= target:
                ret = min(ret, right - left + 1)
                total -= nums[left]
                left += 1
        return 0 if ret > len(nums) else ret
```

```java []
class Solution {
    public int minSubArrayLen(int target, int[] nums) {
        int left = 0;
        int total = 0;
        int ret = Integer.MAX_VALUE;
        for (int right = 0; right < nums.length; right++) {
            total += nums[right];
            while (total >= target) {
                ret = Math.min(ret, right - left + 1);
                total -= nums[left++];
            }
        }
        return ret > nums.length ? 0 : ret;
    }
}
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    9709    |    19485    |   49.8%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
