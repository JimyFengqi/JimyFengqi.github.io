---
title: LCP 04-覆盖(Broken Board Dominoes)
date: 2021-12-03 21:47:01
categories:
  - 困难
tags:
  - 位运算
  - 图
  - 数组
  - 动态规划
  - 状态压缩
---

> 原文链接: https://leetcode-cn.com/problems/broken-board-dominoes




## 中文题目
<div><p>你有一块棋盘，棋盘上有一些格子已经坏掉了。你还有无穷块大小为<code>1 * 2</code>的多米诺骨牌，你想把这些骨牌<strong>不重叠</strong>地覆盖在<strong>完好</strong>的格子上，请找出你最多能在棋盘上放多少块骨牌？这些骨牌可以横着或者竖着放。</p>

<p>&nbsp;</p>

<p>输入：<code>n, m</code>代表棋盘的大小；<code>broken</code>是一个<code>b * 2</code>的二维数组，其中每个元素代表棋盘上每一个坏掉的格子的位置。</p>

<p>输出：一个整数，代表最多能在棋盘上放的骨牌数。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre><strong>输入：</strong>n = 2, m = 3, broken = [[1, 0], [1, 1]]
<strong>输出：</strong>2
<strong>解释：</strong>我们最多可以放两块骨牌：[[0, 0], [0, 1]]以及[[0, 2], [1, 2]]。（见下图）</pre>

<p><img alt="" src="https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2019/09/09/domino_example_1.jpg" style="height: 204px; width: 304px;"></p>

<p>&nbsp;</p>

<p><strong>示例 2：</strong></p>

<pre><strong>输入：</strong>n = 3, m = 3, broken = []
<strong>输出：</strong>4
<strong>解释：</strong>下图是其中一种可行的摆放方式
</pre>

<p><img alt="" src="https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2019/09/09/domino_example_2.jpg" style="height: 304px; width: 304px;"></p>

<p>&nbsp;</p>

<p><strong>限制：</strong></p>

<ol>
	<li><code>1 &lt;= n &lt;= 8</code></li>
	<li><code>1 &lt;= m &lt;= 8</code></li>
	<li><code>0 &lt;= b &lt;= n * m</code></li>
</ol>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
### 解题思路
1、状态的表示
首先定义 `dp[i][state]` 为：
当第 `i` 行的被占用情况（包括损坏的格子和上一行的砖块的占用）为 `state` 时，棋盘的第 `i` ~ `n - 1` 行最多能添加的砖块数。
`state` 用二进制表示，
- `state & (1 << k) == 1`, 表示第 k 个格子被占用
- `state & (1 << k) == 0`, 表示第 k 个格子可用

2、状态的转移
假设第 `i` 行的占用情况为 `state`.
则除了不可用的格子外, 剩下的格子有 3 种可能:
- 横着放砖块
- 竖着放砖块
- 不放砖块

因此，我们可以在剩下可用的格子中，枚举“竖着放”的砖块的情况。“竖着放”的砖块会占用下一行的格子。
除了“竖着放”的砖块，如果仍有可用格子，则尽可能多放“横着”的砖块，因为“横着”的砖块不会占用下一行的格子。
这样，对于所有“竖着放”的状态 `k`（二进制表示，`k` 的某位为 1 代表放置“竖着”的砖块），状态转移可以表示为：
`dp[i][state] = max(dp[i][state], 竖着放的数量 + 横着放的数量 + dp[i + 1][blocked[i + 1] | k])`
其中 `blocked[i]` 代表第 `i` 行的坏格子情况，也用二进制表示。

3、代码实现
需要在棋盘上增加一行，全是障碍物，以便统一处理边界条件（最后一行的只能添加“横着放”的砖块）。
如果一个二进制数为 `S`, 可以用 `for(int st = S; ; st = (st - 1) & S){(...)if(st == 0) break;}` 来枚举其子集。

**时间复杂度**: $O(n*4^m)$。因为 dp 数组共 $n*2^m$ 项，填充每一项的时间复杂度为 $O(2^m)$。
**空间复杂度**: $O(n*2^m)$。

### 代码
运行时间 0 ms
```cpp
class Solution {
    int ones(int x) {
        int res = 0;
        for(; x != 0; x = (x & (x - 1))) ++res;
        return res;
    }
    int bricks(int x) { // 最多横着放的砖块计数
        int res = 0;
        while(x) {
            int j = x & (-x);
            if((x & (j << 1))) ++res;
            x &= ~j;
            x &= ~(j << 1);
        }
        return res;
    }
public:
    int domino(int n, int m, vector<vector<int>>& broken) {
        // dp[i][status],i 代表到第 i 行,status 代表当前行的覆盖情况
        int M = (1 << m), blocked[n + 1] = {0}, dp[n + 1][M], maxv = 0;
        memset(dp, 0, M*sizeof(int));
        dp[n][M - 1] = 0, blocked[n] = M - 1; // 最后一行全是障碍
        for(auto v : broken) blocked[v[0]] |= (1 << v[1]);
        for(int l = n - 1; l >= 0; --l)
        for(int st = (~blocked[l]) & (M - 1); ; st = (st - 1) & (~blocked[l])) { // 枚举新增的集合
            int maxcount = 0, S = st & (~blocked[l + 1]);
            for(int k = S;; k = (k - 1) & S) { // 枚举 “竖着放” 的集合
                maxcount = max(ones(k) + bricks(st & (~k)) + dp[l + 1][blocked[l + 1] | k], maxcount);
                if(k == 0) break;
            }
            dp[l][(~st) & (M - 1)] = maxcount;
            if(st == 0) break;
        }
        for(int i = 0; i < M; ++i) maxv = max(maxv, dp[0][i]);
        return maxv;
    }
};
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    2719    |    7132    |   38.1%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
