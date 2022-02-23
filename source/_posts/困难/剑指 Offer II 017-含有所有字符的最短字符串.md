---
title: 剑指 Offer II 017-含有所有字符的最短字符串
categories:
  - 困难
tags:
  - 哈希表
  - 字符串
  - 滑动窗口
abbrlink: 2903669871
date: 2021-12-03 21:32:35
---

> 原文链接: https://leetcode-cn.com/problems/M1oyTv




## 中文题目
<div><p>给定两个字符串 <code>s</code> 和&nbsp;<code>t</code> 。返回 <code>s</code> 中包含&nbsp;<code>t</code>&nbsp;的所有字符的最短子字符串。如果 <code>s</code> 中不存在符合条件的子字符串，则返回空字符串 <code>&quot;&quot;</code> 。</p>

<p>如果 <code>s</code> 中存在多个符合条件的子字符串，返回任意一个。</p>

<p>&nbsp;</p>

<p><strong>注意： </strong>对于 <code>t</code> 中重复字符，我们寻找的子字符串中该字符数量必须不少于 <code>t</code> 中该字符数量。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>s = &quot;ADOBECODEBANC&quot;, t = &quot;ABC&quot;
<strong>输出：</strong>&quot;BANC&quot; 
<strong>解释：</strong>最短子字符串 &quot;BANC&quot; 包含了字符串 t 的所有字符 &#39;A&#39;、&#39;B&#39;、&#39;C&#39;</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>s = &quot;a&quot;, t = &quot;a&quot;
<strong>输出：</strong>&quot;a&quot;
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>s = &quot;a&quot;, t = &quot;aa&quot;
<strong>输出：</strong>&quot;&quot;
<strong>解释：</strong>t 中两个字符 &#39;a&#39; 均应包含在 s 的子串中，因此没有符合条件的子字符串，返回空字符串。</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= s.length, t.length &lt;= 10<sup>5</sup></code></li>
	<li><code>s</code> 和 <code>t</code> 由英文字母组成</li>
</ul>

<p>&nbsp;</p>

<p><strong>进阶：</strong>你能设计一个在 <code>o(n)</code> 时间内解决此问题的算法吗？</p>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 76&nbsp;题相似（本题答案不唯一）：<a href="https://leetcode-cn.com/problems/minimum-window-substring/">https://leetcode-cn.com/problems/minimum-window-substring/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
思路和心得：

1.滑动窗口+临界统计

2.记录好每次符合条件的起始点和长度即可


```python3 []
class Solution:
    def minWindow(self, s: str, t: str) -> str:
        sn = len(s)
        tn = len(t)
        
        res_start = -1
        res_len = float('inf')

        need_cnt = tn
        need_char_cnt = defaultdict(int)
        for c in t:
            need_char_cnt[c] += 1

        l = 0
        for r in range(sn):
            if s[r] in need_char_cnt:
                if need_char_cnt[s[r]] > 0:
                    need_cnt -= 1
                need_char_cnt[s[r]] -= 1
            if need_cnt == 0:
                while True: 
                    if s[l] not in need_char_cnt:
                        l += 1
                    else:
                        if need_char_cnt[s[l]] < 0:
                            need_char_cnt[s[l]] += 1
                            l += 1
                        else:
                            break
                cur_len = r - l + 1
                if cur_len < res_len:
                    res_len = cur_len
                    res_start = l
        if res_start != -1:
            return s[res_start: res_start + res_len]
        return ""
```

```c++ []
class Solution 
{
public:
    string minWindow(string s, string t) 
    {
        int sn = s.size();
        int tn = t.size();

        if (sn < tn)
            return string("");

        int need_cnt = tn;
        unordered_map<char, int> need_char_cnt;
        for (char c : t)
            need_char_cnt[c] ++;
        
        int res_start = -1;
        int res_len = INT_MAX;

        int l = 0;
        for (int r = 0; r < sn; r ++)
        {
            if (need_char_cnt.find(s[r]) != need_char_cnt.end())
            {
                if (need_char_cnt[s[r]] > 0)
                    need_cnt --;
                need_char_cnt[s[r]] --;
            }

            if (need_cnt == 0)
            {
                while (true)
                {
                    if (need_char_cnt.find(s[l]) == need_char_cnt.end())
                        l ++;
                    else
                    {
                        if (need_char_cnt[s[l]] < 0)
                        {
                            need_char_cnt[s[l]] ++;
                            l ++;
                        }
                        else
                        {
                            break;
                        }
                    }
                }

                if (r - l + 1 < res_len)
                {
                    res_len = r - l + 1;
                    res_start = l;
                }
            }
        }

        if (res_start == -1)
            return string("");
        return s.substr(res_start, res_len);
    }
};
```

```java []
class Solution 
{
    public String minWindow(String s, String t) 
    {
        int sn = s.length();
        int tn = t.length();

        if (sn < tn)
            return new String();
        
        int need_cnt = tn;
        Map<Character, Integer> need_char_cnt = new HashMap<>();
        for (int i = 0; i < tn; i ++)
        {
            char c = t.charAt(i);
            need_char_cnt.put(c, need_char_cnt.getOrDefault(c, 0) + 1);
        }

        int res_start = -1;
        int res_len = Integer.MAX_VALUE;
        
        int l = 0;
        for (int r = 0; r < sn; r ++)
        {
            if (need_char_cnt.containsKey(s.charAt(r)) == true)
            {
                if (need_char_cnt.get(s.charAt(r)) > 0)
                    need_cnt --;
                need_char_cnt.put(s.charAt(r), need_char_cnt.get(s.charAt(r)) - 1);
            }

            if (need_cnt == 0)
            {
                while (true)
                {
                    if (need_char_cnt.containsKey(s.charAt(l)) == false)
                        l ++;
                    else
                    {
                        if (need_char_cnt.get(s.charAt(l)) < 0)
                        {
                            need_char_cnt.put(s.charAt(l), need_char_cnt.get(s.charAt(l)) + 1);
                            l ++;
                        }
                        else
                        {
                            break;
                        }
                    }
                }

                if (r - l + 1 < res_len)
                {
                    res_len = r - l + 1;
                    res_start = l;
                }
            }
        }

        if (res_start == -1)
            return new String();
        return s.substring(res_start, res_start + res_len);
    }
}
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    4438    |    8637    |   51.4%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
