---
title: 剑指 Offer II 064-神奇的字典
categories:
  - 中等
tags:
  - 设计
  - 字典树
  - 哈希表
  - 字符串
abbrlink: 2134148264
date: 2021-12-03 21:28:26
---

> 原文链接: https://leetcode-cn.com/problems/US1pGT




## 中文题目
<div><p>设计一个使用单词列表进行初始化的数据结构，单词列表中的单词 <strong>互不相同</strong> 。 如果给出一个单词，请判定能否只将这个单词中<strong>一个</strong>字母换成另一个字母，使得所形成的新单词存在于已构建的神奇字典中。</p>

<p>实现 <code>MagicDictionary</code> 类：</p>

<ul>
	<li><code>MagicDictionary()</code> 初始化对象</li>
	<li><code>void buildDict(String[]&nbsp;dictionary)</code> 使用字符串数组&nbsp;<code>dictionary</code> 设定该数据结构，<code>dictionary</code> 中的字符串互不相同</li>
	<li><code>bool search(String searchWord)</code> 给定一个字符串 <code>searchWord</code> ，判定能否只将字符串中<strong> 一个 </strong>字母换成另一个字母，使得所形成的新字符串能够与字典中的任一字符串匹配。如果可以，返回 <code>true</code> ；否则，返回 <code>false</code> 。</li>
</ul>

<p>&nbsp;</p>

<div class="top-view__1vxA">
<div class="original__bRMd">
<div>
<p><strong>示例：</strong></p>

<pre>
<strong>输入</strong>
inputs = [&quot;MagicDictionary&quot;, &quot;buildDict&quot;, &quot;search&quot;, &quot;search&quot;, &quot;search&quot;, &quot;search&quot;]
inputs = [[], [[&quot;hello&quot;, &quot;leetcode&quot;]], [&quot;hello&quot;], [&quot;hhllo&quot;], [&quot;hell&quot;], [&quot;leetcoded&quot;]]
<strong>输出</strong>
[null, null, false, true, false, false]

<strong>解释</strong>
MagicDictionary magicDictionary = new MagicDictionary();
magicDictionary.buildDict([&quot;hello&quot;, &quot;leetcode&quot;]);
magicDictionary.search(&quot;hello&quot;); // 返回 False
magicDictionary.search(&quot;hhllo&quot;); // 将第二个 &#39;h&#39; 替换为 &#39;e&#39; 可以匹配 &quot;hello&quot; ，所以返回 True
magicDictionary.search(&quot;hell&quot;); // 返回 False
magicDictionary.search(&quot;leetcoded&quot;); // 返回 False
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;=&nbsp;dictionary.length &lt;= 100</code></li>
	<li><code>1 &lt;=&nbsp;dictionary[i].length &lt;= 100</code></li>
	<li><code>dictionary[i]</code> 仅由小写英文字母组成</li>
	<li><code>dictionary</code> 中的所有字符串 <strong>互不相同</strong></li>
	<li><code>1 &lt;=&nbsp;searchWord.length &lt;= 100</code></li>
	<li><code>searchWord</code> 仅由小写英文字母组成</li>
	<li><code>buildDict</code> 仅在 <code>search</code> 之前调用一次</li>
	<li>最多调用 <code>100</code> 次 <code>search</code></li>
</ul>
</div>
</div>
</div>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 676&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/implement-magic-dictionary/">https://leetcode-cn.com/problems/implement-magic-dictionary/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# **前缀树**
此类问题若是使用哈希表并不能很好得解决，合适的方法应该是使用前缀树，然后在前缀树中查找只修改一个字符的字符串。前缀的实现和前几题类似，如下
```
// 构造前缀树节点
class Trie {
public:
    bool isWord;
    vector<Trie*> children;
    Trie () : isWord(false), children(26, nullptr) {}

    void insert(const string& str) {
        Trie* node = this;
        for (auto& ch : str) {
            if (node->children[ch - 'a'] == nullptr) {
                node->children[ch - 'a'] = new Trie();
            }
            node = node->children[ch - 'a'];
        }
        node->isWord = true;
    }
};
```
接下来分析如何在前缀树中查找只修改一个字符的字符串，可以根据 dfs 搜索前缀树的每条路径。如果到达的节点与字符串中的字符不匹配，则表示此时需要修改该字符以匹配路径。如果到达对应字符串的最后一个字符所对应的节点，且该节点的 isWord 为 ture，并且当前路径刚好修改了字符串中的一个字符，那么就找到了符合要求的路径，返回 true。完整代码如下：
```
// 构造前缀树节点
class Trie {
public:
    bool isWord;
    vector<Trie*> children;
    Trie () : isWord(false), children(26, nullptr) {}

    void insert(const string& str) {
        Trie* node = this;
        for (auto& ch : str) {
            if (node->children[ch - 'a'] == nullptr) {
                node->children[ch - 'a'] = new Trie();
            }
            node = node->children[ch - 'a'];
        }
        node->isWord = true;
    }
};


class MagicDictionary {
private:
    Trie* root;
    bool dfs(Trie* root, string& word, int i, int edit) {
        if (root == nullptr) {
            return false;
        }

        if (root->isWord && i == word.size() && edit == 1) {
            return true;
        }

        if (i < word.size() && edit <= 1) {
            bool found = false;
            for (int j = 0; j < 26 && !found; ++j) {
                int next = (j == word[i] - 'a') ? edit : edit + 1;
                found = dfs(root->children[j], word, i + 1, next);
            }

            return found;
        }

        return false;
    }

public:
    /** Initialize your data structure here. */
    MagicDictionary() {
        root = new Trie();
    }
    
    void buildDict(vector<string> dictionary) {
        for (auto& word : dictionary) {
            root->insert(word);
        }
    }
    
    bool search(string searchWord) {
        return dfs(root, searchWord, 0, 0);
    }
};
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    2026    |    3251    |   62.3%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
