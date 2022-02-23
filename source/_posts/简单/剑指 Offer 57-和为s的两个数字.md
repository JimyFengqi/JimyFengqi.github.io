---
title: 剑指 Offer 57-和为s的两个数字(和为s的两个数字 LCOF)
categories:
  - 简单
tags:
  - 数组
  - 双指针
  - 二分查找
abbrlink: 1757867260
date: 2021-12-03 21:37:47
---

> 原文链接: https://leetcode-cn.com/problems/he-wei-sde-liang-ge-shu-zi-lcof




## 中文题目
<div><p>输入一个递增排序的数组和一个数字s，在数组中查找两个数，使得它们的和正好是s。如果有多对数字的和等于s，则输出任意一对即可。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre><strong>输入：</strong>nums = [2,7,11,15], target = 9
<strong>输出：</strong>[2,7] 或者 [7,2]
</pre>

<p><strong>示例 2：</strong></p>

<pre><strong>输入：</strong>nums = [10,26,30,31,47,60], target = 40
<strong>输出：</strong>[10,30] 或者 [30,10]
</pre>

<p>&nbsp;</p>

<p><strong>限制：</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 10^5</code></li>
	<li><code>1 &lt;= nums[i]&nbsp;&lt;= 10^6</code></li>
</ul>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
#### 解题思路：

利用 HashMap 可以通过遍历数组找到数字组合，时间和空间复杂度均为 $O(N)$ ；
注意本题的 $nums$ 是 **排序数组** ，因此可使用 **双指针法** 将空间复杂度降低至 $O(1)$ 。

##### 算法流程：

1. **初始化：** 双指针 $i$ , $j$ 分别指向数组 $nums$ 的左右两端 *（俗称对撞双指针）*。
2. **循环搜索：** 当双指针相遇时跳出；
   1. 计算和 $s = nums[i] + nums[j]$ ；
   2. 若 $s > target$ ，则指针 $j$ 向左移动，即执行 $j = j - 1$ ；
   3. 若 $s < target$ ，则指针 $i$ 向右移动，即执行 $i = i + 1$ ；
   4. 若 $s = target$ ，立即返回数组 $[nums[i], nums[j]]$ ；
3. 返回空数组，代表无和为 $target$ 的数字组合。

<![Picture2.png](../images/he-wei-sde-liang-ge-shu-zi-lcof-0.png),![Picture3.png](../images/he-wei-sde-liang-ge-shu-zi-lcof-1.png),![Picture4.png](../images/he-wei-sde-liang-ge-shu-zi-lcof-2.png),![Picture5.png](../images/he-wei-sde-liang-ge-shu-zi-lcof-3.png)>

##### 正确性证明：

> 记每个状态为 $S(i, j)$ ，即 $S(i, j) = nums[i] + nums[j]$ 。假设 $S(i, j) < target$ ，则执行 $i = i + 1$ ，即状态切换至 $S(i + 1, j)$ 。

- 状态 $S(i, j)$ 切换至 $S(i + 1, j)$ ，则会消去一行元素，相当于 **消去了状态集合** {$S(i, i + 1), S(i, i + 2), ..., S(i, j - 2), S(i, j - 1), S(i, j)$ } 。（由于双指针都是向中间收缩，因此这些状态之后不可能再遇到）。
- 由于 $nums$ 是排序数组，因此这些 **消去的状态** 都一定满足 $S(i, j) < target$ ，即这些状态都 **不是解** 。
- **结论：** 以上分析已证明 “每次指针 $i$ 的移动操作，都不会导致解的丢失” ，即指针 $i$ 的移动操作是 **安全的** ；同理，对于指针 $j$ 可得出同样推论；因此，此双指针法是正确的。

![Picture1.png](../images/he-wei-sde-liang-ge-shu-zi-lcof-4.png){:width=550}

##### 复杂度分析：

- **时间复杂度 $O(N)$ ：** $N$ 为数组 $nums$ 的长度；双指针共同线性遍历整个数组。
- **空间复杂度 $O(1)$ ：** 变量 $i$, $j$ 使用常数大小的额外空间。

#### 代码：

```python []
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        i, j = 0, len(nums) - 1
        while i < j:
            s = nums[i] + nums[j]
            if s > target: j -= 1
            elif s < target: i += 1
            else: return nums[i], nums[j]
        return []
```

```java []
class Solution {
    public int[] twoSum(int[] nums, int target) {
        int i = 0, j = nums.length - 1;
        while(i < j) {
            int s = nums[i] + nums[j];
            if(s < target) i++;
            else if(s > target) j--;
            else return new int[] { nums[i], nums[j] };
        }
        return new int[0];
    }
}
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    145889    |    218262    |   66.8%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
