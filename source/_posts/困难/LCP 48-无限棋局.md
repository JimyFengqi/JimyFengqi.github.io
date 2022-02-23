---
title: LCP 48-无限棋局
date: 2021-12-03 21:27:56
categories:
  - 困难
tags:
  - 数组
  - 数学
  - 枚举
  - 博弈
---

> 原文链接: https://leetcode-cn.com/problems/fsa7oZ


## 英文原文
<div></div>

## 中文题目
<div>小力正在通过残局练习来备战「力扣挑战赛」中的「五子棋」项目，他想请你能帮他预测当前残局的输赢情况。棋盘中的棋子分布信息记录于二维数组 `pieces` 中，其中 `pieces[i] = [x,y,color]` 表示第 `i` 枚棋子的横坐标为 `x`，纵坐标为 `y`，棋子颜色为 `color`(`0` 表示黑棋，`1` 表示白棋)。假如黑棋先行，并且黑棋和白棋都按最优策略落子，请你求出当前棋局在三步（按 **黑、白、黑** 的落子顺序）之内的输赢情况（三步之内先构成同行、列或对角线连续同颜色的至少 5 颗即为获胜）：
- 黑棋胜, 请返回 `"Black"`
- 白棋胜, 请返回 `"White"`
- 仍无胜者, 请返回 `"None"`

**注意：** 
- 和传统的五子棋项目不同，「力扣挑战赛」中的「五子棋」项目 **不存在边界限制**，即可在 **任意位置** 落子；
- 黑棋和白棋均按 3 步内的输赢情况进行最优策略的选择
- 测试数据保证所给棋局目前无胜者；
- 测试数据保证不会存在坐标一样的棋子。

**示例 1：**
> 输入：
> `pieces = [[0,0,1],[1,1,1],[2,2,0]]`
>
> 输出：`"None"`
>
> 解释：无论黑、白棋以何种方式落子，三步以内都不会产生胜者。

**示例 2：**
> 输入：
> `pieces = [[1,2,1],[1,4,1],[1,5,1],[2,1,0],[2,3,0],[2,4,0],[3,2,1],[3,4,0],[4,2,1],[5,2,1]]`
>
> 输出：`"Black"`
>
> 解释：三步之内黑棋必胜，以下是一种可能的落子情况：
>![902b87df29998b1c181146c8fdb3a4b6.gif](https://pic.leetcode-cn.com/1629800639-KabOfY-902b87df29998b1c181146c8fdb3a4b6.gif){:width="300px"}



**提示：**
- `0 <= pieces.length <= 1000`
- `pieces[i].length = 3`
- `-10^9 <= pieces[i][0], pieces[i][1] <=10^9` 
- `0 <= pieces[i][2] <=1`
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
其实这道题的对弈策略并不难想到，其它题解已有总结的。但在比赛中如何快速的把代码写对是关键，所以我们需要清晰又简短的代码。以下是我基于比赛时的基础版本，做了一下小修改和注释后的版本，供各位参考：

分类讨论与其它题解别无二致，仅方便代码阅读时对照使用：
1、若黑棋存在一步致胜的方案，则黑胜，否则2
2a、若白棋存在多个一步制胜的落子位，则白胜
2b、若白棋存在一个一步制胜的落子位，则黑先手必须堵这个位置
__3b、黑棋堵位后，黑棋存在多个一步制胜的落子位，则黑剩，否则平
2c、若白棋不存在一步制胜的落子位
__3c、黑能落一子创造多个一步制胜的落子位，则黑胜，否则平
        

```python []
class Solution:
    def gobang(self, pieces: List[List[int]]) -> str:
        D = [(1, 0), (0, 1), (1, 1), (-1, 1)]
        board = {(x,y):c for x, y, c in pieces}

        # 枚举指定颜色棋子五子连线的所有方案（当前棋盘额外最多下两子）
        def findLines(color) :
            lines = DefaultDict(list)
            for x, y, c in pieces : # 枚举棋盘上所有指定颜色棋子的位置
                if c != color : continue
                for i, (dx, dy) in enumerate(D) : # 连线有四个方向
                    for k in range(3) : # 因为最多额外下两子，连线端点偏离已有棋子不超过2
                        nx, ny = x-dx*k, y-dy*k
                        head = (nx, ny, i)
                        if head in lines : continue # 该“端点&方向”已存在

                        for _ in range(5) : # 把该连线上剩下的落子位找到
                            c = board.get((nx, ny), -1)
                            if c != color :
                                if c >= 0 or len(lines[head]) >= 2 : # 该连线上有异色棋子，或空位过多，舍弃
                                    lines[head].clear()
                                    break
                                lines[head].append((nx, ny))
                            nx, ny = nx+dx, ny+dy

            # 按待落子数归类连线方案
            res = [[] for _ in range(3)]
            for v in lines.values() :
                if len(v) : res[len(v)].append(v)
            return res

        # 若黑棋存在一步致胜的方案，则黑胜
        black = findLines(0)
        if len(black[1]) > 0 : return "Black"

        white = findLines(1)
        positions = set(line[0] for line in white[1]) # 不同的连线可能包含相同的落子位，须去重
        # 若白棋存在多个一步制胜的落子位，则白胜
        if len(positions) > 1 : return "White"

        if len(positions) == 1 :
            # 若白棋存在一个一步制胜的落子位，则黑先手必须堵这个位置
            x, y = positions.pop()
            pieces.append([x, y, 0])
            board[(x, y)] = 0
            black = findLines(0)

            # 黑棋堵位后，黑棋存在多个一步制胜的落子位，则黑剩，否则平
            positions = set(line[0] for line in black[1])
            return "Black" if len(positions) > 1 else "None"

        # 若白棋不存在一步制胜的落子位，黑须落一子创造多于一个一步制胜的落子位才能在两步内获胜
        pairs = set((pair[0], pair[1]) for pair in black[2]) # 不同的连线可能包含相同的两个落子位，须去重
        positions = set()
        for p1, p2 in pairs :
            # 若某个落子位在之前落子对中已出现，下该位置能产生两个一步致胜的位置
            if p1 in positions or p2 in positions : return "Black"
            positions.add(p1)
            positions.add(p2)

        return "None"
```



## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    321    |    1945    |   16.5%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
