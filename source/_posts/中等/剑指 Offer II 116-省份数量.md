---
title: 剑指 Offer II 116-省份数量
date: 2021-12-03 21:28:08
categories:
  - 中等
tags:
  - 深度优先搜索
  - 广度优先搜索
  - 并查集
  - 图
---

> 原文链接: https://leetcode-cn.com/problems/bLyHh0




## 中文题目
<div><div class="original__bRMd">
<p>有 <code>n</code> 个城市，其中一些彼此相连，另一些没有相连。如果城市 <code>a</code> 与城市 <code>b</code> 直接相连，且城市 <code>b</code> 与城市 <code>c</code> 直接相连，那么城市 <code>a</code> 与城市 <code>c</code> 间接相连。</p>

<p><strong>省份</strong> 是一组直接或间接相连的城市，组内不含其他没有相连的城市。</p>

<p>给你一个 <code>n x n</code> 的矩阵 <code>isConnected</code> ，其中 <code>isConnected[i][j] = 1</code> 表示第 <code>i</code> 个城市和第 <code>j</code> 个城市直接相连，而 <code>isConnected[i][j] = 0</code> 表示二者不直接相连。</p>

<p>返回矩阵中 <strong>省份</strong> 的数量。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>
<img alt="" src="https://assets.leetcode.com/uploads/2020/12/24/graph1.jpg" />
<pre>
<strong>输入：</strong>isConnected = [[1,1,0],[1,1,0],[0,0,1]]
<strong>输出：</strong>2
</pre>

<p><strong>示例 2：</strong></p>
<img alt="" src="https://assets.leetcode.com/uploads/2020/12/24/graph2.jpg" />
<pre>
<strong>输入：</strong>isConnected = [[1,0,0],[0,1,0],[0,0,1]]
<strong>输出：</strong>3
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= n &lt;= 200</code></li>
	<li><code>n == isConnected.length</code></li>
	<li><code>n == isConnected[i].length</code></li>
	<li><code>isConnected[i][j]</code> 为 <code>1</code> 或 <code>0</code></li>
	<li><code>isConnected[i][i] == 1</code></li>
	<li><code>isConnected[i][j] == isConnected[j][i]</code></li>
</ul>
</div>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 547&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/number-of-provinces/">https://leetcode-cn.com/problems/number-of-provinces/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
思路和心得：

# （一）dfs

```python3 []
class Solution:
    def findCircleNum(self, isConnected: List[List[int]]) -> int:
        def dfs(x: int) -> None:
            # nonlocal visited
            for y in range(n):
                if visited[y] == False and isConnected[x][y] == 1:
                    visited[y] = True
                    dfs(y)
        
        n = len(isConnected)
        visited = [False for _ in range(n)]
        cnt = 0
        for x in range(n):
            if visited[x] == False:
                visited[x] = True
                dfs(x)
                cnt += 1
        return cnt 

```

```c++ []
class Solution 
{
public:
    vector<vector<int>> isConnected;
    int n;
    vector<bool> visited;
    int cnt;

    int findCircleNum(vector<vector<int>>& isConnected) 
    {
        this->isConnected = isConnected;
        this->n = (int)isConnected.size();
        this->visited.resize(n, false);

        for (int x = 0; x < n; x ++)
        {
            if (visited[x] == false)
            {
                visited[x] = true;
                dfs(x);
                cnt ++;
            }
        }
        return cnt;
    }

    void dfs(int x)
    {
        for (int y = 0; y < n; y ++)
        {
            if (isConnected[x][y] == 1 && visited[y] == false)
            {
                visited[y] = true;
                dfs(y);
            }
        }
    }
};
```

```java []
class Solution 
{
    int [][] isConnected;
    int n;
    boolean [] visited;
    int cnt = 0;

    public int findCircleNum(int[][] isConnected) 
    {
        this.isConnected = isConnected;
        this.n = isConnected.length;
        visited = new boolean[n];
        for (int x = 0; x < n; x ++)
        {
            if (visited[x] == false)
            {
                visited[x] = true;
                bfs(x);
                cnt ++;
            }
        }
        return cnt;
    }

    public void dfs(int x)
    {
        for (int y = 0; y < n; y ++)
        {
            if (isConnected[x][y] == 1 && visited[y] == false)
            {
                visited[y] = true;
                dfs(y);
            }
        }
    }
}
```

# （二）bfs


```python3 []
class Solution:
    def findCircleNum(self, isConnected: List[List[int]]) -> int:
        def bfs(sx: int) -> None:
            q = collections.deque()
            q.append(sx)
            while q:
                x = q.popleft()
                for y in range(n):
                    if visited[y] == False and isConnected[x][y] == 1:
                        visited[y] = True
                        q.append(y)
        
        n = len(isConnected)
        visited = [False for _ in range(n)]
        cnt = 0
        for x in range(n):
            if visited[x] == False:
                visited[x] = True
                bfs(x)
                cnt += 1
        return cnt
```

```c++ []
class Solution 
{
public:
    vector<vector<int>> isConnected;
    int n;
    vector<bool> visited;
    int cnt;

    int findCircleNum(vector<vector<int>>& isConnected) 
    {
        this->isConnected = isConnected;
        this->n = (int)isConnected.size();
        this->visited.resize(n, false);

        for (int x = 0; x < n; x ++)
        {
            if (visited[x] == false)
            {
                visited[x] = true;
                bfs(x);
                cnt ++;
            }
        }
        return cnt;
    }

    void bfs(int sx)
    {
        queue<int> q;
        q.push(sx);
        while(!q.empty())
        {
            int x = q.front();    q.pop();
            for (int y = 0; y < n; y ++)
            {
                if (isConnected[x][y] == 1 && visited[y] == false)
                {
                    visited[y] = true;
                    q.push(y);
                }
            }
        }

    }
};
```

```java []
class Solution 
{
    int [][] isConnected;
    int n;
    boolean [] visited;
    int cnt = 0;

    public int findCircleNum(int[][] isConnected) 
    {
        this.isConnected = isConnected;
        this.n = isConnected.length;
        visited = new boolean[n];
        for (int x = 0; x < n; x ++)
        {
            if (visited[x] == false)
            {
                visited[x] = true;
                bfs(x);
                cnt ++;
            }
        }
        return cnt;
    }

    public void bfs(int sx)
    {
        Queue<Integer> q = new LinkedList<>();
        q.offer(sx);
        while (!q.isEmpty())
        {
            int x = q.poll();
            for (int y = 0; y < n; y ++)
            {
                if (isConnected[x][y] == 1 && visited[y] == false)
                {
                    visited[y] = true;
                    q.offer(y);
                }
            }
        }
    }
}
```

# （三）并查集

```python3 []
class UnionFind:
    def __init__(self, n: int):
        self.parent = [x for x in range(n)]
        self.size = [1 for x in range(n)]
        self.part = n

    def Find(self, x: int) -> int:
        if self.parent[x] != x:
            self.parent[x] = self.Find(self.parent[x])
        return self.parent[x]
    
    def Union(self, x: int, y: int) -> bool:
        root_x = self.Find(x)
        root_y = self.Find(y)
        if root_x == root_y:
            return False
        if self.size[root_x] > self.size[root_y]:
            root_x, root_y = root_y, root_x
        self.parent[root_x] = root_y
        self.size[root_y] += self.size[root_x]
        self.part -= 1
        return True

    def connected(self, x: int, y: int) -> bool:
        return self.Find(x) == self.Find(y)
        

class Solution:
    def findCircleNum(self, isConnected: List[List[int]]) -> int:
        n = len(isConnected)
        UF = UnionFind(n)
        for x in range(n):
            for y in range(n):
                if isConnected[x][y] == 1:
                    UF.Union(x, y)
        return UF.part
```

```c++ []
class UnionFind
{
public:
    vector<int> parent;
    vector<int> size;
    int part;

    UnionFind(int n)
    {
        parent.resize(n);
        for (int x = 0; x < n; x ++)
            parent[x] = x;
        size.resize(n, 1);
        part = n;
    }

    int Find(int x)
    {
        if (parent[x] != x)
            parent[x] = Find(parent[x]);
        return parent[x];
    }

    bool Union(int x, int y)
    {
        int root_x = Find(x);
        int root_y = Find(y);
        if (root_x == root_y)
            return false;
        if (size[root_x] > root_y)
            swap(root_x, root_y);
        parent[root_x] = root_y;
        size[root_y] += size[root_x];
        part --;
        return true;
    }

    bool connected(int x, int y)
    {
        return Find(x) == Find(y);
    }

};

class Solution 
{
public:
    int findCircleNum(vector<vector<int>>& isConnected) 
    {
        int n = isConnected.size();
        UnionFind UF = UnionFind(n);
        for (int x = 0; x < n; x ++)
        {
            for (int y = 0; y < n; y ++)
            {
                if (isConnected[x][y] == 1)
                {
                    UF.Union(x, y);
                }
            }
        }

        return UF.part;
    }
};
```

```java []
class UnionFind
{
    public int [] parent;
    public int [] size;
    public int part;

    UnionFind(int n)
    {
        parent = new int [n];
        for (int x = 0; x < n; x ++)
            parent[x] = x;
        size = new int [n];
        for (int x = 0; x < n; x ++)
            size[x] = 1;
        part = n;
    }

    public int Find(int x)
    {
        if (parent[x] != x)
            parent[x] = Find(parent[x]);
        return parent[x];
    }

    public boolean Union(int x, int y)
    {
        int root_x = Find(x);
        int root_y = Find(y);
        if (root_x == root_y)
            return false;
        if (size[root_x] > size[root_y])
        {
            int tmp = root_x;
            root_x = root_y;
            root_y = tmp;
        }
        parent[root_x] = root_y;
        size[root_y] += size[root_x];
        part --;
        return true;
    }

    public boolean connected(int x, int y)
    {
        return Find(x) == Find(y);
    }

}


class Solution 
{
    public int findCircleNum(int[][] isConnected) 
    {
        int n = isConnected.length;
        UnionFind UF = new UnionFind(n);
        for (int x = 0; x < n; x ++)
        {
            for (int y = 0; y < n; y ++)
            {
                if (isConnected[x][y] == 1)
                {
                    UF.Union(x, y);
                }
            }
        }

        return UF.part;
    }
}
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    4780    |    7375    |   64.8%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
