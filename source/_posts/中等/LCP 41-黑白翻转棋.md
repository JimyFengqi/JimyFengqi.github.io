---
title: LCP 41-黑白翻转棋
categories:
  - 中等
tags:
  - 广度优先搜索
  - 数组
  - 矩阵
abbrlink: 645884723
date: 2021-12-03 21:27:59
---

> 原文链接: https://leetcode-cn.com/problems/fHi6rV


## 英文原文
<div></div>

## 中文题目
<div>在 `n*m` 大小的棋盘中，有黑白两种棋子，黑棋记作字母 `"X"`, 白棋记作字母 `"O"`，空余位置记作 `"."`。当落下的棋子与其他相同颜色的棋子在行、列或对角线完全包围（中间不存在空白位置）另一种颜色的棋子，则可以翻转这些棋子的颜色。



![1.gif](https://pic.leetcode-cn.com/1630396029-eTgzpN-6da662e67368466a96d203f67bb6e793.gif){:height=170px}![2.gif](https://pic.leetcode-cn.com/1630396240-nMvdcc-8e4261afe9f60e05a4f740694b439b6b.gif){:height=170px}![3.gif](https://pic.leetcode-cn.com/1630396291-kEtzLL-6fcb682daeecb5c3f56eb88b23c81d33.gif){:height=170px}

「力扣挑战赛」黑白翻转棋项目中，将提供给选手一个未形成可翻转棋子的棋盘残局，其状态记作 `chessboard`。若下一步可放置一枚黑棋，请问选手最多能翻转多少枚白棋。

**注意：**
- 若翻转白棋成黑棋后，棋盘上仍存在可以翻转的白棋，将可以 **继续** 翻转白棋
- 输入数据保证初始棋盘状态无可以翻转的棋子且存在空余位置

**示例 1：**
> 输入：`chessboard = ["....X.","....X.","XOOO..","......","......"]`
> 
> 输出：`3`
> 
> 解释：
> 可以选择下在 `[2,4]` 处，能够翻转白方三枚棋子。

**示例 2：**
> 输入：`chessboard = [".X.",".O.","XO."]`
> 
> 输出：`2`
> 
> 解释：
> 可以选择下在 `[2,2]` 处，能够翻转白方两枚棋子。
![2126c1d21b1b9a9924c639d449cc6e65.gif](https://pic.leetcode-cn.com/1626683255-OBtBud-2126c1d21b1b9a9924c639d449cc6e65.gif)

**示例 3：**
> 输入：`chessboard = [".......",".......",".......","X......",".O.....","..O....","....OOX"]`
> 
> 输出：`4`
> 
> 解释：
> 可以选择下在 `[6,3]` 处，能够翻转白方四枚棋子。
![803f2f04098b6174397d6c696f54d709.gif](https://pic.leetcode-cn.com/1630393770-Puyked-803f2f04098b6174397d6c696f54d709.gif)



**提示：**
- `1 <= chessboard.length, chessboard[i].length <= 8`
- `chessboard[i]` 仅包含 `"."、"O"` 和 `"X"`</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
> 这是一道中等规模的模拟题，思路对了就还好~

### 题意概述

黑白棋盘，当下了一颗黑子后，如果能沿着 `[上，下，左，右，左上，左下，右上，右下]` 连续找到白棋，且最终能遇到黑子拦截，则将这条路径上所有的白子翻转为黑子，翻转后得到的新黑子能触发连锁反应。

现在给你一次下黑子的机会，问最多能翻转多少颗白子。 

## 思路

**1. 对棋盘每个空格进行讨论**

这道题很明显找不出什么实质性的最优解规律，只能枚举每个空格下黑子的情况，看哪个格子能得到最优解。

**2. 每一次模拟前复制棋盘**

由于需要模拟每个空格下黑棋后的棋盘变化，不复制一份棋盘的话，每次模拟结束时需要还原现场，比较麻烦。

```java
for (int i = 0; i < n; i++) {
    for (int j = 0; j < m; j++) {
        if (board[i][j] == '.') {
            // copy the board
            // To Do..
        }
    }
}
```

**3. 下黑子后进行八个方向的模拟**

将八个方向的横纵坐标的步长用数组保存，方便遍历的同时，可以简化代码：

```java
final int[] dir_x = { 1, -1, 0, 0, 1, 1, -1, -1 };
final int[] dir_y = { 0, 0, -1, 1, -1, 1, -1, 1 };
```

接着对每一个方向进行模拟搜索，如果 「 连续遇到白子，且最后可以遇到黑子 」 ，则表示被搜索到的 `白子` 都可以被翻转成 `黑子`。反之，我们需要还原现场，当作这个方向上什么都没有发生过。

```java
private LinkedList<Integer> search(char[][] arr, int x, int y, int step_x, int step_y) {
    // 保存白子下标
    LinkedList<Integer> temp = new LinkedList<>();
    boolean flag = false;
    
    while (check(x, y)) {
        if (arr[x][y] != 'O') {
            // 遇到不是白子时，可能是黑子或者空格
            // 如果是黑子，则代表这个方向搜索到的白子可以被翻转
            flag = arr[x][y] == 'X';
            break;
        } else {
            // 保存白子（新黑子）下标并翻转
            temp.add(x * 10 + y);
            arr[x][y] = 'X';
        }
        x += step_x;
        y += step_y;
    }
    if (!flag) {
        // 需要还原现场，将保存的新黑子下标还原成白子
        while (!temp.isEmpty()) {
            var pos = temp.poll();
            arr[pos / 10][pos % 10] = 'O';
        }
    }

    // 如果该方向有效，返回所有新黑子的下标位置，否则是空数组
    return temp;
}

private boolean check(int x, int y) {
    // 检查下标是否有效
    return x >= 0 && x < n && y >= 0 && y < m;
}
```

**4. 对每一轮的新黑子进行连锁反应讨论**

既然是连锁反应，操作会很套娃，因此可以使用递归来帮助我们简化代码。

```java
private int process(char[][] arr, int x, int y) {
    // 存储每一颗 黑子 在八个方向上得到的 新黑子位置
    LinkedList<Integer> q = new LinkedList<>();
    
    for (int i = 0; i < 8; i++) {
        int new_x = x + dir_x[i];
        int new_y = y + dir_y[i];
        // addAll：存下第 i 个方向搜索到的所有新黑子下标位置
        q.addAll(search(arr, new_x, new_y, dir_x[i], dir_y[i]));
    }


    // q.size() 正是 当前黑子 能翻转的白子数量
    int res = q.size();
    while (!q.isEmpty()) {
        var pos = q.poll();
        // 递归调用，每一颗 新黑子 都可以当作 你所下的第一颗黑子
        res += process(arr, pos / 10, pos % 10);
    }

    return res;
}
```

---

## 总代码

```Java []
class Solution {
    final int[] dir_x = { 1, -1, 0, 0, 1, 1, -1, -1 };
    final int[] dir_y = { 0, 0, -1, 1, -1, 1, -1, 1 };
    int n, m;

    public int flipChess(String[] chessboard) {
        n = chessboard.length;
        m = chessboard[0].length();
        char[][] board = copyBoard(chessboard);

        int res = 0;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (board[i][j] == '.') {
                    char[][] copy = copyBoard(chessboard);
                    copy[i][j] = 'X';
                    int cnt = process(copy, i, j);
                    res = Math.max(res, cnt);
                }
            }
        }

        return res;
    }

    private char[][] copyBoard(String[] chessboard) {
        char[][] board = new char[n][m];
        int idx = 0;

        for (var line : chessboard) {
            board[idx++] = line.toCharArray();
        }

        return board;
    }

    private int process(char[][] arr, int x, int y) {
        LinkedList<Integer> q = new LinkedList<>();
        
        for (int i = 0; i < 8; i++) {
            int new_x = x + dir_x[i];
            int new_y = y + dir_y[i];
            q.addAll(search(arr, new_x, new_y, dir_x[i], dir_y[i]));
        }

        int res = q.size();
        while (!q.isEmpty()) {
            var pos = q.poll();
            res += process(arr, pos / 10, pos % 10);
        }

        return res;
    }

    private LinkedList<Integer> search(char[][] arr, int x, int y, int step_x, int step_y) {
        LinkedList<Integer> temp = new LinkedList<>();
        boolean flag = false;

        while (check(x, y)) {
            if (arr[x][y] != 'O') {
                flag = arr[x][y] == 'X';
                break;
            } else {
                temp.add(x * 10 + y);
                arr[x][y] = 'X';
            }
            x += step_x;
            y += step_y;
        }
        if (!flag) {
            while (!temp.isEmpty()) {
                var pos = temp.poll();
                arr[pos / 10][pos % 10] = 'O';
            }
        }

        return temp;
    }

    private boolean check(int x, int y) {
        return x >= 0 && x < n && y >= 0 && y < m;
    }
}
```
```C++ []
class Solution {
public:
    constexpr static int dir_x[] = { 1, -1, 0, 0, 1, 1, -1, -1 };
    constexpr static int dir_y[] = { 0, 0, -1, 1, -1, 1, -1, 1 };
    int n, m;

    int flipChess(vector<string>& chessboard) {
        n = chessboard.size();
        m = chessboard[0].size();
        
        int res = 0;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (chessboard[i][j] == '.') {
                    vector<string> copy{ chessboard.begin(), chessboard.end() };
                    copy[i][j] = 'X';
                    int cnt = process(copy, i, j);
                    res = std::max(res, cnt);
                }
            }
        }

        return res;
    }

    int process(vector<string>& board, int x, int y) {
        vector<int> q;

        for (int i = 0; i < 8; i++) {
            int new_x = x + dir_x[i];
            int new_y = y + dir_y[i];
            auto temp = search(board, new_x, new_y, dir_x[i], dir_y[i]);
            q.insert(q.end(), temp.begin(), temp.end());
        }

        int res = q.size();
        while (!q.empty()) {
            int pos = q.back();
            q.pop_back();
            res += process(board, pos / 10, pos % 10);
        }

        return res;
    }
    
    vector<int> search(vector<string>& board, int x, int y, int step_x, int step_y) {
        vector<int> temp;
        bool flag = false;

        while (check(x, y)) {
            if (board[x][y] != 'O') {
                flag = (board[x][y] == 'X');
                break;
            } else {
                temp.push_back(x * 10 + y);
                board[x][y] = 'X';
            }
            x += step_x;
            y += step_y;
        }
        if (!flag) {
            while (!temp.empty()) {
                int pos = temp.back();
                temp.pop_back();
                board[pos / 10][pos % 10] = 'O';
            }
        }

        return temp;
    }

    bool check(int x, int y) {
        return x >= 0 && x < n && y >= 0 & y < m;
    }
};
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    1384    |    3231    |   42.8%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
