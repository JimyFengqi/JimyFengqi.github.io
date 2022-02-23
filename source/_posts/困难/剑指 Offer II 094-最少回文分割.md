---
title: 剑指 Offer II 094-最少回文分割
categories:
  - 困难
tags:
  - 字符串
  - 动态规划
abbrlink: 2391449213
date: 2021-12-03 21:32:10
---

> 原文链接: https://leetcode-cn.com/problems/omKAoA




## 中文题目
<div><p>给定一个字符串 <code>s</code>，请将 <code>s</code> 分割成一些子串，使每个子串都是回文串。</p>

<p>返回符合要求的 <strong>最少分割次数</strong> 。</p>

<div class="original__bRMd">
<div>
<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>s = &quot;aab&quot;
<strong>输出：</strong>1
<strong>解释：</strong>只需一次分割就可将&nbsp;s<em> </em>分割成 [&quot;aa&quot;,&quot;b&quot;] 这样两个回文子串。
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>s = &quot;a&quot;
<strong>输出：</strong>0
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>s = &quot;ab&quot;
<strong>输出：</strong>1
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= s.length &lt;= 2000</code></li>
	<li><code>s</code> 仅由小写英文字母组成</li>
</ul>
</div>
</div>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 132&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/palindrome-partitioning-ii/">https://leetcode-cn.com/problems/palindrome-partitioning-ii/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
我总结了剑指Offer专项训练的所有题目类型，并给出了刷题建议和所有题解。

在github上开源了，不来看看吗？顺道一提：还有C++、数据结构与算法、计算机网络、操作系统、数据库的秋招知识总结，求求star了，这对我真的很重要？

$\Rightarrow$[通关剑2](https://github.com/muluoleiguo/interview/tree/master/%E9%9D%A2%E8%AF%95/%E7%AE%97%E6%B3%95%E4%B8%8E%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84/%E5%89%91%E6%8C%87Offer%E4%B8%93%E9%A1%B9%E8%AE%AD%E7%BB%83%EF%BC%88%E5%89%912%EF%BC%89)

---

* 首先判断s[i, j] 这一段是不是回文字符串，可以用双指针，但是有重复子问题，我们用dp先计算好。
#### 预处理方法一：区间DP（推荐写法）->找真
```cpp
int n = s.length();
// 初始化全false
vector<vector<bool>> isPalindrome(n, vector<bool>(n, false));
// 长度为1的是回文串
for (int i = 0; i < n; ++i) isPalindrome[i][i] = true;
// 从长度为2的子串开始枚举[left, right]
for (int len = 2; len <= n; ++len)
    // 左端点
    for (int left = 0; left + len <= n; ++left) {
        // 右端点
        int right = left + len - 1;
        // 长度为2就是这俩是否相等
        if (len == 2) isPalindrome[left][right] = (s[left] == s[right]);
        // 长度大于2, 端点相同的同时，内侧也要是回文
        if (len > 2) isPalindrome[left][right] = (s[left] == s[right]) && isPalindrome[left + 1][right - 1];
    }

```
#### 预处理方法二: 还是区间DP（取巧）->去假
```cpp
int n = s.length();
vector<vector<bool>> isPalindrome(n, vector<bool>(n, true));
// [i, j] 左端点从倒数第二个开始，相当于从len == 2开始枚举
for (int i = n - 2; i >= 0; --i) {
    for (int j = i + 1; j < n; ++j) {
        isPalindrome[i][j] = (s[i] == s[j]) && isPalindrome[i + 1][j - 1];
    }
}
```
#### 明确状态
我们定义 dp[i] 为将  [0,i] 这一段字符分割为若干回文串的最小分割次数，那么最终答案为 dp[n - 1]。

#### 状态转移


考虑 dp[r]如何转移：

1. 从「起点字符」到「第 i 个字符」能形成回文串。那么最小分割次数为 0，此时有 dp[i] = 0；
2. 从「起点字符」到「第 i 个字符」不能形成回文串。此时我们需要枚举左端点 j，如果 [j, i] 这一段是回文串的话，那么有 dp[i] = dp[j - 1] + 1
在 2 中满足回文要求的左端点位置 j 可能有很多个，取最小

### 代码
```cpp
class Solution {
public:
    int minCut(string s) {
        int n = s.length();
        vector<vector<bool>> isPalindrome(n, vector<bool>(n));
        for (int i = 0; i < n; ++i) isPalindrome[i][i] = true;
        for (int len = 2; len <= n; ++len)
            for (int left = 0; left + len <= n; ++left) {
                int right = left + len - 1;
                if (len == 2) isPalindrome[left][right] = s[left] == s[right];
                if (len > 2) isPalindrome[left][right] = s[left] == s[right] && isPalindrome[left + 1][right - 1];
            }
        // dp[i] 代表[0, i] 这段最少分隔回文次数
        // 求最小，初始化最大为字符串长度，一一切割
        vector<int> dp(n, n);
        for (int i = 0; i < n; ++i) {
            if(isPalindrome[0][i]) dp[i] = 0;
            else {
                for (int j = 0; j < i; ++j) {
                    if (isPalindrome[j + 1][i]) {
                        dp[i] = min(dp[i], dp[j] + 1);
                    }
                }
            }
        }
        return dp[n - 1];
    }
};
```


#### Manacher马拉车
TODO

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    1909    |    3197    |   59.7%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
