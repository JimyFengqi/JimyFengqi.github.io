---
title: 剑指 Offer 59 - II-队列的最大值(队列的最大值 LCOF)
categories:
  - 中等
tags:
  - 设计
  - 队列
  - 单调队列
abbrlink: 718037873
date: 2021-12-03 21:36:41
---

> 原文链接: https://leetcode-cn.com/problems/dui-lie-de-zui-da-zhi-lcof




## 中文题目
<div><p>请定义一个队列并实现函数 <code>max_value</code> 得到队列里的最大值，要求函数<code>max_value</code>、<code>push_back</code> 和 <code>pop_front</code> 的<strong>均摊</strong>时间复杂度都是O(1)。</p>

<p>若队列为空，<code>pop_front</code> 和 <code>max_value</code>&nbsp;需要返回 -1</p>

<p><strong>示例 1：</strong></p>

<pre><strong>输入:</strong> 
[&quot;MaxQueue&quot;,&quot;push_back&quot;,&quot;push_back&quot;,&quot;max_value&quot;,&quot;pop_front&quot;,&quot;max_value&quot;]
[[],[1],[2],[],[],[]]
<strong>输出:&nbsp;</strong>[null,null,null,2,1,2]
</pre>

<p><strong>示例 2：</strong></p>

<pre><strong>输入:</strong> 
[&quot;MaxQueue&quot;,&quot;pop_front&quot;,&quot;max_value&quot;]
[[],[],[]]
<strong>输出:&nbsp;</strong>[null,-1,-1]
</pre>

<p>&nbsp;</p>

<p><strong>限制：</strong></p>

<ul>
	<li><code>1 &lt;= push_back,pop_front,max_value的总操作数&nbsp;&lt;= 10000</code></li>
	<li><code>1 &lt;= value &lt;= 10^5</code></li>
</ul>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
### 题目理解

>*应用程序接口（Application Programming Interface，API）* 是一些预先定义的函数，或指软件系统不同组成部分衔接的约定。

调用 API 函数就像雇佣一位维修工，我们不需要了解维修工是如何修好灯泡的🌚，我们只关心最终灯泡能不能亮🌝。

本题中 `max_value`、`push_back`、`pop_front` 就是一些 API 函数，我们需要来设计这些函数以供他人直接调用，并且调用每个函数时，时间复杂度均为 $\mathcal{O}(1)$。

### 如何思考

我们知道对于一个普通队列，`push_back` 和 `pop_front` 的时间复杂度都是 $\mathcal{O}(1)$，因此我们直接使用队列的相关操作就可以实现这两个函数。

对于 `max_value` 函数，我们通常会这样思考，即每次入队操作时都更新最大值：

![59.gif](../images/dui-lie-de-zui-da-zhi-lcof-0.gif)

但是当出队时，这个方法会造成信息丢失，**即当最大值出队后，我们无法知道队列里的下一个最大值。**

![fig2.gif](../images/dui-lie-de-zui-da-zhi-lcof-1.gif)






### 解题思路

为了解决上述问题，我们只需记住当前最大值出队后，队列里的下一个最大值即可。

具体方法是使用一个双端队列 $deque$，在每次入队时，如果 $deque$ 队尾元素小于即将入队的元素 $value$，则将小于 $value$ 的元素全部出队后，再将 $value$ 入队；否则直接入队。

![fig3.gif](../images/dui-lie-de-zui-da-zhi-lcof-2.gif)

这时，辅助队列 $deque$ 队首元素就是队列的最大值。

### 代码
事实上，用数组完全可以实现上述操作，操作思路相同，只是数据结构不同。
```python []
import queue
class MaxQueue:
    """1队列+1双端队列"""
    def __init__(self):
        self.queue = queue.Queue()
        self.deque = queue.deque()

    def max_value(self) -> int:
        if self.deque:
            return self.deque[0]
        else:
            return -1
        # return self.deque[0] if self.deque else -1 或者这样写

    def push_back(self, value: int) -> None:
        while self.deque and self.deque[-1] < value:
            self.deque.pop()
        self.deque.append(value)
        self.queue.put(value)
        

    def pop_front(self) -> int:
        if not self.deque: return -1
        ans = self.queue.get()
        if ans == self.deque[0]:
            self.deque.popleft()
        return ans
```
```python []
import queue
class MaxQueue:
    """1队列+1数组"""
    def __init__(self):
        self.queue = queue.Queue()
        self.stack = []

    def max_value(self) -> int:
        return self.stack[0] if self.stack else -1

    def push_back(self, value: int) -> None:
        self.queue.put(value)
        while self.stack and self.stack[-1] < value:
            self.stack.pop()
        self.stack.append(value)

    def pop_front(self) -> int:
        if not self.stack: return -1 # 如果判断 queue 是否为空，会超时
        ans = self.queue.get()
        if ans == self.stack[0]:
            self.stack.pop(0)
        return ans
```
```python []
class MaxQueue:
    """2个数组"""
    def __init__(self):
        self.queue = []
        self.max_stack = []

    def max_value(self) -> int:
        return self.max_stack[0] if self.max_stack else -1

    def push_back(self, value: int) -> None:
        self.queue.append(value)
        while self.max_stack and self.max_stack[-1] < value:
            self.max_stack.pop()
        self.max_stack.append(value)

    def pop_front(self) -> int:
        if not self.queue: return -1
        ans = self.queue.pop(0)
        if ans == self.max_stack[0]:
            self.max_stack.pop(0)
        return ans
```
### 时间复杂度

1. `max_value`：$\mathcal{O}(1)$，直接返回双端队列（或数组）头部的元素。

2. `pop_front`：$\mathcal{O}(1)$，从队列中弹出一个元素，仍然是常数时间复杂度。

3. `push_back`：$\mathcal{O}(1)$，例如 `543216`，只有最后一次 `push_back` 操作是 $\mathcal{O}(n)$，其他每次操作的时间复杂度都是 $\mathcal{O}(1)$，均摊时间复杂度为 $(\mathcal{O}(1)\times (n-1)+\mathcal{O}(n))/n=\mathcal{O}(1)$。

### 小结

使用 $\mathcal{O}(1)$ 时间复杂度来获得队列或栈的最大值或者最小值，*往往需要使用一个辅助的数据结构实现*，具体选用何种数据结构需要在做题过程中总结规律。

相关题目（实现 $\mathcal{O}(1)$ 复杂度）：

- [面试题 03.02. 栈的最小值](https://leetcode-cn.com/problems/min-stack-lcci/)（难度：⭐⭐）（使用辅助栈）

- [146. LRU缓存机制](https://leetcode-cn.com/problems/lru-cache/) （难度：⭐⭐⭐⭐）（使用有序字典）

- [716. 最大栈](https://leetcode-cn.com/problems/max-stack/)（难度：⭐⭐⭐）（使用辅助栈）

欢迎提供 C++ 代码
如有问题欢迎讨论~

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    100600    |    211684    |   47.5%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
