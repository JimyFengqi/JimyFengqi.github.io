---
title: LCP 25-古董键盘
categories:
  - 困难
tags:
  - 数学
  - 动态规划
  - 组合数学
abbrlink: 1027761295
date: 2021-12-03 21:33:33
---

> 原文链接: https://leetcode-cn.com/problems/Uh984O


## 英文原文
<div></div>

## 中文题目
<div>小扣在秋日市集购买了一个古董键盘。由于古董键盘年久失修，键盘上只有 26 个字母 **a~z** 可以按下，且每个字母最多仅能被按 `k` 次。

小扣随机按了 `n` 次按键，请返回小扣总共有可能按出多少种内容。由于数字较大，最终答案需要对 1000000007 (1e9 + 7) 取模。


**示例 1：**
>输入：`k = 1, n = 1`
> 
>输出：`26`
> 
>解释：由于只能按一次按键，所有可能的字符串为 "a", "b", ... "z" 

**示例 2：**
>输入：`k = 1, n = 2`
> 
>输出：`650`
> 
>解释：由于只能按两次按键，且每个键最多只能按一次，所有可能的字符串（按字典序排序）为 "ab", "ac", ... "zy" 

**提示：**
- `1 <= k <= 5`
- `1 <= n <= 26*k`
 

</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# 思路
### 动态规划

$dp[i][j]$表示总长度为$i$，用了前$j$种字母可能出现的字符串的数量，可以得到如下转移方程。
$$
dp[i][j]=\sum_{x=0}^kdp[i-x][j-1]·C_i^x
$$
其中，$x$表示第$j$种字母出现的次数，其值可以为$0,1,..k$，对于每一个$x$，都有$C_i^x$种位置可以选择。
例如，$x=2$，表示第$j$种字符出现了$2$次，他可能出现在前$i$个位置中的任意两个，是一个组合问题，其结果是$C_i^2$。
### C++代码

```cpp
class Solution {
public:
    int keyboard(int k, int n) {
        vector<vector<long long>> dp(n + 1, vector<long long>(27, 0L));
        for(int i = 0;i <= 26;i++)
            dp[0][i] = 1;
        for(int i = 1;i<=n;i++) {
            for(int j = 1;j <= 26;j++) {
                for(int x = 0;x <= k;x++) {
                    if(i-x >= 0)
                    dp[i][j] += dp[i-x][j-1]*C(i,x);
                }
                dp[i][j] %=  1000000007;
            }
        }
        return dp[n][26];
    }
    long long C(int m, int n) {
        int k = 1;
        long long ans=1;
        while(k <= n) {
            ans=((m-k+1)*ans)/k;
            k++;
        }
        return ans;
    }
};
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    1221    |    3596    |   34.0%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
