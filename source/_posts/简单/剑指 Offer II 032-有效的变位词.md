---
title: 剑指 Offer II 032-有效的变位词
date: 2021-12-03 21:32:09
categories:
  - 简单
tags:
  - 哈希表
  - 字符串
  - 排序
---

> 原文链接: https://leetcode-cn.com/problems/dKk3P7




## 中文题目
<div><p>给定两个字符串 <code>s</code> 和 <code>t</code> ，编写一个函数来判断它们是不是一组变位词（字母异位词）。</p>

<p><strong>注意：</strong>若&nbsp;<code><em>s</em></code> 和 <code><em>t</em></code><em>&nbsp;</em>中每个字符出现的次数都相同且<strong>字符顺序不完全相同</strong>，则称&nbsp;<code><em>s</em></code> 和 <code><em>t</em></code><em>&nbsp;</em>互为变位词（字母异位词）。</p>

<p>&nbsp;</p>

<p><strong>示例&nbsp;1:</strong></p>

<pre>
<strong>输入:</strong> s = &quot;anagram&quot;, t = &quot;nagaram&quot;
<strong>输出:</strong> true
</pre>

<p><strong>示例 2:</strong></p>

<pre>
<strong>输入:</strong> s = &quot;rat&quot;, t = &quot;car&quot;
<strong>输出: </strong>false</pre>

<p><strong>示例 3:</strong></p>

<pre>
<strong>输入:</strong> s = &quot;a&quot;, t = &quot;a&quot;
<strong>输出: </strong>false</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>1 &lt;= s.length, t.length &lt;= 5 * 10<sup>4</sup></code></li>
	<li><code>s</code>&nbsp;and&nbsp;<code>t</code>&nbsp;仅包含小写字母</li>
</ul>

<p>&nbsp;</p>

<p><strong>进阶:&nbsp;</strong>如果输入字符串包含 unicode 字符怎么办？你能否调整你的解法来应对这种情况？</p>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 242&nbsp;题相似（字母异位词定义不同）：<a href="https://leetcode-cn.com/problems/valid-anagram/">https://leetcode-cn.com/problems/valid-anagram/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
简单题我再重拳出击
```
class Solution {
    public boolean isAnagram(String s, String t) {
        int m = s.length(), n = t.length();
        if(m != n) return false;
        if(s.equals(t)) return false;//这里有个特殊样例，相等判断为非变位词
        int[] cnt1 = new int[26];
        int[] cnt2 = new int[26];
        for(char c : s.toCharArray()) cnt1[c - 'a']++;
        for(char c : t.toCharArray()) cnt2[c - 'a']++;
        return Arrays.equals(cnt1, cnt2);
    }
}
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    5416    |    9097    |   59.5%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
