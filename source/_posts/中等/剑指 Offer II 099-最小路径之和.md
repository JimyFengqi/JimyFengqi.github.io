---
title: 剑指 Offer II 099-最小路径之和
categories:
  - 中等
tags:
  - 数组
  - 动态规划
  - 矩阵
abbrlink: 217371782
date: 2021-12-03 21:31:07
---

> 原文链接: https://leetcode-cn.com/problems/0i0mDW




## 中文题目
<div><p>给定一个包含非负整数的 <code><em>m</em>&nbsp;x&nbsp;<em>n</em></code>&nbsp;网格&nbsp;<code>grid</code> ，请找出一条从左上角到右下角的路径，使得路径上的数字总和为最小。</p>

<p><strong>说明：</strong>一个机器人每次只能向下或者向右移动一步。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<p><img alt="" src="https://assets.leetcode.com/uploads/2020/11/05/minpath.jpg" style="width: 242px; height: 242px;" /></p>

<pre>
<strong>输入：</strong>grid = [[1,3,1],[1,5,1],[4,2,1]]
<strong>输出：</strong>7
<strong>解释：</strong>因为路径 1&rarr;3&rarr;1&rarr;1&rarr;1 的总和最小。
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>grid = [[1,2,3],[4,5,6]]
<strong>输出：</strong>12
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>m == grid.length</code></li>
	<li><code>n == grid[i].length</code></li>
	<li><code>1 &lt;= m, n &lt;= 200</code></li>
	<li><code>0 &lt;= grid[i][j] &lt;= 100</code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 64&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/minimum-path-sum/">https://leetcode-cn.com/problems/minimum-path-sum/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
这是一道**动态规划**算法题，对于动态规划如何入门的话，请看：[动态规划入门题解](https://leetcode-cn.com/problems/fibonacci-number/solution/dong-tai-gui-hua-de-ru-men-suan-fa-ti-ka-n8b4/)

一般动态规划的问题都可以通过穷举的方式得到答案，既然可以穷举，我们就可以将这个问题抽象成树形结构问题，然后通过回溯来解决

对于什么是回溯算法的话，请参考：[回溯算法入门题解](https://leetcode-cn.com/problems/permutations/solution/pei-yang-chou-xiang-neng-li-de-yi-dao-ti-1731/)

所以，我们先从回溯解法看起，然后一步一步的优化，从而得到最终最优的动态规划解法

#### 1. 回溯解法

![16_最小路径和：回溯解法.mp4](7e32aa1d-9405-4a58-aaed-cd3dc3dd6b16)

代码如下：
```java
private int minPathSum = Integer.MAX_VALUE;
private int[][] dirs = {{1, 0}, {0, 1}};
public int minPathSum(int[][] grid) {
    dfs(grid, 0, 0, grid[0][0]);
    return minPathSum;
}

private void dfs(int[][] grid, int row, int col, int sum) {
    if (row == grid.length - 1 && col == grid[0].length - 1) {
        minPathSum = Math.min(minPathSum, sum);
        return;
    }

    for (int[] dir : dirs) {
        int nextRow = row + dir[0];
        int nextCol = col + dir[1];
        if (nextRow < 0 || nextCol < 0
                || nextRow >= grid.length
                || nextCol >= grid[0].length) continue;
        sum += grid[nextRow][nextCol];
        dfs(grid, nextRow, nextCol, sum);
        sum -= grid[nextRow][nextCol];
    }
}
```

#### 2. 记忆化搜索

![3_力扣 64 最小路径和.mp4](c94546b0-b2b2-4827-bd4e-1a61a5a88ec8)

代码如下：
```java []
private int[][] dirs = {{1, 0}, {0, 1}};
public int minPathSum(int[][] grid) {
    int[][] memo = new int[grid.length][grid[0].length];
    for (int i = 0; i < grid.length; i++) {
        Arrays.fill(memo[i], Integer.MAX_VALUE);
    }
    return dfs(grid, 0, 0, memo);
}

private int dfs(int[][] grid, int row, int col, int[][] memo) {
    if (row == grid.length - 1 && col == grid[0].length - 1) {
        return grid[row][col];
    }
    if (memo[row][col] != Integer.MAX_VALUE) return memo[row][col];
    int minPathSum = Integer.MAX_VALUE;
    for (int[] dir : dirs) {
        int nextRow = row + dir[0];
        int nextCol = col + dir[1];
        if (nextRow < 0 || nextCol < 0
                || nextRow >= grid.length
                || nextCol >= grid[0].length) continue;
        int childMinPathSum = dfs(grid, nextRow, nextCol, memo);
        minPathSum = Math.min(minPathSum, childMinPathSum);
    }
    memo[row][col] = minPathSum + grid[row][col];
    return memo[row][col];
}
```
```c++ []
class Solution {
private:
    vector<vector<int>> dirs = {{1, 0}, {0, 1}};
public:
    // 3. 记忆化搜索
    int minPathSum1(vector<vector<int>>& grid) {
        vector<vector<int>> memo(grid.size(), vector<int>(grid[0].size(), INT_MAX));
        return dfs(grid, 0, 0, memo);
    }

    int dfs(vector<vector<int>>& grid, int row, int col, vector<vector<int>>& memo) {
        if (row == grid.size() - 1 && col == grid[0].size() - 1) {
            return grid[row][col];
        }

        if (memo[row][col] != INT_MAX) return memo[row][col];

        int minPathSum = INT_MAX;
        for (vector<int> dir : dirs) {
            int nextRow = row + dir[0];
            int nextCol = col + dir[1];
            if (nextRow < 0 || nextCol < 0
                    || nextRow >= grid.size()
                    || nextCol >= grid[0].size()) continue;
            int childMinPathSum = dfs(grid, nextRow, nextCol, memo);
            minPathSum = min(minPathSum, childMinPathSum);
        }
        memo[row][col] = minPathSum + grid[row][col];
        return memo[row][col];
    }
}
```
```javascript []
const dirs = [[1, 0], [0, 1]]

// 3. 记忆化搜索
var minPathSum1 = function(grid) {
    const MAX_INT = Math.pow(2, 31) - 1
    const m = grid.length, n = grid[0].length
    const memo = new Array(m).fill(0).map(() => new Array(n).fill(MAX_INT))

    const dfs = (row, col) => {
        if (row == m - 1 && col == n - 1) return grid[row][col]

        if (memo[row][col] != MAX_INT) return memo[row][col]

        let minPathSum = MAX_INT
        for (const dir of dirs) {
            const nextRow = row + dir[0]
            const nextCol = col + dir[1]
            if (nextRow < 0 || nextRow >= m || nextCol < 0 || nextCol >= n) continue
            const childMinPathSum = dfs(nextRow, nextCol)
            minPathSum = Math.min(minPathSum, childMinPathSum)
        }

        memo[row][col] = minPathSum + grid[row][col]
        return memo[row][col]
    }

    return dfs(0, 0)
};
```
```python []
class Solution:
    def __init__(self):
        self.dirs = [[1, 0], [0, 1]]

    # 3. 记忆化搜索
    def minPathSum1(self, grid: List[List[int]]) -> int:
        MAX_INT = 2**31 - 1
        m, n = len(grid), len(grid[0])
        memo = [[MAX_INT] * n for _ in range(m)]

        def dfs(row, col) -> int:
            if row == m - 1 and col == n - 1:
                return grid[row][col]

            if memo[row][col] != MAX_INT:
                return memo[row][col]

            min_path_sum = MAX_INT
            for dir in self.dirs:
                next_row, next_col = row + dir[0], col + dir[1]
                if next_row < 0 or next_row >= m or next_col < 0 or next_col >= n:
                    continue
                child_min_path_sum = dfs(next_row, next_col)
                min_path_sum = min(min_path_sum, child_min_path_sum)

            memo[row][col] = min_path_sum + grid[row][col]
            return memo[row][col]

        return dfs(0, 0)
```

#### 3. 动态规划 - 从终点到起始点

![...路径和【动态规划从终点到起始点】.mp4](0fddbf80-f185-45ba-a54b-139d971c12c3)

代码如下：

```java []
public int minPathSum(int[][] grid) {
    int m = grid.length;
    int n = grid[0].length;
    // 状态定义：dp[i][j] 表示从坐标 (i, j) 到右下角的最小路径和
    int[][] dp = new int[m][n];

    // 状态初始化
    dp[m - 1][n - 1] = grid[m - 1][n - 1];

    // 状态转移
    for (int i = m - 1; i >= 0 ; i--) {
        for (int j = n - 1; j >= 0 ; j--) {
            if (i == m - 1 && j != n - 1) { // 最后一行
                dp[i][j] = grid[i][j] + dp[i][j + 1];
            } else if (i != m - 1 && j == n - 1) {
                dp[i][j] = grid[i][j] + dp[i + 1][j];
            } else if (i != m - 1 && j != n - 1) {
                dp[i][j] = grid[i][j] + Math.min(dp[i + 1][j], dp[i][j + 1]);
            }
        }
    }

    // 返回结果
    return dp[0][0];
}
```
```c++ []
public:
    // 4. 动态规划：从终点到起始点
    int minPathSum2(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();

        // 状态定义：dp[i][j] 表示从坐标 (i, j) 到右下角的最小路径和
        vector<vector<int>> dp(m, vector<int>(n));

        // 状态初始化
        dp[m - 1][n - 1] = grid[m - 1][n - 1];

        // 状态转移
        for (int i = m - 1; i >= 0; i--) {
            for (int j = n - 1; j >= 0; j--) {
                if (i == m - 1 && j != n - 1) { // 最后一行
                    dp[i][j] = grid[i][j] + dp[i][j + 1];
                } else if (i != m - 1 && j == n - 1) { // 最后一列
                    dp[i][j] = grid[i][j] + dp[i + 1][j];
                } else if (i != m - 1 && j != n - 1) {
                    dp[i][j] = grid[i][j] + min(dp[i + 1][j], dp[i][j + 1]);
                }
            }
        }

        // 返回结果
        return dp[0][0];
    }
}
```
```javascript []
// 4. 动态规划：从终点到起始点
var minPathSum2 = function(grid) {
    const m = grid.length, n = grid[0].length

    // 状态定义：dp[i][j] 表示从坐标 (i, j) 到右下角的最小路径和
    const dp = new Array(m).fill(0).map(() => new Array(n).fill(0))

    // 状态初始化
    dp[m - 1][n - 1] = grid[m - 1][n - 1]

    // 状态转移
    for (let i = m - 1; i >= 0 ; i--) {
        for (let j = n - 1; j >= 0 ; j--) {
            if (i == m - 1 && j != n - 1) { // 最后一行
                dp[i][j] = grid[i][j] + dp[i][j + 1]
            } else if (i != m - 1 && j == n - 1) { // 最后一列
                dp[i][j] = grid[i][j] + dp[i + 1][j]
            } else if (i != m - 1 && j != n - 1) {
                dp[i][j] = grid[i][j] + Math.min(dp[i + 1][j], dp[i][j + 1])
            }
        }
    }

    // 返回结果
    return dp[0][0]
}
```
```python []
class Solution:
    # 4. 动态规划：从终点到起始点
    def minPathSum2(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])

        # 状态定义：dp[i][j] 表示从坐标 (i, j) 到右下角的最小路径和
        dp = [[0] * n for _ in range(m)]

        # 状态初始化
        dp[m - 1][n - 1] = grid[m - 1][n - 1]

        # 状态转移
        for i in range(m - 1, -1, -1):
            for j in range(n - 1, -1, -1):
                if i == m - 1 and j != n - 1:
                    dp[i][j] = grid[i][j] + dp[i][j + 1]
                elif i != m - 1 and j == n - 1:
                    dp[i][j] = grid[i][j] + dp[i + 1][j]
                elif i != m - 1 and j != n - 1:
                    dp[i][j] = grid[i][j] + min(dp[i + 1][j], dp[i][j + 1])

        # 返回结果
        return dp[0][0]
```


#### 4. 动态规划 - 从起始点到终点

![...小路径和：从起始点到终点动态规划.mp4](0731717f-ac9d-4b39-8773-503e79bedaeb)

代码如下：
```java []
public int minPathSum(int[][] grid) {
    int m = grid.length;
    int n = grid[0].length;
    // 状态定义：dp[i][j] 表示从 [0,0] 到 [i,j] 的最小路径和
    int[][] dp = new int[m][n];

    // 状态初始化
    dp[0][0] = grid[0][0];

    // 状态转移
    for (int i = 0; i < m ; i++) {
        for (int j = 0; j < n ; j++) {
            if (i == 0 && j != 0) {
                dp[i][j] = grid[i][j] + dp[i][j - 1];
            } else if (i != 0 && j == 0) {
                dp[i][j] = grid[i][j] + dp[i - 1][j];
            } else if (i != 0 && j != 0) {
                dp[i][j] = grid[i][j] + Math.min(dp[i - 1][j], dp[i][j - 1]);
            }
        }
    }

    // 返回结果
    return dp[m - 1][n - 1];
}
```
```c++ []
public:
    // 5. 动态规划：从起始点到终点
    int minPathSum3(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();

        // 状态定义：dp[i][j] 表示从 [0,0] 到 [i,j] 的最小路径和
        vector<vector<int>> dp(m, vector<int>(n));

        // 状态初始化
        dp[0][0] = grid[0][0];

        // 状态转移
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (i == 0 && j != 0) { //第一行
                    dp[i][j] = grid[i][j] + dp[i][j - 1];
                } else if (i != 0 && j == 0) { // 第一列
                    dp[i][j] = grid[i][j] + dp[i - 1][j];
                } else if (i != 0 && j != 0) {
                    dp[i][j] = grid[i][j] + min(dp[i - 1][j], dp[i][j - 1]);
                }
            }
        }

        // 返回结果
        return dp[m - 1][n - 1];
    }
}
```
```javascript []
// 5. 动态规划：从起始点到终点
var minPathSum3 = function(grid) {
    const m = grid.length, n = grid[0].length

    // 状态定义：dp[i][j] 表示从 [0,0] 到 [i,j] 的最小路径和
    const dp = new Array(m).fill(0).map(() => new Array(n).fill(0))

    // 状态初始化
    dp[0][0] = grid[0][0]

    // 状态转移
    for (let i = 0; i < m ; i++) {
        for (let j = 0; j < n ; j++) {
            if (i == 0 && j != 0) {
                dp[i][j] = grid[i][j] + dp[i][j - 1]
            } else if (i != 0 && j == 0) {
                dp[i][j] = grid[i][j] + dp[i - 1][j]
            } else if (i != 0 && j != 0) {
                dp[i][j] = grid[i][j] + Math.min(dp[i - 1][j], dp[i][j - 1])
            }
        }
    }

    // 返回结果
    return dp[m - 1][n - 1]
}
```
```python []
# 5. 动态规划：从起始点到终点
def minPathSum3(self, grid: List[List[int]]) -> int:
    m, n = len(grid), len(grid[0])

    # 状态定义：dp[i][j] 表示从 [0,0] 到 [i,j] 的最小路径和
    dp = [[0] * n for _ in range(m)]

    # 状态初始化
    dp[0][0] = grid[0][0]

    # 状态转移
    for i in range(m):
        for j in range(n):
            if i == 0 and j != 0:
                dp[i][j] = grid[i][j] + dp[i][j - 1]
            elif i != 0 and j == 0:
                dp[i][j] = grid[i][j] + dp[i - 1][j]
            elif i != 0 and j != 0:
                dp[i][j] = grid[i][j] + min(dp[i - 1][j], dp[i][j - 1])

    # 返回结果
    return dp[m - 1][n - 1]
```



#### 5. 空间状态压缩和优化

![...扣 64 最小路径和【状态压缩】.mp4](12c71b11-4018-480b-9ac1-de2bd30aafef)

状态空间压缩代码：
```java []
public int minPathSum(int[][] grid) {
    int m = grid.length;
    int n = grid[0].length;
    // 状态定义：dp[i] 表示从 (0, 0) 到达第 i - 1 行的最短路径值
    int[] dp = new int[n];

    // 状态初始化
    dp[0] = grid[0][0];

    // 状态转移
    for (int i = 0; i < m ; i++) {
        for (int j = 0; j < n ; j++) {
            if (i == 0 && j != 0) {
                dp[j] = grid[i][j] + dp[j - 1];
            } else if (i != 0 && j == 0) {
                dp[j] = grid[i][j] + dp[j];
            } else if (i != 0 && j != 0) {
                dp[j] = grid[i][j] + Math.min(dp[j], dp[j - 1]);
            }
        }
    }

    // 返回结果
    return dp[n - 1];
}
```
```c++ []
// 6. 动态规划：从起始点到终点 + 状态压缩
public:
    int minPathSum4(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();

        // 状态定义：dp[i] 表示从 (0, 0) 到达第 i - 1 行的最短路径值
        vector<int> dp(n);

        // 状态初始化
        dp[0] = grid[0][0];

        // 状态转移
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (i == 0 && j != 0) { //第一行
                    dp[j] = grid[i][j] + dp[j - 1];
                } else if (i != 0 && j == 0) { // 第一列
                    dp[j] = grid[i][j] + dp[j];
                } else if (i != 0 && j != 0) {
                    dp[j] = grid[i][j] + min(dp[j], dp[j - 1]);
                }
            }
        }

        // 返回结果
        return dp[n - 1];
    }
```
```javascript []
// 6. 动态规划：从起始点到终点 + 状态压缩
var minPathSum4 = function(grid) {
    const m = grid.length, n = grid[0].length

    // 状态定义：dp[i] 表示从 (0, 0) 到达第 i - 1 行的最短路径值
    const dp = new Array(n).fill(0)

    // 状态初始化
    dp[0] = grid[0][0]

    // 状态转移
    for (let i = 0; i < m ; i++) {
        for (let j = 0; j < n ; j++) {
            if (i == 0 && j != 0) {
                dp[j] = grid[i][j] + dp[j - 1]
            } else if (i != 0 && j == 0) {
                dp[j] = grid[i][j] + dp[j]
            } else if (i != 0 && j != 0) {
                dp[j] = grid[i][j] + Math.min(dp[j], dp[j - 1])
            }
        }
    }

    // 返回结果
    return dp[n - 1]
}
```
```python []
# 6. 动态规划：从起始点到终点 + 状态压缩
def minPathSum4(self, grid: List[List[int]]) -> int:
    m, n = len(grid), len(grid[0])

    # 状态定义：dp[i] 表示从 (0, 0) 到达第 i - 1 行的最短路径值
    dp = [0] * n

    # 状态初始化
    dp[0] = grid[0][0]

    # 状态转移
    for i in range(m):
        for j in range(n):
            if i == 0 and j != 0:
                dp[j] = grid[i][j] + dp[j - 1]
            elif i != 0 and j == 0:
                dp[j] = grid[i][j] + dp[j]
            elif i != 0 and j != 0:
                dp[j] = grid[i][j] + min(dp[j], dp[j - 1])

    # 返回结果
    return dp[n - 1]
```



空间优化代码如下：
```java []
// 动态规划：从起始点到终点 + 使用输入数组作为状态数组
public int minPathSum(int[][] grid) {
    int m = grid.length;
    int n = grid[0].length;

    for (int i = 0; i < m ; i++) {
        for (int j = 0; j < n ; j++) {
            if (i == 0 && j != 0) {
                grid[i][j] = grid[i][j] + grid[i][j - 1];
            } else if (i != 0 && j == 0) {
                grid[i][j] = grid[i][j] + grid[i - 1][j];
            } else if (i != 0 && j != 0) {
                grid[i][j] = grid[i][j] + Math.min(grid[i - 1][j], grid[i][j - 1]);
            }
        }
    }

    return grid[m - 1][n - 1];
}
```
```c++ []
public:
// 7. 动态规划：从起始点到终点 + 使用输入数组作为状态数组
    int minPathSum(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();

        // 状态转移
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (i == 0 && j != 0) { //第一行
                    grid[i][j] = grid[i][j] + grid[i][j - 1];
                } else if (i != 0 && j == 0) { // 第一列
                    grid[i][j] = grid[i][j] + grid[i - 1][j];
                } else if (i != 0 && j != 0) {
                    grid[i][j] = grid[i][j] + min(grid[i - 1][j], grid[i][j - 1]);
                }
            }
        }

        // 返回结果
        return grid[m - 1][n - 1];
    }
```
```javascript []
// 7. 动态规划：从起始点到终点 + 使用输入数组作为状态数组
var minPathSum = function(grid) {
    const m = grid.length, n = grid[0].length

    // 状态转移
    for (let i = 0; i < m ; i++) {
        for (let j = 0; j < n ; j++) {
            if (i == 0 && j != 0) {
                grid[i][j] = grid[i][j] + grid[i][j - 1]
            } else if (i != 0 && j == 0) {
                grid[i][j] = grid[i][j] + grid[i - 1][j]
            } else if (i != 0 && j != 0) {
                grid[i][j] = grid[i][j] + Math.min(grid[i - 1][j], grid[i][j - 1])
            }
        }
    }

    // 返回结果
    return grid[m - 1][n - 1]
}
```
```python []
# 7. 动态规划：从起始点到终点 + 使用输入数组作为状态数组
def minPathSum(self, grid: List[List[int]]) -> int:
    m, n = len(grid), len(grid[0])

    # 状态转移
    for i in range(m):
        for j in range(n):
            if i == 0 and j != 0:
                grid[i][j] = grid[i][j] + grid[i][j - 1]
            elif i != 0 and j == 0:
                grid[i][j] = grid[i][j] + grid[i - 1][j]
            elif i != 0 and j != 0:
                grid[i][j] = grid[i][j] + min(grid[i - 1][j], grid[i][j - 1])

    # 返回结果
    return grid[m - 1][n - 1]
```


在刷题的时候：
1. 如果你觉得自己数据结构与算法**基础不够扎实**，那么[请点这里](http://www.tangweiqun.com/api/31104/offer099?av=1&cv=1)，这里包含了**一个程序员 5 年内需要的所有算法知识**

2. 如果你感觉刷题**太慢**，或者感觉**很困难**，或者**赶时间**，那么[请点这里](http://www.tangweiqun.com/api/35548/offer099?av=1&cv=1)。这里**用 365 道高频算法题，带你融会贯通算法知识，做到以不变应万变**

3. **回溯、贪心和动态规划，是算法面试中的三大难点内容**，如果你只是想搞懂这三大难点内容 [请点这里](http://www.tangweiqun.com/api/38100/offer099?av=1&cv=1)

**以上三个链接中的内容，都支持 Java/C++/Python/js 四种语言** 







## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    3914    |    5515    |   71.0%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
