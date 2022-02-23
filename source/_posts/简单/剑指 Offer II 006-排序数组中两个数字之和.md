---
title: 剑指 Offer II 006-排序数组中两个数字之和
categories:
  - 简单
tags:
  - 数组
  - 双指针
  - 二分查找
abbrlink: 3796304276
date: 2021-12-03 21:32:54
---

> 原文链接: https://leetcode-cn.com/problems/kLl5u1




## 中文题目
<div><p>给定一个已按照<strong><em> </em>升序排列&nbsp; </strong>的整数数组&nbsp;<code>numbers</code> ，请你从数组中找出两个数满足相加之和等于目标数&nbsp;<code>target</code> 。</p>

<p>函数应该以长度为 <code>2</code> 的整数数组的形式返回这两个数的下标值<em>。</em><code>numbers</code> 的下标 <strong>从 0&nbsp;开始计数</strong> ，所以答案数组应当满足 <code>0&nbsp;&lt;= answer[0] &lt; answer[1] &lt;&nbsp;numbers.length</code>&nbsp;。</p>

<p>假设数组中存在且只存在一对符合条件的数字，同时一个数字不能使用两次。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>numbers = [1,2,4,6,10], target = 8
<strong>输出：</strong>[1,3]
<strong>解释：</strong>2 与 6 之和等于目标数 8 。因此 index1 = 1, index2 = 3 。
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>numbers = [2,3,4], target = 6
<strong>输出：</strong>[0,2]
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>numbers = [-1,0], target = -1
<strong>输出：</strong>[0,1]
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>2 &lt;= numbers.length &lt;= 3 * 10<sup>4</sup></code></li>
	<li><code>-1000 &lt;= numbers[i] &lt;= 1000</code></li>
	<li><code>numbers</code> 按 <strong>递增顺序</strong> 排列</li>
	<li><code>-1000 &lt;= target &lt;= 1000</code></li>
	<li>仅存在一个有效答案</li>
</ul>

<p>&nbsp;</p>

<p>注意：本题与主站 167 题相似（下标起点不同）：<a href="https://leetcode-cn.com/problems/two-sum-ii-input-array-is-sorted/">https://leetcode-cn.com/problems/two-sum-ii-input-array-is-sorted/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
### 1. 题目讲解

如果你已经理解了题目，这个视频可以跳过

![...之和变形一：输入有序数组题目讲解.mp4](cb114b98-096b-4ae0-bf20-ec8950074746)


### 2. 方案一：二分查找，请看视频：

![2_两数之和变形一：二分查找方法.mp4](69db2153-c25d-45a0-8484-47a8931f6924)


代码如下：
```Java []
// 时间复杂度：O(nlogn)
// 空间复杂度：O(1)
public int[] twoSum(int[] nums, int target) {
    if (nums == null || nums.length == 0) return new int[0];

    for (int i = 0; i < nums.length; i++) {
        int x = nums[i];
        // 线性查找 - O(n)
        // 1. 二分查找 - O(logn)
        // [i + 1, nums.length - 1] 区间二分查找 target - x
        int index = binarySearch(nums, i + 1, nums.length - 1, target - x);
        if (index != -1) {
            return new int[]{i, index};
        }
    }

    return new int[0];
}

private int binarySearch(int[] nums, int left, int right, int target) {
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (nums[mid] == target)
            return mid;
        if (nums[mid] > target)
            right = mid - 1;
        else
            left = mid + 1;
    }
    return -1;
}
```
```C++ []
public:
    // 二分查找
    // 时间复杂度：O(nlogn)
    // 空间复杂度：O(1)
    vector<int> twoSum1(vector<int>& numbers, int target) {
        for (int i = 0; i < numbers.size(); i++) {
            int x = numbers[i];
            // 线性查找 - O(n)
            // 1. 二分查找 - O(logn)
            // [i + 1, numbers.length - 1] 区间二分查找 target - x
            int index = binarySearch(numbers, i + 1, numbers.size() - 1, target - x);
            if (index != -1) {
                return {i, index};
            }
        }

        return {};
    }

    int binarySearch(vector<int>& nums, int left, int right, int target) {
        while (left <= right) {
            int mid = left + (right - left) / 2;
            if (nums[mid] == target)
                return mid;
            if (nums[mid] > target)
                right = mid - 1;
            else
                left = mid + 1;
        }
        return -1;
    }
```
```Python []
# 二分查找
# 时间复杂度：O(nlogn)
# 空间复杂度：O(1)
def twoSum1(self, numbers: List[int], target: int) -> List[int]:
    for i in range(len(numbers)):
        x = numbers[i]
        # 1. 二分查找 - O(logn)
        # [i + 1, nums.length - 1] 区间二分查找 target - x
        index = self.binary_search(numbers, i + 1, len(numbers) - 1, target - x)
        if index != -1:
            return [i, index]
    return []

def binary_search(self, numbers: List[int], left: int, right: int, target: int) -> int:
    while left <= right:
        mid = left + (right - left) // 2
        if target == numbers[mid]:
            return mid
        elif target > numbers[mid]:
            left = mid + 1
        else:
            right = mid - 1
    return -1
```
```JavaScript []
// 二分查找
// 时间复杂度：O(nlogn)
// 空间复杂度：O(1)
var twoSum1 = function(numbers, target) {
    for (let i = 0; i < numbers.length; i++) {
        const x = numbers[i]
        const index = binarySearch(numbers, i + 1, numbers.length - 1, target - x)
        if (index != -1) {
            return [i, index]
        }
    }
    return []
};

var binarySearch = function(number, left, right, target) {
    while (left <= right) {
        const mid = left + Math.floor((right - left) / 2)
        if (target == number[mid]) {
            return mid;
        } else if (target < number[mid]) {
            right = mid - 1
        } else {
            left = mid + 1
        }
    }
    return -1
}
```
```Golang []
// 方法一：严格的二分查找
// 时间复杂度：O(nlogn)
// 空间复杂度：O(1)
func twoSum1(numbers []int, target int) []int {
    for i := range numbers {
        var x = numbers[i]
        // 线性查找 - O(n)
        // 1. 二分查找 - O(logn)
        // [i + 1, nums.length - 1] 区间二分查找 target - x
        var index = binarySearch(numbers, i + 1, len(numbers) - 1, target - x)
        if index != -1 {
            return []int{i + 1, index + 1}
        }
    }
    return []int{}
}

func binarySearch(numbers []int, left int, right int, target int) int {
    for left <= right {
        var mid = left + (right - left) / 2
        if numbers[mid] == target {
            return mid
        } else if numbers[mid] > target {
            right = mid - 1
        } else {
            left = mid + 1
        }
    }
    return -1
}
```

### 3. 方案二：双指针， 请看视频：

![..._两数之和变形一：双指针技巧解法.mp4](c9927977-159c-4564-b901-5bfec40bd655)


代码如下：
```Java []
// 时间复杂度：O(n)
// 空间复杂度：O(1)
public int[] twoSum(int[] nums, int target) {
    if (nums == null || nums.length == 0) return new int[0];

    int left = 0;
    int right = nums.length - 1;
    while (left < right) {
        int sum = nums[left] + nums[right];
        if (sum == target) {
            return new int[]{left, right};
        } else if (sum < target) {
            left++;
        } else {
            right--;
        }
    }

    return new int[0];
}
```
```C++ []
public:
    // 双指针
    // 时间复杂度：O(n)
    // 空间复杂度：O(1)
    vector<int> twoSum(vector<int>& numbers, int target) {
        int left = 0, right = numbers.size() - 1;
        while (left < right) {
            int sum = numbers[left] + numbers[right];
            if (sum == target) {
                return {left, right};
            } else if (sum < target) {
                left++;
            } else {
                right--;
            }
        }
        return {};
    }
```
```Python []
# 双指针
# 时间复杂度：O(n)
# 空间复杂度：O(1)
def twoSum(self, numbers: List[int], target: int) -> List[int]:
    left, right = 0, len(numbers) - 1
    while left < right:
        sum = numbers[left] + numbers[right]
        if sum == target:
            return [left, right]
        elif sum < target:
            left = left + 1
        else:
            right = right - 1
    return []
```
```JavaScript []
// 双指针
// 时间复杂度：O(n)
// 空间复杂度：O(1)
var twoSum = function(numbers, target) {
    let left = 0, right = numbers.length - 1
    while (left < right) {
        const sum = numbers[left] + numbers[right]
        if (sum == target) {
            return [left, right]
        } else if (sum < target) {
            left++
        } else {
            right--
        }
    }
    return []
};
```
```Golang []
// 双指针
// 时间复杂度：O(n)
// 空间复杂度：O(1)
func twoSum(numbers []int, target int) []int {
    var left, right = 0, len(numbers) - 1
    for left < right {
        var sum = numbers[left] + numbers[right]
        if sum == target {
            return []int{left + 1, right + 1}
        } else if sum < target {
            left++
        } else {
            right--
        }
    }
    return []int{}
}
```

**类似的题目最好是一起刷，这样可以提高刷题效率：**
1. [leetcode 1 号算法题：两数之和](https://leetcode-cn.com/problems/two-sum/solution/zhu-jian-you-hua-yi-zhi-dao-zui-you-pei-sexli/)
2. [leetcode 167 号算法题：两数之和Ⅱ - 输入有序数组](https://leetcode-cn.com/problems/two-sum-ii-input-array-is-sorted/solution/suan-fa-si-wei-yang-cheng-ji-shuang-zhi-rqju0/)
2. [leetcode 170 号算法题：两数之和Ⅲ - 数据结构设计](https://leetcode-cn.com/problems/two-sum-iii-data-structure-design/solution/suan-fa-si-wei-yang-cheng-ji-er-fen-cha-pz31j/)
3. [leetcode 653 号算法题：两数之和Ⅳ - 输入 BST](https://leetcode-cn.com/problems/two-sum-iv-input-is-a-bst/solution/suan-fa-si-wei-yang-cheng-ji-er-fen-cha-1vttm/)
4. [leetcode 15 号算法题：三数之和](https://leetcode-cn.com/problems/3sum/solution/suan-fa-si-wei-yang-cheng-ji-er-fen-cha-5bk43/)
5. [leetcode 18 号算法题：四数之和](https://leetcode-cn.com/problems/4sum/solution/suan-fa-si-wei-yang-cheng-ji-shuang-zhi-539ll/)


在刷题的时候：
1. 如果你觉得自己数据结构与算法**基础不够扎实**，那么[请点这里](http://www.tangweiqun.com/api/31104/offer006?av=1&cv=1)，这里包含了**一个程序员 5 年内需要的所有算法知识**

2. 如果你感觉刷题**太慢**，或者感觉**很困难**，或者**赶时间**，那么[请点这里](http://www.tangweiqun.com/api/35548/offer006?av=1&cv=1)。这里**用 365 道高频算法题，带你融会贯通算法知识，做到以不变应万变**

3. **回溯、贪心和动态规划，是算法面试中的三大难点内容**，如果你只是想搞懂这三大难点内容 [请点这里](http://www.tangweiqun.com/api/38100/offer006?av=1&cv=1)

**以上三个链接中的内容，都支持 Java/C++/Python/js/go 五种语言** 

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    11130    |    17066    |   65.2%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
