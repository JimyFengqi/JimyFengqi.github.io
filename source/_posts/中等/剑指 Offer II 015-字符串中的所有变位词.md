---
title: 剑指 Offer II 015-字符串中的所有变位词
date: 2021-12-03 21:32:37
categories:
  - 中等
tags:
  - 哈希表
  - 字符串
  - 滑动窗口
---

> 原文链接: https://leetcode-cn.com/problems/VabMRr




## 中文题目
<div><p>给定两个字符串&nbsp;<code>s</code>&nbsp;和<b>&nbsp;</b><code>p</code>，找到&nbsp;<code>s</code><strong>&nbsp;</strong>中所有 <code>p</code> 的&nbsp;<strong>变位词&nbsp;</strong>的子串，返回这些子串的起始索引。不考虑答案输出的顺序。</p>

<p><strong>变位词 </strong>指字母相同，但排列不同的字符串。</p>

<p>&nbsp;</p>

<p><strong>示例&nbsp;1:</strong></p>

<pre>
<strong>输入: </strong>s = &quot;cbaebabacd&quot;, p = &quot;abc&quot;
<strong>输出: </strong>[0,6]
<strong>解释:</strong>
起始索引等于 0 的子串是 &quot;cba&quot;, 它是 &quot;abc&quot; 的变位词。
起始索引等于 6 的子串是 &quot;bac&quot;, 它是 &quot;abc&quot; 的变位词。
</pre>

<p><strong>&nbsp;示例 2:</strong></p>

<pre>
<strong>输入: </strong>s = &quot;abab&quot;, p = &quot;ab&quot;
<strong>输出: </strong>[0,1,2]
<strong>解释:</strong>
起始索引等于 0 的子串是 &quot;ab&quot;, 它是 &quot;ab&quot; 的变位词。
起始索引等于 1 的子串是 &quot;ba&quot;, 它是 &quot;ab&quot; 的变位词。
起始索引等于 2 的子串是 &quot;ab&quot;, 它是 &quot;ab&quot; 的变位词。
</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>1 &lt;= s.length, p.length &lt;= 3 * 10<sup>4</sup></code></li>
	<li><code>s</code>&nbsp;和 <code>p</code> 仅包含小写字母</li>
</ul>

<p>&nbsp;</p>

<p>注意：本题与主站 438&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/find-all-anagrams-in-a-string/" style="background-color: rgb(255, 255, 255);">https://leetcode-cn.com/problems/find-all-anagrams-in-a-string/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# [剑指OfferII015.字符串中的所有变位词](https://leetcode-cn.com/problems/VabMRr/)
> https://leetcode-cn.com/problems/VabMRr/
> 
> 难度：中等

## 题目：
给定两个字符串 s 和 p，找到 s 中所有 p 的 变位词 的子串，返回这些子串的起始索引。不考虑答案输出的顺序。

变位词 指字母相同，但排列不同的字符串。

提示:
- 1 <= s.length, p.length <= 3 * 10 ^ 4
- s 和 p 仅包含小写字母

## 示例：

```
示例 1:
输入: s = "cbaebabacd", p = "abc"
输出: [0,6]
解释:
起始索引等于 0 的子串是 "cba", 它是 "abc" 的变位词。
起始索引等于 6 的子串是 "bac", 它是 "abc" 的变位词。

示例 2:
输入: s = "abab", p = "ab"
输出: [0,1,2]
解释:
起始索引等于 0 的子串是 "ab", 它是 "ab" 的变位词。
起始索引等于 1 的子串是 "ba", 它是 "ab" 的变位词。
起始索引等于 2 的子串是 "ab", 它是 "ab" 的变位词。
```

## 分析
昨天的文章中，我们学习使用长度为26的数组，来建立字符串数量与数组下标对应关系的操作。
通过对应关系，判断数组相等的方式，来实现字母异位词的操作。如果忘记了可以复习下昨天的解题
- [剑指OfferII014.字符串中的变位词](https://leetcode-cn.com/problems/MPnaiL/solution/shua-chuan-jian-zhi-offer-day08-zi-fu-ch-pasw/)

那么今天的这道题，相比于14题有什么变化么？答案是几乎没有...
昨天我们在循环过程中判断如果找到异位词立即返回，今天的题目，我们只需要在遇到异位词时记录此时的起始index，保存在数组。
然后返回数组即可，就这么点差别，看我们ctrl c v 14题的解题，快速解题。

## 解题：

```python []
class Solution:
    def findAnagrams(self, s: str, p: str) -> List[int]:
        arr1, arr2, lg, ret = [0] * 26, [0] * 26, len(p), []
        if lg > len(s):
            return []
        for i in range(lg):
            arr1[ord(p[i]) - ord('a')] += 1
            arr2[ord(s[i]) - ord('a')] += 1
        if arr1 == arr2:
            ret.append(0)
        for i in range(lg,len(s)):
            arr2[ord(s[i]) - ord('a')] += 1
            arr2[ord(s[i - lg]) - ord('a')] -= 1
            if arr1 == arr2:
                ret.append(i - lg + 1)
        return ret
```

```java []
class Solution {
    public List<Integer> findAnagrams(String s, String p) {
        int[] arr1 = new int[26];
        int[] arr2 = new int[26];
        List<Integer> list = new ArrayList<Integer>();
        if (p.length() > s.length()) {
            return list;
        }
        for (int i = 0; i < p.length(); i++) {
            arr1[p.charAt(i) - 'a']++;
            arr2[s.charAt(i) - 'a']++;
        }
        if (Arrays.equals(arr1, arr2)) {
            list.add(0);
        }
        for (int i = p.length(); i < s.length(); i++) {
            arr2[s.charAt(i - p.length()) - 'a']--;
            arr2[s.charAt(i) - 'a']++;
            if (Arrays.equals(arr1, arr2)) {
                list.add(i - p.length() + 1);
            }
        }
        return list;
    }
}
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    5097    |    8096    |   63.0%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
