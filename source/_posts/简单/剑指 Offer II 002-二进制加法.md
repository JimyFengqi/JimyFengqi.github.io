---
title: 剑指 Offer II 002-二进制加法
categories:
  - 简单
tags:
  - 位运算
  - 数学
  - 字符串
  - 模拟
abbrlink: 856975470
date: 2021-12-03 21:33:04
---

> 原文链接: https://leetcode-cn.com/problems/JFETK5




## 中文题目
<div><p>给定两个 01 字符串&nbsp;<code>a</code>&nbsp;和&nbsp;<code>b</code>&nbsp;，请计算它们的和，并以二进制字符串的形式输出。</p>

<p>输入为 <strong>非空 </strong>字符串且只包含数字&nbsp;<code>1</code>&nbsp;和&nbsp;<code>0</code>。</p>

<p>&nbsp;</p>

<p><strong>示例&nbsp;1:</strong></p>

<pre>
<strong>输入:</strong> a = &quot;11&quot;, b = &quot;10&quot;
<strong>输出:</strong> &quot;101&quot;</pre>

<p><strong>示例&nbsp;2:</strong></p>

<pre>
<strong>输入:</strong> a = &quot;1010&quot;, b = &quot;1011&quot;
<strong>输出:</strong> &quot;10101&quot;</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li>每个字符串仅由字符 <code>&#39;0&#39;</code> 或 <code>&#39;1&#39;</code> 组成。</li>
	<li><code>1 &lt;= a.length, b.length &lt;= 10^4</code></li>
	<li>字符串如果不是 <code>&quot;0&quot;</code> ，就都不含前导零。</li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 67&nbsp;题相同：<a href="https://leetcode-cn.com/problems/add-binary/">https://leetcode-cn.com/problems/add-binary/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
刷题的过程中，类似的题目最好是一起来刷，这样效果非常的好！！！

不信的话，你往下看！！！

一个思路轻而易举的解决以下 5 道算法面试题：
1. leetcode 989 号算法题：数组形式的整数加法
2. leetcode 66 号算法题：加 1
3. leetcode 415 号算法题：字符串相加
4. 剑指 offer 002 号算法题：二进制求和
5. leetcode 2 号算法题：两数相加

文末有题解链接~~~

**注意**：在看这道题解之前，请确保你已经看到了 [leetcode 415 号算法题：字符串相加](https://leetcode-cn.com/problems/add-strings/solution/jian-dan-yi-dong-javacpythonjs-pei-yang-4yj7t/) 的题解

### 题目解读
如果你对本题的题目已经理解，下面的视频可以跳过：

![13_67_二进制求和.mp4](2270c20f-9e69-4371-9c48-66b5a19f54c4)

### 思路讲解 + 代码实现

请看下面的视频：

![14_67_代码实现.mp4](5c228df5-b04e-4d57-ab5c-939b9eaaaed3)

代码如下：

```java []
public String addBinary(String a, String b) {
    StringBuilder res = new StringBuilder();
    int carry = 0;
    int l1 = a.length() - 1;
    int l2 = b.length() - 1;
    while (l1 >= 0 || l2 >= 0) {
        int x = l1 < 0 ? 0 : a.charAt(l1) - '0';
        int y = l2 < 0 ? 0 : b.charAt(l2) - '0';

        int sum = x + y + carry;
        res.append(sum % 2);
        carry = sum / 2;

        l1--;
        l2--;
    }
    if (carry != 0) res.append(carry);
    return res.reverse().toString();
}
```
```c++ []
public:
    string addStrings(string num1, string num2) {
        string res = "";

        int i1 = num1.length() - 1, i2 = num2.length() - 1;
        int carry = 0;
        while (i1 >= 0 || i2 >= 0) {
            int x = i1 >= 0 ? num1[i1] - '0' : 0;
            int y = i2 >= 0 ? num2[i2] - '0' : 0;

            int sum = x + y + carry;
            res.push_back('0' + sum % 2);
            carry = sum / 2;

            i1--;
            i2--;
        }
        if (carry != 0) res.push_back('0' + carry);
        reverse(res.begin(), res.end());
        return res;
    }
```
```python []
def addStrings(self, num1: str, num2: str) -> str:
    res = ''
    i1, i2, carry = len(num1) - 1, len(num2) - 1, 0
    while i1 >= 0 or i2 >= 0:
        x = ord(num1[i1]) - ord('0') if i1 >= 0 else 0
        y = ord(num2[i2]) - ord('0') if i2 >= 0 else 0

        sum = x + y + carry
        res += str(sum % 2)
        carry = sum // 2

        i1, i2 = i1 - 1, i2 - 1
    if carry != 0: res += str(carry)
    return res[::-1]
```
```javascript []
var addStrings = function(num1, num2) {
    let res = ''
    let i1 = num1.length - 1
    let i2 = num2.length - 1
    let carry = 0
    while (i1 >= 0 || i2 >= 0) {
        const x = i1 >= 0 ? num1[i1] - '0' : 0
        const y = i2 >= 0 ? num2[i2] - '0' : 0

        const sum = x + y + carry
        res += (sum % 2)
        carry = Math.floor(sum / 2)

        i1--
        i2--
    }
    if (carry) res += carry
    return res.split("").reverse().join("")
};
```
```Golang []
func addTwoNumbers(l1 *ListNode, l2 *ListNode) *ListNode {
    dummy := &ListNode{Val: -1}
    curr, carry := dummy, 0
    for l1 != nil || l2 != nil {
        x, y := 0, 0
        if l1 != nil {
            x = l1.Val
        }
        if l2 != nil {
            y = l2.Val
        }

        sum := x + y + carry
        curr.Next = &ListNode{Val: sum % 10}
        // bug 修复：视频中忘了加上这一步
        curr = curr.Next
        carry = sum / 10

        if l1 != nil {
            l1 = l1.Next
        }
        if l2 != nil {
            l2 = l2.Next
        }
    }
    if carry != 0 {
        curr.Next = &ListNode{Val: carry}
    }
    return dummy.Next
}
```

在刷题的时候：
1. 如果你觉得自己数据结构与算法**基础不够扎实**，那么[请点这里](http://www.tangweiqun.com/api/31104/offer002?av=1&cv=1)，这里包含了**一个程序员 5 年内需要的所有算法知识**

2. 如果你感觉刷题**太慢**，或者感觉**很困难**，或者**赶时间**，那么[请点这里](http://www.tangweiqun.com/api/35548/offer002?av=1&cv=1)。这里**用 365 道高频算法题，带你融会贯通算法知识，做到以不变应万变**

3. **回溯、贪心和动态规划，是算法面试中的三大难点内容**，如果你只是想搞懂这三大难点内容 [请点这里](http://www.tangweiqun.com/api/38100/offer002?av=1&cv=1)

**以上三个链接中的内容，都支持 Java/C++/Python/js/go 五种语言** 


接下来可以一起刷下面的 5 道算法题了：
1. [leetcode 989 号算法题：数组形式的整数加法](https://leetcode-cn.com/problems/add-to-array-form-of-integer/solution/jian-dan-yi-dong-javacpythonjs-pei-yang-a8ofe/)
2. [leetcode 66 号算法题：加 1](https://leetcode-cn.com/problems/plus-one/solution/jian-dan-yi-dong-javacpythonjs-pei-yang-lf0sg/)
3. [leetcode 415 号算法题：字符串相加](https://leetcode-cn.com/problems/add-strings/solution/jian-dan-yi-dong-javacpythonjs-pei-yang-4yj7t/)
4. [leetcode 67 号算法题：二进制求和](https://leetcode-cn.com/problems/add-binary/solution/jian-dan-yi-dong-javacpythonjs-pei-yang-7xcrw/)
5. [leetcode 2 号算法题：两数相加](https://leetcode-cn.com/problems/add-two-numbers/solution/jian-dan-yi-dong-javacpythonjs-pei-yang-y2w6g/)




## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    11940    |    21309    |   56.0%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
