---
title: 剑指 Offer II 011-0 和 1 个数相同的子数组
date: 2021-12-03 21:32:41
categories:
  - 中等
tags:
  - 数组
  - 哈希表
  - 前缀和
---

> 原文链接: https://leetcode-cn.com/problems/A1NYOS




## 中文题目
<div><p>给定一个二进制数组 <code>nums</code> , 找到含有相同数量的 <code>0</code> 和 <code>1</code> 的最长连续子数组，并返回该子数组的长度。</p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<pre>
<strong>输入:</strong> nums = [0,1]
<strong>输出:</strong> 2
<strong>说明:</strong> [0, 1] 是具有相同数量 0 和 1 的最长连续子数组。</pre>

<p><strong>示例 2:</strong></p>

<pre>
<strong>输入:</strong> nums = [0,1,0]
<strong>输出:</strong> 2
<strong>说明:</strong> [0, 1] (或 [1, 0]) 是具有相同数量 0 和 1 的最长连续子数组。</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 10<sup>5</sup></code></li>
	<li><code>nums[i]</code> 不是 <code>0</code> 就是 <code>1</code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 525&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/contiguous-array/">https://leetcode-cn.com/problems/contiguous-array/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
我总结了剑指Offer专项训练的所有题目类型，并给出了刷题建议和所有题解。

在github上开源了，不来看看吗？顺道一提：还有C++、数据结构与算法、计算机网络、操作系统、数据库的秋招知识总结，求求star了，这对我真的很重要？

$\Rightarrow$[通关剑2](https://github.com/muluoleiguo/interview/tree/master/%E9%9D%A2%E8%AF%95/%E7%AE%97%E6%B3%95%E4%B8%8E%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/%E5%89%91%E6%8C%87Offer%E4%B8%93%E9%A1%B9%E8%AE%AD%E7%BB%83%EF%BC%88%E5%89%912%EF%BC%89)

### 思路一 枚举 O(n^3) 超时
注释解释得很清楚了，
```cpp
int findMaxLength(vector<int>& nums) {
    size_t n = nums.size();
    int maxLen = 0;
    // 枚举子数组起点
    for (int i = 0; i < n; ++i)
        // 枚举子数组终点
        for (int j = i + 1; j < n; ++j) {
            // 遍历子数组并统计0和1的数量
            int zeros = 0, ones = 0;
            for (int k = i; k <= j; ++k) {
                if (nums[k] == 1) ones++;
                else zeros++;
            }
            // 如果符合条件就更新最长长度
            if (ones == zeros) maxLen = max(maxLen, j - i + 1);
        }
    return maxLen; 
}
```
### 思路二 枚举优化（两处） 超时
没有改变时间复杂度，所以还是没过
```cpp
int findMaxLength(vector<int>& nums) {
    size_t n = nums.size();
    int maxLen = 0;
    // 起点， 优化1：之后可能长度不足maxLen就不举了
    for (int i = 0; i < n - maxLen; ++i)
        // 终点， 优化二：与起点的间隔至少maxLen
        for (int j = i + 1 + maxLen; j < n; ++j) {
            // 遍历子数组并统计0和1的数量
            int zeros = 0, ones = 0;
            for (int k = i; k <= j; ++k) {
                if (nums[k] == 1) ones++;
                else zeros++;
            }
            // 如果符合条件就更新最长长度
            if (ones == zeros) maxLen = max(maxLen, j - i + 1);
        }
    return maxLen; 
}
```
### 思路三 前缀和+优化 O(n^2) 超时
具体的，我们在预处理前缀和时，将 nums[i]0 的值当做 −1。

从而将问题转化为：如何求得最长一段区间和为 0 的子数组。

同样我们枚举起点和终点，如果他俩前缀和相同，说明起点和终点这一段和为0。

并且之前的优化思路也可以用上。

```cpp
int findMaxLength(vector<int>& nums) {

    size_t n = nums.size();
    // 前缀和
    vector<int> preSum(n + 1);
    for (size_t i = 0; i < n; ++i) {
        if (nums[i] == 0) nums[i] = -1;
        preSum[i + 1] = preSum[i] + nums[i];
    }
    size_t maxLen = 0;
    // 起点， 优化1：之后可能长度不足maxLen就不举了
    for (size_t i = 0; i < n - maxLen; ++i)
        // 终点， 优化二：与起点的间隔至少maxLen
        for (size_t j = i + 1 + maxLen; j < n; ++j) {
            // 前缀和相同更新答案
            if (preSum[j + 1] - preSum[i] == 0) maxLen = max(maxLen, j - i + 1);
        }
    return maxLen;

}
```
日尼妈，怎么还是超时了，`1 <= nums.length <= 10^5`,看样子只有想个O(n)的算法了

### 思路四 前缀和 + hash O(n)
之前思路三，我们枚举了起点终点看前缀和（本质是看连续和为0）；
但是我们可以直接用hash记录某个前缀和出现的最左边的位置，这样，直接降维打击

```cpp
int findMaxLength(vector<int>& nums) {
    size_t n = nums.size();
    vector<int> preSum(n + 1);
    unordered_map<int, int> mp;
    mp[0] = -1;
    size_t maxLen = 0;
    for (size_t i = 0; i < n; ++i) {
        if (nums[i] == 0) nums[i] = -1;
        preSum[i + 1] = preSum[i] + nums[i];
        // 首次出现保存到unordered_map中
        if (mp.find(preSum[i + 1]) == mp.end())
            mp[preSum[i + 1]] = i;
        // 在mp的就是preSum值之前首次出现的下标，更新最大值
        else maxLen = max(maxLen, i - mp[preSum[i + 1]]);
    }
    return maxLen;
}
```
哦哦哦哦哦，终于过了，但是怎么不是双百，日尼玛，退钱！

### 路径压缩(针对前缀和数组,但hash还是要空间) 空间复杂度 O(n) 时间复杂度O(n) 

```cpp
class Solution {
public:
    int findMaxLength(vector<int>& nums) {
        unordered_map<int, int> mp;
        int preSum = 0, maxLen = 0;
        mp[0] = -1;
        for (int i = 0; i < nums.size(); ++i){
            preSum += nums[i] ? 1 : -1;
            if(mp.find(preSum) != mp.end()) maxLen = max(maxLen, i - mp[preSum]);
            else mp[preSum] = i;
        }    
        return maxLen;  
    }
};
```
```
执行用时	内存消耗
92 ms	    81.8 MB
```

终于双百了，不容易，看到这点个赞吧，谢谢啦！

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    6410    |    11519    |   55.6%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
