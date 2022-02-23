---
title: LCP 31-变换的迷宫
date: 2021-12-03 21:33:22
categories:
  - 困难
tags:
  - 深度优先搜索
  - 广度优先搜索
  - 数组
  - 动态规划
  - 矩阵
---

> 原文链接: https://leetcode-cn.com/problems/Db3wC1


## 英文原文
<div></div>

## 中文题目
<div>某解密游戏中，有一个 N\*M 的迷宫，迷宫地形会随时间变化而改变，迷宫出口一直位于 `(n-1,m-1)` 位置。迷宫变化规律记录于 `maze` 中，`maze[i]` 表示 `i` 时刻迷宫的地形状态，`"."` 表示可通行空地，`"#"` 表示陷阱。

地形图初始状态记作 `maze[0]`，此时小力位于起点 `(0,0)`。此后每一时刻可选择往上、下、左、右其一方向走一步，或者停留在原地。

小力背包有以下两个魔法卷轴（卷轴使用一次后消失）：
+ 临时消除术：将指定位置在下一个时刻变为空地；
+ 永久消除术：将指定位置永久变为空地。

请判断在迷宫变化结束前（含最后时刻），小力能否在不经过任意陷阱的情况下到达迷宫出口呢？

**注意： 输入数据保证起点和终点在所有时刻均为空地。**

**示例 1：**
>输入：`maze = [[".#.","#.."],["...",".#."],[".##",".#."],["..#",".#."]]`
>
>输出：`true`
>
>解释：
![maze.gif](https://pic.leetcode-cn.com/1615892239-SCIjyf-maze.gif)


**示例 2：**
>输入：`maze = [[".#.","..."],["...","..."]]`
>
>输出：`false`
>
>解释：由于时间不够，小力无法到达终点逃出迷宫。

**示例 3：**
>输入：`maze = [["...","...","..."],[".##","###","##."],[".##","###","##."],[".##","###","##."],[".##","###","##."],[".##","###","##."],[".##","###","##."]]`
>
>输出：`false`
>
>解释：由于道路不通，小力无法到达终点逃出迷宫。

**提示：**
- `1 <= maze.length <= 100`
- `1 <= maze[i].length, maze[i][j].length <= 50`
- `maze[i][j]` 仅包含 `"."`、`"#"`</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
### 解题思路

首先，若不考虑两个魔法卷轴，则该问题为最基础的搜索问题。
考虑上第三维时间因素（令$dep=len(maze)$），迷宫实际大小为$dep*N*M$，通过记忆化搜索，时间复杂度为$O(dep*N*M)$，即最大为$100*50*50=250000$。

接下来考虑引入卷轴。
- 临时卷轴：较为简单，在上述的三个维度上再增加一个维度，即临时卷轴是否使用过了，由于其值仅为`False`或`True`，时间复杂度只需再乘以2。
- 永久卷轴：与临时卷轴无后续影响不同，永久卷轴使用之后会有后续影响，若直接引入使用的坐标点，则时间复杂度直接爆炸。这里需要脑筋急转弯。我们考虑一下，记录永久卷轴使用的坐标点的目的是为了下次再回来当前点的时候，能判断是否可以落脚，也即`A->B->C->...->A`，这时我们可以发现，这种情况可以直接等价于`A->A->A->...->A`。因此，其实没有必要记录永久卷轴使用的坐标点，只需要在使用的时候，停留原地，考虑所有未来的时间步即可。因此，同临时卷轴，只需再增加一个值仅为`False`或`True`的维度，时间复杂度再乘以2。

### 复杂度分析

时间/空间复杂度：$O(dep*N*M)$
即最大为$100*50*50*2*2=10^6$

### 代码

有不懂的可以评论。

```python3 [solution1-Python3]
class Solution:
    def escapeMaze(self, maze: List[List[str]]) -> bool:
        max_dep, n, m = len(maze), len(maze[0]), len(maze[0][0])
        # 下一点移动方式
        dirs = [(1, 0), (0, 1), (-1, 0), (0, -1), (0, 0)]
        # 记忆化搜索（为python缓存机制）
        @lru_cache(None)
        def dfs(x, y, dep, magic_a, magic_b):
            # print(x, y, dep, magic_a, magic_b)
            if x == n - 1 and y == m - 1:
                return True
            if dep + 1 == max_dep:
                return False
            # 剪枝
            if n - 1 - x + m - 1 - y > max_dep - dep - 1:
                return False
            for i, j in dirs:
                xx, yy = x + i, y + j
                if xx < 0 or xx == n or yy < 0 or yy == m:
                    continue
                # 下一点为平地
                if maze[dep + 1][xx][yy] == '.':
                    if dfs(xx, yy, dep + 1, magic_a, magic_b):
                        return True
                # 下一点需要使用卷轴
                else:
                    if not magic_a:
                        # 临时卷轴
                        if dfs(xx, yy, dep + 1, True, magic_b):
                            return True
                    if not magic_b:
                        # 用永久卷轴保持不动
                        for next_dep in range(dep + 1, max_dep):
                            if dfs(xx, yy, next_dep, magic_a, True):
                                return True
            return False
        return dfs(0, 0, 0, False, False)
```

```C++ [solution1-C++]
class Solution {
public:
    int dx[5] = {0, 1, 0,-1,0};
    int dy[5] = {1, 0,-1,0,0};
    int n; //n行m列
    int m;
    int max_step; //最大步数
    bool visited[55][55][105][2][2] = {false};  // 记忆化搜索，是否已访问过
    bool dfs(int x, int y, int step, bool magic1, bool magic2, const vector<vector<string>>& maze){
        if(visited[x][y][step][magic1][magic2] == true) return false;  // 历史已访问过，相同case已不可能
        visited[x][y][step][magic1][magic2] = true;
        if(x == n-1 && y == m-1) return true;//到达终点
        if(step == max_step) return false;//最大步数都用完了还没走到终点 GG
        if(max_step - step < n-1-x + m-1-y) return false; // 不可能再走到终点了 剪枝
        for(int i=0; i<5; i++){ //尝试每一种next_state
            int fx = x + dx[i];
            int fy = y + dy[i];
            if(fx>=0 && fx<n && fy>=0 && fy<m){ //如果在地图内
                if(maze[step+1][fx][fy] == '.'){ //如果是空地可以直接踩过去
                    if(dfs(fx, fy, step+1, magic1, magic2, maze)) return true;
                }
                else{ //如果是陷阱则需要魔法才能踩过去
                    if(magic1 == false){ //使用临时魔法，在下一时刻踩过去
                        if( dfs(fx, fy, step+1, true, magic2, maze)) return true;
                    }
                    if(magic2 == false){//使用永久魔法，在下一时刻至最后一个时刻，选择一个时刻踩过去
                        for(int i=step+1; i<=max_step; i++){
                            if(dfs(fx, fy, i, magic1, true, maze)) return true;
                        }
                    }
                }
            }
        }
        return false;
    }
    bool escapeMaze(vector<vector<string>>& maze) {
        n = maze[0].size();
        m = maze[0][0].size();
        max_step = maze.size() - 1;
        return dfs(0, 0, 0, false, false, maze);
    }
};
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    1812    |    7152    |   25.3%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
