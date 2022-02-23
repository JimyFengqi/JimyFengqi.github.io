---
title: 剑指 Offer II 018-有效的回文
date: 2021-12-03 21:32:34
categories:
  - 简单
tags:
  - 双指针
  - 字符串
---

> 原文链接: https://leetcode-cn.com/problems/XltzEq




## 中文题目
<div><p>给定一个字符串 <code>s</code> ，验证 <code>s</code>&nbsp;是否是&nbsp;<strong>回文串&nbsp;</strong>，只考虑字母和数字字符，可以忽略字母的大小写。</p>

<p>本题中，将空字符串定义为有效的&nbsp;<strong>回文串&nbsp;</strong>。</p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<pre>
<strong>输入: </strong>s =<strong> </strong>&quot;A man, a plan, a canal: Panama&quot;
<strong>输出:</strong> true
<strong>解释：</strong>&quot;amanaplanacanalpanama&quot; 是回文串</pre>

<p><strong>示例 2:</strong></p>

<pre>
<strong>输入:</strong> s = &quot;race a car&quot;
<strong>输出:</strong> false
解释：&quot;raceacar&quot; 不是回文串</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= s.length &lt;= 2 * 10<sup>5</sup></code></li>
	<li>字符串 <code>s</code> 由 ASCII 字符组成</li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 125&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/valid-palindrome/">https://leetcode-cn.com/problems/valid-palindrome/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# **回文解释**
柳庭风静人眠昼，昼眠人静风庭柳。
香汗薄纱凉，凉纱薄汗香。
手红水碗藕，藕碗水红手。
郎笑藕丝长，长丝藕笑郎。————— 苏轼《菩萨蛮》

# **思路**
判断一个字符串是不是回文，常用的方法就是使用双指针。第一个指针从第一个字符向后移动，第二个指针从最后一个字符向前移动。若当前指针所指字符相同，则判断下一对字符，直到两个指针相遇。因为本题中只判断字母与数字，所以指针遇到其他字符则跳过。另外字母不区分大小写，则可以都转化为大写或者小写字母判断。

介绍几个比较有用的函数：
- isalpha ：判断一个字符是否为字母，如果是则返回true，否则返回false；
- isdigit : 判断一个字符是否表示数字，如果是则返回true，否则返回false；
- isalnum : 判断一个字符是否表示数字或者字母，如果是则返回true，否则返回false;
- islower : 判断一个字符是否为小写字母，如果是则返回true，否则返回false;
- isupper : 判断一个字符是否为大写字母，如果是则返回true，否则返回false；
- tolower : 若字符为字母则转化为小写字母；
- toupper : 若字符为字母则转化为大写字母；

代码如下，时间复杂度为 O(n)，空间复杂度为 O(1)。
```
class Solution {
public:
    bool isPalindrome(string s) {
        int i = 0;
        int j = s.size() - 1;
        while (i < j) {
            if (!isalnum(s[i])) {
                i++;
            }
            else if (!isalnum(s[j])) {
                j--;
            }
            else {
                if (tolower(s[i]) != tolower(s[j])) {
                    return false;
                }
                else {
                    i++;
                    j--;
                }
            } 
        }
        return true;
    } 
};
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    7340    |    14165    |   51.8%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
