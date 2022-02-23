---
title: 剑指 Offer II 066-单词之和
categories:
  - 中等
tags:
  - 设计
  - 字典树
  - 哈希表
  - 字符串
abbrlink: 1504099989
date: 2021-12-03 21:28:24
---

> 原文链接: https://leetcode-cn.com/problems/z1R5dt




## 中文题目
<div><p>实现一个 <code>MapSum</code> 类，支持两个方法，<code>insert</code>&nbsp;和&nbsp;<code>sum</code>：</p>

<ul>
	<li><code>MapSum()</code> 初始化 <code>MapSum</code> 对象</li>
	<li><code>void insert(String key, int val)</code> 插入 <code>key-val</code> 键值对，字符串表示键 <code>key</code> ，整数表示值 <code>val</code> 。如果键 <code>key</code> 已经存在，那么原来的键值对将被替代成新的键值对。</li>
	<li><code>int sum(string prefix)</code> 返回所有以该前缀 <code>prefix</code> 开头的键 <code>key</code> 的值的总和。</li>
</ul>

<p>&nbsp;</p>

<p><strong>示例：</strong></p>

<pre>
<strong>输入：</strong>
inputs = [&quot;MapSum&quot;, &quot;insert&quot;, &quot;sum&quot;, &quot;insert&quot;, &quot;sum&quot;]
inputs = [[], [&quot;apple&quot;, 3], [&quot;ap&quot;], [&quot;app&quot;, 2], [&quot;ap&quot;]]
<strong>输出：</strong>
[null, null, 3, null, 5]

<strong>解释：</strong>
MapSum mapSum = new MapSum();
mapSum.insert(&quot;apple&quot;, 3);  
mapSum.sum(&quot;ap&quot;);           // return 3 (<u>ap</u>ple = 3)
mapSum.insert(&quot;app&quot;, 2);    
mapSum.sum(&quot;ap&quot;);           // return 5 (<u>ap</u>ple + <u>ap</u>p = 3 + 2 = 5)
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= key.length, prefix.length &lt;= 50</code></li>
	<li><code>key</code> 和 <code>prefix</code> 仅由小写英文字母组成</li>
	<li><code>1 &lt;= val &lt;= 1000</code></li>
	<li>最多调用 <code>50</code> 次 <code>insert</code> 和 <code>sum</code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 677&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/map-sum-pairs/">https://leetcode-cn.com/problems/map-sum-pairs/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# **前缀树**
此题还是使用前缀树的解法，只是将常规的前缀树节点中，记录是否为插入字符串结尾的 isword 改成记录字符串值的 val。前缀树还要实现类函数 insert 实现插入字符串，以及类函数 coutSum 实现返回所有以该前缀开头的字符串的值的总和。在实现 coutSum 函数时，可以采用先遍历到该前缀的尾节点，若不存在该前缀的路径则返回0，若存在则从尾节点开始使用广度优先搜索算法，实现返回所有以该前缀开头的字符串的值的总和。完整代码如下：

```
// 构造前缀树节点
class Trie {
public:
    int val;
    vector<Trie*> children;
    Trie () : val(0), children(26, nullptr) {}

    // 实现插入字符串
    void insert(string& str, int m) {
        Trie* node = this;
        for (auto& ch : str) {
            if (node->children[ch - 'a'] == nullptr) {
                node->children[ch - 'a'] = new Trie();
            }
            node = node->children[ch - 'a'];
        }
        node->val = m;
    }

    // 实现返回所有以该前缀 prefix 开头的键 key 的值的总和
    int coutSum(string &prefix) {
        Trie* node = this;
        for (auto& ch : prefix) {
            if (node->children[ch - 'a'] == nullptr) {
                return 0;
            }
            node = node->children[ch - 'a'];
        }

        // BFS
        int count = 0;
        queue<Trie*> que;
        que.push(node);
        while (!que.empty()) {
            Trie* node = que.front();
            que.pop();
            count += node->val;
            for (int i = 0; i < node->children.size(); ++i) {
                if (node->children[i] != nullptr) {
                    que.push(node->children[i]);
                }
            }
        }
        return count;
    }
};

class MapSum {
private:
    Trie* root;
public:
    MapSum() {
        root = new Trie();
    }
    
    void insert(string key, int val) {
        root->insert(key, val);
    }
    
    int sum(string prefix) {
        return root->coutSum(prefix);
    }
};
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    1966    |    3023    |   65.0%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
