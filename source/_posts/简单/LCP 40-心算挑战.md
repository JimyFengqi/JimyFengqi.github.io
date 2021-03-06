---
title: LCP 40-心算挑战
categories:
  - 简单
tags:
  - 贪心
  - 数组
  - 排序
abbrlink: 2821402400
date: 2021-12-03 21:28:01
---

> 原文链接: https://leetcode-cn.com/problems/uOAnQW


## 英文原文
<div></div>

## 中文题目
<div>「力扣挑战赛」心算项目的挑战比赛中，要求选手从 `N` 张卡牌中选出 `cnt` 张卡牌，若这 `cnt` 张卡牌数字总和为偶数，则选手成绩「有效」且得分为 `cnt` 张卡牌数字总和。
给定数组 `cards` 和 `cnt`，其中 `cards[i]` 表示第 `i` 张卡牌上的数字。 请帮参赛选手计算最大的有效得分。若不存在获取有效得分的卡牌方案，则返回 0。

**示例 1：**
>输入：`cards = [1,2,8,9], cnt = 3`
>
>输出：`18`
>
>解释：选择数字为 1、8、9 的这三张卡牌，此时可获得最大的有效得分 1+8+9=18。

**示例 2：**
>输入：`cards = [3,3,1], cnt = 1`
>
>输出：`0`
>
>解释：不存在获取有效得分的卡牌方案。

**提示：**
- `1 <= cnt <= cards.length <= 10^5`
- `1 <= cards[i] <= 1000`


</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
首先如何考虑构造`cnt`个数和为偶数，很明显有**偶数`k`个奇数+`cnt-k`个偶数**。但是怎么让结果最大呢？偶数之和和奇数之和尽可能大就行。

算法实现细节：
1. 对`cards`进行**逆序**排序，然后构造奇数和偶数前缀和数组`odd, even`。构建前缀和数组原因见下
2. 枚举所有组合中奇数的个数 `k`（`k`必须是偶数） 和 `cnt - k`（需判断是否足够）个偶数，它们都取**最大**则该轮组合结果最大。因此更新所有组合最大值就是答案。
```python3 []
class Solution:
    def maxmiumScore(self, cards: List[int], cnt: int) -> int:
        cards.sort(reverse=True)
        odd, even = [0], [0]  # 前缀和数组（向右偏移一个单位）
        for card in cards:
            if card & 1:
                odd.append(odd[-1] + card)
            else:
                even.append(even[-1] + card)
        
        # 枚举奇数个数
        ans = 0
        for k in range(0, len(odd), 2):  # 原序列中取偶数个奇数
            if 0 <= cnt - k < len(even):
                ans = max(ans, odd[k] + even[cnt-k])  # 前面都是最大的数
        return ans
```
**复杂度分析**：
+ **时间复杂度**：$O(n\log n)$
+ **空间复杂度**：$O(n)$

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    3249    |    13199    |   24.6%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
