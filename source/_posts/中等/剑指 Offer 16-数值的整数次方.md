---
title: 剑指 Offer 16-数值的整数次方(数值的整数次方 LCOF)
date: 2021-12-03 21:39:24
categories:
  - 中等
tags:
  - 递归
  - 数学
---

> 原文链接: https://leetcode-cn.com/problems/shu-zhi-de-zheng-shu-ci-fang-lcof




## 中文题目
<div><p>实现 <a href="https://www.cplusplus.com/reference/valarray/pow/">pow(<em>x</em>, <em>n</em>)</a> ，即计算 x 的 n 次幂函数（即，x<sup>n</sup>）。不得使用库函数，同时不需要考虑大数问题。</p>

<p> </p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>x = 2.00000, n = 10
<strong>输出：</strong>1024.00000
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>x = 2.10000, n = 3
<strong>输出：</strong>9.26100</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>x = 2.00000, n = -2
<strong>输出：</strong>0.25000
<strong>解释：</strong>2<sup>-2</sup> = 1/2<sup>2</sup> = 1/4 = 0.25</pre>

<p> </p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>-100.0 < x < 100.0</code></li>
	<li><code>-2<sup>31</sup> <= n <= 2<sup>31</sup>-1</code></li>
	<li><code>-10<sup>4</sup> <= x<sup>n</sup> <= 10<sup>4</sup></code></li>
</ul>

<p> </p>

<p>注意：本题与主站 50 题相同：<a href="https://leetcode-cn.com/problems/powx-n/">https://leetcode-cn.com/problems/powx-n/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
#### 解题思路：

> 求 $x^n$ 最简单的方法是通过循环将 $n$ 个 $x$ 乘起来，依次求 $x^1, x^2, ..., x^{n-1}, x^n$ ，时间复杂度为 $O(n)$ 。
> **快速幂法** 可将时间复杂度降低至 $O(log_2 n)$ ，以下从 **“二分法”** 和 **“二进制”** 两个角度解析快速幂法。

##### 快速幂解析（二进制角度）：

> 利用十进制数字 $n$ 的二进制表示，可对快速幂进行数学化解释。

- 对于任何十进制正整数 $n$ ，设其二进制为 "$b_m...b_3b_2b_1$"（ $b_i$ 为二进制某位值，$i \in [1,m]$ ），则有：
  - **二进制转十进制：** $n = 1b_1 + 2b_2 + 4b_3 + ... + 2^{m-1}b_m$ *（即二进制转十进制公式）* ；
  - **幂的二进制展开：** $x^n = x^{1b_1 + 2b_2 + 4b_3 + ... + 2^{m-1}b_m} = x^{1b_1}x^{2b_2}x^{4b_3}...x^{2^{m-1}b_m}$  ；

- 根据以上推导，可把计算 $x^n$ 转化为解决以下两个问题：
  - **计算 $x^1, x^2, x^4, ..., x^{2^{m-1}}$ 的值：** 循环赋值操作 $x = x^2$ 即可；
  - **获取二进制各位 $b_1, b_2, b_3, ..., b_m$ 的值：** 循环执行以下操作即可。
    1. **$n \& 1$ （与操作）：** 判断 $n$ 二进制最右一位是否为 $1$ ；
    2. **$n>>1$  （移位操作）：** $n$ 右移一位（可理解为删除最后一位）。

- 因此，应用以上操作，可在循环中依次计算 $x^{2^{0}b_1}, x^{2^{1}b_2}, ..., x^{2^{m-1}b_m}$ 的值，并将所有 $x^{2^{i-1}b_i}$ 累计相乘即可。
  - 当 $b_i = 0$ 时：$x^{2^{i-1}b_i} = 1$ ；
  - 当 $b_i = 1$ 时：$x^{2^{i-1}b_i} = x^{2^{i-1}}$ ；

![Picture1.png](../images/shu-zhi-de-zheng-shu-ci-fang-lcof-0.png){:width=450}

##### 快速幂解析（二分法角度）：

> 快速幂实际上是二分思想的一种应用。

- **二分推导：** $x^n = x^{n/2} \times x^{n/2} = (x^2)^{n/2}$ ，令 $n/2$ 为整数，则需要分为奇偶两种情况（设向下取整除法符号为 "$//$" ）：
  - 当 $n$ 为偶数： $x^n = (x^2)^{n//2}$ ；
  - 当 $n$ 为奇数： $x^n = x(x^2)^{n//2}$ ，即会多出一项 $x$ ；

- **幂结果获取：**
  - 根据二分推导，可通过循环 $x = x^2$ 操作，每次把幂从 $n$ 降至 $n//2$ ，直至将幂降为 $0$ ；
  - 设 $res=1$ ，则初始状态 $x^n = x^n \times res$ 。在循环二分时，每当 $n$ 为奇数时，将多出的一项 $x$ 乘入 $res$ ，则最终可化至 $x^n = x^0 \times res = res$ ，返回 $res$ 即可。

![Picture2.png](../images/shu-zhi-de-zheng-shu-ci-fang-lcof-1.png){:width=450}

- **转化为位运算：**
  - 向下整除 $n // 2$  **等价于** 右移一位 $n >> 1$ ；
  - 取余数 $n \% 2$ **等价于** 判断二进制最右一位值 $n \& 1$ ；

##### 算法流程：

1. 当 $x = 0$ 时：直接返回 $0$ （避免后续 $x = 1 / x$ 操作报错）。
2. 初始化 $res = 1$ ；
2. 当 $n < 0$ 时：把问题转化至 $n \geq 0$ 的范围内，即执行 $x = 1/x$ ，$n = - n$ ；
3. 循环计算：当 $n = 0$ 时跳出；
   1. 当 $n \& 1 = 1$ 时：将当前 $x$ 乘入 $res$ （即 $res *= x$ ）；
   2. 执行 $x = x^2$ （即 $x *= x$ ）；
   3. 执行 $n$ 右移一位（即 $n >>= 1$）。
4. 返回 $res$ 。

##### 复杂度分析：

- **时间复杂度 $O(log_2 n)$ ：** 二分的时间复杂度为对数级别。 
- **空间复杂度 $O(1)$ ：** $res$, $b$ 等变量占用常数大小额外空间。

#### 代码：

> Java 代码中 `int32` 变量 $n \in [-2147483648, 2147483647]$ ，因此当 $n = -2147483648$ 时执行 $n = -n$ 会因越界而赋值出错。解决方法是先将 $n$ 存入 `long` 变量 $b$ ，后面用 $b$ 操作即可。

```python []
class Solution:
    def myPow(self, x: float, n: int) -> float:
        if x == 0: return 0
        res = 1
        if n < 0: x, n = 1 / x, -n
        while n:
            if n & 1: res *= x
            x *= x
            n >>= 1
        return res
```

```java []
class Solution {
    public double myPow(double x, int n) {
        if(x == 0) return 0;
        long b = n;
        double res = 1.0;
        if(b < 0) {
            x = 1 / x;
            b = -b;
        }
        while(b > 0) {
            if((b & 1) == 1) res *= x;
            x *= x;
            b >>= 1;
        }
        return res;
    }
}
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    132647    |    388997    |   34.1%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
