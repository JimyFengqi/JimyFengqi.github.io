---
title: LCP 10-二叉树任务调度
categories:
  - 困难
tags:
  - 树
  - 深度优先搜索
  - 动态规划
  - 二叉树
abbrlink: 3750216040
date: 2021-12-03 21:33:50
---

> 原文链接: https://leetcode-cn.com/problems/er-cha-shu-ren-wu-diao-du


## 英文原文
<div></div>

## 中文题目
<div><p>任务调度优化是计算机性能优化的关键任务之一。在任务众多时，不同的调度策略可能会得到不同的总体执行时间，因此寻求一个最优的调度方案是非常有必要的。</p>

<p>通常任务之间是存在依赖关系的，即对于某个任务，你需要先<strong>完成</strong>他的前导任务（如果非空），才能开始执行该任务。<strong>我们保证任务的依赖关系是一棵二叉树，</strong>其中 <code>root</code> 为根任务，<code>root.left</code> 和 <code>root.right</code> 为他的两个前导任务（可能为空），<code>root.val</code> 为其自身的执行时间。</p>

<p>在一个 CPU 核执行某个任务时，我们可以在任何时刻暂停当前任务的执行，并保留当前执行进度。在下次继续执行该任务时，会从之前停留的进度开始继续执行。暂停的时间可以不是整数。</p>

<p>现在，系统有<strong>两个</strong> CPU 核，即我们可以同时执行两个任务，但是同一个任务不能同时在两个核上执行。给定这颗任务树，请求出所有任务执行完毕的最小时间。</p>

<p><strong>示例 1：</strong></p>

<blockquote>
<p><img alt="image.png" src="https://pic.leetcode-cn.com/3522fbf8ce4ebb20b79019124eb9870109fdfe97fe9da99f6c20c07ceb1c60b3-image.png" /></p>

<p>输入：root = [47, 74, 31]</p>

<p>输出：121</p>

<p>解释：根节点的左右节点可以并行执行31分钟，剩下的43+47分钟只能串行执行，因此总体执行时间是121分钟。</p>
</blockquote>

<p><strong>示例 2：</strong></p>

<blockquote>
<p><img alt="image.png" src="https://pic.leetcode-cn.com/13accf172ee4a660d241e25901595d55b759380b090890a17e6e7bd51a143e3f-image.png" /></p>

<p>输入：root = [15, 21, null, 24, null, 27, 26]</p>

<p>输出：87</p>
</blockquote>

<p><strong>示例 3：</strong></p>

<blockquote>
<p><img alt="image.png" src="https://pic.leetcode-cn.com/bef743a12591aafb9047dd95d335b8083dfa66e8fdedc63f50fd406b4a9d163a-image.png" /></p>

<p>输入：root = [1,3,2,null,null,4,4]</p>

<p>输出：7.5</p>
</blockquote>

<p><strong>限制：</strong></p>

<ul>
	<li><code>1 &lt;= 节点数量 &lt;= 1000</code></li>
	<li><code>1 &lt;= 单节点执行时间 &lt;= 1000</code></li>
</ul>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
我们设 $f(i)$ 为节点 $i$ 的最短时间，然后分类讨论。

如果 $i$ 是一个叶子，那么显然 $f(i) = val(i)$。如果 $i$ 只有一个儿子，那么先要执行完儿子才轮得到自己，$f(i) = f(son(i)) + val(i)$。

如果 $i$ 有两个儿子 $l, r$，那么我们就可以考虑用双核来优化。一种最简单的优化策略是：两个子树分别使用双核跑完，然后再根节点跑。这样的时间消耗是 $f(l)+f(r) + val(i)$。

还有一种策略是：在左边花费 $x$ 时间使用双核（这里是**有效使用，即两个核都必须用上**，后同），在右边花费 $y$ 时间使用双核，然后在左右两棵子树一边一个核。可以看出，第三个样例使用的正是这样的策略，在根节点的右子树先花费了 3.5 的时间，然后左右两边一边一个核花费 3 时间。

那么，这种情况下，设左右子树的任务总时间和分别为 $sum(l), sum(r)$。则通过利用双核，左子树剩下的任务时间变成了 $sum(l) - 2x$，右子树剩下的任务时间变成了 $sum(r) - 2y$，然后一边一个核处理完剩下的任务所需时间为这两者的较大者。因而总时间为
$$
val(i) + x+y+\max\left\lbrace sum(l) - 2x , sum(r) - 2y \right\rbrace
$$
即
$$
val(i) + \max\left\lbrace sum(l) +y-x , sum(r) -(y-x)\right\rbrace
$$

$val(i)$ 的时间消耗是逃不掉的，我们考虑后面这个 $\max$ 怎样取得尽量小。设 $t=y-x$，那么后面这个 $\max$ 要取到最小当且仅当 $t^* = mid = \frac{sum(r) - sum(l)}{2}$。并且如果 $t$ 偏离 $mid$ 越远，那么这个 $\max$ 就越大。注意到 $x \in [0, sum(l) - f(l)], y \in [0, sum(r) - f(r)]$，就有 $t\in [f(l) -  sum(l), sum(r) - f(r)]$。通过对 $mid$ 和这个区间位置的讨论，我们就能算出这个 $\max$ 的最小值。

最后把以上这些情况统合起来，就有下面的转移方程：
$$
f(i) = val(i) + \min\left\lbrace f(l)+ f(r), \min_{t\in [f(l) -  sum(l), sum(r) - f(r)]}\max\left\lbrace sum(l) +t , sum(r) -t\right\rbrace \right\rbrace
$$
其中规定如果 $l$ 或者 $r$ 为空，对应的 $sum, f$ 均为 $0$。

时间复杂度 $O(n)$。

```python
class Solution:
    def minimalExecTime(self, root: TreeNode) -> float:
        def dfs(cur):
            if cur == None:
                return 0, 0
            fl, sml = dfs(cur.left)
            fr, smr = dfs(cur.right)
            f, sm = cur.val + fl + fr, cur.val + sml + smr
            gl, gr = sml - fl, smr - fr
            mid = (cur.right.sm - cur.left.sm) / 2
            t = -gl if mid < -gl else (gr if mid > gr else mid)
            f = min(f, cur.val + max(sml + t, smr - t))
            return f, sm

        ans, _ = dfs(root)
        return ans
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    1901    |    3194    |   59.5%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
