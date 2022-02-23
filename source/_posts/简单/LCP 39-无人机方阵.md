---
title: LCP 39-无人机方阵
date: 2021-12-03 21:28:00
categories:
  - 简单
tags:
  - 数组
  - 哈希表
  - 计数
  - 矩阵
---

> 原文链接: https://leetcode-cn.com/problems/0jQkd0


## 英文原文
<div></div>

## 中文题目
<div>在 「力扣挑战赛」 开幕式的压轴节目 「无人机方阵」中，每一架无人机展示一种灯光颜色。 无人机方阵通过两种操作进行颜色图案变换：
- 调整无人机的位置布局
- 切换无人机展示的灯光颜色


给定两个大小均为 `N*M` 的二维数组 `source` 和 `target` 表示无人机方阵表演的两种颜色图案，由于无人机切换灯光颜色的耗能很大，请返回从 `source` 到 `target` 最少需要多少架无人机切换灯光颜色。


**注意：** 调整无人机的位置布局时无人机的位置可以随意变动。


**示例 1：**
> 输入：`source = [[1,3],[5,4]], target = [[3,1],[6,5]]`
>
> 输出：`1`
>
> 解释：
> 最佳方案为
将 `[0,1]` 处的无人机移动至 `[0,0]` 处；
将 `[0,0]` 处的无人机移动至 `[0,1]` 处；
将 `[1,0]` 处的无人机移动至 `[1,1]` 处；
将 `[1,1]` 处的无人机移动至 `[1,0]` 处，其灯光颜色切换为颜色编号为 `6` 的灯光；
因此从`source` 到 `target` 所需要的最少灯光切换次数为 1。
>![8819ccdd664e91c78cde3bba3c701986.gif](https://pic.leetcode-cn.com/1628823765-uCDaux-8819ccdd664e91c78cde3bba3c701986.gif){:height=300px}





**示例 2：**
> 输入：`source = [[1,2,3],[3,4,5]], target = [[1,3,5],[2,3,4]]`
>
> 输出：`0`
> 解释：
> 仅需调整无人机的位置布局，便可完成图案切换。因此不需要无人机切换颜色


**提示：**
`n == source.length == target.length`
`m == source[i].length == target[i].length`
`1 <= n, m <=100`
`1 <= source[i][j], target[i][j] <=10^4`



</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
### 解题思路
1. 题目说了target[i][j]<10的4次方，开辟数组p[10005]
2. 如果sorcesorce[i][j]出现，p[i*m+j]就加一
3. 如果target[i][j]出现，p[i*m+j]就减一
4. p数组为正的值，就是多出来没有找到相应灯的***，遍历一遍，相加即可


### 代码

```java
class Solution {
    public int minimumSwitchingTimes(int[][] source, int[][] target) {
        int n=source.length,m=source[0].length,sum=0;
        int[] p=new int[10005];
        for(int i=0;i<n*m;i++){
            p[source[i/m][i%m]]++;
            p[target[i/m][i%m]]--;
        }
        for(int i=0;i<10005;i++){
            if(p[i]>0) sum+=p[i];
        }
        return sum;
    }
}
```
![截屏2021-09-11 下午8.52.26.png](../images/0jQkd0-0.png)


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    4138    |    8079    |   51.2%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
