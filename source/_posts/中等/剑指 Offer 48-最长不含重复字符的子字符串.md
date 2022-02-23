---
title: 剑指 Offer 48-最长不含重复字符的子字符串(最长不含重复字符的子字符串 LCOF)
date: 2021-12-03 21:37:23
categories:
  - 中等
tags:
  - 哈希表
  - 字符串
  - 滑动窗口
---

> 原文链接: https://leetcode-cn.com/problems/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof




## 中文题目
<div><p>请从字符串中找出一个最长的不包含重复字符的子字符串，计算该最长子字符串的长度。</p>

<p>&nbsp;</p>

<p><strong>示例&nbsp;1:</strong></p>

<pre><strong>输入: </strong>&quot;abcabcbb&quot;
<strong>输出: </strong>3 
<strong>解释:</strong> 因为无重复字符的最长子串是 <code>&quot;abc&quot;，所以其</code>长度为 3。
</pre>

<p><strong>示例 2:</strong></p>

<pre><strong>输入: </strong>&quot;bbbbb&quot;
<strong>输出: </strong>1
<strong>解释: </strong>因为无重复字符的最长子串是 <code>&quot;b&quot;</code>，所以其长度为 1。
</pre>

<p><strong>示例 3:</strong></p>

<pre><strong>输入: </strong>&quot;pwwkew&quot;
<strong>输出: </strong>3
<strong>解释: </strong>因为无重复字符的最长子串是&nbsp;<code>&quot;wke&quot;</code>，所以其长度为 3。
&nbsp;    请注意，你的答案必须是 <strong>子串 </strong>的长度，<code>&quot;pwke&quot;</code>&nbsp;是一个<em>子序列，</em>不是子串。
</pre>

<p>&nbsp;</p>

<p>提示：</p>

<ul>
	<li><code>s.length &lt;= 40000</code></li>
</ul>

<p>注意：本题与主站 3 题相同：<a href="https://leetcode-cn.com/problems/longest-substring-without-repeating-characters/">https://leetcode-cn.com/problems/longest-substring-without-repeating-characters/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
#### 解题思路：

长度为 $N$ 的字符串共有 $\frac{(1 + N)N}{2}$ 个子字符串（复杂度为 $O(N^2)$ ），判断长度为 $N$ 的字符串是否有重复字符的复杂度为 $O(N)$ ，因此本题使用暴力法解决的复杂度为 $O(N^3)$ 。考虑使用动态规划降低时间复杂度。

##### 动态规划解析：

- **状态定义：** 设动态规划列表 $dp$ ，$dp[j]$ 代表以字符 $s[j]$ 为结尾的 “最长不重复子字符串” 的长度。
- **转移方程：** 固定右边界 $j$ ，设字符 $s[j]$ 左边距离最近的相同字符为  $s[i]$ ，即 $s[i] = s[j]$ 。
  1. 当 $i < 0$ ，即 $s[j]$ 左边无相同字符，则 $dp[j] = dp[j-1] + 1$ ；
  2. 当 $dp[j - 1] < j - i$ ，说明字符 $s[i]$ 在子字符串 $dp[j-1]$ **区间之外** ，则 $dp[j] = dp[j - 1] + 1$ ；
  3. 当 $dp[j - 1] \geq j - i$ ，说明字符 $s[i]$ 在子字符串 $dp[j-1]$ **区间之中** ，则 $dp[j]$ 的左边界由 $s[i]$ 决定，即 $dp[j] = j - i$ ；

  > 当 $i < 0$ 时，由于 $dp[j - 1] \leq j$ 恒成立，因而 $dp[j - 1] < j - i$ 恒成立，因此分支 `1.` 和 `2.` 可被合并。

$$
dp[j] =
\begin{cases}
dp[j - 1] + 1 & , dp[j-1] < j - i \\
j - i & , dp[j-1] \geq j - i
\end{cases}
$$

- **返回值：** $\max(dp)$ ，即全局的 “最长不重复子字符串” 的长度。

![Picture1.png](../images/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof-0.png){:width=500}

##### 空间复杂度优化：

- 由于返回值是取 $dp$ 列表最大值，因此可借助变量 $tmp$ 存储 $dp[j]$ ，变量 $res$ 每轮更新最大值即可。
- 此优化可节省 $dp$ 列表使用的 $O(N)$ 大小的额外空间。

> 观察转移方程，可知问题为：每轮遍历字符 $s[j]$ 时，如何计算索引 $i$ ？
> 以下介绍 **哈希表** ， **线性遍历** 两种方法。

#### 方法一：动态规划 + 哈希表

- **哈希表统计：** 遍历字符串 $s$ 时，使用哈希表（记为 $dic$ ）统计 **各字符最后一次出现的索引位置** 。
- **左边界 $i$ 获取方式：** 遍历到 $s[j]$ 时，可通过访问哈希表 $dic[s[j]]$ 获取最近的相同字符的索引 $i$ 。

##### 复杂度分析：

- **时间复杂度 $O(N)$ ：** 其中 $N$ 为字符串长度，动态规划需遍历计算 $dp$ 列表。
- **空间复杂度 $O(1)$ ：** 字符的 ASCII 码范围为 $0$ ~ $127$ ，哈希表 $dic$ 最多使用 $O(128) = O(1)$ 大小的额外空间。

<![Picture2.png](../images/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof-1.png),![Picture3.png](../images/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof-2.png),![Picture4.png](../images/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof-3.png),![Picture5.png](../images/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof-4.png),![Picture6.png](../images/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof-5.png),![Picture7.png](../images/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof-6.png),![Picture8.png](../images/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof-7.png),![Picture9.png](../images/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof-8.png),![Picture10.png](../images/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof-9.png),![Picture11.png](../images/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof-10.png)>

##### 代码：

> Python 的 $get(key, default)$ 方法和 Java 的 $getOrDefault(key, default)$ ， 代表当哈希表包含键 $key$ 时返回对应 $value$ ，不包含时返回默认值 $default$ 。

```Python []
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        dic = {}
        res = tmp = 0
        for j in range(len(s)):
            i = dic.get(s[j], -1) # 获取索引 i
            dic[s[j]] = j # 更新哈希表
            tmp = tmp + 1 if tmp < j - i else j - i # dp[j - 1] -> dp[j]
            res = max(res, tmp) # max(dp[j - 1], dp[j])
        return res
```

```Java []
class Solution {
    public int lengthOfLongestSubstring(String s) {
        Map<Character, Integer> dic = new HashMap<>();
        int res = 0, tmp = 0;
        for(int j = 0; j < s.length(); j++) {
            int i = dic.getOrDefault(s.charAt(j), -1); // 获取索引 i
            dic.put(s.charAt(j), j); // 更新哈希表
            tmp = tmp < j - i ? tmp + 1 : j - i; // dp[j - 1] -> dp[j]
            res = Math.max(res, tmp); // max(dp[j - 1], dp[j])
        }
        return res;
    }
}
```

#### 方法二： 动态规划 + 线性遍历

- **左边界 $i$ 获取方式：** 遍历到 $s[j]$ 时，初始化索引 $i = j - 1$ ，向左遍历搜索第一个满足 $s[i] = s[j]$ 的字符即可 。

##### 复杂度分析：

- **时间复杂度 $O(N^2)$ ：** 其中 $N$ 为字符串长度，动态规划需遍历计算 $dp$ 列表，占用 $O(N)$ ；每轮计算 $dp[j]$ 时搜索 $i$ 需要遍历 $j$ 个字符，占用 $O(N)$ 。
- **空间复杂度 $O(1)$ ：** 几个变量使用常数大小的额外空间。

##### 代码：

```Python []
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        res = tmp = i = 0
        for j in range(len(s)):
            i = j - 1
            while i >= 0 and s[i] != s[j]: i -= 1 # 线性查找 i
            tmp = tmp + 1 if tmp < j - i else j - i # dp[j - 1] -> dp[j]
            res = max(res, tmp) # max(dp[j - 1], dp[j])
        return res
```

```Java []
class Solution {
    public int lengthOfLongestSubstring(String s) {
        Map<Character, Integer> dic = new HashMap<>();
        int res = 0, tmp = 0;
        for(int j = 0; j < s.length(); j++) {
            int i = j - 1;
            while(i >= 0 && s.charAt(i) != s.charAt(j)) i--; // 线性查找 i
            tmp = tmp < j - i ? tmp + 1 : j - i; // dp[j - 1] -> dp[j]
            res = Math.max(res, tmp); // max(dp[j - 1], dp[j])
        }
        return res;
    }
}
```

#### 方法三：双指针 + 哈希表

> 本质上与方法一类似，不同点在于左边界 $i$ 的定义。

- **哈希表 $dic$ 统计：** 指针 $j$ 遍历字符 $s$ ，哈希表统计字符 $s[j]$ **最后一次出现的索引** 。
- **更新左指针 $i$ ：** 根据上轮左指针 $i$ 和 $dic[s[j]]$ ，每轮更新左边界 $i$ ，保证区间 $[i + 1, j]$ 内无重复字符且最大。

$$
i = \max(dic[s[j]], i)
$$

- **更新结果 $res$ ：** 取上轮 $res$ 和本轮双指针区间 $[i + 1,j]$ 的宽度（即 $j - i$ ）中的最大值。

$$
res = \max(res, j - i)
$$

##### 复杂度分析：

- **时间复杂度 $O(N)$ ：** 其中 $N$ 为字符串长度，动态规划需遍历计算 $dp$ 列表。
- **空间复杂度 $O(1)$ ：** 字符的 ASCII 码范围为 $0$ ~ $127$ ，哈希表 $dic$ 最多使用 $O(128) = O(1)$ 大小的额外空间。

<![Picture12.png](../images/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof-11.png),![Picture13.png](../images/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof-12.png),![Picture14.png](../images/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof-13.png),![Picture15.png](../images/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof-14.png),![Picture16.png](../images/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof-15.png),![Picture17.png](../images/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof-16.png),![Picture18.png](../images/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof-17.png),![Picture19.png](../images/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof-18.png),![Picture20.png](../images/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof-19.png),![Picture21.png](../images/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof-20.png)>

##### 代码：

```Python []
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        dic, res, i = {}, 0, -1
        for j in range(len(s)):
            if s[j] in dic:
                i = max(dic[s[j]], i) # 更新左指针 i
            dic[s[j]] = j # 哈希表记录
            res = max(res, j - i) # 更新结果
        return res
```

```Java []
class Solution {
    public int lengthOfLongestSubstring(String s) {
        Map<Character, Integer> dic = new HashMap<>();
        int i = -1, res = 0;
        for(int j = 0; j < s.length(); j++) {
            if(dic.containsKey(s.charAt(j)))
                i = Math.max(i, dic.get(s.charAt(j))); // 更新左指针 i
            dic.put(s.charAt(j), j); // 哈希表记录
            res = Math.max(res, j - i); // 更新结果
        }
        return res;
    }
}
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    164561    |    354253    |   46.5%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
