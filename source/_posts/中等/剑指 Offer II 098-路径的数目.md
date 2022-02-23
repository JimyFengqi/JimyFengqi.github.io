---
title: 剑指 Offer II 098-路径的数目
date: 2021-12-03 21:28:09
categories:
  - 中等
tags:
  - 数学
  - 动态规划
  - 组合数学
---

> 原文链接: https://leetcode-cn.com/problems/2AoeFn




## 中文题目
<div><p>一个机器人位于一个 <code>m x n</code><em>&nbsp;</em>网格的左上角 （起始点在下图中标记为 &ldquo;Start&rdquo; ）。</p>

<p>机器人每次只能向下或者向右移动一步。机器人试图达到网格的右下角（在下图中标记为 &ldquo;Finish&rdquo; ）。</p>

<p>问总共有多少条不同的路径？</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<p><img src="https://assets.leetcode.com/uploads/2018/10/22/robot_maze.png" /></p>

<pre>
<strong>输入：</strong>m = 3, n = 7
<strong>输出：</strong>28</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>m = 3, n = 2
<strong>输出：</strong>3
<strong>解释：</strong>
从左上角开始，总共有 3 条路径可以到达右下角。
1. 向右 -&gt; 向下 -&gt; 向下
2. 向下 -&gt; 向下 -&gt; 向右
3. 向下 -&gt; 向右 -&gt; 向下
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>m = 7, n = 3
<strong>输出：</strong>28
</pre>

<p><strong>示例 4：</strong></p>

<pre>
<strong>输入：</strong>m = 3, n = 3
<strong>输出：</strong>6</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= m, n &lt;= 100</code></li>
	<li>题目数据保证答案小于等于 <code>2 * 10<sup>9</sup></code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 62&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/unique-paths/">https://leetcode-cn.com/problems/unique-paths/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# **排列组合**
机器人从 (0, 0) 到达 (m, n) 一共需要走 m + n - 2 步，这其中有 m - 1 步是向下走，如果在这  m + n - 2 步中向下走的顺序不同就会出现不同的路径，所有路径数等于从 m + n - 2 步中选择 m - 1 步为向下走的组合数，即
![image.png](../images/2AoeFn-0.png)

完整代码如下，注意计算组合数的计算公式，时间复杂度为 O(min(m, n))，空间复杂度为 O(1)。

```
class Solution {
public:
    int uniquePaths(int m, int n) {
        if (m > n) {
            return uniquePaths(n, m);
        }
        
        long long ret = 1;
        for (int x = n, y = 1; y < m; ++x, ++y) {
            // 不要写成 ret *= x / y ，因为 x / y 不一定是整数但是会被取整，但 ret * x / y 一定为整数
            ret = ret * x / y;
        }
        return ret;
    }
};
```
# **动态规划**
如果没有想到组合数的解法，也可以尝试其他解法。机器人需要若干步才能从 (0, 0) 到达 (m, n)，每走一步又面临向下还是向右走的两种选择，最终需要返回符合要求的路径数，所以本问题也可以采用动态规划求解。

用 f(i, j) 表示从 (0, 0) 到达 (m, n) 的路径数。当 i == 0 时，机器人位于格子的第一行，所以不可能从某一个位置向下走一步到达，只能从 (0, 0) 不断往右走到达，所以 f(0, j) = 1，同理可得 f(i, 0) = 1。在 i != 0 且 j != 0 时，机器人有两种办法到达 (i, j) 分别时从 (i - 1, j) 向右走一步以及从 (i, j - 1) 向下走一步，所以 f(i, j) = f(i - 1, j) + f(i, j - 1)。

使用二维数组的完整代码如下，时间复杂度为 O(mn)，空间复杂度为 O(mn)。
```
class Solution {
public:
    int uniquePaths(int m, int n) {
        vector<vector<int>> dp(m, vector<int>(n, 1));
        for (int i = 1; i < m; ++i) {
            for (int j = 1; j < n; ++j) {
                dp[i][j] = dp[i][j - 1] + dp[i - 1][j];
            }
        }
        return dp[m - 1][n - 1];
    }
};
```

同样可以优化为一维数组，完整代码如下，时间复杂度为 O(mn)，空间复杂度为 O(min(m, n))。
```
class Solution {
public:
    int uniquePaths(int m, int n) {
        if (m < n) {
            return uniquePaths(n, m);
        }
        
        vector<int> dp(n, 1);
        for (int i = 1; i < m; ++i) {
            for (int j = 1; j < n; ++j) {
                dp[j] += dp[j - 1];
            }
        }
        return dp[n - 1];
    }
};
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    3107    |    4092    |   75.9%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
