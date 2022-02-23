---
title: LCP 33-蓄水
categories:
  - 简单
tags:
  - 贪心
  - 数组
  - 堆（优先队列）
abbrlink: 1642444175
date: 2021-12-03 21:33:18
---

> 原文链接: https://leetcode-cn.com/problems/o8SXZn


## 英文原文
<div></div>

## 中文题目
<div>给定 N 个无限容量且初始均空的水缸，每个水缸配有一个水桶用来打水，第 `i` 个水缸配备的水桶容量记作 `bucket[i]`。小扣有以下两种操作：
-  升级水桶：选择任意一个水桶，使其容量增加为 `bucket[i]+1`
-  蓄水：将全部水桶接满水，倒入各自对应的水缸

每个水缸对应最低蓄水量记作 `vat[i]`，返回小扣至少需要多少次操作可以完成所有水缸蓄水要求。

注意：实际蓄水量 **达到或超过** 最低蓄水量，即完成蓄水要求。

**示例 1：**
>输入：`bucket = [1,3], vat = [6,8]`
>
>输出：`4`
>
>解释：
>第 1 次操作升级 bucket[0]；
>第 2 ~ 4 次操作均选择蓄水，即可完成蓄水要求。
![vat1.gif](https://pic.leetcode-cn.com/1616122992-RkDxoL-vat1.gif)



**示例 2：**
>输入：`bucket = [9,0,1], vat = [0,2,2]`
>
>输出：`3`
>
>解释：
>第 1 次操作均选择升级 bucket[1]
>第 2~3 次操作选择蓄水，即可完成蓄水要求。

**提示：**
- `1 <= bucket.length == vat.length <= 100`
- `0 <= bucket[i], vat[i] <= 10^4`
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
#### 前言

由于本题是「力扣杯」的竞赛题，因此只会给出提示、简要思路以及代码，不会对算法本身进行详细说明，希望读者多多思考。

#### 提示 $1$

显然应该把所有「升级水桶」的操作放在「蓄水」操作之前。

#### 提示 $2$

枚举「蓄水」的次数，倒推出每个水桶的容量，并计算出「升级水桶」的操作次数。

#### 思路

我们枚举「蓄水」的次数 $k$，那么对于容量为 $v$ 的水缸，就至少需要一个容量为

$$
\lceil \frac{v}{k} \rceil
$$

的水桶，其中 $\lceil x \rceil$ 表示对 $x$ 向上取整。这样我们就能计算出每个水桶需要「升级」多少次了。

#### 代码

```C++ [sol1-C++]
class Solution {
public:
    int storeWater(vector<int>& bucket, vector<int>& vat) {
        int n = bucket.size();
        int maxk = *max_element(vat.begin(), vat.end());
        if (!maxk) {
            return 0;
        }

        int ans = INT_MAX;
        for (int k = 1; k <= maxk; ++k) {
            int cur = k;
            for (int i = 0; i < n; ++i) {
                int least = vat[i] / k + (vat[i] % k != 0);
                cur += max(least - bucket[i], 0);
            }
            ans = min(ans, cur);
        }
        return ans;
    }
};
```



## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    4920    |    22107    |   22.3%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
