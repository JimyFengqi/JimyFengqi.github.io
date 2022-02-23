---
title: 剑指 Offer II 090-环形房屋偷盗
date: 2021-12-03 21:32:18
categories:
  - 中等
tags:
  - 数组
  - 动态规划
---

> 原文链接: https://leetcode-cn.com/problems/PzWKhm




## 中文题目
<div><p>一个专业的小偷，计划偷窃一个环形街道上沿街的房屋，每间房内都藏有一定的现金。这个地方所有的房屋都 <strong>围成一圈</strong> ，这意味着第一个房屋和最后一个房屋是紧挨着的。同时，相邻的房屋装有相互连通的防盗系统，<strong>如果两间相邻的房屋在同一晚上被小偷闯入，系统会自动报警</strong> 。</p>

<p>给定一个代表每个房屋存放金额的非负整数数组 <code>nums</code> ，请计算&nbsp;<strong>在不触动警报装置的情况下</strong> ，今晚能够偷窃到的最高金额。</p>

<p>&nbsp;</p>

<p><strong>示例&nbsp;1：</strong></p>

<pre>
<strong>输入：</strong>nums = [2,3,2]
<strong>输出：</strong>3
<strong>解释：</strong>你不能先偷窃 1 号房屋（金额 = 2），然后偷窃 3 号房屋（金额 = 2）, 因为他们是相邻的。
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>nums = [1,2,3,1]
<strong>输出：</strong>4
<strong>解释：</strong>你可以先偷窃 1 号房屋（金额 = 1），然后偷窃 3 号房屋（金额 = 3）。
&nbsp;    偷窃到的最高金额 = 1 + 3 = 4 。</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>nums = [0]
<strong>输出：</strong>0
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 100</code></li>
	<li><code>0 &lt;= nums[i] &lt;= 1000</code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 213&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/house-robber-ii/">https://leetcode-cn.com/problems/house-robber-ii/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# **动态规划**
本题与面试题 89 [《剑指offer 2 面试题89》 书中算法C++实现](https://leetcode-cn.com/problems/Gu0c2T/solution/jian-zhi-offer-2-mian-shi-ti-89-shu-zhon-86xo/) 的唯一不同是，本题的房屋连成一圈，那么下标为 0 和下标为 n - 1 的房屋就是相邻的。如果他考虑去下标为 0 的房屋，那么就不再考虑下标为 n - 1 的房屋；如果他考虑去下标为 n - 1的房屋，那么就不再考虑下标为 0 的房屋。所以可以将该问题拆分为两个小问题：一个是求小偷从下标为 0 的房屋开始到下标为 n - 2 的房屋结束能偷得的最大财物，另一个是求小偷从下标为 1 的房屋开始到下标为 n - 1 的房屋结束能偷得的最大财物。最终的大问题的解就是这两个小问题的最大值。

代码可以根据修改面试题 89 的代码得到，单状态动态规划和双状态动态规划的代码如下，时间复杂度为 O(n)，空间复杂度为 O(1)。

1. 单状态动态规划
```
class Solution {
private:
    int helper(vector<int>& nums, int start, int end) {
        if (start == end) {
            return nums[start];
        }
        vector<int> dp(2, 0);
        dp[start % 2] = nums[start];
        dp[(start + 1) % 2] = max(nums[start], nums[start + 1]);
        for (int i = start + 2; i <= end; ++i) {
            dp[i % 2] = max(dp[(i - 2) % 2] + nums[i], dp[(i - 1) % 2]);
        }
        return max(dp[0], dp[1]);
    }

public:
    int rob(vector<int>& nums) {
        if (nums.size() == 1) {
            return nums[0];
        }
        int len = nums.size();
        return max(helper(nums, 0, len - 2), helper(nums, 1, len - 1));
    }
};
```

2. 双状态动态规划

```
class Solution {
private:
    int helper(vector<int>& nums, int start, int end) {
        vector<vector<int>> dp(2,vector<int>(2));
        dp[start % 2][0] = 0;
        dp[start % 2][1] = nums[start];
        for (int i = start + 1; i <= end; ++i) {
            dp[i % 2][0] = max(dp[(i - 1) % 2][0], dp[(i - 1) % 2][1]);
            dp[i % 2][1] = dp[(i - 1) % 2][0] + nums[i];
        }
        return max(dp[end % 2][0], dp[end % 2][1]);
    }

public:
    int rob(vector<int>& nums) {
        if (nums.size() == 1) {
            return nums[0];
        }
        int len = nums.size();
        return max(helper(nums, 0, len - 2), helper(nums, 1, len - 1));
    }
};
```



## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    2483    |    4941    |   50.3%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
