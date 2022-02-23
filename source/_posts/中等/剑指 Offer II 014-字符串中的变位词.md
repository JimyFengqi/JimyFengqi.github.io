---
title: 剑指 Offer II 014-字符串中的变位词
categories:
  - 中等
tags:
  - 哈希表
  - 双指针
  - 字符串
  - 滑动窗口
abbrlink: 3063137252
date: 2021-12-03 21:32:38
---

> 原文链接: https://leetcode-cn.com/problems/MPnaiL




## 中文题目
<div><p>给定两个字符串&nbsp;<code>s1</code>&nbsp;和&nbsp;<code>s2</code>，写一个函数来判断 <code>s2</code> 是否包含 <code>s1</code><strong>&nbsp;</strong>的某个变位词。</p>

<p>换句话说，第一个字符串的排列之一是第二个字符串的 <strong>子串</strong> 。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入: </strong>s1 = &quot;ab&quot; s2 = &quot;eidbaooo&quot;
<strong>输出: </strong>True
<strong>解释:</strong> s2 包含 s1 的排列之一 (&quot;ba&quot;).
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入: </strong>s1= &quot;ab&quot; s2 = &quot;eidboaoo&quot;
<strong>输出:</strong> False
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= s1.length, s2.length &lt;= 10<sup>4</sup></code></li>
	<li><code>s1</code> 和 <code>s2</code> 仅包含小写字母</li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 567&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/permutation-in-string/">https://leetcode-cn.com/problems/permutation-in-string/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
## 前文回顾

上一章我们学习了数组相关的知识与解题，并针对例题讲解了双指针和前缀和的解题思想。其中重点针对双指针的特殊场景滑动窗口进行了细致讨论和解题模板梳理。到这里一些初入刷题不久的朋友也许要想，那是不双指针就只能用来刷数组的题目，其他的就不适用了呢？完全不是...

针对某一类数据结构的算法题目，很多时候解题思维是通用的，不仅是数组会用到双指针，链表、字符串等等同样适用。而且我们在解某一种题目时，经常会通过将该结构转化为其他数据结构的方式来完成解题，而这种场景出现最多的就是字符串类型了。

## 字符串题目解析

字符串普遍认为它是不可变的，所以如果单纯考察字符串，能涉及到的知识点未免太过狭隘了，难道面试的时候算法题目考些诸如：字符串切片求子串、两个字符串判断是否相等、字符串倒序输出？醒醒，别做梦了，但凡喝酒配点花生米，也不至于醉成这样啊....

力扣上的字符串题目有536道，但这个分类是有问题的，它将所有入参为字符串的题目都分到的这个类型里面，但其实几乎所有字符串的题目都是通过以下几类来完成的，让我们来仔细划分下：

### 数组

由于字符串是有字符组成的，而算法题中的字符串一般都只会包含26个英文字母，更为简单的一般会告诉你仅包含大/小写字母，那么在判断字符串中包含的英文字母数量时，可以使用一个长度为26的数组根据下标0-25的value值 对应 a-z个字符在字符串中出现的次数。

通过这种方式可以解决很大一部分字符串的题目。

### 栈

针对括号匹配、路径拆分等字符串题目，使用栈的方式简直手到擒来闭眼AC。当然这里要说明下在Python中，是没有Stack这个数据类型的，它是通过list的append和pop实现栈的压入弹出。

### 哈希表

哈希表在字符串中也是有一定地位的，我们在解题时可以使用哈希表快速完成一些匹配的关系，比如罗马数字转整数中的循环比较：

```python
tmp = { "I": 1,
        "V": 5,
        "X": 10,
        "L": 50,
        "C": 100,
        "D": 500,
        "M": 1000}
```

亦或者是判断字符串同构等的题目，也可以通过哈希表的方式轻松解题，这里举例两道简单题目用来了解这种解题方式。

有兴趣的朋友可以先提前去看看：

- 205.同构字符串
- 290.单词规律

### 队列

队列由于其先进先出的特点，可以在循环匹配中帮助我们通过枚举的方式完成部分字符串的题目，比如 **17. 电话号码的字母组合**

其他类型的还有很多，这里就不逐一介绍了，通过这些例子只是想告诉大家，数据结构是互通的，我们可以通过数据结构的转换来完成解题。并且算法和数据结构不是强绑定的，一个算法在不同的数据结构中经常是通用的。

## 字符串方法

上面看到由于我们需要将字符串转化为其他的数据类型，那么不可避免的需要用到一些方法。在这里快速介绍下吧。

1. 获取字符串长度
   - **Java:** someString.length()
   - **Python:** len(some_string)
2. 判断字符串是否相等
   - **Java:** someString.equals(otherString)
   - **Python:**  some_string == other_string
3. 获取字符串的子串
   - **Java：**someString.substring(begin,end)
   - **Python:** some_string [begin: end:step​]

4. 拆分字符串
   - **Java：**String[] arr = someString.split(regex);
   - **Python:** some_string.split(regex,maxsplit)

5. 获取下标
   - **Java：** indexOf()  lastIndexOf()
   - **Python:** python 只有index()

6. 大小写转换
   - **Java：** toLowerCase() toUpperCase()
   - **Python:** lower() upper()
7. Java返回指定下标的字符时，需要使用**charAt()**，Python无需如此。

对于字符串的题目，理解上面这些就差不多了，接下来，让我们拿一道题目试试手吧。

## [剑指OfferII014.字符串中的变位词](https://leetcode-cn.com/problems/MPnaiL/solution/shua-chuan-jian-zhi-offer-day08-zi-fu-ch-pasw/)
> https://leetcode-cn.com/problems/MPnaiL/solution/shua-chuan-jian-zhi-offer-day08-zi-fu-ch-pasw/
>
> 难度：中等

## 题目
给定两个字符串 s1 和 s2，写一个函数来判断 s2 是否包含 s1 的某个变位词。

换句话说，第一个字符串的排列之一是第二个字符串的 子串 。

提示：
- 1 <= s1.length, s2.length <= 10^4
- s1 和 s2 仅包含小写字母

## 示例

```
示例 1：
输入: s1 = "ab" s2 = "eidbaooo"
输出: True
解释: s2 包含 s1 的排列之一 ("ba").

示例 2：
输入: s1= "ab" s2 = "eidboaoo"
输出: False
```

## 分析
正如上面说到的，双指针的解题思维不仅适用于数组，在字符串中也是适用的。
这道题相信在做过了前面第八、第九题后，可以一眼看出是一道双指针题目。
只不过从int[]的数组转化为了字符串而已。既然数组的双指针我们会做，那么我们只需要将字符串转换为数组即可。
由于本题仅包含小写字母，所以我们维护一个长度为26的数组，使用数组index对应的value值对应a-z字符出现的次数。
那么，为了便于理解我们维护两个数组，arr1、arr2分别表示s1、s2的转换。
然后通过循环逐次判断arr1是否等于arr2，当相等时，表示结果成立return True
如果整体循环结束后，仍未出现相等的场景，则判断结果为False，具体代码如下。

## 解题
**Python:**

```python []
class Solution:
    def checkInclusion(self, s1: str, s2: str) -> bool:
        arr1, arr2, lg = [0] * 26, [0] * 26, len(s1)
        if lg > len(s2):
            return False

        for i in range(lg):
            arr1[ord(s1[i]) - ord('a')] += 1
            arr2[ord(s2[i]) - ord('a')] += 1

        for j in range(lg, len(s2)):
            if arr1 == arr2:
                return True
            arr2[ord(s2[j - lg]) - ord('a')] -= 1
            arr2[ord(s2[j]) - ord('a')] += 1
        return arr1 == arr2
```

```java []
class Solution {
    public boolean checkInclusion(String s1, String s2) {
        int[] arr1 = new int[26];
        int[] arr2 = new int[26];
        if (s1.length() > s2.length()){
            return false;
        }
        for (int i = 0; i < s1.length(); i++) {
            arr1[s1.charAt(i) - 'a']++;
            arr2[s2.charAt(i) - 'a']++;
        }
        for (int i = s1.length(); i < s2.length(); i++) {
            if (Arrays.equals(arr1, arr2)) {
                return true;
            }
            arr2[s2.charAt(i - s1.length()) - 'a']--;
            arr2[s2.charAt(i) - 'a']++;
        }
        return Arrays.equals(arr1, arr2);
    }
}
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    6449    |    12835    |   50.2%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
