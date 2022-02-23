---
title: 剑指 Offer II 057-值和下标之差都在给定的范围内
categories:
  - 中等
tags:
  - 数组
  - 桶排序
  - 有序集合
  - 排序
  - 滑动窗口
abbrlink: 1333328996
date: 2021-12-03 21:28:35
---

> 原文链接: https://leetcode-cn.com/problems/7WqeDu




## 中文题目
<div><p>给你一个整数数组 <code>nums</code> 和两个整数&nbsp;<code>k</code> 和 <code>t</code> 。请你判断是否存在 <b>两个不同下标</b> <code>i</code> 和 <code>j</code>，使得&nbsp;<code>abs(nums[i] - nums[j]) &lt;= t</code> ，同时又满足 <code>abs(i - j) &lt;= k</code><em> </em>。</p>

<p>如果存在则返回 <code>true</code>，不存在返回 <code>false</code>。</p>

<p>&nbsp;</p>

<p><strong>示例&nbsp;1：</strong></p>

<pre>
<strong>输入：</strong>nums = [1,2,3,1], k<em> </em>= 3, t = 0
<strong>输出：</strong>true</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>nums = [1,0,1,1], k<em> </em>=<em> </em>1, t = 2
<strong>输出：</strong>true</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>nums = [1,5,9,1,5,9], k = 2, t = 3
<strong>输出：</strong>false</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>0 &lt;= nums.length &lt;= 2 * 10<sup>4</sup></code></li>
	<li><code>-2<sup>31</sup> &lt;= nums[i] &lt;= 2<sup>31</sup> - 1</code></li>
	<li><code>0 &lt;= k &lt;= 10<sup>4</sup></code></li>
	<li><code>0 &lt;= t &lt;= 2<sup>31</sup> - 1</code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 220&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/contains-duplicate-iii/">https://leetcode-cn.com/problems/contains-duplicate-iii/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# **暴力解法**
很直观的想法是，逐一扫描数组内的数字。对于数字 nums[i] ，需要逐次遍历在它前面的 k 个数字检查是否存在 [nums[i] - t, nyms[i] + t] 范围内的数字。代码如下，由两层循环组成，时间复杂度为 O(kn)，在本题中时间复杂度过高。

```
class Solution {
public:
    bool containsNearbyAlmostDuplicate(vector<int>& nums, int k, int t) {
        for (int i = k; i < nums.size(); ++i) {
            for (int j = i - k; j < i; ++j) {
                if (abs(static_cast<long>(nums[i]) - nums[j]) <= t) {
                    return true;
                }
            }
        }
        return false;
    }
};
```
# **set 解法** 
在暴力解法中其实一直在寻找是否存在落在 [nums[i] - t, nyms[i] + t] 的数，这个过程可以用平衡的二叉搜索树来加速，平衡的二叉树的搜索时间复杂度为 O(logk)。在 C+++ STL 中 set 和 map 属于关联容器，其内部由红黑树实现，红黑树是平衡二叉树的一种优化实现，其搜索时间复杂度也为 O(logk)。逐次扫码数组，对于每个数字 nums[i]，当前的 set 应该由其前 k 个数字组成，可以 lower_bound 函数可以从 set 中找到符合大于等于 nums[i] - t 的最小的数，若该数存在且小于等于 nums[i] + t，则找到了符合要求的一对数。

代码如下，时间复杂度为 O(nlogk)，另外可能存在用 int 表示溢出情况，可以通过一些特殊处理，避免 int 溢出的情况。
```
class Solution {
public:
    bool containsNearbyAlmostDuplicate(vector<int>& nums, int k, int t) {
        set<int> st;
        for (int i = 0; i < nums.size(); ++i) {
            int lowerLimit = max(nums[i], INT_MIN + t) - t;
            int upperLimit = min(nums[i], INT_MAX - t) + t;
            auto it = st.lower_bound(lowerLimit);
            if (it != st.end() && *it <= upperLimit) {
                return true;
            }
            st.insert(nums[i]);
            if (i >= k) {
                st.erase(nums[i - k]);
            }
        }
        return false;
    }
};
```
# **桶解法**
换一种思路考虑该问题，因为题目只关心的是差的绝对值小于等于 t 的数字，这时候容易联想到桶，可以把数字放进若干个大小为 t + 1 的桶内，这样的好处是一个桶内的数字绝对值差肯定小于等于 t。对于桶的标号进行说明，例如 [0, t] 放进编号为 0 的桶内，[t + 1, 2t + 1] 放进编号为 1 的桶内，对于负数，则 [-t - 1, -1] 放进编号为 -1 的桶内，[-2t - 2, -t - 2] 编号为 -2 的桶内，可以发现桶 
- **n >= 0 :** ID = n / (t + 1);
- **n <  0 :** ID = (n + 1) / (t + 1) - 1;

另外需要一个哈希表保存扫描到数字的前 k 个数字的桶的编号，key → val 为 ID → num。在算法中依次扫描数组，扫描到 nums[i]，首先得到 nums[i] 的桶ID，先查询前 k 个数字中是否也有在 ID 桶内的数字，如果存在则该数字与 nums[i] 的差的绝对值肯定小于等于 t。另外若不存在，则需要查询 ID - 1 和 ID + 1 内的桶，因为也有可能存在与 nums[i] 的差绝对值差小于等于 t 的数字，但是这两个桶内的数字若存在还需要验证是否与 nums[i] 的差的绝对值小于等于 t。只要依次检查这三个桶即可，因为其他桶内的数字肯定不符合要求。

桶算法的时间复杂度为 O(n)，另外还是要考虑到 int 表示的溢出问题。
```
class Solution {
public:
    bool containsNearbyAlmostDuplicate(vector<int>& nums, int k, int t) {
        unordered_map<int, int> mp;
        long bucketSize = static_cast<long>(t) + 1;
        for (int i = 0; i < nums.size(); ++i) {
            int num = nums[i];
            int ID = getBucketID(num, bucketSize);
            if (mp.count(ID) 
            || (mp.count(ID - 1) &&  min(INT_MAX - t, mp[ID - 1]) + t >= num)
            || (mp.count(ID + 1) &&  max(INT_MIN + t, mp[ID + 1]) - t <= num)) {
                return true;
            }
            mp[ID] = num;
            if (i >= k) {
                mp.erase(getBucketID(nums[i - k], bucketSize));
            }
        }
        return false;
    }

private:
    int getBucketID(int n, long size) {
        return (n >= 0) ? n / size : (n + 1) / size - 1;
    }
};
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    2321    |    6482    |   35.8%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
