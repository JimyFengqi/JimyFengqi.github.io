---
title: 剑指 Offer II 110-所有路径
categories:
  - 中等
tags:
  - 深度优先搜索
  - 广度优先搜索
  - 图
  - 回溯
abbrlink: 1967820422
date: 2021-12-03 21:30:46
---

> 原文链接: https://leetcode-cn.com/problems/bP4bmD




## 中文题目
<div><p>给定一个有&nbsp;<code>n</code>&nbsp;个节点的有向无环图，用二维数组&nbsp;<code>graph</code>&nbsp;表示，请找到所有从&nbsp;<code>0</code>&nbsp;到&nbsp;<code>n-1</code>&nbsp;的路径并输出（不要求按顺序）。</p>

<p><code>graph</code>&nbsp;的第 <code>i</code> 个数组中的单元都表示有向图中 <code>i</code>&nbsp;号节点所能到达的下一些结点（译者注：有向图是有方向的，即规定了 a&rarr;b 你就不能从 b&rarr;a ），若为空，就是没有下一个节点了。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<p><img alt="" src="https://assets.leetcode.com/uploads/2020/09/28/all_1.jpg" style="height: 242px; width: 242px;" /></p>

<pre>
<strong>输入：</strong>graph = [[1,2],[3],[3],[]]
<strong>输出：</strong>[[0,1,3],[0,2,3]]
<strong>解释：</strong>有两条路径 0 -&gt; 1 -&gt; 3 和 0 -&gt; 2 -&gt; 3
</pre>

<p><strong>示例 2：</strong></p>

<p><img alt="" src="https://assets.leetcode.com/uploads/2020/09/28/all_2.jpg" style="height: 301px; width: 423px;" /></p>

<pre>
<strong>输入：</strong>graph = [[4,3,1],[3,2,4],[3],[4],[]]
<strong>输出：</strong>[[0,4],[0,3,4],[0,1,3,4],[0,1,2,3,4],[0,1,4]]
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>graph = [[1],[]]
<strong>输出：</strong>[[0,1]]
</pre>

<p><strong>示例 4：</strong></p>

<pre>
<strong>输入：</strong>graph = [[1,2,3],[2],[3],[]]
<strong>输出：</strong>[[0,1,2,3],[0,2,3],[0,3]]
</pre>

<p><strong>示例 5：</strong></p>

<pre>
<strong>输入：</strong>graph = [[1,3],[2],[3],[]]
<strong>输出：</strong>[[0,1,2,3],[0,3]]
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>n == graph.length</code></li>
	<li><code>2 &lt;= n &lt;= 15</code></li>
	<li><code>0 &lt;= graph[i][j] &lt; n</code></li>
	<li><code>graph[i][j] != i</code>&nbsp;</li>
	<li>保证输入为有向无环图 <code>(GAD)</code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 797&nbsp;题相同：<a href="https://leetcode-cn.com/problems/all-paths-from-source-to-target/">https://leetcode-cn.com/problems/all-paths-from-source-to-target/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
#### 方法一：深度优先搜索

**思路和算法**

我们可以使用深度优先搜索的方式求出所有可能的路径。具体地，我们从 $0$ 号点出发，使用栈记录路径上的点。每次我们遍历到点 $n-1$，就将栈中记录的路径加入到答案中。

特别地，因为本题中的图为有向无环图（$\text{DAG}$），搜索过程中不会反复遍历同一个点，因此我们无需判断当前点是否遍历过。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> ans;
    vector<int> stk;

    void dfs(vector<vector<int>>& graph, int x, int n) {
        if (x == n) {
            ans.push_back(stk);
            return;
        }
        for (auto& y : graph[x]) {
            stk.push_back(y);
            dfs(graph, y, n);
            stk.pop_back();
        }
    }

    vector<vector<int>> allPathsSourceTarget(vector<vector<int>>& graph) {
        stk.push_back(0);
        dfs(graph, 0, graph.size() - 1);
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    List<List<Integer>> ans = new ArrayList<List<Integer>>();
    Deque<Integer> stack = new ArrayDeque<Integer>();

    public List<List<Integer>> allPathsSourceTarget(int[][] graph) {
        stack.offerLast(0);
        dfs(graph, 0, graph.length - 1);
        return ans;
    }

    public void dfs(int[][] graph, int x, int n) {
        if (x == n) {
            ans.add(new ArrayList<Integer>(stack));
            return;
        }
        for (int y : graph[x]) {
            stack.offerLast(y);
            dfs(graph, y, n);
            stack.pollLast();
        }
    }
}
```

```Python [sol1-Python3]
class Solution:
    def allPathsSourceTarget(self, graph: List[List[int]]) -> List[List[int]]:
        ans = list()
        stk = list()

        def dfs(x: int):
            if x == len(graph) - 1:
                ans.append(stk[:])
                return
            
            for y in graph[x]:
                stk.append(y)
                dfs(y)
                stk.pop()
        
        stk.append(0)
        dfs(0)
        return ans
```

```C [sol1-C]
int** ans;
int stk[15];
int stkSize;

void dfs(int x, int n, int** graph, int* graphColSize, int* returnSize, int** returnColumnSizes) {
    if (x == n) {
        int* tmp = malloc(sizeof(int) * stkSize);
        memcpy(tmp, stk, sizeof(int) * stkSize);
        ans[*returnSize] = tmp;
        (*returnColumnSizes)[(*returnSize)++] = stkSize;
        return;
    }
    for (int i = 0; i < graphColSize[x]; i++) {
        int y = graph[x][i];
        stk[stkSize++] = y;
        dfs(y, n, graph, graphColSize, returnSize, returnColumnSizes);
        stkSize--;
    }
}

int** allPathsSourceTarget(int** graph, int graphSize, int* graphColSize, int* returnSize, int** returnColumnSizes) {
    stkSize = 0;
    stk[stkSize++] = 0;
    ans = malloc(sizeof(int*) * 16384);
    *returnSize = 0;
    *returnColumnSizes = malloc(sizeof(int) * 16384);
    dfs(0, graphSize - 1, graph, graphColSize, returnSize, returnColumnSizes);
    return ans;
}
```

```go [sol1-Golang]
func allPathsSourceTarget(graph [][]int) (ans [][]int) {
    stk := []int{0}
    var dfs func(int)
    dfs = func(x int) {
        if x == len(graph)-1 {
            ans = append(ans, append([]int(nil), stk...))
            return
        }
        for _, y := range graph[x] {
            stk = append(stk, y)
            dfs(y)
            stk = stk[:len(stk)-1]
        }
    }
    dfs(0)
    return
}
```

```JavaScript [sol1-JavaScript]
var allPathsSourceTarget = function(graph) {
    const stack = [], ans = [];

    const dfs = (graph, x, n) => {
        if (x === n) {
            ans.push(stack.slice());
            return;
        }
        for (const y of graph[x]) {
            stack.push(y);
            dfs(graph, y, n);
            stack.pop();
        }
    }

    stack.push(0);
    dfs(graph, 0, graph.length - 1);
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n \times 2^n)$，其中 $n$ 为图中点的数量。我们可以找到一种最坏情况，即每一个点都可以去往编号比它大的点。此时路径数为 $O(2^n)$，且每条路径长度为 $O(n)$，因此总时间复杂度为 $O(n \times 2^n)$。

- 空间复杂度：$O(n)$，其中 $n$ 为点的数量。主要为栈空间的开销。注意返回值不计入空间复杂度。

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    2628    |    3161    |   83.1%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
