---
title: 剑指 Offer II 005-单词长度的最大乘积
date: 2021-12-03 21:32:55
categories:
  - 中等
tags:
  - 位运算
  - 数组
  - 字符串
---

> 原文链接: https://leetcode-cn.com/problems/aseY1I




## 中文题目
<div><p>给定一个字符串数组&nbsp;<code>words</code>，请计算当两个字符串 <code>words[i]</code> 和 <code>words[j]</code> 不包含相同字符时，它们长度的乘积的最大值。假设字符串中只包含英语的小写字母。如果没有不包含相同字符的一对字符串，返回 0。</p>

<p>&nbsp;</p>

<p><strong>示例&nbsp;1:</strong></p>

<pre>
<strong>输入:</strong> words = <code>[&quot;abcw&quot;,&quot;baz&quot;,&quot;foo&quot;,&quot;bar&quot;,&quot;fxyz&quot;,&quot;abcdef&quot;]</code>
<strong>输出: </strong><code>16 
<strong>解释:</strong> 这两个单词为<strong> </strong></code><code>&quot;abcw&quot;, &quot;fxyz&quot;</code>。它们不包含相同字符，且长度的乘积最大。</pre>

<p><strong>示例 2:</strong></p>

<pre>
<strong>输入:</strong> words = <code>[&quot;a&quot;,&quot;ab&quot;,&quot;abc&quot;,&quot;d&quot;,&quot;cd&quot;,&quot;bcd&quot;,&quot;abcd&quot;]</code>
<strong>输出: </strong><code>4 
<strong>解释: </strong></code>这两个单词为 <code>&quot;ab&quot;, &quot;cd&quot;</code>。</pre>

<p><strong>示例 3:</strong></p>

<pre>
<strong>输入:</strong> words = <code>[&quot;a&quot;,&quot;aa&quot;,&quot;aaa&quot;,&quot;aaaa&quot;]</code>
<strong>输出: </strong><code>0 
<strong>解释: </strong>不存在这样的两个单词。</code>
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>2 &lt;= words.length &lt;= 1000</code></li>
	<li><code>1 &lt;= words[i].length &lt;= 1000</code></li>
	<li><code>words[i]</code>&nbsp;仅包含小写字母</li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 318&nbsp;题相同：<a href="https://leetcode-cn.com/problems/maximum-product-of-word-lengths/">https://leetcode-cn.com/problems/maximum-product-of-word-lengths/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解


### 暴力解法(我们都能想到的)

![31_318_暴力解法.mp4](1421c4f1-240f-421c-8f8d-522fd20906d3)

代码如下：
```java []
// 暴力解法
// m 表示单词的平均长度，n 表示单词的个数
// 时间复杂度：O(n^2 * m)
// 空间复杂度：O(1)
public int maxProduct1(String[] words) {
    int ans = 0;
    for (int i = 0; i < words.length; i++) {
        String word1 = words[i];
        for (int j = i + 1; j < words.length; j++) {
            String word2 = words[j];
            // 每个单词的 bitMask 会重复计算很多次
            if (!hasSameChar(word1, word2)) {
                ans = Math.max(ans, word1.length() * word2.length());
            }
        }
    }
    return ans;
}
// O(m^2)
private boolean hasSameChar1(String word1, String word2) {
    for (char c : word1.toCharArray()) {
        if (word2.indexOf(c) != -1) return true;
    }
    return false;
}
```
```Golang []
// 暴力解法
// m 表示单词的平均长度，n 表示单词的个数
// 时间复杂度：O(n^2 * m)
// 空间复杂度：O(1)
func maxProduct1(words []string) int {
    var ans = 0
    for i := range words {
        var word1 = words[i]
        for j := i + 1; j < len(words); j++ {
            var word2 = words[j]
            // 每个单词的 bitMask 会重复计算很多次
            if !hasSameChar(word1, word2) {
                var length = len(word1) * len(word2)
                if length > ans {
                    ans = length
                }
            }
        }
    }
    return ans
}

// O(m^2)
func hasSameChar(word1 string, word2 string) bool {
    for _, c := range word1 {
        if strings.Index(word2, string(c)) >= 0 {
            return true
        }
    }
    return false
}
```

### 计数优化降低时间复杂度

![..._318_计数优化降低时间复杂度.mp4](9c0a4d07-5825-49e6-8588-06a828aaa514)

代码如下：
```java []
// O(m)
private boolean hasSameChar2(String word1, String word2) {
    int[] count = new int[26];
    for (char c : word1.toCharArray()) count[c - 'a'] = 1;
    for (char c : word2.toCharArray()) {
        if (count[c - 'a'] == 1) return true;
    }
    return false;
}
```
```Golang []
func hasSameChar2(word1 string, word2 string) bool {
    var count = [26]int{}
    for _, c := range word1 {
        count[c - 'a'] = 1
    }
    for _, c := range word2 {
        if count[c - 'a'] == 1 {
            return true
        }
    }
    return false
}
```

### 位运算优化

![33_318_位运算优化.mp4](4e2dc7c5-4a12-4ea7-84f1-1d4a27e3b2ff)

代码如下：
```java []
// O(m)
private boolean hasSameChar(String word1, String word2) {
    int bitMask1 = 0, bitMask2 = 0;
    for (char c : word1.toCharArray()) bitMask1 |= (1 << (c - 'a'));
    for (char c : word2.toCharArray()) bitMask2 |= (1 << (c - 'a'));
    return (bitMask1 & bitMask2) != 0;
}
```
```Golang []
// O(m)
func hasSameChar(word1 string, word2 string) bool {
    var bitMask1, bitMask2 = 0, 0
    for _, c := range word1 {
        bitMask1 |= (1 << (c - 'a'))
    }
    for _, c := range word2 {
        bitMask2 |= (1 << (c - 'a'))
    }
    return (bitMask1 & bitMask2) != 0
}
```

### 位运算预计算优化

![34_318_位运算预计算优化.mp4](7c2d044d-7724-4c5b-b93d-6f9fd7573693)

代码如下：
```java []
// 位运算 + 预计算
// 时间复杂度：O((m + n)* n)
// 空间复杂度：O(n)
public int maxProduct2(String[] words) {
    // O(mn)
    int n = words.length;
    int[] masks = new int[n];
    for (int i = 0; i < n; i++) {
        int bitMask = 0;
        for (char c : words[i].toCharArray()) {
            bitMask |= (1 << (c - 'a'));
        }
        masks[i] = bitMask;
    }

    // O(n^2)
    int ans = 0;
    for (int i = 0; i < words.length; i++) {
        String word1 = words[i];
        for (int j = i + 1; j < words.length; j++) {
            String word2 = words[j];
            if ((masks[i] & masks[j]) == 0) {
                ans = Math.max(ans, word1.length() * word2.length());
            }
        }
    }
    return ans;
}
```
```Golang []
// 位运算 + 预计算
// 时间复杂度：O((m + n)* n)
// 空间复杂度：O(n)
func maxProduct2(words []string) int {
    // O(mn)
    var n = len(words)
    var masks = make([]int, n)
    for i := 0; i < n; i++ {
        var bitMask = 0
        for _, c := range words[i] {
            bitMask |= (1 << (c - 'a'))
        }
        masks[i] = bitMask
    }

    var ans = 0
    for i := range words {
        var word1 = words[i]
        for j := i + 1; j < len(words); j++ {
            var word2 = words[j]
            if (masks[i] & masks[j]) == 0 {
                var length = len(word1) * len(word2)
                if length > ans {
                    ans = length
                }
            }
        }
    }
    return ans
}
```

### 继续优化

![35_318_继续优化.mp4](3b5e2891-4363-47a9-b268-a88c75c9dfe0)

代码如下：
```java []
// 位运算 + 预计算
// 时间复杂度：O((m + n)* n)
// 空间复杂度：O(n)
public int maxProduct(String[] words) {
    // O(mn)
    Map<Integer, Integer> map = new HashMap<>();
    int n = words.length;
    for (int i = 0; i < n; i++) {
        int bitMask = 0;
        for (char c : words[i].toCharArray()) {
            bitMask |= (1 << (c - 'a'));
        }
        // there could be different words with the same bitmask
        // ex. ab and aabb
        map.put(bitMask, Math.max(map.getOrDefault(bitMask, 0), words[i].length()));
    }

    // O(n^2)
    int ans = 0;
    for (int x : map.keySet()) {
        for (int y : map.keySet()) {
            if ((x & y) == 0) {
                ans = Math.max(ans, map.get(x) * map.get(y));
            }
        }
    }
    return ans;
}
```
```c++ []
class Solution {
public:
    int maxProduct(vector<string>& words) {
        int m = words.size();
        unordered_map<int, int> bitMaskMap;
        for (int i = 0; i < m; i++) {
            int bitMask = 0;
            for (char c : words[i]) {
                bitMask |= 1 << (c - 'a');
            }
            if (bitMaskMap.count(bitMask)) {
                int maxV = max(bitMaskMap[bitMask], (int)words[i].size());
                bitMaskMap[bitMask] = maxV;
            } else {
                bitMaskMap[bitMask] = words[i].size();
            }
        }

        int ans = 0;
        for (auto& x : bitMaskMap) {
            for (auto& y : bitMaskMap) {
                if ((x.first & y.first) == 0) {
                    ans = max(ans, x.second * y.second);
                }
            }
        }

        return ans;
    }
};
```
```javascript []
/**
 * @param {string[]} words
 * @return {number}
 */
var maxProduct = function(words) {
    const bitmaskMap = new Map()
    for (let i = 0; i < words.length; i++) {
        let bitmask = 0
        for (const c of words[i]) {
            bitmask |= 1 << (c.charCodeAt() - 'a'.charCodeAt())
        }
        if (bitmaskMap.has(bitmask)) {
            bitmaskMap.set(bitmask, Math.max(bitmaskMap.get(bitmask), words[i].length))
        } else {
            bitmaskMap.set(bitmask, words[i].length)
        }
    }

    let ans = 0
    for (const x of bitmaskMap.keys()) {
        for (const y of bitmaskMap.keys()) {
            if ((x & y) == 0) {
                ans = Math.max(ans, bitmaskMap.get(x) * bitmaskMap.get(y))
            }
        }
    }

    return ans
};
```
```python []
class Solution:
    def maxProduct(self, words: List[str]) -> int:
        bitmask_map, ans = {}, 0
        for i in range(len(words)):
            bitmask = 0
            for c in words[i]:
                bitmask |= 1 << (ord(c) - ord('a'))
            if bitmask in bitmask_map:
                bitmask_map[bitmask] = max(bitmask_map[bitmask], len(words[i]))
            else:
                bitmask_map[bitmask] = len(words[i])

        for x in bitmask_map:
            for y in bitmask_map:
                if (x & y) == 0:
                    ans = max(ans, bitmask_map[x] * bitmask_map[y])

        return ans
```
```Golang []
// 位运算 + 预计算
// 时间复杂度：O((m + n)* n)
// 空间复杂度：O(n)
func maxProduct(words []string) int {
    // O(mn)
    var n = len(words)
    var masksMap = make(map[int]int)
    for i := 0; i < n; i++ {
        var bitMask = 0
        for _, c := range words[i] {
            bitMask |= (1 << (c - 'a'))
        }
        // there could be different words with the same bitmask
        // ex. ab and aabb
        if len(words[i]) > masksMap[bitMask] {
            masksMap[bitMask] = len(words[i])
        }
    }

    var ans = 0
    for x := range masksMap {
        for y := range masksMap {
            if (x & y) == 0 {
                var length = masksMap[x] * masksMap[y]
                if length > ans {
                    ans = length
                }
            }
        }
    }
    return ans
}
```


在刷题的时候：
1. 如果你觉得自己数据结构与算法**基础不够扎实**，那么[请点这里](http://www.tangweiqun.com/api/31104/offer005?av=1&cv=1)，这里包含了**一个程序员 5 年内需要的所有算法知识**

2. 如果你感觉刷题**太慢**，或者感觉**很困难**，或者**赶时间**，那么[请点这里](http://www.tangweiqun.com/api/35548/offer005?av=1&cv=1)。这里**用 365 道高频算法题，带你融会贯通算法知识，做到以不变应万变**

3. **回溯、贪心和动态规划，是算法面试中的三大难点内容**，如果你只是想搞懂这三大难点内容 [请点这里](http://www.tangweiqun.com/api/38100/offer005?av=1&cv=1)

**以上三个链接中的内容，都支持 Java/C++/Python/js/go 五种语言** 





## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    9422    |    13214    |   71.3%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
