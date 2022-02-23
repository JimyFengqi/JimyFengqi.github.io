---
title: 剑指 Offer II 087-复原 IP
categories:
  - 中等
tags:
  - 字符串
  - 回溯
abbrlink: 4090951918
date: 2021-12-03 21:32:51
---

> 原文链接: https://leetcode-cn.com/problems/0on3uN




## 中文题目
<div><p>给定一个只包含数字的字符串 <code>s</code> ，用以表示一个 IP 地址，返回所有可能从&nbsp;<code>s</code> 获得的 <strong>有效 IP 地址 </strong>。你可以按任何顺序返回答案。</p>

<p><strong>有效 IP 地址</strong> 正好由四个整数（每个整数位于 0 到 255 之间组成，且不能含有前导 <code>0</code>），整数之间用 <code>&#39;.&#39;</code> 分隔。</p>

<p>例如：&quot;0.1.2.201&quot; 和 &quot;192.168.1.1&quot; 是 <strong>有效</strong> IP 地址，但是 &quot;0.011.255.245&quot;、&quot;192.168.1.312&quot; 和 &quot;192.168@1.1&quot; 是 <strong>无效</strong> IP 地址。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>s = &quot;25525511135&quot;
<strong>输出：</strong>[&quot;255.255.11.135&quot;,&quot;255.255.111.35&quot;]
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>s = &quot;0000&quot;
<strong>输出：</strong>[&quot;0.0.0.0&quot;]
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>s = &quot;1111&quot;
<strong>输出：</strong>[&quot;1.1.1.1&quot;]
</pre>

<p><strong>示例 4：</strong></p>

<pre>
<strong>输入：</strong>s = &quot;010010&quot;
<strong>输出：</strong>[&quot;0.10.0.10&quot;,&quot;0.100.1.0&quot;]
</pre>

<p><strong>示例 5：</strong></p>

<pre>
<strong>输入：</strong>s = &quot;10203040&quot;
<strong>输出：</strong>[&quot;10.20.30.40&quot;,&quot;102.0.30.40&quot;,&quot;10.203.0.40&quot;]
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>0 &lt;= s.length &lt;= 3000</code></li>
	<li><code>s</code> 仅由数字组成</li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 93&nbsp;题相同：<a href="https://leetcode-cn.com/problems/restore-ip-addresses/">https://leetcode-cn.com/problems/restore-ip-addresses/</a>&nbsp;</p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# **回溯法**
首先明确一下合法的 IP 地址的条件：
1. 一个 IP 地址有四个分段
2. 每个分段表示的数值小于等于 255
3. 分段除了表示为 0 的情况以外，其他情况的第一个数字不能为 0

所以判断分段的合法性很重要，代码如下
```
// 判断分段合法性
bool isValidSeg(string& seg) {
    return stoi(seg) <= 255 && (seg == "0" || seg[0] != '0');
}
```
下面逐个扫描输入的字符串的每一个字符，通常面临两个选择。
- 第一个选择是将当前字符拼接到当前分段之后，且拼接后的分段合法。
- 第二个选择是将当前作为新的分段数字的开始，但是必须满足一个 IP 地址的分段最多只有 4 个，并且当开始一个新的分段数字时前一个分段不能为空。

可以发现解决该问题需要若干步，每一步又面临若干个选择，最后需要返回所有符合要求的结果，所以本题可以用回溯法解决。完整代码如下，helper 函数中第一个参数 i 是当前处理的字符在 s 中的下标，segI 是分段的编号，seg 是当前已经恢复的一个分段，IP 是当前已经恢复的 IP 地址。

```
class Solution {
private:
    // 回溯
    void helper(string& s, int i, int segI, string seg, string ip, vector<string>& ret) {
        // 当前 ip + seg 符合要求
        if (i == s.size() && segI == 3 && isValidSeg(seg)) {
            ret.push_back(ip + seg);
        }
        else if (i < s.size() && segI <= 3) {
            string temp = seg + s[i];
            // 将当前字符拼接到当前分段之后，且拼接后的分段合法
            if (isValidSeg(temp)) {
                helper(s, i + 1, segI, temp, ip, ret);
            }

            // 将当前作为新的分段数字的开始，但是必须满足一个 IP 地址的分段最多只有 4 个，
            // 并且当开始一个新的分段数字时前一个分段不能为空
            if (seg.size() > 0 && segI < 3) {
                string str{s[i]};
                helper(s, i + 1, segI + 1, str, ip + seg + ".", ret);
            }
        }
    }

    // 判断分段合法性
    bool isValidSeg(string& seg) {
        return stoi(seg) <= 255 && (seg == "0" || seg[0] != '0');
    }
public:
    vector<string> restoreIpAddresses(string s) {
        vector<string> ret;
        helper(s, 0, 0, "", "", ret);
        return ret;
    }
};
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    3319    |    5249    |   63.2%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
