---
title: LCP 17-速算机器人
categories:
  - 简单
tags:
  - 数学
  - 字符串
  - 模拟
abbrlink: 713361904
date: 2021-12-03 21:33:32
---

> 原文链接: https://leetcode-cn.com/problems/nGK0Fy


## 英文原文
<div></div>

## 中文题目
<div>小扣在秋日市集发现了一款速算机器人。店家对机器人说出两个数字（记作 `x` 和 `y`），请小扣说出计算指令：
- `"A"` 运算：使 `x = 2 * x + y`；
- `"B"` 运算：使 `y = 2 * y + x`。

在本次游戏中，店家说出的数字为 `x = 1` 和 `y = 0`，小扣说出的计算指令记作仅由大写字母 `A`、`B` 组成的字符串 `s`，字符串中字符的顺序表示计算顺序，请返回最终 `x` 与 `y` 的和为多少。

**示例 1：**
>输入：`s = "AB"`
> 
>输出：`4`
> 
>解释：
>经过一次 A 运算后，x = 2, y = 0。
>再经过一次 B 运算，x = 2, y = 2。
>最终 x 与 y 之和为 4。

**提示：**
- `0 <= s.length <= 10`
- `s` 由 `'A'` 和 `'B'` 组成


</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
目标结果是x+y
出现一个"A"，有x+y=(2x+y)+y=2x+2y
出现一个"B"，有x+y=x+(2y+x)=2x+2y
所以每出现一个A/B，都使x+y的值翻倍
因此结果是2**len(s)



PS：字节跳动内推啦，各位走过路过不要错过呀。
https://job.toutiao.com/s/eaHwWsg
实习/正式均可，工作地可选 北京/上海/杭州。有兴趣可私聊戳我。

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    24484    |    30678    |   79.8%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
