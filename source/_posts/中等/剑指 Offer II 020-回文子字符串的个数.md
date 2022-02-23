---
title: 剑指 Offer II 020-回文子字符串的个数
categories:
  - 中等
tags:
  - 字符串
  - 动态规划
abbrlink: 1210300321
date: 2021-12-03 21:32:32
---

> 原文链接: https://leetcode-cn.com/problems/a7VOhD




## 中文题目
<div><p>给定一个字符串 <code>s</code> ，请计算这个字符串中有多少个回文子字符串。</p>

<p>具有不同开始位置或结束位置的子串，即使是由相同的字符组成，也会被视作不同的子串。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>s = "abc"
<strong>输出：</strong>3
<strong>解释：</strong>三个回文子串: "a", "b", "c"
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>s =<strong> </strong>"aaa"
<strong>输出：</strong>6
<strong>解释：</strong>6个回文子串: "a", "a", "a", "aa", "aa", "aaa"</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= s.length &lt;= 1000</code></li>
	<li><code>s</code> 由小写英文字母组成</li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 647 题相同：<a href="https://leetcode-cn.com/problems/palindromic-substrings/">https://leetcode-cn.com/problems/palindromic-substrings/</a>&nbsp;</p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
我总结了剑指Offer专项训练的所有题目类型，并给出了刷题建议和所有题解。
在github上开源了，不来看看吗？顺道一提：还有C++、数据结构与算法、计算机网络、操作系统、数据库的秋招知识总结，求求star了，这对我真的很重要？

$\Rightarrow$[通关剑2](https://github.com/muluoleiguo/interview/tree/master/%E9%9D%A2%E8%AF%95/%E7%AE%97%E6%B3%95%E4%B8%8E%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/%E5%89%91%E6%8C%87Offer%E4%B8%93%E9%A1%B9%E8%AE%AD%E7%BB%83%EF%BC%88%E5%89%912%EF%BC%89)
### 解法一暴力枚举 O(n^3)
```cpp
class Solution {
private:
    // 双指针判断是否是回文
    bool isPalindrome(string& s, int left, int right) {
        while (left < right) {
            if (s[left++] != s[right--]) return false;
        }
        return true;
    }
public:
    int countSubstrings(string s) {
        // 暴力枚举端点的可能性
        int n = s.length(), ans = 0;
        for (int i = 0; i < n; ++i)
            for (int j = i; j < n; ++j) {
                if(isPalindrome(s, i, j)) ans++;
            }
        return ans;
    }
};
```
### 中心扩展 O(n^2)
枚举每一个可能的**中心**，然后用两个指针分别向左右两边拓展，当两个指针指向的元素相同的时候就继续，否则停止。

1. 如果回文长度是奇数，那么回文中心是一个字符；
2. 如果回文长度是偶数，那么中心是两个字符。


```
执行用时：4 ms, 在所有 C++ 提交中击败了78.79%的用户
内存消耗：6 MB, 在所有 C++ 提交中击败了98.99%的用户
```

```cpp
int countSubstrings(string s) {
        int n = s.length(), ans = 0;
        
        for (int i = 0; i < n; ++i) {
            // 中心是一个字符的
            int left = i, right = i;
            while (left >= 0 && right < n) {
                if (s[left] == s[right]) {
                    left--;
                    right++;
                    ans++;
                } else break;
            }
        }
        
        for (int i = 0; i < n - 1; ++i) {
            // 中心是俩的
            int left = i, right = i + 1;
            while (left >= 0 && right < n) {
                if (s[left] == s[right]) {
                    left--;
                    right++;
                    ans++;
                } else break;
            }
        }
        return ans;
    }
```

优化一下枚举中心的方法，这样子可以只用一个循环统一的写
```cpp
class Solution {
public:
    int countSubstrings(string s) {
        int n = s.length(), ans = 0;
        for (int i = 0; i < 2 * n - 1; ++i) {
            int left = i / 2, right = i / 2 + i % 2;
            while (left >= 0 && right < n && s[left] == s[right]) {
                --left;
                ++right;
                ++ans;
            }
        }
        return ans;
    }
};

```

### 动态规划 O(n^2)

```cpp
class Solution {
public:
    int countSubstrings(string s) {
        // 这个的确是用动态规划来做的，我有记忆，但是这个世界不一定美好
        int n = s.length(), ans = 0;
        vector<vector<bool>> dp(n, vector<bool>(n));
        // dp[i][j] 表示i...j这一段是不是回文串
        for (int i = 0; i < n; ++i)
            dp[i][i] = true;
        for (int len = 2; len <= n; ++len)
            for (int left = 0; left <= n - len; ++left) {
                // 典型的区间dp是吧，从小区间枚举到大区间
                int right = left + len - 1;
                if (right == left + 1 && s[left] == s[right]) {
                    dp[left][right] = true;
                    ans++;
                } else if (s[left] == s[right] && dp[left + 1][right - 1]) {
                    dp[left][right] = true;
                    ans++;
                } else dp[left][right] = false;
            }
        return ans + n;
    }
};
```

### Manacher 算法
TODO

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    5953    |    8331    |   71.5%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
