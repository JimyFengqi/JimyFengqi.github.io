---
title: 剑指 Offer II 036-后缀表达式
date: 2021-12-03 21:31:15
categories:
  - 中等
tags:
  - 栈
  - 数组
  - 数学
---

> 原文链接: https://leetcode-cn.com/problems/8Zf90G




## 中文题目
<div><p>根据<a href="https://baike.baidu.com/item/%E9%80%86%E6%B3%A2%E5%85%B0%E5%BC%8F/128437" target="_blank"> 逆波兰表示法</a>，求该后缀表达式的计算结果。</p>

<p>有效的算符包括&nbsp;<code>+</code>、<code>-</code>、<code>*</code>、<code>/</code>&nbsp;。每个运算对象可以是整数，也可以是另一个逆波兰表达式。</p>

<p>&nbsp;</p>

<p><strong>说明：</strong></p>

<ul>
	<li>整数除法只保留整数部分。</li>
	<li>给定逆波兰表达式总是有效的。换句话说，表达式总会得出有效数值且不存在除数为 0 的情况。</li>
</ul>

<p>&nbsp;</p>

<p><strong>示例&nbsp;1：</strong></p>

<pre>
<strong>输入：</strong>tokens = [&quot;2&quot;,&quot;1&quot;,&quot;+&quot;,&quot;3&quot;,&quot;*&quot;]
<strong>输出：</strong>9
<strong>解释：</strong>该算式转化为常见的中缀算术表达式为：((2 + 1) * 3) = 9
</pre>

<p><strong>示例&nbsp;2：</strong></p>

<pre>
<strong>输入：</strong>tokens = [&quot;4&quot;,&quot;13&quot;,&quot;5&quot;,&quot;/&quot;,&quot;+&quot;]
<strong>输出：</strong>6
<strong>解释：</strong>该算式转化为常见的中缀算术表达式为：(4 + (13 / 5)) = 6
</pre>

<p><strong>示例&nbsp;3：</strong></p>

<pre>
<strong>输入：</strong>tokens = [&quot;10&quot;,&quot;6&quot;,&quot;9&quot;,&quot;3&quot;,&quot;+&quot;,&quot;-11&quot;,&quot;*&quot;,&quot;/&quot;,&quot;*&quot;,&quot;17&quot;,&quot;+&quot;,&quot;5&quot;,&quot;+&quot;]
<strong>输出：</strong>22
<strong>解释：</strong>
该算式转化为常见的中缀算术表达式为：
  ((10 * (6 / ((9 + 3) * -11))) + 17) + 5
= ((10 * (6 / (12 * -11))) + 17) + 5
= ((10 * (6 / -132)) + 17) + 5
= ((10 * 0) + 17) + 5
= (0 + 17) + 5
= 17 + 5
= 22</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= tokens.length &lt;= 10<sup>4</sup></code></li>
	<li><code>tokens[i]</code> 要么是一个算符（<code>&quot;+&quot;</code>、<code>&quot;-&quot;</code>、<code>&quot;*&quot;</code> 或 <code>&quot;/&quot;</code>），要么是一个在范围 <code>[-200, 200]</code> 内的整数</li>
</ul>

<p>&nbsp;</p>

<p><strong>逆波兰表达式：</strong></p>

<p>逆波兰表达式是一种后缀表达式，所谓后缀就是指算符写在后面。</p>

<ul>
	<li>平常使用的算式则是一种中缀表达式，如 <code>( 1 + 2 ) * ( 3 + 4 )</code> 。</li>
	<li>该算式的逆波兰表达式写法为 <code>( ( 1 2 + ) ( 3 4 + ) * )</code> 。</li>
</ul>

<p>逆波兰表达式主要有以下两个优点：</p>

<ul>
	<li>去掉括号后表达式无歧义，上式即便写成 <code>1 2 + 3 4 + * </code>也可以依据次序计算出正确结果。</li>
	<li>适合用栈操作运算：遇到数字则入栈；遇到算符则取出栈顶两个数字进行计算，并将结果压入栈中。</li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 150&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/evaluate-reverse-polish-notation/">https://leetcode-cn.com/problems/evaluate-reverse-polish-notation/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
## 栈的介绍

栈(stack) 本身是一种简单、常用的数据结构，它常常用来和队列进行比较。

- 队列： 先入先出
- 栈：    后入先出

栈的所有操作都发生在栈顶，其实就三个操作，入栈(压栈)、出栈(弹栈)、获取栈顶元素。

## Python & Java 中的栈

Java中存在Stack的数据结构，但Python是没有栈的，它们的实现与操作方式如下：

| 操作         | Java                                 |    Python        | 说明       |
| ------------ | ------------------------------------- | --------------- | ---------- |
| 初始化       | Stack<Integer> stack = new Stack<>(); | stack = []      |            |
| 入栈         | stack.push(1);                        | stack.append(1) |            |
| 出栈         | stack.pop();                          | stack.pop()     | 为空时报错 |
| 获取栈顶元素 | stack.peek();                         | stack[-1]       | 为空时报错 |

栈的操作就是这几个，是不是很简单，要不直接下一章？**too young，too simple！**

栈的操作是简单的，但是栈在算法中的应用确实变化多端....有些题目打眼一看就是栈操作，比如 **括号匹配**。但更多的题目并不是能直接看出来通过栈去解决的。比如单调栈等类型的题目，真的是新手劝退神器....

但饭要一口一口吃，让我们先来看一道简单的括号匹配问题，熟悉下栈的操作吧。

## [剑指OfferII036.后缀表达式](https://leetcode-cn.com/problems/8Zf90G/solution/shua-chuan-jian-zhi-offer-day10-zi-fu-ch-c9f1/)
> https://leetcode-cn.com/problems/8Zf90G/solution/shua-chuan-jian-zhi-offer-day10-zi-fu-ch-c9f1/
> 
> 难度：中等
## 题目：

根据 逆波兰表示法，求表达式的值。
有效的算符包括+、-、*、/。每个运算对象可以是整数，也可以是另一个逆波兰表达式。

说明：
- 整数除法只保留整数部分。
- 给定逆波兰表达式总是有效的。换句话说，表达式总会得出有效数值且不存在除数为 0 的情况。

提示：
- 1 <= tokens.length <= 10 ^ 4
- tokens[i] 要么是一个算符（"+"、"-"、"*" 或 "/"），要么是一个在范围 [-200, 200] 内的整数

**逆波兰表达式：**

逆波兰表达式是一种后缀表达式，所谓后缀就是指算符写在后面。
- 平常使用的算式则是一种中缀表达式，如 ( 1 + 2 ) * ( 3 + 4 ) 。
- 该算式的逆波兰表达式写法为 ( ( 1 2 + ) ( 3 4 + ) * ) 。

逆波兰表达式主要有以下两个优点：
- 去掉括号后表达式无歧义，上式即便写成 1 2 + 3 4 + * 也可以依据次序计算出正确结果。
- 适合用栈操作运算：遇到数字则入栈；遇到算符则取出栈顶两个数字进行计算，并将结果压入栈中。

## 示例：
```
示例1：
输入：tokens = ["2","1","+","3","*"]
输出：9
解释：该算式转化为常见的中缀算术表达式为：((2 + 1) * 3) = 9

示例2：
输入：tokens = ["4","13","5","/","+"]
输出：6
解释：该算式转化为常见的中缀算术表达式为：(4 + (13 / 5)) = 6

示例3：
输入：tokens = ["10","6","9","3","+","-11","*","/","*","17","+","5","+"]
输出：22
```

解释：
该算式转化为常见的中缀算术表达式为：
```
  ((10 * (6 / ((9 + 3) * -11))) + 17) + 5
= ((10 * (6 / (12 * -11))) + 17) + 5
= ((10 * (6 / -132)) + 17) + 5
= ((10 * 0) + 17) + 5
= (0 + 17) + 5
= 17 + 5
= 22
```

## 分析
1. 根据题目所知，输入的逆波兰表达式都是有效的，所以无需考虑特殊的场景。
2. 既然是一道栈的题目，肯定要先创建一个stack，然后依次将元素入栈，但什么时候出栈呢？
3. 后缀表达式是指算符写在后面，即当我们遇到操作符时，需要将操作符紧邻的前两项拿出来进行计算
4. 在第3步计算完成后，还需要将结果重新加入栈中
5. 最终将计算结果返回即可



## 解题：
**Python:**
```python
class Solution:
    def evalRPN(self, tokens):
        stack = []
        calc = {'+': lambda x, y: x + y,
                '-': lambda x, y: x - y,
                '*': lambda x, y: x * y,
                '/': lambda x, y: int(x / y), }
        for i in tokens:
            if i in calc:
                num2, num1 = stack.pop(), stack.pop()
                stack.append(calc[i](num1, num2))
            else:
                stack.append(int(i))
        return stack[0]
```
**Java:**
```java
class Solution {
    public int evalRPN(String[] tokens) {
        Stack<Integer> stack = new Stack<>();
        for (String c : tokens) {
            switch (c) {
                case "+":
                case "-":
                case "*":
                case "/":
                    int num2 = stack.pop();
                    int num1 = stack.pop();
                    stack.push(calc(num1, num2, c));
                    break;
                default:
                    stack.push(Integer.parseInt(c));
            }
        }
        return stack.pop();
    }

    private int calc(int a, int b, String op) {
        switch (op) {
            case "+":
                return a + b;
            case "-":
                return a - b;
            case "*":
                return a * b;
            default:
                return a / b;
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
|    4383    |    7750    |   56.6%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
