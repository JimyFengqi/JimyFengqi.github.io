---
title: 剑指 Offer II 107-矩阵中的距离
categories:
  - 中等
tags:
  - 广度优先搜索
  - 数组
  - 动态规划
  - 矩阵
abbrlink: 875590803
date: 2021-12-03 21:30:54
---

> 原文链接: https://leetcode-cn.com/problems/2bCMpM




## 中文题目
<div><p>给定一个由 <code>0</code> 和 <code>1</code> 组成的矩阵 <code>mat</code>&nbsp;，请输出一个大小相同的矩阵，其中每一个格子是 <code>mat</code> 中对应位置元素到最近的 <code>0</code> 的距离。</p>

<p>两个相邻元素间的距离为 <code>1</code> 。</p>

<p>&nbsp;</p>

<p><b>示例 1：</b></p>

<p><img alt="" src="https://pic.leetcode-cn.com/1626667201-NCWmuP-image.png" style="width: 150px; " /></p>

<pre>
<strong>输入：</strong>mat =<strong> </strong>[[0,0,0],[0,1,0],[0,0,0]]
<strong>输出：</strong>[[0,0,0],[0,1,0],[0,0,0]]
</pre>

<p><b>示例 2：</b></p>

<p><img alt="" src="https://pic.leetcode-cn.com/1626667205-xFxIeK-image.png" style="width: 150px; " /></p>

<pre>
<b>输入：</b>mat =<b> </b>[[0,0,0],[0,1,0],[1,1,1]]
<strong>输出：</strong>[[0,0,0],[0,1,0],[1,2,1]]
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>m == mat.length</code></li>
	<li><code>n == mat[i].length</code></li>
	<li><code>1 &lt;= m, n &lt;= 10<sup>4</sup></code></li>
	<li><code>1 &lt;= m * n &lt;= 10<sup>4</sup></code></li>
	<li><code>mat[i][j] is either 0 or 1.</code></li>
	<li><code>mat</code> 中至少有一个 <code>0&nbsp;</code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 542&nbsp;题相同：<a href="https://leetcode-cn.com/problems/01-matrix/">https://leetcode-cn.com/problems/01-matrix/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
思路和心得：

# （一）多源bfs波纹法

1.逆向思维，从0出发

2.多源bfs比单源的要快

3.可以step更新dist，也可以dist[y] = dist[x] + 1 更新dist[y]

```python3 []
class Solution:
    def updateMatrix(self, mat: List[List[int]]) -> List[List[int]]:
        Row = len(mat)
        Col = len(mat[0])
        visited = [[False for _ in range(Col)] for _ in range(Row)]
        dist = [[0 for _ in range(Col)] for _ in range(Row)]

        q = collections.deque()
        for r in range(Row):
            for c in range(Col):
                if mat[r][c] == 0:
                    visited[r][c] = True
                    q.append((r, c))
        step = 0
        while q:
            for _ in range(len(q)):
                r, c = q.popleft()
                for nr, nc in [(r-1, c), (r+1, c), (r, c-1), (r, c+1)]:
                    if 0 <= nr < Row and 0 <= nc < Col and visited[nr][nc] == False:
                        dist[nr][nc] = step + 1
                        visited[nr][nc] = True
                        q.append((nr, nc))
            step += 1
        return dist
```

```c++ []
class Solution 
{
public:
    const int dirs [4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
    vector<vector<int>> updateMatrix(vector<vector<int>>& mat) 
    {
        int Row = (int)mat.size();
        int Col = (int)mat[0].size();
        bool visited [Row][Col];
        memset(visited, 0, sizeof(visited));
        vector<vector<int>> dist(Row, vector<int>(Col, 0));

        queue<pair<int, int>> q;
        for (int r = 0; r < Row; r ++)
        {
            for (int c = 0; c < Col; c ++)
            {
                if (mat[r][c] == 0)
                {
                    q.push({r, c});
                    visited[r][c] = true;
                }
            }
        }

        int step = 0;
        while (!q.empty())
        {
            int cur_len = q.size();
            for (int _ = 0; _ < cur_len; _ ++)
            {
                auto [r, c] = q.front();    q.pop();
                for (int di = 0; di < 4; di ++)
                {
                    int dr = dirs[di][0],    dc = dirs[di][1];
                    int nr = r + dr,    nc = c + dc;
                    if (0 <= nr && nr < Row && 0 <= nc && nc < Col && visited[nr][nc] == false)
                    {
                        dist[nr][nc] = step + 1;
                        visited[nr][nc] = true;
                        q.push({nr, nc});
                    }
                }
            }
            step ++;
        }

        return dist;
    }
};
```

```java []
class Solution 
{
    int [][] dirs = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

    public int[][] updateMatrix(int[][] mat) 
    {
        int Row = mat.length;
        int Col = mat[0].length;    
        int [][] dist = new int [Row][Col];
        boolean [][] visited = new boolean [Row][Col];

        Queue<int []> q = new LinkedList<int []>();
        for (int r = 0; r < Row; r ++)
        {
            for (int c = 0; c < Col; c ++)
            {
                if (mat[r][c] == 0)
                {
                    visited[r][c] = true;
                    q.offer(new int [] {r, c});
                }
            }
        }

        int step = 0;
        while (!q.isEmpty())
        {
            int cur_len = q.size();
            for (int ee = 0; ee < cur_len; ee ++)
            {
                int []  tmp = q.poll();
                int r = tmp[0],    c = tmp[1];
                for (int di = 0; di < 4; di ++)
                {
                    int dr = dirs[di][0],    dc = dirs[di][1];
                    int nr = r + dr,    nc = c + dc;
                    if (0 <= nr && nr < Row && 0 <= nc && nc < Col && visited[nr][nc] == false)
                    {
                        dist[nr][nc] = step + 1;
                        visited[nr][nc] = true;
                        q.offer(new int [] {nr, nc});
                    }
                }
            }
            step ++;
        }

        return dist;
    }
}
```

# （二）4方向dp

```python3 []
class Solution:
    def updateMatrix(self, mat: List[List[int]]) -> List[List[int]]:
        INF = 10 ** 9
        Row = len(mat)
        Col = len(mat[0])

        dist = [[INF for _ in range(Col)] for _ in range(Row)]
        for r in range(Row):
            for c in range(Col):
                if mat[r][c] == 0:
                    dist[r][c] = 0
        
        #---- 只能左上
        for r in range(Row - 1, -1, -1):
            for c in range(Col - 1, -1, -1):
                dist[r][c] = min(dist[r][c], dist[r+1][c] + 1 if r+1<Row else INF)
                dist[r][c] = min(dist[r][c], dist[r][c+1] + 1 if c+1<Col else INF)

        #---- 只能左下
        for r in range(Row):
            for c in range(Col - 1, -1, -1):
                dist[r][c] = min(dist[r][c], dist[r-1][c] + 1 if 0<=r-1 else INF)
                dist[r][c] = min(dist[r][c], dist[r][c+1] + 1 if c+1<Col else INF)

        #---- 只能右上
        for r in range(Row - 1, -1, -1):
            for c in range(Col):
                dist[r][c] = min(dist[r][c], dist[r+1][c] + 1 if r+1<Row else INF)
                dist[r][c] = min(dist[r][c], dist[r][c-1] + 1 if 0<=c-1 else INF)

        #---- 只能右下
        for r in range(Row):
            for c in range(Col):
                dist[r][c] = min(dist[r][c], dist[r-1][c] + 1 if 0<=r-1 else INF)
                dist[r][c] = min(dist[r][c], dist[r][c-1] + 1 if 0<=c-1 else INF)

        return dist
```

```c++ []
class Solution 
{
public:
    const int dirs [4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
    vector<vector<int>> updateMatrix(vector<vector<int>>& mat) 
    {
        int INF = (int)1e9;
        int Row = (int)mat.size();
        int Col = (int)mat[0].size();

        vector<vector<int>> dist(Row, vector<int>(Col, INF));

        for (int r = 0; r < Row; r ++)
            for (int c = 0; c < Col; c ++)
                if (mat[r][c] == 0)
                    dist[r][c] = 0;
        
        //----只能左上
        for (int r = Row - 1; r > -1; r --)
        {
            for (int c = Col - 1; c > -1; c --)
            {
                dist[r][c] = min(dist[r][c], r+1<Row ? dist[r+1][c] + 1 : INF);
                dist[r][c] = min(dist[r][c], c+1<Col ? dist[r][c+1] + 1 : INF);
            }
        }

        //----只能左下
        for (int r = 0; r < Row; r ++)
        {
            for (int c = Col - 1; c > -1; c --)
            {
                dist[r][c] = min(dist[r][c], 0<=r-1 ? dist[r-1][c] + 1 : INF);
                dist[r][c] = min(dist[r][c], c+1<Col ? dist[r][c+1] + 1 : INF);
            }
        }

        //----只能右上
        for (int r = Row - 1; r > -1; r --)
        {
            for (int c = 0; c < Col; c ++)
            {
                dist[r][c] = min(dist[r][c], r+1<Row ? dist[r+1][c] + 1 : INF);
                dist[r][c] = min(dist[r][c], 0<=c-1 ? dist[r][c-1] + 1 : INF);
            }
        }

        //----只能右下
        for (int r = 0; r < Row; r ++)
        {
            for (int c = 0; c < Col; c ++)
            {
                dist[r][c] = min(dist[r][c], 0<=r-1 ? dist[r-1][c] + 1 : INF);
                dist[r][c] = min(dist[r][c], 0<=c-1 ? dist[r][c-1] + 1 : INF);
            }
        }

        return dist;
    }
};
```

```java []
class Solution 
{
    public int[][] updateMatrix(int[][] mat) 
    {
        int INF = (int)1e9;
        int Row = mat.length;
        int Col = mat[0].length;

        int [][] dist = new int [Row][Col];
        for (int r = 0; r < Row; r ++)
            Arrays.fill(dist[r], INF);

        for (int r = 0; r < Row; r ++)
            for (int c = 0; c < Col; c ++)
                if (mat[r][c] == 0)
                    dist[r][c] = 0;
        
        //----只能左上
        for (int r = Row - 1; r > - 1; r --)
        {
            for (int c = Col - 1; c > -1; c --)
            {
                dist[r][c] = Math.min(dist[r][c], r+1<Row ? dist[r+1][c] + 1 : INF);
                dist[r][c] = Math.min(dist[r][c], c+1<Col ? dist[r][c+1] + 1 : INF);
            }
        }
        //----只能左下  
        for (int r = 0; r < Row; r ++)
        {
            for (int c = Col - 1; c > -1; c --)
            {
                dist[r][c] = Math.min(dist[r][c], 0<=r-1 ? dist[r-1][c] + 1 : INF);
                dist[r][c] = Math.min(dist[r][c], c+1<Col ? dist[r][c+1] + 1 : INF);
            }
        }
        //----只能右上
        for (int r = Row - 1; r > -1; r --)
        {
            for (int c = 0; c < Col; c ++)
            {
                dist[r][c] = Math.min(dist[r][c], r+1<Row ? dist[r+1][c] + 1 : INF);
                dist[r][c] = Math.min(dist[r][c], 0<=c-1 ? dist[r][c-1] + 1 : INF);
            }
        }
        //----只能右下
        for (int r = 0; r < Row; r ++)
        {
            for (int c = 0; c < Col; c ++)
            {
                dist[r][c] = Math.min(dist[r][c], 0<=r-1 ? dist[r-1][c] + 1 : INF);
                dist[r][c] = Math.min(dist[r][c], 0<=c-1 ? dist[r][c-1] + 1 : INF);
            }
        }

        return dist;
    }
}
```

# （三）对角线dp

1.这个思路很强。没想到。
之前看过证明，很强。

```python3 []
class Solution:
    def updateMatrix(self, mat: List[List[int]]) -> List[List[int]]:
        INF = 10 ** 9
        Row = len(mat)
        Col = len(mat[0])

        dist = [[INF for _ in range(Col)] for _ in range(Row)]
        for r in range(Row):
            for c in range(Col):
                if mat[r][c] == 0:
                    dist[r][c] = 0
        
        #---- 只能左上
        for r in range(Row - 1, -1, -1):
            for c in range(Col - 1, -1, -1):
                dist[r][c] = min(dist[r][c], dist[r+1][c] + 1 if r+1<Row else INF)
                dist[r][c] = min(dist[r][c], dist[r][c+1] + 1 if c+1<Col else INF)

        #---- 只能右下
        for r in range(Row):
            for c in range(Col):
                dist[r][c] = min(dist[r][c], dist[r-1][c] + 1 if 0<=r-1 else INF)
                dist[r][c] = min(dist[r][c], dist[r][c-1] + 1 if 0<=c-1 else INF)

        return dist
```

```c++ []
class Solution 
{
public:
    const int dirs [4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
    vector<vector<int>> updateMatrix(vector<vector<int>>& mat) 
    {
        int INF = (int)1e9;
        int Row = (int)mat.size();
        int Col = (int)mat[0].size();

        vector<vector<int>> dist(Row, vector<int>(Col, INF));

        for (int r = 0; r < Row; r ++)
            for (int c = 0; c < Col; c ++)
                if (mat[r][c] == 0)
                    dist[r][c] = 0;
        
        //----只能左上
        for (int r = Row - 1; r > -1; r --)
        {
            for (int c = Col - 1; c > -1; c --)
            {
                dist[r][c] = min(dist[r][c], r+1<Row ? dist[r+1][c] + 1 : INF);
                dist[r][c] = min(dist[r][c], c+1<Col ? dist[r][c+1] + 1 : INF);
            }
        }

        //----只能右下
        for (int r = 0; r < Row; r ++)
        {
            for (int c = 0; c < Col; c ++)
            {
                dist[r][c] = min(dist[r][c], 0<=r-1 ? dist[r-1][c] + 1 : INF);
                dist[r][c] = min(dist[r][c], 0<=c-1 ? dist[r][c-1] + 1 : INF);
            }
        }

        return dist;
    }
};
```

```java []
class Solution 
{
    public int[][] updateMatrix(int[][] mat) 
    {
        int INF = (int)1e9;
        int Row = mat.length;
        int Col = mat[0].length;

        int [][] dist = new int [Row][Col];
        for (int r = 0; r < Row; r ++)
            Arrays.fill(dist[r], INF);

        for (int r = 0; r < Row; r ++)
            for (int c = 0; c < Col; c ++)
                if (mat[r][c] == 0)
                    dist[r][c] = 0;
        
        //----只能左上
        for (int r = Row - 1; r > - 1; r --)
        {
            for (int c = Col - 1; c > -1; c --)
            {
                dist[r][c] = Math.min(dist[r][c], r+1<Row ? dist[r+1][c] + 1 : INF);
                dist[r][c] = Math.min(dist[r][c], c+1<Col ? dist[r][c+1] + 1 : INF);
            }
        }
        
        //----只能右下
        for (int r = 0; r < Row; r ++)
        {
            for (int c = 0; c < Col; c ++)
            {
                dist[r][c] = Math.min(dist[r][c], 0<=r-1 ? dist[r-1][c] + 1 : INF);
                dist[r][c] = Math.min(dist[r][c], 0<=c-1 ? dist[r][c-1] + 1 : INF);
            }
        }

        return dist;
    }
}
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    1791    |    3272    |   54.7%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
