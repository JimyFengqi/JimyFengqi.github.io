---
title: 剑指 Offer II 119-最长连续序列
date: 2021-12-03 21:28:35
categories:
  - 中等
tags:
  - 并查集
  - 数组
  - 哈希表
---

> 原文链接: https://leetcode-cn.com/problems/WhsWhI




## 中文题目
<div><p>给定一个未排序的整数数组 <code>nums</code> ，找出数字连续的最长序列（不要求序列元素在原数组中连续）的长度。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>nums = [100,4,200,1,3,2]
<strong>输出：</strong>4
<strong>解释：</strong>最长数字连续序列是 <code>[1, 2, 3, 4]。它的长度为 4。</code></pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>nums = [0,3,7,2,5,8,4,6,0,1]
<strong>输出：</strong>9
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>0 &lt;= nums.length &lt;= 10<sup>4</sup></code></li>
	<li><code>-10<sup>9</sup> &lt;= nums[i] &lt;= 10<sup>9</sup></code></li>
</ul>

<p>&nbsp;</p>

<p><strong>进阶：</strong>可以设计并实现时间复杂度为&nbsp;<code>O(n)</code><em> </em>的解决方案吗？</p>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 128&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/longest-consecutive-sequence/">https://leetcode-cn.com/problems/longest-consecutive-sequence/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
我总结了剑指Offer专项训练的所有题目类型，并给出了刷题建议和所有题解。

在github上开源了，不来看看吗？顺道一提：还有C++、数据结构与算法、计算机网络、操作系统、数据库的秋招知识总结，求求star了，这对我真的很重要？

$\Rightarrow$[通关剑2](https://github.com/muluoleiguo/interview/tree/master/%E9%9D%A2%E8%AF%95/%E7%AE%97%E6%B3%95%E4%B8%8E%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/%E5%89%91%E6%8C%87Offer%E4%B8%93%E9%A1%B9%E8%AE%AD%E7%BB%83%EF%BC%88%E5%89%912%EF%BC%89)

### 排序 时间复杂度O(nlogn)
![119.jpg](../images/WhsWhI-0.jpg)
思想就很质朴，但是肯定是过不了面试的
```cpp
int longestConsecutive(vector<int>& nums) {
    size_t len = nums.size();
    if(len == 0) return 0;
    sort(nums.begin(), nums.end());
    int inclen = 1, ans = 1;
    
    for(int i = 1; i < len; i++) {
        if (nums[i] == nums[i - 1] + 1) inclen++;
        else if (nums[i] == nums[i - 1]) continue;
        else inclen = 1;
        ans = max(ans, inclen);
    }
    return ans;
}

```

### 时间复杂度为 O(n)

用hash存起来，遍历的时候找后面如果有找找找，然后更新最大长度，但是这样还不如排序

360 ms	30.2 MB
### 代码

```cpp
class Solution {
public:
    int longestConsecutive(vector<int>& nums) {
        unordered_set<int> s;
        for(const int& num : nums) {
            s.insert(num);
        }
        int ans = 0;
        for(int& num : nums) {
            if(s.find(num - 1) != s.end())
                continue;
            int cnt = 1;        
            while(s.find(num + 1) != s.end()) {
                cnt++;
                num++;
            }
            ans = max(ans, cnt);        
        }
        return ans;
    }
};
```


### 优化
```
执行用时：48 ms, 在所有 C++ 提交中击败了100.00%的用户
内存消耗：30.2 MB, 在所有 C++ 提交中击败了100.00%的用户
```
上面拉夸的原因是做了很多重复的计算，比如
```
1,2,3,4,5,6

每个都要往后看到6，太蠢了
```
因此，我们选择看过就删除，过河拆桥

```cpp
int longestConsecutive(vector<int>& nums) {
        unordered_set<int> s;
        for (int i = 0; i < nums.size(); i++) {
            s.insert(nums[i]);
        }
        int ans = 0;
        while (!s.empty()) {
            int now = *s.begin();
            s.erase(now);
            int l = now - 1, r = now + 1;
            while (s.find(l) != s.end()) {
                s.erase(l);
                l--;
            }
            while(s.find(r) != s.end()) {
                s.erase(r);
                r++;
            }
            l = l + 1, r = r - 1;
            ans = max(ans, r - l + 1);
        }
        return ans;

    }
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    4264    |    8900    |   47.9%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
