---
title: 剑指 Offer II 016-不含重复字符的最长子字符串
categories:
  - 中等
tags:
  - 哈希表
  - 字符串
  - 滑动窗口
abbrlink: 264623514
date: 2021-12-03 21:32:36
---

> 原文链接: https://leetcode-cn.com/problems/wtcaE1




## 中文题目
<div><p>给定一个字符串 <code>s</code> ，请你找出其中不含有重复字符的&nbsp;<strong>最长连续子字符串&nbsp;</strong>的长度。</p>

<p>&nbsp;</p>

<p><strong>示例&nbsp;1:</strong></p>

<pre>
<strong>输入: </strong>s = &quot;abcabcbb&quot;
<strong>输出: </strong>3 
<strong>解释:</strong> 因为无重复字符的最长子字符串是 <code>&quot;abc&quot;，所以其</code>长度为 3。
</pre>

<p><strong>示例 2:</strong></p>

<pre>
<strong>输入: </strong>s = &quot;bbbbb&quot;
<strong>输出: </strong>1
<strong>解释: </strong>因为无重复字符的最长子字符串是 <code>&quot;b&quot;</code>，所以其长度为 1。
</pre>

<p><strong>示例 3:</strong></p>

<pre>
<strong>输入: </strong>s = &quot;pwwkew&quot;
<strong>输出: </strong>3
<strong>解释: </strong>因为无重复字符的最长子串是&nbsp;<code>&quot;wke&quot;</code>，所以其长度为 3。
&nbsp;    请注意，你的答案必须是 <strong>子串 </strong>的长度，<code>&quot;pwke&quot;</code>&nbsp;是一个<em>子序列，</em>不是子串。
</pre>

<p><strong>示例 4:</strong></p>

<pre>
<strong>输入: </strong>s = &quot;&quot;
<strong>输出: </strong>0
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>0 &lt;= s.length &lt;= 5 * 10<sup>4</sup></code></li>
	<li><code>s</code>&nbsp;由英文字母、数字、符号和空格组成</li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 3&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/longest-substring-without-repeating-characters/">https://leetcode-cn.com/problems/longest-substring-without-repeating-characters/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解


我们从暴力解法开始，一步一步来优化！！！

#### 1. 暴力解法及其缺点
请看视频：

![10_03_暴力解法及其缺点.mp4](d2bc47a3-d634-47e6-8de7-77a1618c9d52)

代码如下：
```java []
// 1. 暴力解法：遍历数组的所有的区间，然后找到最长没有重复字符的区间
// 时间复杂度：O(n^3)
// 空间复杂度：O(n)
// 会超时
public int lengthOfLongestSubstring1(String s) {
    int n = s.length();
    if (n <= 1) return n;
    int maxLen = 1;

    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n; j++) {
            if (allUnique(s, i, j)) {
                maxLen = Math.max(maxLen, j - i + 1);
            }
        }
    }

    return maxLen;
}

private boolean allUnique(String s, int start, int end) {
    Set<Character> set = new HashSet<>();
    for (int i = start; i <= end; i++) {
        if (set.contains(s.charAt(i))) {
            return false;
        }
        set.add(s.charAt(i));
    }
    return true;
}
```
```Golang []
// 1. 暴力解法：遍历数组的所有的区间，然后找到最长没有重复字符的区间
// 时间复杂度：O(n^3)
// 空间复杂度：O(n)
// 会超时
func lengthOfLongestSubstring1(s string) int {
    var n = len(s)
    if n <= 1 {
        return n
    }
    var maxLen = 1
    for i := range s {
        for j := i + 1; j < n; j++ {
            if allUnique(s, i, j) && j - i + 1 > maxLen {
                maxLen = j - i + 1
            }
        }
    }
    return maxLen
}

func allUnique(s string, start int, end int) bool {
    var set = make(map[byte]bool)
    for i := start; i <= end; i++ {
        if set[s[i]] {
            return false
        }
        set[s[i]] = true
    }
    return true
}
```


#### 2. 优化 - 滑动窗口思路
暴力解法存在重复计算，同一个子串会进行多次判断是否存在重复字符

我们可以做如下的优化：
- 如果 s[i, j) 子串没有重复字符的话，那么如果要判断 s[i, j] 没有重复字符的话，我们只需要判断 s[i, j) 中是否存在 s[j] 即可

请看视频：
![11_03_滑动窗口思路.mp4](d1daaf5c-64fb-4785-907b-511aec2133d6)


#### 3. 滑动窗口代码实现

请看视频：
![12_03_滑动窗口代码实现.mp4](e882abbf-9317-49d0-9146-f7afcadd2d3a)

代码如下：
```Java []
// 2. 滑动窗口
// 时间复杂度：O(2n) = O(n)，最坏的情况是 left 和 right 都遍历了一遍字符串
// 空间复杂度：O(n)
public int lengthOfLongestSubstring2(String s) {
    int n = s.length();
    if (n <= 1) return n;
    int maxLen = 1;

    int left = 0, right = 0;
    Set<Character> window = new HashSet<>();
    while (right < n) {
        char rightChar = s.charAt(right);
        while (window.contains(rightChar)) {
            window.remove(s.charAt(left));
            left++;
        }
        maxLen = Math.max(maxLen, right - left + 1);
        window.add(rightChar);
        right++;
    }

    return maxLen;
}
```
```C++ []
// 2. 滑动窗口
// 时间复杂度：O(2n) = O(n)，最坏的情况是 left 和 right 都遍历了一遍字符串
// 空间复杂度：O(n)
int lengthOfLongestSubstring1(string s) {
    int n = s.length();
    if (n <= 1) return n;

    int maxLen = 0;
    int left = 0, right = 0;
    unordered_set<char> window;
    while (right < n) {
        char currChar = s[right];
        if (!window.count(currChar)) {
            maxLen = max(maxLen, right - left + 1);
            window.insert(currChar);
            right++;
        } else {
            window.erase(s[left]);
            left++;
        }
    }
    return maxLen;
}
```
```Python []
# 2. 滑动窗口
# 时间复杂度：O(2n) = O(n)，最坏的情况是 left 和 right 都遍历了一遍字符串
# 空间复杂度：O(n)
def lengthOfLongestSubstring1(self, s: str) -> int:
    n = len(s)
    if n <= 1: return n
    max_len, window = 0, set()
    left = right = 0
    while right < n:
        if s[right] not in window:
            max_len = max(max_len, right - left + 1)
            window.add(s[right])
            right += 1
        else:
            window.remove(s[left])
            left += 1
    return max_len
```
```JavaScript []
// 2. 滑动窗口
// 时间复杂度：O(2n) = O(n)，最坏的情况是 left 和 right 都遍历了一遍字符串
// 空间复杂度：O(n)
var lengthOfLongestSubstring1 = function(s) {
    const n = s.length
    if (n <= 1) return n

    let left = 0, right = 0
    const window = new Set()
    let maxLen = 0
    while (right < n) {
        if (!window.has(s[right])) {
            maxLen = Math.max(maxLen, right - left + 1)
            window.add(s[right])
            right++
        } else {
            window.delete(s[left])
            left++
        }
    }
    return maxLen
};
```
```Golang []
// 2. 滑动窗口
// 时间复杂度：O(2n) = O(n)，最坏的情况是 left 和 right 都遍历了一遍字符串
// 空间复杂度：O(n)
func lengthOfLongestSubstring2(s string) int {
    var n = len(s)
    if n <= 1 {
        return n
    }
    var maxLen = 1
    var left, right, window = 0, 0, make(map[byte]bool)
    for right < n {
        var rightChar = s[right]
        for window[rightChar] {
            delete(window, s[left])
            left++
        }
        if right - left + 1 > maxLen {
            maxLen = right - left + 1
        }
        window[rightChar] = true
        right++
    }
    return maxLen
}
```

#### 4. 我们再来优化
以上当在窗口中存在重复字符，是一个一个字符的缩小窗口~

我们可以通过记住每个字符在字符串中的索引，当遇到重复字符的时候，就可以直接跳到重复字符的后面

请看视频：
![13_03_滑动窗口性能优化.mp4](d8a3c32e-1acc-45cc-8b70-61b3084dce74)

代码如下：
```Java []
// 3. 优化后的滑动窗口
// 时间复杂度：O(n)
// 空间复杂度：O(n)
public int lengthOfLongestSubstring3(String s) {
    int n = s.length();
    if (n <= 1) return n;
    int maxLen = 1;

    int left = 0, right = 0;
    Map<Character, Integer> window = new HashMap<>();
    while (right < n) {
        char rightChar = s.charAt(right);
        int rightCharIndex = window.getOrDefault(rightChar, 0);
        left = Math.max(left, rightCharIndex);
        maxLen = Math.max(maxLen, right - left + 1);
        window.put(rightChar, right + 1);
        right++;
    }

    return maxLen;
}
```
```C++ []
// 哈希映射
int lengthOfLongestSubstring2(string s) {
    int n = s.length();
    if (n <= 1) return n;

    int maxLen = 0;
    int left = 0, right = 0;
    // 存储窗口中每个字符及其位置的下一个位置
    // 表示如果再次碰到这个字符的时候，那么 left 就跳到这个字符所在位置的下一个位置
    unordered_map<char, int> window;
    while (right < n) {
        char currChar = s[right];
        unordered_map<char, int>::iterator it = window.find(currChar);
        int currCharIndex = (it == window.end() ? -1 : it->second);
        left = max(left, currCharIndex);
        maxLen = max(maxLen, right - left + 1);

        window[currChar] = right + 1;
        right++;
    }
    return maxLen;
}
```
```Python []
# 哈希映射
def lengthOfLongestSubstring2(self, s: str) -> int:
    n = len(s)
    if n <= 1: return n
    max_len, window = 0, {}
    left = right = 0
    while right < n:
        right_char_index = window.get(s[right], -1)
        left = max(left, right_char_index)
        max_len = max(max_len, right - left + 1)
        window[s[right]] = right + 1
        right += 1
    return max_len
```
```JavaScript []
// 哈希映射
var lengthOfLongestSubstring2 = function(s) {
    const n = s.length
    if (n <= 1) return n

    let left = 0, right = 0
    const window = new Map()
    let maxLen = 0
    while (right < n) {
        const rightCharIndex = window.has(s[right]) ? window.get(s[right]) : -1
        left = Math.max(left, rightCharIndex)
        maxLen = Math.max(maxLen, right - left + 1)
        window.set(s[right], right + 1)
        right++
    }
    return maxLen
};
```
```Golang []
// 3. 优化后的滑动窗口
// 时间复杂度：O(n)
// 空间复杂度：O(n)
func lengthOfLongestSubstring3(s string) int {
    var n = len(s)
    if n <= 1 {
        return n
    }
    var maxLen = 1
    var left, right, window = 0, 0, make(map[byte]int)
    for right < n {
        var rightChar = s[right]
        var rightCharIndex = 0
        if _, ok := window[rightChar]; ok {
            rightCharIndex = window[rightChar]
        }
        if rightCharIndex > left {
            left = rightCharIndex
        }
        if right - left + 1 > maxLen {
            maxLen = right - left + 1
        }
        window[rightChar] = right + 1
        right++
    }
    return maxLen
}
```

#### 5. 追求极致性能
请看视频：
![...03_使用数组代替HashMap.mp4](e91537ef-4ad0-41d0-8e37-a209b113982a)

代码如下：
```Java []
// 4. 追求程序的极致性能
// s 由英文字母、数字、符号和空格组成
public int lengthOfLongestSubstring(String s) {
    int n = s.length();
    if (n <= 1) return n;
    int maxLen = 1;

    int left = 0, right = 0;
    int[] window = new int[128];
    while (right < n) {
        char rightChar = s.charAt(right);
        int rightCharIndex = window[rightChar];
        left = Math.max(left, rightCharIndex);
        maxLen = Math.max(maxLen, right - left + 1);
        window[rightChar] = right + 1;
        right++;
    }

    return maxLen;
}
```
```C++ []
// 字符数组
int lengthOfLongestSubstring(string s) {
    int n = s.length();
    if (n <= 1) return n;

    int maxLen = 0;
    int left = 0, right = 0;
    vector<int> window(128, 0);
    while (right < n) {
        char currChar = s[right];
        int currCharIndex = window[currChar];
        left = max(left, currCharIndex);
        maxLen = max(maxLen, right - left + 1);

        window[currChar] = right + 1;
        right++;
    }
    return maxLen;
}
```
```Python []
# 字符数组
def lengthOfLongestSubstring(self, s: str) -> int:
    n = len(s)
    if n <= 1: return n
    max_len, window = 0, [0]*128
    left = right = 0
    while right < n:
        right_char_index = window[ord(s[right])]
        left = max(left, right_char_index)
        max_len = max(max_len, right - left + 1)
        window[ord(s[right])] = right + 1
        right += 1
    return max_len
```
```JavaScript []
// 字符数组
var lengthOfLongestSubstring = function(s) {
    const n = s.length
    if (n <= 1) return n

    let left = 0, right = 0
    const window = new Array(128).fill(0)
    let maxLen = 0
    while (right < n) {
        const rightCharIndex = window[s[right].charCodeAt()]
        left = Math.max(left, rightCharIndex)
        maxLen = Math.max(maxLen, right - left + 1)
        window[s[right].charCodeAt()] = right + 1
        right++
    }
    return maxLen
};
```
```Golang []
// 4. 追求程序的极致性能
// s 由英文字母、数字、符号和空格组成
func lengthOfLongestSubstring(s string) int {
    var n = len(s)
    if n <= 1 {
        return n
    }
    var maxLen = 1
    var left, right, window = 0, 0, [128]int{}
    for right < n {
        var rightChar = s[right]
        var rightCharIndex = window[rightChar]
        if rightCharIndex > left {
            left = rightCharIndex
        }
        if right - left + 1 > maxLen {
            maxLen = right - left + 1
        }
        window[rightChar] = right + 1
        right++
    }
    return maxLen
}
```

在刷题的时候：
1. 如果你觉得自己数据结构与算法**基础不够扎实**，那么[请点这里](http://www.tangweiqun.com/api/31104/3?av=1&cv=1)，这里包含了**一个程序员 5 年内需要的所有算法知识**

2. 如果你感觉刷题**太慢**，或者感觉**很困难**，或者**赶时间**，那么[请点这里](http://www.tangweiqun.com/api/35548/3?av=1&cv=1)。这里**用 365 道高频算法题，带你融会贯通算法知识，做到以不变应万变**

3. **回溯、贪心和动态规划，是算法面试中的三大难点内容**，如果你只是想搞懂这三大难点内容 [请点这里](http://www.tangweiqun.com/api/38100/3?av=1&cv=1)

**以上三个链接中的内容，都支持 Java/C++/Python/js/go 五种语言** 

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    7653    |    15692    |   48.8%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
