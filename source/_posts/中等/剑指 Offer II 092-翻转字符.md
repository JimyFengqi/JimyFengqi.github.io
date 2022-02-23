---
title: 剑指 Offer II 092-翻转字符
categories:
  - 中等
tags:
  - 字符串
  - 动态规划
abbrlink: 1400284489
date: 2021-12-03 21:32:13
---

> 原文链接: https://leetcode-cn.com/problems/cyJERH




## 中文题目
<div><p>如果一个由&nbsp;<code>&#39;0&#39;</code> 和 <code>&#39;1&#39;</code>&nbsp;组成的字符串，是以一些 <code>&#39;0&#39;</code>（可能没有 <code>&#39;0&#39;</code>）后面跟着一些 <code>&#39;1&#39;</code>（也可能没有 <code>&#39;1&#39;</code>）的形式组成的，那么该字符串是&nbsp;<strong>单调递增&nbsp;</strong>的。</p>

<p>我们给出一个由字符 <code>&#39;0&#39;</code> 和 <code>&#39;1&#39;</code>&nbsp;组成的字符串 <font color="#c7254e" face="Menlo, Monaco, Consolas, Courier New, monospace"><span style="caret-color: rgb(199, 37, 78); font-size: 12.600000381469727px; background-color: rgb(249, 242, 244);">s</span></font>，我们可以将任何&nbsp;<code>&#39;0&#39;</code> 翻转为&nbsp;<code>&#39;1&#39;</code>&nbsp;或者将&nbsp;<code>&#39;1&#39;</code>&nbsp;翻转为&nbsp;<code>&#39;0&#39;</code>。</p>

<p>返回使 <font color="#c7254e" face="Menlo, Monaco, Consolas, Courier New, monospace"><span style="caret-color: rgb(199, 37, 78); font-size: 12.600000381469727px; background-color: rgb(249, 242, 244);">s</span></font>&nbsp;<strong>单调递增&nbsp;</strong>的最小翻转次数。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>s =<strong> </strong>&quot;00110&quot;
<strong>输出：</strong>1
<strong>解释：</strong>我们翻转最后一位得到 00111.
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>s =<strong> </strong>&quot;010110&quot;
<strong>输出：</strong>2
<strong>解释：</strong>我们翻转得到 011111，或者是 000111。
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>s =<strong> </strong>&quot;00011000&quot;
<strong>输出：</strong>2
<strong>解释：</strong>我们翻转得到 00000000。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= s.length &lt;= 20000</code></li>
	<li><font color="#c7254e" face="Menlo, Monaco, Consolas, Courier New, monospace"><span style="caret-color: rgb(199, 37, 78); font-size: 12.600000381469727px; background-color: rgb(249, 242, 244);">s</span></font> 中只包含字符&nbsp;<code>&#39;0&#39;</code>&nbsp;和&nbsp;<code>&#39;1&#39;</code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 926&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/flip-string-to-monotone-increasing/">https://leetcode-cn.com/problems/flip-string-to-monotone-increasing/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
由题意由字符‘0’和‘1’构成的字符串，字符之间可以相互转换，求原字符串得到一个单调递增字符串的最小转换次数。

这是典型的求解问题有多个步骤，每个步骤又有若干个选择的问题，若是要求过程步骤中所有得到的结果，则应想到用回溯法思想解决该问题，但这是要求问题的最优解，我们应该想到运用动态规划算法。如果能找到状态转移方程和最小子问题的解，动态规划问题就可迎刃而解。
时间上因为肯定需要遍历一次字符串，时间复杂度肯定是O(n)无法再优化，但空间复杂度却可以优化。下面用三种方法逐步进行优化并在法一分析最小子问题的解以及状态方程是如何转移的：

# 法一 空间复杂度O(n)：
因为字符可以有两个状态0或1，我们可以用两个数组zero[i]和one[i]保存当前下标是i的字符是‘0’和‘1’的最小转换次数。分析遍历字符串时字符的两种情况：

***一.若当前字符i下标的字符是‘0’:***
  zero[i]不需要转换，zero[i] = zero[i-1].
  one[i]需要将‘0’转换为‘1’,有两种情况：1.若前一位是‘0’转换的‘1’,则one[i] = one[i-1] + 1;
                                  2.若前一位本身就是'1',则one[i] = zero[i-1] + 1;
                                 即one[i]为两数组保存的前一位的最小值+1，one[i] = Math.min(one[i-1], zero[i-1]) + 1.

***二.若当前下标i的字符为‘1’:***
zero[i]需要把'1'转换成'0',当前位的最小转换次数应该比前一位转换次数多一次，即zero[i] = zero[i-1] + 1.
one[i]不需要转换,但也有两种情况：1.若前一位是‘0’，则one[i] = zero[i-1];
                             2.若前一位是‘1’，则one[i] = one[i-1];
                             即one[i]为两数组保存的前一位的最小值，one[i] = Math.min(one[i-1], zero[i-1]).


而它们的最小子问题的解即初始状态下标i=0的字符是‘0’则zero[0] = 0, one[0] = 1, i=0的字符是‘1’则zero[0] = 1, one[0] = 0, 遍历完字符串后两数组最后一位对应的数字即为各自转换过程得到的满足单调递增的最小转换次数.代码如下：
```
class Solution {
    public int minFlipsMonoIncr(String s) {
        int n = s.length();
        int[] zero = new int[n];
        int[] one = new int[n];
        zero[0] = s.charAt(0) == '0' ? 0 : 1;
        one[0] =s.charAt(0) == '0' ? 1 : 0;
        for(int i = 1; i < n; ++i){
            if(s.charAt(i) == '0'){
                zero[i] = zero[i-1];
                one[i] = Math.min(one[i-1], zero[i-1]) + 1;
            }else if(s.charAt(i) == '1'){
                zero[i] = zero[i-1] + 1;
                one[i] = Math.min(one[i-1], zero[i-1]);
            }
        }
        return Math.min(one[n-1], zero[n-1]);
    }
}
```

# 法二 空间复杂度O(1):

分析完状态转移方程后可以发现，当前位的最小转换次数仅依赖于前一位的最小转换次数，所以不必用一个完整数组的空间来保存所有对应下标的最小转换次数，仅用两个空间即可，dp[0][i]表示zero[i], dp[1][i]表示one[i], 这样仅用两个数组单位就可得到最优解，大大降低了空间复杂度。最后注意字符串长度是奇数还是偶数决定dp数组第二维对应的哪一个下标保存字符串末位的最小转换次数。对应代码如下：
```
class Solution {
    public int minFlipsMonoIncr(String s) {
        int n = s.length();
        int[][] dp = new int[2][2];
        dp[0][0] = s.charAt(0) == '0' ? 0 : 1;
        dp[1][0] = s.charAt(0) == '1' ? 0 : 1;
        for(int i = 1; i < n; ++i){
            dp[0][i % 2] = s.charAt(i) == '0' ? dp[0][(i-1) % 2] : dp[0][(i-1) % 2]+1; 
            dp[1][i % 2] = s.charAt(i) == '1' ? Math.min(dp[1][(i-1) % 2], dp[0][(i-1) % 2]) : Math.min(dp[1][(i-1) % 2], dp[0][(i-1) % 2])+1;
        }
        int last = (n-1)%2;
        return Math.min(dp[0][last], dp[1][last]);
    }
}
```

# 法三 空间复杂度O(1):

在法二的基础上并理解了状态转移方程和最小子问题的解以后，我们还可以再优化仅用两个变量就可保存前一位的最小转换次数，代码如下：
```
class Solution {
    public int minFlipsMonoIncr(String s) {
        int n = s.length();
        int one = 0, zero = 0;
        for(char c : s.toCharArray()){
            if(c == '0') one = Math.min(zero, one) + 1;
            else if(c == '1'){
                one = Math.min(zero, one);
                zero++;
            }
        }
        return Math.min(one, zero);
    }
}
```

这样一步步分析并优化大大降低了动态规划算法的复杂度。




## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    2723    |    4030    |   67.6%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
