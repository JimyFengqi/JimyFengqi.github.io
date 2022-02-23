---
title: 剑指 Offer II 112-最长递增路径
categories:
  - 困难
tags:
  - 深度优先搜索
  - 广度优先搜索
  - 图
  - 拓扑排序
  - 记忆化搜索
  - 动态规划
abbrlink: 941369669
date: 2021-12-03 21:30:39
---

> 原文链接: https://leetcode-cn.com/problems/fpTFWP




## 中文题目
<div><p>给定一个&nbsp;<code>m x n</code> 整数矩阵&nbsp;<code>matrix</code> ，找出其中 <strong>最长递增路径</strong> 的长度。</p>

<p>对于每个单元格，你可以往上，下，左，右四个方向移动。 <strong>不能</strong> 在 <strong>对角线</strong> 方向上移动或移动到 <strong>边界外</strong>（即不允许环绕）。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<p><img alt="" src="https://assets.leetcode.com/uploads/2021/01/05/grid1.jpg" style="width: 242px; height: 242px;" /></p>

<pre>
<strong>输入：</strong>matrix = [[9,9,4],[6,6,8],[2,1,1]]
<strong>输出：</strong>4 
<strong>解释：</strong>最长递增路径为&nbsp;<code>[1, 2, 6, 9]</code>。</pre>

<p><strong>示例 2：</strong></p>

<p><img alt="" src="https://assets.leetcode.com/uploads/2021/01/27/tmp-grid.jpg" style="width: 253px; height: 253px;" /></p>

<pre>
<strong>输入：</strong>matrix = [[3,4,5],[3,2,6],[2,2,1]]
<strong>输出：</strong>4 
<strong>解释：</strong>最长递增路径是&nbsp;<code>[3, 4, 5, 6]</code>。注意不允许在对角线方向上移动。
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>matrix = [[1]]
<strong>输出：</strong>1
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>m == matrix.length</code></li>
	<li><code>n == matrix[i].length</code></li>
	<li><code>1 &lt;= m, n &lt;= 200</code></li>
	<li><code>0 &lt;= matrix[i][j] &lt;= 2<sup>31</sup> - 1</code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 329&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/longest-increasing-path-in-a-matrix/">https://leetcode-cn.com/problems/longest-increasing-path-in-a-matrix/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# **带记忆的深度优先搜索**
如果把矩阵的各个数字看作节点，若矩阵中的某数字小于其四周的数字那么存在从该数字指向其四周数字的边，所以该问题就可以转化为求有向图内最长的路径。求解图的最长路径时可以采用广度优先搜素和深度优先搜索两种算法，这里适合采用深度优先算法。

为了提高时间效率可以使用一个二维数组 path 记录当前已经计算得到的各节点的最长路径，那么对于某个节点 i,j 选择其四周与其相连的路径最长为 len 的节点相连，那么节点 i,j 的路径最长为 len + 1，若其四周与其相连的节点存在最长路径未明确的，则先调用递归函数计算该节点的最长路径。完整的代码如下：
```
class Solution {
private:
    int dfs(vector<vector<int>>& matrix, vector<vector<int>>& path, vector<vector<int>>& dires, int i, int j) {
        int len = 0;
        for (auto& d : dires) {
            int row = i + d[0];
            int col = j + d[1];
            if (row >= 0 && row < matrix.size() && col >= 0 &&
             col < matrix[0].size() && matrix[row][col] > matrix[i][j]) {
                if (path[row][col] == 0) {
                    len = max(len, dfs(matrix, path, dires, row, col));
                }
                else {
                    len = max(len, path[row][col]);
                }
            }
        }
        path[i][j] = len + 1;
        return path[i][j];
    }

public:
    int longestIncreasingPath(vector<vector<int>>& matrix) {
        vector<vector<int>> path(matrix.size(), vector<int>(matrix[0].size(), 0));
        vector<vector<int>> dires{{0, 1}, {0, -1}, {1, 0}, {-1, 0}};
        int ret = 0;
        for (int i = 0; i < matrix.size(); ++i) {
            for (int j = 0; j < matrix[0].size(); ++j) {
                if (path[i][j] == 0) {
                    ret = max(ret, dfs(matrix, path, dires, i, j));
                }
                else {
                    ret = max(ret, path[i][j]);
                }
            }
        }

        return ret;
    }
};
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    1850    |    3263    |   56.7%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
