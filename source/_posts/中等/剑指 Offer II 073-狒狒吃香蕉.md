---
title: 剑指 Offer II 073-狒狒吃香蕉
categories:
  - 中等
tags:
  - 数组
  - 二分查找
abbrlink: 1551869922
date: 2021-12-03 21:28:16
---

> 原文链接: https://leetcode-cn.com/problems/nZZqjQ




## 中文题目
<div><p>狒狒喜欢吃香蕉。这里有&nbsp;<code>N</code>&nbsp;堆香蕉，第 <code>i</code> 堆中有&nbsp;<code>piles[i]</code>&nbsp;根香蕉。警卫已经离开了，将在&nbsp;<code>H</code>&nbsp;小时后回来。</p>

<p>狒狒可以决定她吃香蕉的速度&nbsp;<code>K</code>&nbsp;（单位：根/小时）。每个小时，她将会选择一堆香蕉，从中吃掉 <code>K</code> 根。如果这堆香蕉少于 <code>K</code> 根，她将吃掉这堆的所有香蕉，然后这一小时内不会再吃更多的香蕉，下一个小时才会开始吃另一堆的香蕉。&nbsp;&nbsp;</p>

<p>狒狒喜欢慢慢吃，但仍然想在警卫回来前吃掉所有的香蕉。</p>

<p>返回她可以在 <code>H</code> 小时内吃掉所有香蕉的最小速度 <code>K</code>（<code>K</code> 为整数）。</p>

<p>&nbsp;</p>

<ul>
</ul>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入: </strong>piles = [3,6,7,11], H = 8
<strong>输出: </strong>4
</pre>

<p><strong>示例&nbsp;2：</strong></p>

<pre>
<strong>输入: </strong>piles = [30,11,23,4,20], H = 5
<strong>输出: </strong>30
</pre>

<p><strong>示例&nbsp;3：</strong></p>

<pre>
<strong>输入: </strong>piles = [30,11,23,4,20], H = 6
<strong>输出: </strong>23
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= piles.length &lt;= 10^4</code></li>
	<li><code>piles.length &lt;= H &lt;= 10^9</code></li>
	<li><code>1 &lt;= piles[i] &lt;= 10^9</code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 875&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/koko-eating-bananas/">https://leetcode-cn.com/problems/koko-eating-bananas/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
### 解题思路
二分答案

### 代码

```cpp
class Solution {
public:
    //算出速度x需要几小时
    bool check(vector<int>& piles, int x, int h){
        int ans = 0;
        for(int i = 0; i < piles.size(); i++){
            //如果piles[i] < x 就会出现等于0的情况
            ans += (piles[i] - 1) / x + 1;
        }
        //速度x 需要的时间小于h返回true
        return ans <= h;
    }
    int minEatingSpeed(vector<int>& piles, int h) {
        int l = 1, r = 1e9;
        while(l < r){
            int mid = l + (r - l) / 2;
            if(!check(piles,mid,h)){
                l = mid + 1;
            }else{
                r = mid;
            }
        }
        return l;
    }
};
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    2934    |    5583    |   52.6%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
