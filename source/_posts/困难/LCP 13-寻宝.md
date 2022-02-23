---
title: LCP 13-寻宝
categories:
  - 困难
tags:
  - 位运算
  - 广度优先搜索
  - 数组
  - 动态规划
  - 状态压缩
  - 矩阵
abbrlink: 2879466061
date: 2021-12-03 21:33:40
---

> 原文链接: https://leetcode-cn.com/problems/xun-bao


## 英文原文
<div></div>

## 中文题目
<div><p>我们得到了一副藏宝图，藏宝图显示，在一个迷宫中存在着未被世人发现的宝藏。</p>

<p>迷宫是一个二维矩阵，用一个字符串数组表示。它标识了唯一的入口（用 &#39;S&#39; 表示），和唯一的宝藏地点（用 &#39;T&#39; 表示）。但是，宝藏被一些隐蔽的机关保护了起来。在地图上有若干个机关点（用 &#39;M&#39; 表示），<strong>只有所有机关均被触发，才可以拿到宝藏。</strong></p>

<p>要保持机关的触发，需要把一个重石放在上面。迷宫中有若干个石堆（用 &#39;O&#39; 表示），每个石堆都有<strong>无限</strong>个足够触发机关的重石。但是由于石头太重，我们一次只能搬<strong>一个</strong>石头到指定地点。</p>

<p>迷宫中同样有一些墙壁（用 &#39;#&#39; 表示），我们不能走入墙壁。剩余的都是可随意通行的点（用 &#39;.&#39; 表示）。石堆、机关、起点和终点（无论是否能拿到宝藏）也是可以通行的。</p>

<p>我们每步可以选择向上/向下/向左/向右移动一格，并且不能移出迷宫。搬起石头和放下石头不算步数。那么，从起点开始，我们最少需要多少步才能最后拿到宝藏呢？如果无法拿到宝藏，返回 -1 。</p>

<p><strong>示例 1：</strong></p>

<blockquote>
<p>输入： [&quot;S#O&quot;, &quot;M..&quot;, &quot;M.T&quot;]</p>

<p>输出：16</p>

<p>解释：最优路线为： S-&gt;O, cost = 4, 去搬石头 O-&gt;第二行的M, cost = 3, M机关触发 第二行的M-&gt;O, cost = 3, 我们需要继续回去 O 搬石头。 O-&gt;第三行的M, cost = 4, 此时所有机关均触发 第三行的M-&gt;T, cost = 2，去T点拿宝藏。 总步数为16。 <img alt="图片.gif" src="https://pic.leetcode-cn.com/6bfff669ad65d494cdc237bcedfec10a2b1ac2f2593c2bf97e9aecb41dc8a08b-%E5%9B%BE%E7%89%87.gif" /></p>
</blockquote>

<p><strong>示例 2：</strong></p>

<blockquote>
<p>输入： [&quot;S#O&quot;, &quot;M.#&quot;, &quot;M.T&quot;]</p>

<p>输出：-1</p>

<p>解释：我们无法搬到石头触发机关</p>
</blockquote>

<p><strong>示例 3：</strong></p>

<blockquote>
<p>输入： [&quot;S#O&quot;, &quot;M.T&quot;, &quot;M..&quot;]</p>

<p>输出：17</p>

<p>解释：注意终点也是可以通行的。</p>
</blockquote>

<p><strong>限制：</strong></p>

<ul>
	<li><code>1 &lt;= maze.length&nbsp;&lt;= 100</code></li>
	<li><code>1 &lt;= maze[i].length&nbsp;&lt;= 100</code></li>
	<li><code>maze[i].length == maze[j].length</code></li>
	<li>S 和 T 有且只有一个</li>
	<li>0 &lt;= M的数量 &lt;= 16</li>
	<li>0 &lt;= O的数量 &lt;= 40，题目保证当迷宫中存在 M 时，一定存在至少一个 O 。</li>
</ul>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
#### 方法一：状态压缩动态规划

**题意概述**

一个人在迷宫中，要从起点 $S$ 走到终点 $T$。迷宫有两类特殊点，分别是：

+ $M$：机关点，需要用石头触发
+ $O$：石头点，一次可以搬一块石头

只有当所有 $M$ 点均被触发以后，终点才可到达，问起点走到终点的最小代价。

**思路与算法**
虽然迷宫有很多格子，但是我们实际上的走法只有几种：

+ 从 $S$ 走到 $O$，我们不会从 $S$ 直接走到 $M$，因为触发机关要先搬石头
+ 从 $O$ 走到 $M$
+ 从 $M$ 走到 $O$
+ 从 $M$ 走到 $T$

有一点性质很重要，**不论我们触发机关还是搬运石头，都不会改变迷宫的连通状态。因此，两个点的最短距离一旦计算出，就不会再改变了。** 于是第一步，我们可以做一步预处理——我们计算所有特殊点（包括 $M$，$O$，$S$，$T$）互相之间的最短距离，即对这里面的每个点做一次 BFS。这样我们就不需要考虑其他点了。为什么要预处理出这些特殊点两两之间的距离，这个问题会在在下文中解释。

解决这个问题的关键是理解我们要以什么样的策略来取石头和触发机关：

+ 在最开始，我们一定会从 $S$，经过某一个 $O$，到达某一个 $M$。那么对于特定的 $M$ 来说，我们枚举 $O$ 就可以计算 $S-O-M$ 的最短距离。那么如果我们要从起点 $S$ 到达 $M$，一定会选择这条距离最短的路。这样，我们首先得到了 $S$ 到每一个 $M$ 的最短距离。

![fig1](https://assets.leetcode-cn.com/solution-static/LCP_13/1.png){:width="70%"}

+ 假定我们已经从起点到达了某个 $M$ 了，接下来需要去其他的 $O$ 点搬石头接着触发其他的机关，这是一个 $M-O-M'$ 的路线。同样的道理，对于给定的 $M'$，中间的 $O$ 也是固定的。即给定 $M$ 和 $M'$，我们可以确定一个 $O$，使得 $M-O-M'$ 距离最短。我们同样可以记录下这个最短距离，即得到了 所有 $M$ 到 $M'$ 的最短距离。

![fig2](https://assets.leetcode-cn.com/solution-static/LCP_13/2.png){:width="86%"}

+ 最后，所有 $M$ 到 $T$ 的距离在前面已经计算出了。

我们需要所有的 $M$ 都被触发，$M$ 的触发顺序不同会导致行走的路径长度不同。假设这里一共有 $n$ 个 $M$，我们用 $d(i, j)$ 表示第 $i$ 个 $M$ 到第 $j$ 个 $M$ 经过某一个 $O$ 的最短距离。因为这里的 $n$ 不大于 $16$，我们可以使用一个 $16$ 位的二进制数表示状态，这个二进制数的第 $i$ 位为 $1$ 表示第 $i$ 个 $M$ 已经触发，为 $0$ 表示第 $i$ 个 $M$ 还未被触发，记这个二进制数为 $\rm mask$。记 $M_i$ 为第 $i$ 个 $M$（下标从 $1$ 开始），每一个 $\rm mask$ 都可以表示成两个集合，一个已触发集合、一个未触发集合，例如 $n = 16$，$mask = 0000~1100~0001~0001$ 的已触发集合就可以表示为 $T = \{ M_1, M_5, M_{11}, M_{12} \}$，剩下的元素都在未触发集合 $U - T$ 中。

我们定义 $f({\rm mask}, i)$ 表示当前在第 $i$ 个 $M$ 处，触发状态为 ${\rm mask}$ 的最小步数，如果当前 ${\rm mask}$ 代表的已触发集合为 $T$，未触发集合为 $U - T$，则我们可以推出这样的动态规划转移方程：

$$ f({\rm mask}, i) = \min_{j \in T, j \neq i } \{ f({\rm mask}~{\rm xor}~2^i, j) + d(j, i)\} $$

其中 ${\rm mask}~{\rm xor}~2^i$ 表示把 $M_i$ 已触发的集合当中去掉，即 ${\rm mask}$ 这个状态可以由 ${\rm mask}~{\rm xor}~2^i$ 状态转移得到，转移时我们除了关注触发状态 $\rm mask$ 的变化，我们还关注是从哪一个 $M$ 转移到了 $M_i$，我们可以枚举 $\rm mask$ 当中已触发的所有的 $M_j(j \neq i)$ 作为上一个位置，而 $d(j, i)$ 就是我们从 $j$ 转移到 $i$ 行走的最短步数，我们可以在预处理之后按照我们的策略得到所有的 $d(j, i)$（如果 $i, j$ 不可达可以设为正无穷），然后 $O(1)$ 查询，这就是预处理的目的。

实际上，在实现的时候，如果我们用记忆化搜索的方式实现，那么我们用到的是上面的转移方程；如果我们使用循环实现的话，也可以使用下面的转移方程，写法类似递推：

$$ f({\rm mask} | 2^j, j) = \min \{ f({\rm mask}, i) + d(i, j) \} $$

大家可以结合代码来理解。当然，写代码的时候需要注意的是：

+ 由于本题的复杂度较高，使用 Python 等性能较差的语言实现时需要注意效率问题。
+ 本题边界情况较多，比如迷宫没有 $M$、$M$ 不可达等。

**题型小结**

这道题是一个非常经典的状态压缩动态规划模型：有 $n$ 个任务 $\{M_1, M_2 \cdots M_n \}$，每两个任务之间有一个 $c(M_i, M_j)$ 表示在 $M_i$ 之后（下一个）做 $M_j$ 的花费，让你求解把 $n$ 个任务都做完需要的最小花费。通常这个 $n$ 会非常的小，因为需要构造 $2^n$ 种状态，$c(M_i, M_j)$ 可能是题目给出，也可能是可以在很短的时间内计算出来的一个值。这类问题的状态设计一般都是 $f({\rm mask}, i)$ 表示当前任务完成的状态是 $\rm mask$，当前位置是 $i$，考虑转移的时候我们只需要考虑当前任务的上一个任务即可。**希望读者可以理解这里的思想，并尝试使用记忆化搜索和循环两种方式实现。**

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int dx[4] = {1, -1, 0, 0};
    int dy[4] = {0, 0, 1, -1};
    int n, m;

    bool inBound(int x, int y) {
        return x >= 0 && x < n && y >= 0 && y < m;
    }

    vector<vector<int>> bfs(int x, int y, vector<string>& maze) {
        vector<vector<int>> ret(n, vector<int>(m, -1));
        ret[x][y] = 0;
        queue<pair<int, int>> Q;
        Q.push({x, y});
        while (!Q.empty()) {
            auto p = Q.front();
            Q.pop();
            int x = p.first, y = p.second;
            for (int k = 0; k < 4; k++) {
                int nx = x + dx[k], ny = y + dy[k];
                if (inBound(nx, ny) && maze[nx][ny] != '#' && ret[nx][ny] == -1) {
                    ret[nx][ny] = ret[x][y] + 1;
                    Q.push({nx, ny});
                }
            }
        }
        return ret;
    }

    int minimalSteps(vector<string>& maze) {
        n = maze.size(), m = maze[0].size();
        // 机关 & 石头
        vector<pair<int, int>> buttons, stones;
        // 起点 & 终点
        int sx, sy, tx, ty;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (maze[i][j] == 'M') {
                    buttons.push_back({i, j});
                }
                if (maze[i][j] == 'O') {
                    stones.push_back({i, j});
                }
                if (maze[i][j] == 'S') {
                    sx = i, sy = j;
                }
                if (maze[i][j] == 'T') {
                    tx = i, ty = j;
                }
            }
        }
        int nb = buttons.size();
        int ns = stones.size();
        vector<vector<int>> start_dist = bfs(sx, sy, maze);

        // 边界情况：没有机关
        if (nb == 0) {
            return start_dist[tx][ty];
        }
        // 从某个机关到其他机关 / 起点与终点的最短距离。
        vector<vector<int>> dist(nb, vector<int>(nb + 2, -1));
        // 中间结果
        vector<vector<vector<int>>> dd(nb);
        for (int i = 0; i < nb; i++) {
            vector<vector<int>> d = bfs(buttons[i].first, buttons[i].second, maze);
            dd[i] = d;
            // 从某个点到终点不需要拿石头
            dist[i][nb + 1] = d[tx][ty];
        }

        for (int i = 0; i < nb; i++) {
            int tmp = -1;
            for (int k = 0; k < ns; k++) {
                int mid_x = stones[k].first, mid_y = stones[k].second;
                if (dd[i][mid_x][mid_y] != -1 && start_dist[mid_x][mid_y] != -1) {
                    if (tmp == -1 || tmp > dd[i][mid_x][mid_y] + start_dist[mid_x][mid_y]) {
                        tmp = dd[i][mid_x][mid_y] + start_dist[mid_x][mid_y];
                    }
                }
            }
            dist[i][nb] = tmp;
            for (int j = i + 1; j < nb; j++) {
                int mn = -1;
                for (int k = 0; k < ns; k++) {
                    int mid_x = stones[k].first, mid_y = stones[k].second;
                    if (dd[i][mid_x][mid_y] != -1 && dd[j][mid_x][mid_y] != -1) {
                        if (mn == -1 || mn > dd[i][mid_x][mid_y] + dd[j][mid_x][mid_y]) {
                            mn = dd[i][mid_x][mid_y] + dd[j][mid_x][mid_y];
                        }
                    }
                }
                dist[i][j] = mn;
                dist[j][i] = mn;
            }
        }

        // 无法达成的情形
        for (int i = 0; i < nb; i++) {
            if (dist[i][nb] == -1 || dist[i][nb + 1] == -1) return -1;
        }
        
        // dp 数组， -1 代表没有遍历到
        vector<vector<int>> dp(1 << nb, vector<int>(nb, -1));
        for (int i = 0; i < nb; i++) {
            dp[1 << i][i] = dist[i][nb];
        }
        
        // 由于更新的状态都比未更新的大，所以直接从小到大遍历即可
        for (int mask = 1; mask < (1 << nb); mask++) {
            for (int i = 0; i < nb; i++) {
                // 当前 dp 是合法的
                if (mask & (1 << i)) {
                    for (int j = 0; j < nb; j++) {
                        // j 不在 mask 里
                        if (!(mask & (1 << j))) {
                            int next = mask | (1 << j);
                            if (dp[next][j] == -1 || dp[next][j] > dp[mask][i] + dist[i][j]) {
                                dp[next][j] = dp[mask][i] + dist[i][j];
                            }
                        }
                    }
                }
            }
        }

        int ret = -1;
        int final_mask = (1 << nb) - 1;
        for (int i = 0; i < nb; i++) {
            if (ret == -1 || ret > dp[final_mask][i] + dist[i][nb + 1]) {
                ret = dp[final_mask][i] + dist[i][nb + 1];
            }
        }

        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    int[] dx = {1, -1, 0, 0};
    int[] dy = {0, 0, 1, -1};
    int n, m;

    public int minimalSteps(String[] maze) {
        n = maze.length;
        m = maze[0].length();
        // 机关 & 石头
        List<int[]> buttons = new ArrayList<int[]>();
        List<int[]> stones = new ArrayList<int[]>();
        // 起点 & 终点
        int sx = -1, sy = -1, tx = -1, ty = -1;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (maze[i].charAt(j) == 'M') {
                    buttons.add(new int[]{i, j});
                }
                if (maze[i].charAt(j) == 'O') {
                    stones.add(new int[]{i, j});
                }
                if (maze[i].charAt(j) == 'S') {
                    sx = i;
                    sy = j;
                }
                if (maze[i].charAt(j) == 'T') {
                    tx = i;
                    ty = j;
                }
            }
        }
        int nb = buttons.size();
        int ns = stones.size();
        int[][] startDist = bfs(sx, sy, maze);

        // 边界情况：没有机关
        if (nb == 0) {
            return startDist[tx][ty];
        }
        // 从某个机关到其他机关 / 起点与终点的最短距离。
        int[][] dist = new int[nb][nb + 2];
        for (int i = 0; i < nb; i++) {
            Arrays.fill(dist[i], -1);
        }
        // 中间结果
        int[][][] dd = new int[nb][][];
        for (int i = 0; i < nb; i++) {
            int[][] d = bfs(buttons.get(i)[0], buttons.get(i)[1], maze);
            dd[i] = d;
            // 从某个点到终点不需要拿石头
            dist[i][nb + 1] = d[tx][ty];
        }

        for (int i = 0; i < nb; i++) {
            int tmp = -1;
            for (int k = 0; k < ns; k++) {
                int midX = stones.get(k)[0], midY = stones.get(k)[1];
                if (dd[i][midX][midY] != -1 && startDist[midX][midY] != -1) {
                    if (tmp == -1 || tmp > dd[i][midX][midY] + startDist[midX][midY]) {
                        tmp = dd[i][midX][midY] + startDist[midX][midY];
                    }
                }
            }
            dist[i][nb] = tmp;
            for (int j = i + 1; j < nb; j++) {
                int mn = -1;
                for (int k = 0; k < ns; k++) {
                    int midX = stones.get(k)[0], midY = stones.get(k)[1];
                    if (dd[i][midX][midY] != -1 && dd[j][midX][midY] != -1) {
                        if (mn == -1 || mn > dd[i][midX][midY] + dd[j][midX][midY]) {
                            mn = dd[i][midX][midY] + dd[j][midX][midY];
                        }
                    }
                }
                dist[i][j] = mn;
                dist[j][i] = mn;
            }
        }

        // 无法达成的情形
        for (int i = 0; i < nb; i++) {
            if (dist[i][nb] == -1 || dist[i][nb + 1] == -1) {
                return -1;
            }
        }
        
        // dp 数组， -1 代表没有遍历到
        int[][] dp = new int[1 << nb][nb];
        for (int i = 0; i < 1 << nb; i++) {
            Arrays.fill(dp[i], -1);
        }
        for (int i = 0; i < nb; i++) {
            dp[1 << i][i] = dist[i][nb];
        }
        
        // 由于更新的状态都比未更新的大，所以直接从小到大遍历即可
        for (int mask = 1; mask < (1 << nb); mask++) {
            for (int i = 0; i < nb; i++) {
                // 当前 dp 是合法的
                if ((mask & (1 << i)) != 0) {
                    for (int j = 0; j < nb; j++) {
                        // j 不在 mask 里
                        if ((mask & (1 << j)) == 0) {
                            int next = mask | (1 << j);
                            if (dp[next][j] == -1 || dp[next][j] > dp[mask][i] + dist[i][j]) {
                                dp[next][j] = dp[mask][i] + dist[i][j];
                            }
                        }
                    }
                }
            }
        }

        int ret = -1;
        int finalMask = (1 << nb) - 1;
        for (int i = 0; i < nb; i++) {
            if (ret == -1 || ret > dp[finalMask][i] + dist[i][nb + 1]) {
                ret = dp[finalMask][i] + dist[i][nb + 1];
            }
        }

        return ret;
    }

    public int[][] bfs(int x, int y, String[] maze) {
        int[][] ret = new int[n][m];
        for (int i = 0; i < n; i++) {
            Arrays.fill(ret[i], -1);
        }
        ret[x][y] = 0;
        Queue<int[]> queue = new LinkedList<int[]>();
        queue.offer(new int[]{x, y});
        while (!queue.isEmpty()) {
            int[] p = queue.poll();
            int curx = p[0], cury = p[1];
            for (int k = 0; k < 4; k++) {
                int nx = curx + dx[k], ny = cury + dy[k];
                if (inBound(nx, ny) && maze[nx].charAt(ny) != '#' && ret[nx][ny] == -1) {
                    ret[nx][ny] = ret[curx][cury] + 1;
                    queue.offer(new int[]{nx, ny});
                }
            }
        }
        return ret;
    }

    public boolean inBound(int x, int y) {
        return x >= 0 && x < n && y >= 0 && y < m;
    }
}
```

```golang [sol1-Golang]
var (
    dx = []int{1, -1, 0, 0}
    dy = []int{0, 0, 1, -1}
    n, m int
)
func minimalSteps(maze []string) int {
    n, m = len(maze), len(maze[0])
    // 机关 & 石头
    var buttons, stones [][]int
    // 起点 & 终点
    sx, sy, tx, ty := -1, -1, -1, -1
    for i := 0; i < n; i++ {
        for j := 0; j < m; j++ {
            switch maze[i][j] {
            case 'M':
                buttons = append(buttons, []int{i, j})
            case 'O':
                stones = append(stones, []int{i, j})
            case 'S':
                sx, sy = i, j
            case 'T':
                tx, ty = i, j
            }
        }
    }

    nb, ns := len(buttons), len(stones)
    startDist := bfs(sx, sy, maze)
    // 边界情况：没有机关
    if nb == 0 {
        return startDist[tx][ty]
    }
    // 从某个机关到其他机关 / 起点与终点的最短距离。
    dist := make([][]int, nb)
    for i := 0; i < nb; i++ {
        dist[i] = make([]int, nb + 2)
        for j := 0; j < nb + 2; j++ {
            dist[i][j] = -1
        }
    }
    // 中间结果
    dd := make([][][]int, nb)
    for i := 0; i < nb; i++ {
        dd[i] = bfs(buttons[i][0], buttons[i][1], maze)
        // 从某个点到终点不需要拿石头
        dist[i][nb + 1] = dd[i][tx][ty]
    }
    for i := 0; i < nb; i++ {
        tmp := -1
        for k := 0; k < ns; k++ {
            midX, midY := stones[k][0], stones[k][1]
            if dd[i][midX][midY] != -1 && startDist[midX][midY] != -1 {
                if tmp == -1 || tmp > dd[i][midX][midY] + startDist[midX][midY] {
                    tmp = dd[i][midX][midY] + startDist[midX][midY]
                }
            }
        }
        dist[i][nb] = tmp
        for j := i + 1; j < nb; j++ {
            mn := -1
            for k := 0; k < ns; k++ {
                midX, midY := stones[k][0], stones[k][1]
                if dd[i][midX][midY] != -1 && startDist[midX][midY] != -1 {
                    if mn == -1 || mn > dd[i][midX][midY] + dd[j][midX][midY] {
                        mn = dd[i][midX][midY] + dd[j][midX][midY]
                    }
                }
            }
            dist[i][j] = mn
            dist[j][i] = mn
        }
    }
    // 无法达成的情形
    for i := 0; i < nb; i++ {
        if dist[i][nb] == -1 || dist[i][nb + 1] == -1 {
            return -1
        }
    }
    // dp 数组， -1 代表没有遍历到
    dp := make([][]int, 1 << nb)
    for i := 0; i < (1 << nb); i++ {
        dp[i] = make([]int, nb)
        for j := 0; j < nb; j++ {
            dp[i][j] = -1
        }
    }
    for i := 0; i < nb; i++ {
        dp[1 << i][i] = dist[i][nb]
    }

    // 由于更新的状态都比未更新的大，所以直接从小到大遍历即可
    for mask := 1; mask < (1 << nb); mask++ {
        for i := 0; i < nb; i++ {
            // 当前 dp 是合法的
            if mask & (1 << i) != 0 {
                for j := 0; j < nb; j++ {
                    // j 不在 mask 里
                    if mask & (1 << j) == 0 {
                        next := mask | (1 << j)
                        if dp[next][j] == -1 || dp[next][j] > dp[mask][i] + dist[i][j] {
                            dp[next][j] = dp[mask][i] + dist[i][j]
                        }
                    }
                }
            }
        }
    }
    ret := -1
    finalMask := (1 << nb) - 1
    for i := 0; i < nb; i++ {
        if ret == -1 || ret > dp[finalMask][i] + dist[i][nb + 1] {
            ret = dp[finalMask][i] + dist[i][nb + 1]
        }
    }
    return ret
}

func bfs(x, y int, maze []string) [][]int {
    ret := make([][]int, n)
    for i := 0; i < n; i++ {
        ret[i] = make([]int, m)
        for j := 0; j < m; j++ {
            ret[i][j] = -1
        }
    }
    ret[x][y] = 0
    queue := [][]int{}
    queue = append(queue, []int{x, y})
    for len(queue) > 0 {
        p := queue[0]
        queue = queue[1:]
        curx, cury := p[0], p[1]
        for k := 0; k < 4; k++ {
            nx, ny := curx + dx[k], cury + dy[k]
            if inBound(nx, ny) && maze[nx][ny] != '#' && ret[nx][ny] == -1 {
                ret[nx][ny] = ret[curx][cury] + 1
                queue = append(queue, []int{nx, ny})
            }
        }
    }
    return ret
}

func inBound(x, y int) bool {
    return x >= 0 && x < n && y >= 0 && y < m
}
```

```C [sol1-C]
const int dx[4] = {1, -1, 0, 0};
const int dy[4] = {0, 0, 1, -1};
int n, m;

bool inBound(int x, int y) { return x >= 0 && x < n && y >= 0 && y < m; }

int** bfs(int x, int y, char** maze) {
    int** ret = (int**)malloc(sizeof(int*) * n);
    for (int i = 0; i < n; i++) {
        ret[i] = (int*)malloc(sizeof(int) * m);
        memset(ret[i], -1, sizeof(int) * m);
    }
    ret[x][y] = 0;
    int quex[n * m], quey[n * m];
    quex[0] = x, quey[0] = y;
    int left = 0, right = 0;
    while (left <= right) {
        for (int k = 0; k < 4; k++) {
            int nx = quex[left] + dx[k], ny = quey[left] + dy[k];
            if (inBound(nx, ny) && maze[nx][ny] != '#' && ret[nx][ny] == -1) {
                ret[nx][ny] = ret[quex[left]][quey[left]] + 1;
                quex[++right] = nx, quey[right] = ny;
            }
        }
        left++;
    }
    return ret;
}

typedef struct point {
    int x, y;
} point;

int minimalSteps(char** maze, int mazeSize) {
    n = mazeSize, m = strlen(maze[0]);
    // 机关 & 石头
    point* buttons = (point*)malloc(0);
    point* stones = (point*)malloc(0);
    int nb = 0, ns = 0;
    // 起点 & 终点
    int sx, sy, tx, ty;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            if (maze[i][j] == 'M') {
                buttons = (point*)realloc(buttons, sizeof(point) * (++nb));
                buttons[nb - 1] = (point){i, j};
            }
            if (maze[i][j] == 'O') {
                stones = (point*)realloc(stones, sizeof(point) * (++ns));
                stones[ns - 1] = (point){i, j};
            }
            if (maze[i][j] == 'S') {
                sx = i, sy = j;
            }
            if (maze[i][j] == 'T') {
                tx = i, ty = j;
            }
        }
    }
    int** start_dist = bfs(sx, sy, maze);

    // 边界情况：没有机关
    if (nb == 0) {
        return start_dist[tx][ty];
    }
    // 从某个机关到其他机关 / 起点与终点的最短距离。
    int** dist = (int**)malloc(sizeof(int*) * nb);
    for (int i = 0; i < nb; i++) {
        dist[i] = (int*)malloc(sizeof(int) * (nb + 2));
        memset(dist[i], -1, sizeof(int) * (nb + 2));
    }
    // 中间结果
    int*** dd = (int***)malloc(sizeof(int**) * nb);
    for (int i = 0; i < nb; i++) {
        int** d = bfs(buttons[i].x, buttons[i].y, maze);
        dd[i] = d;
        // 从某个点到终点不需要拿石头
        dist[i][nb + 1] = d[tx][ty];
    }

    for (int i = 0; i < nb; i++) {
        int tmp = -1;
        for (int k = 0; k < ns; k++) {
            int mid_x = stones[k].x, mid_y = stones[k].y;
            if (dd[i][mid_x][mid_y] != -1 && start_dist[mid_x][mid_y] != -1) {
                if (tmp == -1 || tmp > dd[i][mid_x][mid_y] + start_dist[mid_x][mid_y]) {
                    tmp = dd[i][mid_x][mid_y] + start_dist[mid_x][mid_y];
                }
            }
        }
        dist[i][nb] = tmp;
        for (int j = i + 1; j < nb; j++) {
            int mn = -1;
            for (int k = 0; k < ns; k++) {
                int mid_x = stones[k].x, mid_y = stones[k].y;
                if (dd[i][mid_x][mid_y] != -1 && dd[j][mid_x][mid_y] != -1) {
                    if (mn == -1 || mn > dd[i][mid_x][mid_y] + dd[j][mid_x][mid_y]) {
                        mn = dd[i][mid_x][mid_y] + dd[j][mid_x][mid_y];
                    }
                }
            }
            dist[i][j] = mn;
            dist[j][i] = mn;
        }
    }
    // 无法达成的情形
    for (int i = 0; i < nb; i++) {
        if (dist[i][nb] == -1 || dist[i][nb + 1] == -1) return -1;
    }

    // dp 数组， -1 代表没有遍历到
    int** dp = (int**)malloc(sizeof(int*) * (1 << nb));
    for (int i = 0; i < (1 << nb); i++) {
        dp[i] = (int*)malloc(sizeof(int) * nb);
        memset(dp[i], -1, sizeof(int) * nb);
    }
    for (int i = 0; i < nb; i++) {
        dp[1 << i][i] = dist[i][nb];
    }

    // 由于更新的状态都比未更新的大，所以直接从小到大遍历即可
    for (int mask = 1; mask < (1 << nb); mask++) {
        for (int i = 0; i < nb; i++) {
            // 当前 dp 是合法的
            if (mask & (1 << i)) {
                for (int j = 0; j < nb; j++) {
                    // j 不在 mask 里
                    if (!(mask & (1 << j))) {
                        int next = mask | (1 << j);
                        if (dp[next][j] == -1 || dp[next][j] > dp[mask][i] + dist[i][j]) {
                            dp[next][j] = dp[mask][i] + dist[i][j];
                        }
                    }
                }
            }
        }
    }
    int ret = -1;
    int final_mask = (1 << nb) - 1;
    for (int i = 0; i < nb; i++) {
        if (ret == -1 || ret > dp[final_mask][i] + dist[i][nb + 1]) {
            ret = dp[final_mask][i] + dist[i][nb + 1];
        }
    }

    return ret;
}
```

**复杂度分析**

假设迷宫的面积为 $s$，$M$ 的数量为 $m$，$O$ 的数量为 $o$。

- 时间复杂度：$O(ms + m^2o + 2^m m^2)$。单次 BFS 的时间代价为 $O(s)$，$m$ 次 BFS 的时间代价为 $O(ms)$；预处理任意两个 $M$ 经过 $O$ 的最短距离的时间代价是 $O(m^2o)$；动态规划的时间代价是 $O(2^m m^2)$。
- 空间复杂度：$O(s + bs + 2^m m)$。BFS 队列的空间代价是 $O(s)$；预处理 $M_i$ 到各个点的最短距离的空间代价是 $O(bs)$；动态规划数组的空间代价是 $O(2^m m)$。

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    9514    |    15544    |   61.2%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
