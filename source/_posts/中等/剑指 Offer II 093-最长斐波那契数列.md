---
title: 剑指 Offer II 093-最长斐波那契数列
date: 2021-12-03 21:32:11
categories:
  - 中等
tags:
  - 数组
  - 哈希表
  - 动态规划
---

> 原文链接: https://leetcode-cn.com/problems/Q91FMA




## 中文题目
<div><p>如果序列&nbsp;<code>X_1, X_2, ..., X_n</code>&nbsp;满足下列条件，就说它是&nbsp;<em>斐波那契式&nbsp;</em>的：</p>

<ul>
	<li><code>n &gt;= 3</code></li>
	<li>对于所有&nbsp;<code>i + 2 &lt;= n</code>，都有&nbsp;<code>X_i + X_{i+1} = X_{i+2}</code></li>
</ul>

<p>给定一个<strong>严格递增</strong>的正整数数组形成序列 <code>arr</code>&nbsp;，找到 <code>arr</code> 中最长的斐波那契式的子序列的长度。如果一个不存在，返回&nbsp;&nbsp;0 。</p>

<p><em>（回想一下，子序列是从原序列&nbsp; <code>arr</code> 中派生出来的，它从 <code>arr</code> 中删掉任意数量的元素（也可以不删），而不改变其余元素的顺序。例如，&nbsp;<code>[3, 5, 8]</code>&nbsp;是&nbsp;<code>[3, 4, 5, 6, 7, 8]</code>&nbsp;的一个子序列）</em></p>

<p>&nbsp;</p>

<ul>
</ul>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入: </strong>arr =<strong> </strong>[1,2,3,4,5,6,7,8]
<strong>输出: </strong>5
<strong>解释: </strong>最长的斐波那契式子序列为 [1,2,3,5,8] 。
</pre>

<p><strong>示例&nbsp;2：</strong></p>

<pre>
<strong>输入: </strong>arr =<strong> </strong>[1,3,7,11,12,14,18]
<strong>输出: </strong>3
<strong>解释</strong>: 最长的斐波那契式子序列有 [1,11,12]、[3,11,14] 以及 [7,11,18] 。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>3 &lt;= arr.length &lt;= 1000</code></li>
	<li>
	<p><code>1 &lt;= arr[i] &lt; arr[i + 1] &lt;= 10^9</code></p>
	</li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 873&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/length-of-longest-fibonacci-subsequence/">https://leetcode-cn.com/problems/length-of-longest-fibonacci-subsequence/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# **动态规划 + 哈希表**
从左往右扫描数组内的每一个数字，该数字可能和前面的不同的数字组成不同的斐波那契数列，如在数组 [1,2,3,4,5,6,7,8] 中数字 6 可以组成 2, 5, 6 和 2, 4, 6 两个斐波那契数列。也就是说，解决该问题需要若干步，每一步都面临若干选择，最后需要返回斐波那契数列的长度最大值，所以该问题可以用动态规划解决。

若当前扫描到数字 A[i]，那么 A[i] 前的数字 A[j] (j < i) 都可能与 A[i] 组成斐波那契数列，前提是存在 k < j 使得 A[i] = A[j] + A[k] 成立。这个以 A[i] 结尾前一个数字是 A[j] 的斐波那契数列，是在以 A[j] 结尾前一个数字是 A[k] 的斐波那契数列的基础上增加一个数字 A[i]，因此前者的长度是后者的长度加 1。

可以发现 A[i] 与  A[j] 密切相关，因此可以定义状态转移方程为 f(i, j) 表示以 A[i] 结尾前一个数字是 A[j] 的斐波那契数列长度。如果存在一个数字 k，使得 A[i] = A[j] + A[k] （0 <= k < j < i) 成立，那么 f(i, j) = f(j, k) + 1。若不存在这样的 k 那么 f(i, j) = 2，因为此时虽然 A[i] 和 A[j] 两个数字还不能形成有效的斐波那契数列，但是可能在之后增加一个新的数字就会形成斐波那契数列。

因为状态转移方程有两个参数，因此需要使用二维数组来保存，i 对应二维数组的行号，j 对应二维数组的列号。因为 j < i，所以只会使用二维数组的一半。如果数组的长度为 n，那么 i 的取值为 1 ~ n - 1，j 的取值为 1 ~ i。根据是否存在 k 使得 A[i] = A[j] + A[k] (0 <= k < j < i) 的情况，状态方程可以写成
![image.png](../images/Q91FMA-0.png)
因为需要查询 A[k] = A[i] - A[j] 是否存在，并且需要得到下标 k，所以需要一个哈希表将数组内所有的数字和下标保存下来供查询。完整的代码如下，时间复杂为 O(n^2)，空间复杂为 O(n^2)。

```
class Solution {
public:
    int lenLongestFibSubseq(vector<int>& arr) {
        vector<vector<int>> dp(arr.size(), vector<int>(arr.size()));
        unordered_map<int, int> mp;
        for (int i = 0; i < arr.size(); ++i) {
            mp[arr[i]] = i;
        }

        int ret = 0;
        for (int i = 1; i < arr.size(); ++i) {
            for (int j = 0; j < i; ++j) {
                int temp = arr[i] - arr[j];
                // 存在 k 使得 A[i] = A[j] + A[k] (0 <= k < j < i)
                if (mp.count(temp) && mp[temp] < j) {
                    dp[i][j] = dp[j][mp[temp]] + 1;
                }
                // 不存在 k 使得 A[i] = A[j] + A[k] (0 <= k < j < i)
                else {
                    dp[i][j] = 2;
                }
                ret = max(ret, dp[i][j]);
            }
        }

        return ret > 2 ? ret : 0;
    }
};
```

# **动态规划 + 二分查找**
其实也可以不使用哈希表处理，因为原数组是递增的，可以使用二分查找确定在下标区间 0 ~ j - 1 内是否存在 k 使得 A[k] = A[i] - A[j] 成立。完整代码如下，时间复杂为 O(n^2 logn)，空间复杂为 O(n^2)。

```
class Solution {
private:
    int search(vector<int>& nums, int right, int target) {
        int left = 0;
        while (left <= right) {
            int mid = left + ((right - left) >> 1);
            if (nums[mid] == target) {
                return mid;
            }
            nums[mid] > target ? right = mid - 1 : left = mid + 1;
        }
        return -1;
    }

public:
    int lenLongestFibSubseq(vector<int>& arr) {
        vector<vector<int>> dp(arr.size(), vector<int>(arr.size()));
        int ret = 0;
        for (int i = 1; i < arr.size(); ++i) {
            for (int j = 0; j < i; ++j) {
                int index = search(arr, j - 1, arr[i] - arr[j]);
                dp[i][j] = (index != -1) ? dp[j][index] + 1 : 2;
                ret = max(ret, dp[i][j]);
            }
        }

        return ret > 2 ? ret : 0;
    }
};
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    2318    |    4048    |   57.3%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
