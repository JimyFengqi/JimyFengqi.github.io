---
title: LCP 45-自行车炫技赛场
date: 2021-12-03 21:27:55
categories:
  - 中等
tags:
  - 深度优先搜索
  - 广度优先搜索
  - 记忆化搜索
  - 数组
  - 动态规划
  - 矩阵
---

> 原文链接: https://leetcode-cn.com/problems/kplEvH


## 英文原文
<div></div>

## 中文题目
<div>「力扣挑战赛」中 `N*M` 大小的自行车炫技赛场的场地由一片连绵起伏的上下坡组成，场地的高度值记录于二维数组 `terrain` 中，场地的减速值记录于二维数组 `obstacle` 中。
- 若选手骑着自行车从高度为 `h1` 且减速值为 `o1` 的位置到高度为 `h2` 且减速值为 `o2` 的相邻位置（上下左右四个方向），速度变化值为 `h1-h2-o2`（负值减速，正值增速）。

选手初始位于坐标 `position` 处且初始速度为 1，请问选手可以刚好到其他哪些位置时速度依旧为 1。请以二维数组形式返回这些位置。若有多个位置则按行坐标升序排列，若有多个位置行坐标相同则按列坐标升序排列。

**注意：** 骑行过程中速度不能为零或负值

**示例 1：**
> 输入：`position = [0,0], terrain = [[0,0],[0,0]], obstacle = [[0,0],[0,0]]`
> 
> 输出：`[[0,1],[1,0],[1,1]]`
> 
> 解释：
> 由于当前场地属于平地，根据上面的规则，选手从`[0,0]`的位置出发都能刚好在其他处的位置速度为 1。

**示例 2：**
> 输入：`position = [1,1], terrain = [[5,0],[0,6]], obstacle = [[0,6],[7,0]]`
> 
> 输出：`[[0,1]]`
> 
> 解释：
> 选手从 `[1,1]` 处的位置出发，到 `[0,1]` 处的位置时恰好速度为 1。


**提示：**
- `n == terrain.length == obstacle.length`
- `m == terrain[i].length == obstacle[i].length`
- `1 <= n <= 100`
- `1 <= m <= 100`
- `0 <= terrain[i][j], obstacle[i][j] <= 100`
- `position.length == 2`
- `0 <= position[0] < n`
- `0 <= position[1] < m`</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
根据题目的数据范围，选手到任意位置的速度至多为 $101$，那么可以用 $(x,y,\textit{speed})$ 表示状态，从起点 $(\textit{position}[0],\textit{position}[1],1)$ 开始跑 BFS。

BFS 结束后，如果 $(x,y,1)$ 被访问过，那么将 $(x,y)$ 计入答案中。注意起点不能计入答案。

```go
var dir4 = []struct{ x, y int }{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

func bicycleYard(position []int, terrain, obstacle [][]int) (ans [][]int) {
	n, m := len(terrain), len(terrain[0])
	vis := make([][][102]bool, n)
	for i := range vis {
		vis[i] = make([][102]bool, m)
	}

	sx, sy := position[0], position[1]
	vis[sx][sy][1] = true
	type pair struct{ x, y, speed int }
	q := []pair{{sx, sy, 1}}
	for len(q) > 0 {
		p := q[0]
		q = q[1:]
		x, y, speed := p.x, p.y, p.speed
		for _, d := range dir4 {
			if xx, yy := x+d.x, y+d.y; 0 <= xx && xx < n && 0 <= yy && yy < m {
				s := speed + terrain[x][y] - terrain[xx][yy] - obstacle[xx][yy]
				if s > 0 && !vis[xx][yy][s] {
					vis[xx][yy][s] = true
					q = append(q, pair{xx, yy, s})
				}
			}
		}
	}

	vis[sx][sy][1] = false // 起点不计入答案
	for i, row := range vis {
		for j, b := range row {
			if b[1] {
				ans = append(ans, []int{i, j})
			}
		}
	}
	return
}
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    1164    |    5849    |   19.9%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
