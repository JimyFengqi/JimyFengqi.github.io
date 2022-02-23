---
title: 剑指 Offer II 100-三角形中最小路径之和
categories:
  - 中等
tags:
  - 数组
  - 动态规划
abbrlink: 1728313329
date: 2021-12-03 21:31:05
---

> 原文链接: https://leetcode-cn.com/problems/IlPe0q




## 中文题目
<div><p>给定一个三角形 <code>triangle</code> ，找出自顶向下的最小路径和。</p>

<p>每一步只能移动到下一行中相邻的结点上。<strong>相邻的结点 </strong>在这里指的是 <strong>下标</strong> 与 <strong>上一层结点下标</strong> 相同或者等于 <strong>上一层结点下标 + 1</strong> 的两个结点。也就是说，如果正位于当前行的下标 <code>i</code> ，那么下一步可以移动到下一行的下标 <code>i</code> 或 <code>i + 1</code> 。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>triangle = [[2],[3,4],[6,5,7],[4,1,8,3]]
<strong>输出：</strong>11
<strong>解释：</strong>如下面简图所示：
   <strong>2</strong>
  <strong>3</strong> 4
 6 <strong>5</strong> 7
4 <strong>1</strong> 8 3
自顶向下的最小路径和为&nbsp;11（即，2&nbsp;+&nbsp;3&nbsp;+&nbsp;5&nbsp;+&nbsp;1&nbsp;= 11）。
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>triangle = [[-10]]
<strong>输出：</strong>-10
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= triangle.length &lt;= 200</code></li>
	<li><code>triangle[0].length == 1</code></li>
	<li><code>triangle[i].length == triangle[i - 1].length + 1</code></li>
	<li><code>-10<sup>4</sup> &lt;= triangle[i][j] &lt;= 10<sup>4</sup></code></li>
</ul>

<p>&nbsp;</p>

<p><strong>进阶：</strong></p>

<ul>
	<li>你可以只使用 <code>O(n)</code>&nbsp;的额外空间（<code>n</code> 为三角形的总行数）来解决这个问题吗？</li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 120&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/triangle/">https://leetcode-cn.com/problems/triangle/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# **动态规划**
三角形保存在方阵的下三角区域。从三角形的顶部到底部需要多步，而且每一步面临两个选择，最后需要计算所有路径的最小值，所以该问题可以用动态规划解决。

用 f(i, j) 表示从三角形的顶部出发到达行号和列号分别为 i 和 j (i >= j) 的位置时路径数字之和的最小值。如果 j 等于 0，也就是当前到达某行的第一个数字。由于路径的每一步都是前往正下方或右下方的数字，而此时当前位置的左上角无数字，所以
![image.png](../images/IlPe0q-0.png)
如果 i 等于 j，也就是当前到达某一行的最后一个数字，因为此时其上方无数字，所以前一步只能是来自于其左上角，所以
![image.png](../images/IlPe0q-1.png)
其他情况，当前位置的前一步可能来自于其正上方数字，也可能来自于左上角数字，因为要取最小值，所以
![image.png](../images/IlPe0q-2.png)
使用二维数组的完整代码如下，若方阵的维度为 n，那么时间复杂度为 O(n^2)，空间复杂度为 O(n^2)。
```
class Solution {
public:
    int minimumTotal(vector<vector<int>>& triangle) {
        vector<vector<int>> dp(triangle.size(), vector<int>(triangle.size()));
        dp[0][0] = triangle[0][0];
        for (int i = 1; i < triangle.size(); ++i) {
            dp[i][0] = dp[i - 1][0] + triangle[i][0];
        }

        for (int i = 1; i < triangle.size(); ++i) {
            for (int j = 1; j < i; ++j) {
                dp[i][j] = min(dp[i - 1][j], dp[i - 1][j - 1]) + triangle[i][j];
            }
            dp[i][i] = dp[i - 1][i - 1] + triangle[i][i];
        }

        return *min_element(dp.back().begin(), dp.back().end());
    }
};
```
同样可以优化为一维数组，完整代码如下，时间复杂度为 O(n^2)，空间复杂度为 O(n)。
```
class Solution {
public:
    int minimumTotal(vector<vector<int>>& triangle) {
        vector<int> dp(triangle.size());
        dp[0] = triangle[0][0];

        for (int i = 1; i < triangle.size(); ++i) {
            dp[i] = dp[i - 1] + triangle[i][i];
            for (int j = i - 1; j > 0; --j) {
                dp[j] = min(dp[j], dp[j - 1]) + triangle[i][j];
            }
            dp[0] += triangle[i][0];
        }

        return *min_element(dp.begin(), dp.end());
    }
};
```



## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    2865    |    3818    |   75.0%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
