---
title: 69-Sqrt(x)
date: 2021-12-03 22:59:57
categories:
  - 简单
tags:
  - 数学
  - 二分查找
---

> 原文链接: https://leetcode-cn.com/problems/sqrtx


## 英文原文
<div><p>Given a non-negative integer <code>x</code>,&nbsp;compute and return <em>the square root of</em> <code>x</code>.</p>

<p>Since the return type&nbsp;is an integer, the decimal digits are <strong>truncated</strong>, and only <strong>the integer part</strong> of the result&nbsp;is returned.</p>

<p><strong>Note:&nbsp;</strong>You are not allowed to use any built-in exponent function or operator, such as <code>pow(x, 0.5)</code> or&nbsp;<code>x ** 0.5</code>.</p>

<p>&nbsp;</p>
<p><strong>Example 1:</strong></p>

<pre>
<strong>Input:</strong> x = 4
<strong>Output:</strong> 2
</pre>

<p><strong>Example 2:</strong></p>

<pre>
<strong>Input:</strong> x = 8
<strong>Output:</strong> 2
<strong>Explanation:</strong> The square root of 8 is 2.82842..., and since the decimal part is truncated, 2 is returned.</pre>

<p>&nbsp;</p>
<p><strong>Constraints:</strong></p>

<ul>
	<li><code>0 &lt;= x &lt;= 2<sup>31</sup> - 1</code></li>
</ul>
</div>

## 中文题目
<div><p>给你一个非负整数 <code>x</code> ，计算并返回&nbsp;<code>x</code>&nbsp;的 <strong>算术平方根</strong> 。</p>

<p>由于返回类型是整数，结果只保留 <strong>整数部分 </strong>，小数部分将被 <strong>舍去 。</strong></p>

<p><strong>注意：</strong>不允许使用任何内置指数函数和算符，例如 <code>pow(x, 0.5)</code> 或者 <code>x ** 0.5</code> 。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>x = 4
<strong>输出：</strong>2
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>x = 8
<strong>输出：</strong>2
<strong>解释：</strong>8 的算术平方根是 2.82842..., 由于返回类型是整数，小数部分将被舍去。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>0 &lt;= x &lt;= 2<sup>31</sup> - 1</code></li>
</ul>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
**摘要**：本题解于 2021 年 4 月 3 日重写，精简了「二分查找」部分的描述，删去了「牛顿法」，关于「牛顿法」请见 「[官方题解](https://leetcode-cn.com/problems/sqrtx/solution/x-de-ping-fang-gen-by-leetcode-solution/)」。

### 方法：二分查找

+ 本题是二分查找算法的典型应用场景：**查找一个有确定范围的整数**，可以根据 **单调性** 逐渐缩小搜索范围；
+ **单调性**：注意到题目中给出的「例 2」，8 的平方根返回 2，不可以返回 3。因此：如果一个数 $a$ 的平方大于 $x$ ，那么 $a$ 一定不是 $x$ 的平方根，下一轮需要在区间 $[0..a - 1]$ 里继续查找 $x$ 的平方根。



**参考代码**：

```Java []
public class Solution {

    public int mySqrt(int x) {
        // 特殊值判断
        if (x == 0) {
            return 0;
        }
        if (x == 1) {
            return 1;
        }

        int left = 1;
        int right = x / 2;
        // 在区间 [left..right] 查找目标元素
        while (left < right) {
            int mid = left + (right - left + 1) / 2;
            // 注意：这里为了避免乘法溢出，改用除法
            if (mid > x / mid) {
                // 下一轮搜索区间是 [left..mid - 1]
                right = mid - 1;
            } else {
                // 下一轮搜索区间是 [mid..right]
                left = mid;
            }
        }
        return left;
    }
}
```

**代码解释**：

+ 直觉上一个数的平方根一定不会超过它的一半，但是有特殊情况，因此解方程 $\left(\cfrac{x}{2}\right)^2 \le x$，得 $x\le4$。注意到：当 $x = 3$ 时，返回 $1 = 3 / 2$，当 $x = 4$ 时，返回 $2 = 4 / 2$。因此只需要对 $x = 0$ 和 $x = 1$ 作单独判断。其它情况下，搜索的下界 $\texttt{left} = 1$，上界 $\texttt{right} = x / 2$；
+ 使用 `mid > x / mid` 作为判断条件是因为 `mid * mid > x` 在 `mid` 很大的时候，`mid * mid` 有可能会整型溢出，使用 `mid * mid > x` 不能通过的测试用例如下：

![image.png](../images/sqrtx-0.png){:style="width:400px"}{:align=center}

**复杂度分析**：

+ 时间复杂度：$O(\log x)$，每一次搜索的区间大小为原来的 $\cfrac{1}{2}$，时间复杂度为 $O(\log_2 x) = O(\log x)$；
+ 空间复杂度：$O(1)$。

----




### 问答

#### 1. 为什么用 `while(left < right)` 这种写法？

采用 `while(left < right)` 这种写法，在退出循环的时候有 `left == right` 成立，因此返回 `left` 或者 `right` 都可以。不用思考返回 `left` 还是 `right`。

#### 2. **如何想到判断条件是 `mid > x / mid`**？

`while(left < right)` 这种写法把区间分成两个区间：一个区间一定不存在目标元素，另一个区间有可能存在目标元素。因此 **先思考满足什么条件的 `mid` 一定不是目标元素**，进而思考下一轮搜索区间不容易出错，它的反面就是另一个区间。

根据本题解最开始分析「例 2」。我们分析出：如果一个数 $mid$ 的平方大于 $x$ ，那么 $mid$ 一定不是 $x$ 的平方根，这种情况下，搜索区间是 $[0..mid - 1]$，此时我们将右边界设置为 `right = mid - 1` 的原因。剩下的情况不用思考，搜索区间一定是 $[a..right]$ ，此时设置 `left = mid`。

#### 3. 取中间数为什么需要加 1？

这一点初学的时候很难理解（包括我自己），但其实只要对着错误的测试用例打印出相关变量看一下就很清楚了。

```Java []
public class Solution {

    public int mySqrt(int x) {
        // 特殊值判断
        if (x == 0) {
            return 0;
        }
        if (x == 1) {
            return 1;
        }

        int left = 1;
        int right = x / 2;
        // 在区间 [left..right] 查找目标元素
        while (left < right) {
            // 取中间数 mid 下取整时
            int mid = left + (right - left ) / 2;

            // 调试语句开始
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println("left = " + left + ", right = " + right + ", mid = " + mid);
            // 调试语句结束

            // 注意：这里为了避免乘法溢出，改用除法
            if (mid > x / mid) {
                // 下一轮搜索区间是 [left..mid - 1]
                right = mid - 1;
            } else {
                // 下一轮搜索区间是 [mid..right]
                left = mid;
            }
        }
        return left;
    }

    public static void main(String[] args) {
        Solution solution = new Solution();
        int x = 9;
        int res = solution.mySqrt(x);
        System.out.println(res);
    }
}
```

控制台输出：

```
left = 1, right = 4, mid = 2
left = 2, right = 4, mid = 3
left = 3, right = 4, mid = 3
left = 3, right = 4, mid = 3
left = 3, right = 4, mid = 3
left = 3, right = 4, mid = 3
```

**分析原因**：**在区间只有 $2$ 个数的时候**，根据 `if`、`else` 的逻辑区间的划分方式是：`[left..mid - 1]` 与 `[mid..right]`。如果 `mid` 下取整，在区间只有 $2$ 个数的时候有 `mid = left`，一旦进入分支 `[mid..right]` 区间不会再缩小，发生死循环。

**解决办法**：把取中间数的方式改成上取整。


### 补充

整数除法的下取整行为，导致了区间划分是 `[left..mid - 1]` 与 `[mid..right]` 的时候，如果搜索进入区间 `[mid..right]` 的时候，`left = mid` 导致区间不再缩小，进入死循环。

解决办法是把 `mid` 改成上取整，之前的取法上取整、下取整都无所谓，甚至不用取在中间的位置，最后一轮取对就可以了。

我介绍的二分查找算法，对区间的定义均为「左闭右闭区间」，即循环不变量的定义是：**在区间 `[left..right]` 里可能存在目标元素**。如果有朋友对区间的定义是左闭右开，能把问题做对也是完全可以的，不必和我一样。


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    418505    |    1070670    |   39.1%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |


## 相似题目
|                             题目                             | 难度 |
| :----------------------------------------------------------: | :---------: |
| [Pow(x, n)](https://leetcode-cn.com/problems/powx-n/) | 中等|
| [有效的完全平方数](https://leetcode-cn.com/problems/valid-perfect-square/) | 简单|
