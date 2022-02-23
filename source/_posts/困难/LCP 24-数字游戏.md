---
title: LCP 24-数字游戏
date: 2021-12-03 21:33:38
categories:
  - 困难
tags:
  - 数组
  - 数学
  - 堆（优先队列）
---

> 原文链接: https://leetcode-cn.com/problems/5TxKeK


## 英文原文
<div></div>

## 中文题目
<div>小扣在秋日市集入口处发现了一个数字游戏。主办方共有 `N` 个计数器，计数器编号为 `0 ~ N-1`。每个计数器上分别显示了一个数字，小扣按计数器编号升序将所显示的数字记于数组 `nums`。每个计数器上有两个按钮，分别可以实现将显示数字加一或减一。小扣每一次操作可以选择一个计数器，按下加一或减一按钮。

主办方请小扣回答出一个长度为 `N` 的数组，第 `i` 个元素(0 <= i < N)表示将 `0~i` 号计数器 **初始** 所示数字操作成满足所有条件 `nums[a]+1 == nums[a+1],(0 <= a < i)` 的最小操作数。回答正确方可进入秋日市集。

由于答案可能很大，请将每个最小操作数对 `1,000,000,007` 取余。


**示例 1：**
>输入：`nums = [3,4,5,1,6,7]`
>
>输出：`[0,0,0,5,6,7]`
>
>解释：
>i = 0，[3] 无需操作
>i = 1，[3,4] 无需操作；
>i = 2，[3,4,5] 无需操作；
>i = 3，将 [3,4,5,1] 操作成 [3,4,5,6], 最少 5 次操作；
>i = 4，将 [3,4,5,1,6] 操作成 [3,4,5,6,7], 最少 6 次操作；
>i = 5，将 [3,4,5,1,6,7] 操作成 [3,4,5,6,7,8]，最少 7 次操作；
>返回 [0,0,0,5,6,7]。


**示例 2：**
>输入：`nums = [1,2,3,4,5]`
>
>输出：`[0,0,0,0,0]`
>
>解释：对于任意计数器编号 i 都无需操作。

**示例 3：**
>输入：`nums = [1,1,1,2,3,4]`
>
>输出：`[0,1,2,3,3,3]`
>
>解释：
>i = 0，无需操作；
>i = 1，将 [1,1] 操作成 [1,2] 或 [0,1] 最少 1 次操作；
>i = 2，将 [1,1,1] 操作成 [1,2,3] 或 [0,1,2]，最少 2 次操作；
>i = 3，将 [1,1,1,2] 操作成 [1,2,3,4] 或 [0,1,2,3]，最少 3 次操作；
>i = 4，将 [1,1,1,2,3] 操作成 [-1,0,1,2,3]，最少 3 次操作；
>i = 5，将 [1,1,1,2,3,4] 操作成 [-1,0,1,2,3,4]，最少 3 次操作；
>返回 [0,1,2,3,3,3]。


**提示：**
- `1 <= nums.length <= 10^5`
- `1 <= nums[i] <= 10^3`

</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
**首先同步一下表达方式: 下文中所有 "数组 `nums` 的前 `i` 个元素" 均指 `nums[0]` 到 `nums[i]` 的 `i + 1` 个元素**

题目中要求满足 `nums[a] + 1 == nums[a + 1]`, 等价于满足 `nums[a] - a == nums[a + 1] - (a + 1)`, 所以我们可以先对数组进行预处理, 将每个`nums[i]` 替换为 `nums[i] - i`, 问题就变成寻找最小的操作次数使得数组的前 `i` 个元素相等, 假设操作后得到的这个相等的元素为 `median[i]`, 即:

$$median[i]=argmin_{x}\sum_{j=0}^{i}|nums[j]-x|$$

那么当前有奇数个元素时, `median[i]` 必然是数组前 `i` 个元素的中位数, 有偶数个元素时 `median[i]` 则可以是排序后最中间两个数构成的区间内的任意一个值 (不理解这一点的可以画一个数轴感受一下), 所以我们可以利用 [295. 数据流的中位数](https://leetcode-cn.com/problems/find-median-from-data-stream/) 中**维护两个堆**的方法快速求出 `nums` 数组前 `i` 个元素的中位数.

求得中位数后, 如果直接遍历 `[0, i]` 求需要的操作次数会超时, 所以我们将求中位数的算法稍加修改, 维护数据流较小的一半的和 `maxSum` (即小于中位数的所有数之和) 与较大的一半的和 `minSum` (即大于等于中位数的所有数之和), 即:

$$minSum=\sum_{j=0\cdots i, nums[j]\geq median[i]}nums[j]$$

$$maxSum=\sum_{j=0\cdots i, nums[j]<median[i]}nums[j]$$

那么:

$$\sum_{j=0}^{i}|nums[j]-median[i]|=minSum-card\left(\{j|nums[j]\geq median[i],0\leq j\leq i\}\right)\times median[i]\\+(card\left(\{j|nums[j]<median[i],0\leq j\leq i\}\right)\times median[i]-maxSum)$$

这样我们就不用数据流中每加入一个元素后重新求和, 从而以 $O(nlogn)$ 复杂度解决问题.

注意代码中 `minHeap` 代表的小顶堆维护的是数据流较大的一半, 而 `maxHeap` 则是较小的一半.

```
class Solution {
  public int[] numsGame(int[] nums) {
    int n = nums.length;
    int[] result = new int[n];
    for (int i = 0; i < n; i++)
      nums[i] -= i;
    result[0] = 0;
    MedianFinder finder = new MedianFinder();
    finder.addNum(nums[0]);
    for (int i = 1; i < n; i++) {
      finder.addNum(nums[i]);
      int median = finder.findMedian();
      long value = finder.minSum - (long) (finder.minHeap.size() - 1) * (long) median
          + ((long) (finder.maxHeap.size() - 1) * (long) median - finder.maxSum);
      result[i] = (int) (value % 1000000007);
    }
    return result;
  }
}

class MedianFinder {
  PriorityQueue<Integer> minHeap, maxHeap;
  long minSum = 0, maxSum = 0;

  public MedianFinder() {
    minHeap = new PriorityQueue<>();
    maxHeap = new PriorityQueue<>(1, (x, y) -> {
      long result = (long) y - (long) x;
      if (result > 0)
        return 1;
      if (result < 0)
        return -1;
      return 0;
    });
    minHeap.add(Integer.MAX_VALUE);
    maxHeap.add(Integer.MIN_VALUE);
  }

  private void adjust() {
    int maxSize = maxHeap.size(), minSize = minHeap.size();
    if (maxSize - minSize >= 2) {
      int num = maxHeap.poll();
      maxSum -= num;
      minHeap.add(num);
      minSum += num;
    } else if (minSize - maxSize >= 2) {
      int num = minHeap.poll();
      minSum -= num;
      maxHeap.add(num);
      maxSum += num;
    }
  }

  public void addNum(int num) {
    int lowerMax = maxHeap.peek();
    if (num <= lowerMax) {
      maxHeap.add(num);
      maxSum += num;
    } else {
      minHeap.add(num);
      minSum += num;
    }
    adjust();
  }

  public int findMedian() {
    if (maxHeap.size() > minHeap.size())
      return maxHeap.peek();
    else
      return minHeap.peek();
  }
}
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    956    |    3362    |   28.4%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
