---
title: 剑指 Offer II 001-整数除法
categories:
  - 简单
tags:
  - 位运算
  - 数学
abbrlink: 2808254282
date: 2021-12-03 21:33:06
---

> 原文链接: https://leetcode-cn.com/problems/xoh6Oh




## 中文题目
<div><p>给定两个整数 <code>a</code> 和 <code>b</code> ，求它们的除法的商 <code>a/b</code> ，要求不得使用乘号 <code>&#39;*&#39;</code>、除号 <code>&#39;/&#39;</code> 以及求余符号 <code>&#39;%&#39;</code>&nbsp;。</p>

<p>&nbsp;</p>

<p><strong>注意：</strong></p>

<ul>
	<li>整数除法的结果应当截去（<code>truncate</code>）其小数部分，例如：<code>truncate(8.345) = 8</code>&nbsp;以及&nbsp;<code>truncate(-2.7335) = -2</code></li>
	<li>假设我们的环境只能存储 32 位有符号整数，其数值范围是 <code>[&minus;2<sup>31</sup>,&nbsp;2<sup>31</sup>&minus;1]</code>。本题中，如果除法结果溢出，则返回 <code>2<sup>31&nbsp;</sup>&minus; 1</code></li>
</ul>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>a = 15, b = 2
<strong>输出：</strong>7
<strong><span style="white-space: pre-wrap;">解释：</span></strong>15/2 = truncate(7.5) = 7
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>a = 7, b = -3
<strong>输出：</strong><span style="white-space: pre-wrap;">-2</span>
<strong><span style="white-space: pre-wrap;">解释：</span></strong>7/-3 = truncate(-2.33333..) = -2</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>a = 0, b = 1
<strong>输出：</strong><span style="white-space: pre-wrap;">0</span></pre>

<p><strong>示例 4：</strong></p>

<pre>
<strong>输入：</strong>a = 1, b = 1
<strong>输出：</strong><span style="white-space: pre-wrap;">1</span></pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>-2<sup>31</sup>&nbsp;&lt;= a, b &lt;= 2<sup>31</sup>&nbsp;- 1</code></li>
	<li><code>b != 0</code></li>
</ul>

<p>&nbsp;</p>

<p>注意：本题与主站 29&nbsp;题相同：<a href="https://leetcode-cn.com/problems/divide-two-integers/">https://leetcode-cn.com/problems/divide-two-integers/</a></p>

<p>&nbsp;</p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
我们一步一步来剖析这道算法题！！！！

### 1. 减法代替除法
我们最简单可以想到的是：使用减法代替除法，请看视频：

![1_001_减法代替除法.mp4](9bbda531-b267-4593-9c99-3ca7d0a13b96)

### 2. 考虑边界问题
以上代码没有考虑清楚边界问题，请看视频：

![2_001_考虑边界条件.mp4](95f54d92-45dc-43f1-bf64-729563f2baa2)

代码如下：
```java []
// 因为将 -2147483648 转成正数会越界，但是将 2147483647 转成负数，则不会
// 所以，我们将 a 和 b 都转成负数
// 时间复杂度：O(n)，n 是最大值 2147483647 --> 10^10 --> 超时
public int divide2(int a, int b) {
    // 32 位最大值：2^31 - 1 = 2147483647
    // 32 位最小值：-2^31 = -2147483648
    // -2147483648 / (-1) = 2147483648 > 2147483647 越界了
    if (a == Integer.MIN_VALUE && b == -1)
        return Integer.MAX_VALUE;
    int sign = (a > 0) ^ (b > 0) ? -1 : 1;
    // 环境只支持存储 32 位整数
    if (a > 0) a = -a;
    if (b > 0) b = -b;
    int res = 0;
    while (a <= b) {
        a -= b;
        res++;
    }
    // bug 修复：因为不能使用乘号，所以将乘号换成三目运算符
    return sign == 1 ? res : -res;
}
```
```javascript []
// 超时
var divide1 = function(a, b) {
    const INT_MIN = -Math.pow(2, 31)
    const INT_MAX = Math.pow(2, 31) - 1

    if (a == INT_MIN && b == -1) return INT_MAX

    const sign = (a > 0) ^ (b > 0) ? -1 : 1
    if (a > 0) a = -a 
    if (b > 0) b = -b 

    let res = 0
    while (a <= b) {
        a -= b
        res++
    }

    // bug 修复：因为不能使用乘号，所以将乘号换成三目运算符
    return sign == 1 ? res : -res
};
```
```python []
# 超时
def divide1(self, a: int, b: int) -> int:
    INT_MIN, INT_MAX = -2**31, 2**31 - 1
    if a == INT_MIN and b == -1:
        return INT_MAX
    
    sign = -1 if (a > 0) ^ (b > 0) else 1
    if a > 0:
        a = -a
    if b > 0:
        b = -b

    ans = 0
    while a <= b:
        a -= b
        ans += 1
    
    # bug 修复：因为不能使用乘号，所以将乘号换成三目运算符
    return ans if sign == 1 else -ans
```
```c++ []
int divide(int a, int b) {
    if (a == INT_MIN && b == -1) return INT_MAX;

    int sign = (a > 0) ^ (b > 0) ? -1 : 1;

    if (a > 0) a = -a;
    if (b > 0) b = -b;
    
    unsigned int res = 0;
    while (a <= b) {
        a -= b;
        res++;
    }

    // bug 修复：因为不能使用乘号，所以将乘号换成三目运算符
    return sign == 1 ? res : -res;
}
```
```golang []
// 超时
// 因为将 -2147483648 转成正数会越界，但是将 2147483647 转成负数，则不会
// 所以，我们将 a 和 b 都转成负数
// 时间复杂度：O(n)，n 是最大值 2147483647 --> 10^10
func divide1(a int, b int) int {
    if a == math.MinInt32 && b == -1 {
        return math.MaxInt32
    }

    sign := 1
    if (a > 0 && b < 0) || (a < 0 && b > 0) {
        sign = -1
    }

    if a > 0 {
        a = -a
    }
    if b > 0 {
        b = -b
    }

    res := 0
    for a <= b {
        a -= b
        res++
    }
    return sign * res
}
```
- 时间复杂度：O(n)
- 空间复杂度：O(1)

### 3. 优化，降低时间复杂度

以下视频要是看不了的话，可以看这里：https://www.bilibili.com/video/BV1Aq4y1U7Ly

请看视频：

![...001_优化-每次减去除数的倍数.mp4](0ae60ffc-c779-4bda-b8f0-62ff5a075fb5)


代码如下：

```java []
// 时间复杂度：O(logn * logn)，n 是最大值 2147483647 --> 10^10
public int divide(int a, int b) {
    if (a == Integer.MIN_VALUE && b == -1)
        return Integer.MAX_VALUE;
    int sign = (a > 0) ^ (b > 0) ? -1 : 1;
    if (a > 0) a = -a;
    if (b > 0) b = -b;
    int res = 0;
    while (a <= b) {
        int value = b;
        int k = 1;
        // 0xc0000000 是十进制 -2^30 的十六进制的表示
        // 判断 value >= 0xc0000000 的原因：保证 value + value 不会溢出
        // 可以这样判断的原因是：0xc0000000 是最小值 -2^31 的一半，
        // 而 a 的值不可能比 -2^31 还要小，所以 value 不可能比 0xc0000000 小
        // -2^31 / 2 = -2^30
        while (value >= 0xc0000000 && a <= value + value) {
            value += value;
            k += k;
        }
        a -= value;
        res += k;
    }
    // bug 修复：因为不能使用乘号，所以将乘号换成三目运算符
    return sign == 1 ? res : -res;
}
```
```javascript []
// 超时
var divide1 = function(a, b) {
    const INT_MIN = -Math.pow(2, 31)
    const INT_MAX = Math.pow(2, 31) - 1

    if (a == INT_MIN && b == -1) return INT_MAX

    const sign = (a > 0) ^ (b > 0) ? -1 : 1
    if (a > 0) a = -a 
    if (b > 0) b = -b 

    let res = 0
    while (a <= b) {
        let value = b
        let k = 1
        while (value >= 0xc0000000 && a <= value + value) {
            value += value
            k += k
        }
        a -= value
        res += k
    }

    // bug 修复：因为不能使用乘号，所以将乘号换成三目运算符
    return sign == 1 ? res : -res
};
```
```python []
# 超时
def divide1(self, a: int, b: int) -> int:
    INT_MIN, INT_MAX = -2**31, 2**31 - 1
    if a == INT_MIN and b == -1:
        return INT_MAX
    
    sign = -1 if (a > 0) ^ (b > 0) else 1
    if a > 0:
        a = -a
    if b > 0:
        b = -b

    ans = 0
    while a <= b:
        value, k = b, 1
        while value >= 0xc0000000 and a <= value + value:
            k += k
            value += value
        ans, a = ans + k, a - value
    
    # bug 修复：因为不能使用乘号，所以将乘号换成三目运算符
    return ans if sign == 1 else -ans
```
```c++ []
int divide(int a, int b) {
    if (a == INT_MIN && b == -1) return INT_MAX;

    int sign = (a > 0) ^ (b > 0) ? -1 : 1;

    if (a > 0) a = -a;
    if (b > 0) b = -b;
    
    unsigned int res = 0;
    while (a <= b) {
        int value = b;
        // 如果不用 unsigned 的话，那么当 a = -2147483648, b = 1 的时候，k 会越界
        unsigned int k = 1;
        // 0xc0000000 是十进制 -2^30 的十六进制的表示
        // 判断 value >= 0xc0000000 的原因：保证 value + value 不会溢出
        // 可以这样判断的原因是：0xc0000000 是最小值 -2^31 的一半，
        // 而 a 的值不可能比 -2^31 还要小，所以 value 不可能比 0xc0000000 小
        while (value >= 0xc0000000 && a <= value + value) {
            k += k;
            value += value;
        }
        a -= value;
        res += k;
    }

    // bug 修复：因为不能使用乘号，所以将乘号换成三目运算符
    return sign == 1 ? res : -res;
}

```
```golang []
// 超时 时间复杂度：O(logn * logn)，n 是最大值 2147483647 --> 10^10
func divide2(a int, b int) int {
    if a == math.MinInt32 && b == -1 {
        return math.MaxInt32
    }

    sign := 1
    if (a > 0 && b < 0) || (a < 0 && b > 0) {
        sign = -1
    }

    if a > 0 {
        a = -a
    }
    if b > 0 {
        b = -b
    }

    res := 0
    for a <= b {
        value, k := b, 1
        // 0xc0000000 是十进制 -2^30 的十六进制的表示
        // 判断 value >= 0xc0000000 的原因：保证 value + value 不会溢出
        // 可以这样判断的原因是：0xc0000000 是最小值 -2^31 的一半，
        // 而 a 的值不可能比 -2^31 还要小，所以 value 不可能比 0xc0000000 小
        // -2^31 / 2 = -2^30
        for value >= 0xc0000000 && a <= value + value {
            value += value
            k += k
        }
        a -= value
        res += k
    }
    return sign * res
}
```
- 时间复杂度：O(logn * logn) ，使用 python 和 javascript 会超时，看下面的优化
- 空间复杂度：O(1)

### 4. 继续优化，使用位运算来优化
请看视频：

![...01_使用位运算优化算法-无广告.mp4](3aedc0ec-64e6-495b-aacd-a76c5d27764a)


代码如下：

```java []
// 时间复杂度：O(1)
public int divide(int a, int b) {
    if (a == Integer.MIN_VALUE && b == -1)
        return Integer.MAX_VALUE;
    int sign = (a > 0) ^ (b > 0) ? -1 : 1;
    a = Math.abs(a);
    b = Math.abs(b);
    int res = 0;
    for (int i = 31; i >= 0; i--) {
        // 首先，右移的话，再怎么着也不会越界
        // 其次，无符号右移的目的是：将 -2147483648 看成 2147483648

        // 注意，这里不能是 (a >>> i) >= b 而应该是 (a >>> i) - b >= 0
        // 这个也是为了避免 b = -2147483648，如果 b = -2147483648
        // 那么 (a >>> i) >= b 永远为 true，但是 (a >>> i) - b >= 0 为 false
        if ((a >>> i) - b >= 0) { // a >= (b << i)
            a -= (b << i);
            res += (1 << i);
        }
    }
    // bug 修复：因为不能使用乘号，所以将乘号换成三目运算符
    return sign == 1 ? res : -res;
}
```
```javascript []
var divide = function(a, b) {
    const INT_MIN = -Math.pow(2, 31)
    const INT_MAX = Math.pow(2, 31) - 1

    if (a == INT_MIN && b == -1) return INT_MAX

    const sign = (a > 0) ^ (b > 0) ? -1 : 1
    a = Math.abs(a)
    b = Math.abs(b)

    let res = 0
    for (let x = 31; x >= 0; x--) {
        if ((a >>> x) - b >= 0) {
            a = a - (b << x)
            res = res + (1 << x)
        }
    }
    if (res == -2147483648) return -2147483648
    // bug 修复：因为不能使用乘号，所以将乘号换成三目运算符
    return sign == 1 ? res : -res
};
```
```python []
def divide(self, a: int, b: int) -> int:
    INT_MIN, INT_MAX = -2**31, 2**31 - 1
    if a == INT_MIN and b == -1:
        return INT_MAX
    
    sign = -1 if (a > 0) ^ (b > 0) else 1
    
    a, b = abs(a), abs(b)
    ans = 0
    for i in range(31, -1, -1):
        if (a >> i) - b >= 0:
            a = a - (b << i)
            ans += 1 << i
    
    # bug 修复：因为不能使用乘号，所以将乘号换成三目运算符
    return ans if sign == 1 else -ans
```
```c++ []
int divide(int a, int b) {
    if (a == INT_MIN && b == -1) return INT_MAX;

    int sign = (a > 0) ^ (b > 0) ? -1 : 1;

    unsigned int ua = abs(a);
    unsigned int ub = abs(b);
    unsigned int res = 0;
    for (int i = 31; i >= 0; i--) {
        if ((ua >> i) >= ub) {
            ua = ua - (ub << i);
            res += 1 << i;
        }
    }
    // bug 修复：因为不能使用乘号，所以将乘号换成三目运算符
    return sign == 1 ? res : -res;
}
```
```golang []
// 时间复杂度：O(1)
func divide(a int, b int) int {
    if a == math.MinInt32 && b == -1 {
        return math.MaxInt32
    }

    sign := 1
    if (a > 0 && b < 0) || (a < 0 && b > 0) {
        sign = -1
    }

    a = abs(a)
    b = abs(b)

    res := 0
    for i := 31; i >= 0; i-- {
        if (a >> i) - b >= 0 {
            a = a - (b << i)
            res += 1 << i
        }
    }
    return sign * res
}

func abs(a int) int {
    if a < 0 {
        return -a
    }
    return a
}
```
- 时间复杂度：O(1) 
- 空间复杂度：O(1)


在刷题的时候：
1. 如果你觉得自己数据结构与算法**基础不够扎实**，那么[请点这里](http://www.tangweiqun.com/api/31104/offer001?av=1&cv=1)，这里包含了**一个程序员 5 年内需要的所有算法知识**

2. 如果你感觉刷题**太慢**，或者感觉**很困难**，或者**赶时间**，那么[请点这里](http://www.tangweiqun.com/api/35548/offer001?av=1&cv=1)。这里**用 365 道高频算法题，带你融会贯通算法知识，做到以不变应万变**

3. **回溯、贪心和动态规划，是算法面试中的三大难点内容**，如果你只是想搞懂这三大难点内容 [请点这里](http://www.tangweiqun.com/api/38100/offer001?av=1&cv=1)

**以上三个链接中的内容，都支持 Java/C++/Python/js/go 四种语言** 

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    13516    |    65201    |   20.7%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
