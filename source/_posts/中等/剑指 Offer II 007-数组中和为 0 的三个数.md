---
title: 剑指 Offer II 007-数组中和为 0 的三个数
date: 2021-12-03 21:32:53
categories:
  - 中等
tags:
  - 数组
  - 双指针
  - 排序
---

> 原文链接: https://leetcode-cn.com/problems/1fGaJU




## 中文题目
<div><p>给定一个包含 <code>n</code> 个整数的数组&nbsp;<code>nums</code>，判断&nbsp;<code>nums</code>&nbsp;中是否存在三个元素&nbsp;<code>a</code> ，<code>b</code> ，<code>c</code> <em>，</em>使得&nbsp;<code>a + b + c = 0</code> ？请找出所有和为 <code>0</code> 且&nbsp;<strong>不重复&nbsp;</strong>的三元组。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>nums = [-1,0,1,2,-1,-4]
<strong>输出：</strong>[[-1,-1,2],[-1,0,1]]
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>nums = []
<strong>输出：</strong>[]
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>nums = [0]
<strong>输出：</strong>[]
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>0 &lt;= nums.length &lt;= 3000</code></li>
	<li><code>-10<sup>5</sup> &lt;= nums[i] &lt;= 10<sup>5</sup></code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 15&nbsp;题相同：<a href="https://leetcode-cn.com/problems/3sum/">https://leetcode-cn.com/problems/3sum/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解


### 1. 题目讲解

如果你已经理解了题目，这个视频可以跳过

![10_三数之和题目讲解.mp4](bb82c608-9af3-4081-a705-3036b15ce56d)

### 2. 暴力解法

![11_三数之和：暴力解法.mp4](082e308b-f481-4035-8c1a-e9cc934dd568)

代码如下：
```java
public List<List<Integer>> threeSum(int[] nums) {
    if (nums == null || nums.length < 3)
        return new ArrayList<>();

    Set<List<Integer>> res = new HashSet<>();

    Arrays.sort(nums); // O(nlogn)

    // O(n^3)
    for (int i = 0; i < nums.length; i++) {
        for (int j = i + 1; j < nums.length; j++) {
            for (int k = j + 1; k < nums.length; k++) {
                if (nums[i] + nums[j] + nums[k] == 0) {
                    res.add(Arrays.asList(nums[i], nums[j], nums[k]));
                }
            }
        }
    }

    return new ArrayList<>(res);
}
```

### 3. 优化：双指针

![12_三数之和：二分查找.mp4](ed558e86-1824-4088-a590-dbd1e556f44e)

代码实现，请看下面的视频：

![13_三数之和：二分查找代码实现.mp4](ee5e1158-2972-4d4d-a6e5-df78c5d63712)

代码如下：
```java
public List<List<Integer>> threeSum(int[] nums) {
    if (nums == null || nums.length < 3)
        return new ArrayList<>();

    Set<List<Integer>> res = new HashSet<>();

    Arrays.sort(nums); // O(nlogn)

    // O(n^2)
    for (int i = 0; i < nums.length; i++) {
        // 在 i + 1 ... nums.length - 1 中查找相加等于 -nums[i] 的两个数
        int target = -nums[i];
        int left = i + 1;
        int right = nums.length - 1;
        while (left < right) {
            int sum = nums[left] + nums[right];
            if (sum == target) {
                res.add(Arrays.asList(nums[i], nums[left], nums[right]));
                left++;
                right--;
            } else if (sum < target) {
                left++;
            } else {
                right--;
            }
        }
    }

    return new ArrayList<>(res); // O(n)
}
```

### 4. 再优化：去重技巧

![14_三数之和：去重技巧.mp4](cdff24dd-11bd-48c8-8a05-1ecd1bbb4b1a)

代码如下：
```Java []
public List<List<Integer>> threeSum(int[] nums) {
    if (nums == null || nums.length < 3)
        return new ArrayList<>();

    List<List<Integer>> res = new ArrayList<>();

    Arrays.sort(nums); // O(nlogn)

    // O(n^2)
    for (int i = 0; i < nums.length - 2; i++) {
        if (i > 0 && nums[i] == nums[i - 1]) continue;
        // 在 i + 1 ... nums.length - 1 中查找相加等于 -nums[i] 的两个数
        int target = -nums[i];
        int left = i + 1;
        int right = nums.length - 1;
        while (left < right) {
            int sum = nums[left] + nums[right];
            if (sum == target) {
                res.add(Arrays.asList(nums[i], nums[left], nums[right]));
                // 去重
                while (left < right && nums[left] == nums[++left]);
                while (left < right && nums[right] == nums[--right]);
            } else if (sum < target) {
                left++;
            } else {
                right--;
            }
        }
    }

    return res;
}
```
```C++ []
class Solution {
public:
    vector<vector<int>> threeSum(vector<int>& nums) {
        if (nums.size() < 3) return {};
        vector<vector<int>> res;

        sort(nums.begin(), nums.end());
        for (int i = 0; i < nums.size() - 2; i++) {
            if (i > 0 && nums[i] == nums[i - 1]) continue;

            // 在 i + 1 ... nums.length - 1 中查找相加等于 -nums[i] 的两个数
            int target = - nums[i];
            int left = i + 1, right = nums.size() - 1;
            while (left < right) {
                int sum = nums[left] + nums[right];
                if (sum == target) {
                    res.push_back({nums[i], nums[left], nums[right]});
                    /*
                        下面的代码相当于：
                        while (left < right) {
                            // 不管前后相不相等，left 都要往前走
                            left++;
                            if (nums[left - 1] != nums[left]) break;
                        }
                        while (left < right) {
                            // 不管前后相不相等，right 都要往后走
                            right--;
                            if (nums[right + 1] != nums[right]) break;
                        }
                     */
                    // 去重
                    while (left < right && nums[left] == nums[++left]);
                    while (left < right && nums[right] == nums[--right]);
                } else if (sum < target) {
                    left++;
                } else {
                    right--;
                }
            }
        }
        return res;
    }
};
```
```Python []
from typing import List


class Solution:
    def threeSum(self, nums: List[int]) -> List[List[int]]:
        if len(nums) < 3:
            return []

        nums.sort()

        res = []
        for i in range(0, len(nums) - 2):
            if i > 0 and nums[i] == nums[i - 1]: continue
            target = -nums[i]
            left, right = i + 1, len(nums) - 1
            while left < right:
                s = nums[left] + nums[right]
                if s == target:
                    res.append([nums[i], nums[left], nums[right]])
                    # 去重
                    while left < right:
                        left = left + 1
                        if nums[left - 1] != nums[left]: break
                    while left < right:
                        right = right - 1
                        if nums[right + 1] != nums[right]: break
                elif s < target:
                    left = left + 1
                else:
                    right = right - 1
        return res
```
```JavaScript []
/**
 * @param {number[]} nums
 * @return {number[][]}
 */
var threeSum = function(nums) {
    if (nums.length < 3) return []

    nums.sort((a, b) => a - b)
    res = []
    for (let i = 0; i < nums.length - 2; i++) {
        // 去重
        if (i > 0 && nums[i] == nums[i - 1]) continue

        const target = -nums[i]
        let left = i + 1, right = nums.length - 1
        while (left < right) {
            const sum = nums[left] + nums[right]
            if (sum == target) {
                res.push([nums[i], nums[left], nums[right]])
                /*
                下面的代码相当于：
                while (left < right) {
                    // 不管前后相不相等，left 都要往前走
                    left++;
                    if (nums[left - 1] != nums[left]) break;
                }
                while (left < right) {
                    // 不管前后相不相等，right 都要往后走
                    right--;
                    if (nums[right + 1] != nums[right]) break;
                }
                */
                // 去重
                while (left < right && nums[left] == nums[++left]);
                while (left < right && nums[right] == nums[--right]);
            } else if (sum < target) {
                left++
            } else {
                right--
            }
        }
    }
    return res
};
```
```Golang []
func threeSum(nums []int) [][]int {
    if len(nums) < 3 {
        return [][]int{}
    }

    var res = make([][]int, 0)

    sort.Ints(nums) // O(nlogn)

    // O(n^2)
    for i := 0; i < len(nums) - 2; i++ {
        if i > 0 && nums[i] == nums[i - 1] {
            continue
        }
        // 在 i + 1 ... nums.length - 1 中查找相加等于 -nums[i] 的两个数
        var target = -nums[i]
        var left, right = i + 1, len(nums) - 1
        for left < right {
            var sum = nums[left] + nums[right]
            if sum == target {
                res = append(res, []int{nums[i], nums[left], nums[right]})
                // 去重
                for left < right {
                    left++
                    if nums[left - 1] != nums[left] {
                        break
                    }
                }
                for left < right {
                    right--
                    if nums[right + 1] != nums[right] {
                        break
                    }
                }
            } else if sum < target {
                left++
            } else {
                right--
            }
        }
    }
    return res
}
```

**注意**，以上这两行代码：
```java
while (left < right && nums[left] == nums[++left]);
while (left < right && nums[right] == nums[--right]);
```
相当于下面的代码：
```java
while (left < right) {
    // 不管前后相不相等，left 都要往前走
    left++;
    if (nums[left - 1] != nums[left]) break;
}
while (left < right) {
    // 不管前后相不相等，right 都要往后走
    right--;
    if (nums[right + 1] != nums[right]) break;
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
1. 如果你觉得自己数据结构与算法**基础不够扎实**，那么[请点这里](http://www.tangweiqun.com/api/31104/offer007?av=1&cv=1)，这里包含了**一个程序员 5 年内需要的所有算法知识**

2. 如果你感觉刷题**太慢**，或者感觉**很困难**，或者**赶时间**，那么[请点这里](http://www.tangweiqun.com/api/35548/offer007?av=1&cv=1)。这里**用 365 道高频算法题，带你融会贯通算法知识，做到以不变应万变**

3. **回溯、贪心和动态规划，是算法面试中的三大难点内容**，如果你只是想搞懂这三大难点内容 [请点这里](http://www.tangweiqun.com/api/38100/offer007?av=1&cv=1)

**以上三个链接中的内容，都支持 Java/C++/Python/js/go 五种语言** 

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    9772    |    21730    |   45.0%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
