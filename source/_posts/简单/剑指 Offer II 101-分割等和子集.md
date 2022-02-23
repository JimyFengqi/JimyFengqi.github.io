---
title: 剑指 Offer II 101-分割等和子集
date: 2021-12-03 21:31:04
categories:
  - 简单
tags:
  - 数学
  - 字符串
  - 模拟
---

> 原文链接: https://leetcode-cn.com/problems/NUPfPr




## 中文题目
<div><p>给定一个非空的正整数数组 <code>nums</code> ，请判断能否将这些数字分成元素和相等的两部分。</p>

<p>&nbsp;</p>

<p><strong>示例&nbsp;1：</strong></p>

<pre>
<strong>输入：</strong>nums = [1,5,11,5]
<strong>输出：</strong>true
<strong>解释：</strong>nums<strong> </strong>可以分割成 [1, 5, 5] 和 [11] 。</pre>

<p><strong>示例&nbsp;2：</strong></p>

<pre>
<strong>输入：</strong>nums = [1,2,3,5]
<strong>输出：</strong>false
<strong>解释：</strong>nums<strong> </strong>不可以分为和相等的两部分
</pre>

<p>&nbsp;</p>

<p><meta charset="UTF-8" /></p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 200</code></li>
	<li><code>1 &lt;= nums[i] &lt;= 100</code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 416&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/partition-equal-subset-sum/">https://leetcode-cn.com/problems/partition-equal-subset-sum/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# **动态规划**
该问题的本质就是，能否从数组中选出若个数字，使它们的和等于 target = sum / 2，那么所有数字之和 sum 必须为偶数，若 sum 不为偶数则等和子集肯定不存在。有 n 个数字，每一步都判断该数字是否加入等和子集，最终需要判断组合的解的个数是否大于 0，所以该问题可以使用动态规划解决。更确切一点该问题属于 0 - 1 背包问题，此类问题的一般描述为：能否选择若干物品，使它们刚好放满一个容量为 t 的背包。若每种物品只有一个，则为 0 - 1 背包问题；若每个物品的个数有限，则为多重背包问题；若每个物品的个数无限，则为完全背包问题。

设 f(i, j) 表示能否从前 i 个物品(物品编号为 0 ~ i - 1)中选择若干物品放满容量为 j 的背包。对于 f(i, j) 存在两个选择，第一个选择是将标号为 i - 1 的物品放入背包，如果能从前 i - 1 个物品中选择若干物品放满容量为 j - nums[i - 1] 的背包(即 f(i - 1, j - nums[i - 1]) 为 true)，那么 f(i, j) 为 true。另一个选择是不把标号为 i - 1 的物品放入背包，如果能从前 i - 1 个物品中选择若干物品放满容量为 j 的背包(即 f(i - 1, j) 为 true)，那么 f(i, j) 为 true。即
![image.png](../images/NUPfPr-0.png)
当 j 等于 0 时，即背包容量为空，只要不选择物品就可以，所以 f(i, 0) 为 true。当 i 等于 0 时，即物品数量为 0，那么除了空背包都无法装满，所以当 j 大于 0 时，f(0, j) 为 fasle;

使用二维数组的完整代码如下，若数组长度为 n，所有数字之和为 t，那么时间复杂度为 O(nt)，空间复杂度为 O(nt)。
```
class Solution {
public:
    bool canPartition(vector<int>& nums) {
        int sum = 0;
        for (auto& n : nums) {
            sum += n;
        }
        if (sum & 1 != 0) {
            return false;
        }

        int target = sum >> 1;
        vector<vector<bool>> dp(nums.size() + 1, vector<bool>(target + 1, false));
        dp[0][0] = true;
        for (int i = 1; i <= nums.size(); ++i) {
            for (int j = 0; j <= target; ++j) {
                dp[i][j] = dp[i - 1][j];
                if (!dp[i][j] && j >= nums[i - 1]) {
                    dp[i][j] = dp[i - 1][j - nums[i - 1]];
                }
            }
        }
        return dp[nums.size()][target];
    }
};
```
在使用二维矩阵的时候可以发现，当前行其实是在前一行的基础上进行更新的，所以使用一维的数组可以无需复制前一行的数据直接更新，这样会更高效。但是要注意 j 是从大往小遍历，因为这样不会破坏之前的值。优化后时间复杂度为 O(nt)，空间复杂度为 O(t)。

```
class Solution {
public:
    bool canPartition(vector<int>& nums) {
        int sum = 0;
        for (auto& n : nums) {
            sum += n;
        }
        if (sum & 1 != 0) {
            return false;
        }

        int target = sum >> 1;
        vector<bool> dp(target + 1, false);
        dp[0] = true;
        for (int i = 0; i < nums.size(); ++i) {
            for (int j = target; j >= nums[i]; --j) {
                dp[j] = dp[j] || dp[j - nums[i]];
            }
        }
        return dp[target];
    }
};
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    3340    |    6869    |   48.6%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
