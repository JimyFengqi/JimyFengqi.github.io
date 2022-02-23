---
title: 剑指 Offer II 037-小行星碰撞
categories:
  - 中等
tags:
  - 栈
  - 数组
abbrlink: 720793338
date: 2021-12-03 21:31:13
---

> 原文链接: https://leetcode-cn.com/problems/XagZNi




## 中文题目
<div><p>给定一个整数数组 <code>asteroids</code>，表示在同一行的小行星。</p>

<p>对于数组中的每一个元素，其绝对值表示小行星的大小，正负表示小行星的移动方向（正表示向右移动，负表示向左移动）。每一颗小行星以相同的速度移动。</p>

<p>找出碰撞后剩下的所有小行星。碰撞规则：两个行星相互碰撞，较小的行星会爆炸。如果两颗行星大小相同，则两颗行星都会爆炸。两颗移动方向相同的行星，永远不会发生碰撞。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>asteroids = [5,10,-5]
<strong>输出：</strong>[5,10]
<b>解释：</b>10 和 -5 碰撞后只剩下 10 。 5 和 10 永远不会发生碰撞。</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>asteroids = [8,-8]
<strong>输出：</strong>[]
<b>解释：</b>8 和 -8 碰撞后，两者都发生爆炸。</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>asteroids = [10,2,-5]
<strong>输出：</strong>[10]
<b>解释：</b>2 和 -5 发生碰撞后剩下 -5 。10 和 -5 发生碰撞后剩下 10 。</pre>

<p><strong>示例 4：</strong></p>

<pre>
<strong>输入：</strong>asteroids = [-2,-1,1,2]
<strong>输出：</strong>[-2,-1,1,2]
<b>解释</b><strong>：</strong>-2 和 -1 向左移动，而 1 和 2 向右移动。 由于移动方向相同的行星不会发生碰撞，所以最终没有行星发生碰撞。 </pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>2 &lt;= asteroids.length&nbsp;&lt;= 10<sup>4</sup></code></li>
	<li><code>-1000 &lt;= asteroids[i] &lt;= 1000</code></li>
	<li><code>asteroids[i] != 0</code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 735&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/asteroid-collision/">https://leetcode-cn.com/problems/asteroid-collision/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# [剑指OfferII037.小行星碰撞](https://leetcode-cn.com/problems/XagZNi/solution/shua-chuan-jian-zhi-offer-day17-zhan-i-0-5yho/)
> https://leetcode-cn.com/problems/XagZNi/solution/shua-chuan-jian-zhi-offer-day17-zhan-i-0-5yho/
> 
> 难度：中等

## 题目
给定一个整数数组 asteroids，表示在同一行的小行星。
对于数组中的每一个元素，其绝对值表示小行星的大小，正负表示小行星的移动方向（正表示向右移动，负表示向左移动）。每一颗小行星以相同的速度移动。
找出碰撞后剩下的所有小行星。碰撞规则：两个行星相互碰撞，较小的行星会爆炸。如果两颗行星大小相同，则两颗行星都会爆炸。两颗移动方向相同的行星，永远不会发生碰撞。

提示：
- 2 <= asteroids.length <= 10 ^ 4
- -1000 <= asteroids[i] <= 1000
- asteroids[i] != 0


## 示例

```
示例 1：
输入：asteroids = [5,10,-5]
输出：[5,10]
解释：10 和 -5 碰撞后只剩下 10 。 5 和 10 永远不会发生碰撞。

示例 2：
输入：asteroids = [8,-8]
输出：[]
解释：8 和 -8 碰撞后，两者都发生爆炸。

示例 3：
输入：asteroids = [10,2,-5]
输出：[10]
解释：2 和 -5 发生碰撞后剩下 -5 。10 和 -5 发生碰撞后剩下 10 。

示例 4：
输入：asteroids = [-2,-1,1,2]
输出：[-2,-1,1,2]
解释：-2 和 -1 向左移动，而 1 和 2 向右移动。 
     由于移动方向相同的行星不会发生碰撞，所以最终没有行星发生碰撞。 
```

## 分析
这道栈的题目难点应该主要是在分析场景上了。
我们需要明确什么时候无脑入栈，什么时候需要判断，理解这两点就可以轻松解题了。
首先，循环每一个元素时，在什么情况下无脑入栈呢？
1. 栈为空
2. 栈顶元素为负数(下一个为负数则一起向左，下一个为正数则分向两边)
3. 当前元素为正数（栈顶为正一起向右，栈顶为负分向两边）

下来，我们需要看碰撞的场景又细分为什么情况：
1. 栈顶元素大于abs(当前元素)，当前元素被撞毁
2. 栈顶元素等于abs(当前元素)，栈顶弹出和当前元素抵消
3. 栈顶元素小于abs(当前元素)，栈顶弹出，并与新栈顶完成上述判断

最终返回栈即可。

## 解题

```python []
class Solution:
    def asteroidCollision(self, asteroids):
        s, p = [], 0
        while p < len(asteroids):
            if not s or s[-1] < 0 or asteroids[p] > 0:
                s.append(asteroids[p])
            elif s[-1] <= -asteroids[p]:
                if s.pop() < -asteroids[p]:
                    continue
            p += 1
        return s
```

```java []
class Solution {
    public int[] asteroidCollision(int[] asteroids) {
        Stack<Integer> s = new Stack<>();
        int p = 0;
        while (p < asteroids.length) {
            if (s.empty() || s.peek() < 0 || asteroids[p] > 0) {
                s.push(asteroids[p]);
            } else if (s.peek() <= -asteroids[p]) {
                if (s.pop() < -asteroids[p]) {
                    continue;
                }
            }
            p++;
        }
        int[] ret = new int[s.size()];
        for (int i = ret.length - 1; i >= 0; i--) {
            ret[i] = s.pop();
        }
        return ret;
    }
}
```

欢迎关注我的公众号: **清风Python**，带你每日学习Python算法刷题的同时，了解更多python小知识。

有喜欢力扣刷题的小伙伴可以加我微信（King_Uranus）互相鼓励，共同进步，一起玩转超级码力！

我的个人博客：[https://qingfengpython.cn](https://qingfengpython.cn)

力扣解题合集：[https://github.com/BreezePython/AlgorithmMarkdown](https://github.com/BreezePython/AlgorithmMarkdown)

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    4777    |    10826    |   44.1%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
