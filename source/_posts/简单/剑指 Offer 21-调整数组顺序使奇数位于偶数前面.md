---
title: 剑指 Offer 21-调整数组顺序使奇数位于偶数前面(调整数组顺序使奇数位于偶数前面 LCOF)
categories:
  - 简单
tags:
  - 数组
  - 双指针
  - 排序
abbrlink: 2518893686
date: 2021-12-03 21:39:33
---

> 原文链接: https://leetcode-cn.com/problems/diao-zheng-shu-zu-shun-xu-shi-qi-shu-wei-yu-ou-shu-qian-mian-lcof




## 中文题目
<div><p>输入一个整数数组，实现一个函数来调整该数组中数字的顺序，使得所有奇数在数组的前半部分，所有偶数在数组的后半部分。</p>

<p>&nbsp;</p>

<p><strong>示例：</strong></p>

<pre>
<strong>输入：</strong>nums =&nbsp;[1,2,3,4]
<strong>输出：</strong>[1,3,2,4] 
<strong>注：</strong>[3,1,2,4] 也是正确的答案之一。</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ol>
	<li><code>0 &lt;= nums.length &lt;= 50000</code></li>
	<li><code>0 &lt;= nums[i] &lt;= 10000</code></li>
</ol>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
####  首尾双指针



- 定义头指针 $left$ ，尾指针 $right$ .
- $left$ 一直往右移，直到它指向的值为偶数
- $right$ 一直往左移， 直到它指向的值为奇数
- 交换 $nums[left]$ 和 $nums[right]$  .
- 重复上述操作，直到 $left == right$ .



![](../images/diao-zheng-shu-zu-shun-xu-shi-qi-shu-wei-yu-ou-shu-qian-mian-lcof-0.gif)



#### 代码

```cpp
class Solution {
public:
    vector<int> exchange(vector<int>& nums) {
        int left = 0, right = nums.size() - 1;
        while (left < right) {
            if ((nums[left] & 1) != 0) {
                left ++;
                continue;
            }
            if ((nums[right] & 1) != 1) {
                right --;
                continue;
            }
            swap(nums[left++], nums[right--]);
        }
        return nums;
    }
};
```





#### 快慢双指针

- 定义快慢双指针 $fast$ 和 $low$ ，$fast$ 在前， $low$ 在后 .
- $fast$ 的作用是向前搜索奇数位置，$low$ 的作用是指向下一个奇数应当存放的位置
- $fast$ 向前移动，当它搜索到奇数时，将它和 $nums[low]$ 交换，此时 $low$ 向前移动一个位置 .
- 重复上述操作，直到 $fast$ 指向数组末尾 .



![](../images/diao-zheng-shu-zu-shun-xu-shi-qi-shu-wei-yu-ou-shu-qian-mian-lcof-1.gif)


#### 代码

```cpp
class Solution {
public:
    vector<int> exchange(vector<int>& nums) {
        int low = 0, fast = 0;
        while (fast < nums.size()) {
            if (nums[fast] & 1) {
                swap(nums[low], nums[fast]);
                low ++;
            }
            fast ++;
        }
        return nums;
    }
};
```

#### 最后


至此您已经掌握了解决此题的两种方式，感谢您的观看！欢迎大家留言，一起讨论交流。

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    209830    |    325796    |   64.4%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
