---
title: LCP 08-剧情触发时间
date: 2021-12-03 21:33:54
categories:
  - 中等
tags:
  - 数组
  - 二分查找
  - 排序
---

> 原文链接: https://leetcode-cn.com/problems/ju-qing-hong-fa-shi-jian


## 英文原文
<div></div>

## 中文题目
<div><p>在战略游戏中，玩家往往需要发展自己的势力来触发各种新的剧情。一个势力的主要属性有三种，分别是文明等级（<code>C</code>），资源储备（<code>R</code>）以及人口数量（<code>H</code>）。在游戏开始时（第 0 天），三种属性的值均为 0。</p>

<p>随着游戏进程的进行，每一天玩家的三种属性都会对应<strong>增加</strong>，我们用一个二维数组 <code>increase</code> 来表示每天的增加情况。这个二维数组的每个元素是一个长度为 3 的一维数组，例如 <code>[[1,2,1],[3,4,2]]</code> 表示第一天三种属性分别增加 <code>1,2,1</code> 而第二天分别增加 <code>3,4,2</code>。</p>

<p>所有剧情的触发条件也用一个二维数组 <code>requirements</code> 表示。这个二维数组的每个元素是一个长度为 3 的一维数组，对于某个剧情的触发条件 <code>c[i], r[i], h[i]</code>，如果当前 <code>C &gt;= c[i]</code> 且 <code>R &gt;= r[i]</code> 且 <code>H &gt;= h[i]</code> ，则剧情会被触发。</p>

<p>根据所给信息，请计算每个剧情的触发时间，并以一个数组返回。如果某个剧情不会被触发，则该剧情对应的触发时间为 -1 。</p>

<p><strong>示例 1：</strong></p>

<blockquote>
<p>输入： <code>increase = [[2,8,4],[2,5,0],[10,9,8]]</code> <code>requirements = [[2,11,3],[15,10,7],[9,17,12],[8,1,14]]</code></p>

<p>输出: <code>[2,-1,3,-1]</code></p>

<p>解释：</p>

<p>初始时，C = 0，R = 0，H = 0</p>

<p>第 1 天，C = 2，R = 8，H = 4</p>

<p>第 2 天，C = 4，R = 13，H = 4，此时触发剧情 0</p>

<p>第 3 天，C = 14，R = 22，H = 12，此时触发剧情 2</p>

<p>剧情 1 和 3 无法触发。</p>
</blockquote>

<p><strong>示例 2：</strong></p>

<blockquote>
<p>输入： <code>increase = [[0,4,5],[4,8,8],[8,6,1],[10,10,0]]</code> <code>requirements = [[12,11,16],[20,2,6],[9,2,6],[10,18,3],[8,14,9]]</code></p>

<p>输出: <code>[-1,4,3,3,3]</code></p>
</blockquote>

<p><strong>示例 3：</strong></p>

<blockquote>
<p>输入： <code>increase = [[1,1,1]]</code> <code>requirements = [[0,0,0]]</code></p>

<p>输出: <code>[0]</code></p>
</blockquote>

<p><strong>限制：</strong></p>

<ul>
	<li><code>1 &lt;= increase.length &lt;= 10000</code></li>
	<li><code>1 &lt;= requirements.length &lt;= 100000</code></li>
	<li><code>0 &lt;= increase[i] &lt;= 10</code></li>
	<li><code>0 &lt;= requirements[i] &lt;= 100000</code></li>
</ul>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
### 解题思路
维护一个递增的Increse数组，其每个元素都是严格递增的，对requirements里的每个元素 在Increse数组里二分查找到第一个比它大的，极为首先满足条件的天数

### 代码

```cpp
class Solution {
public:
    vector<int> getTriggerTime(vector<vector<int>>& increase, vector<vector<int>>& requirements) {
        vector<vector<int>> s(increase.size()+1,vector<int>(3,0));
        for(int i=0;i<increase.size();i++){
            for(int j=0;j<3;j++){
                s[i+1][j] = s[i][j] + increase[i][j];
            }
        }
        vector<int> ans;
        for(auto v:requirements){
            int l=0, r = increase.size();
            while(l<r){
                int m = (l+r)/2;
                if(s[m][0]>=v[0]&&s[m][1]>=v[1]&&s[m][2]>=v[2])
                    r = m;
                else
                    l = m+1;
            }
            if(s[l][0]>=v[0]&&s[l][1]>=v[1]&&s[l][2]>=v[2])
                ans.push_back(l);
            else
                ans.push_back(-1);
        }
        return ans;
    }
};
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    5273    |    18062    |   29.2%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
