---
title: 剑指 Offer II 065-最短的单词编码
categories:
  - 中等
tags:
  - 字典树
  - 数组
  - 哈希表
  - 字符串
abbrlink: 1931091218
date: 2021-12-03 21:28:25
---

> 原文链接: https://leetcode-cn.com/problems/iSwD2y




## 中文题目
<div><p>单词数组&nbsp;<code>words</code> 的 <strong>有效编码</strong> 由任意助记字符串 <code>s</code> 和下标数组 <code>indices</code> 组成，且满足：</p>

<ul>
	<li><code>words.length == indices.length</code></li>
	<li>助记字符串 <code>s</code> 以 <code>&#39;#&#39;</code> 字符结尾</li>
	<li>对于每个下标 <code>indices[i]</code> ，<code>s</code> 的一个从 <code>indices[i]</code> 开始、到下一个 <code>&#39;#&#39;</code> 字符结束（但不包括 <code>&#39;#&#39;</code>）的 <strong>子字符串</strong> 恰好与 <code>words[i]</code> 相等</li>
</ul>

<p>给定一个单词数组&nbsp;<code>words</code> ，返回成功对 <code>words</code> 进行编码的最小助记字符串 <code>s</code> 的长度 。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>words = [&quot;time&quot;, &quot;me&quot;, &quot;bell&quot;]
<strong>输出：</strong>10
<strong>解释：</strong>一组有效编码为 s = <code>&quot;time#bell#&quot; 和 indices = [0, 2, 5</code>] 。
words[0] = &quot;time&quot; ，s 开始于 indices[0] = 0 到下一个 &#39;#&#39; 结束的子字符串，如加粗部分所示 &quot;<strong>time</strong>#bell#&quot;
words[1] = &quot;me&quot; ，s 开始于 indices[1] = 2 到下一个 &#39;#&#39; 结束的子字符串，如加粗部分所示 &quot;ti<strong>me</strong>#bell#&quot;
words[2] = &quot;bell&quot; ，s 开始于 indices[2] = 5 到下一个 &#39;#&#39; 结束的子字符串，如加粗部分所示 &quot;time#<strong>bell</strong>#&quot;
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>words = [&quot;t&quot;]
<strong>输出：</strong>2
<strong>解释：</strong>一组有效编码为 s = &quot;t#&quot; 和 indices = [0] 。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= words.length &lt;= 2000</code></li>
	<li><code>1 &lt;= words[i].length &lt;= 7</code></li>
	<li><code>words[i]</code> 仅由小写字母组成</li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 820&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/short-encoding-of-words/">https://leetcode-cn.com/problems/short-encoding-of-words/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
思路和心得：


# （一）无序结合+暴力删掉后缀

1.如果word的某个后缀 是 别的单词，把别的单词从集合中删除。


```python3 []
class Solution:
    def minimumLengthEncoding(self, words: List[str]) -> int:
        us = set(words)
        for word in words:
            for i in range(1, len(word)):
                suffix = word[i: ]
                us.discard(suffix)
        
        res = 0
        for w in us:
            res += len(w)
            res += 1
        return res
```

```c++ []
class Solution 
{
public:
    int minimumLengthEncoding(vector<string>& words) 
    {
        unordered_set<string> us(words.begin(), words.end());
        for (string word: words)
        {
            for (int i = 1; i < word.size(); i ++)
            {
                string suffix = word.substr(i);
                us.erase(suffix);
            }
        }

        int res = 0;
        for (string  w: us)
        {
            res += w.size();
            res += 1;
        }
        return res;
    }       
};
```

```java []
class Solution 
{
    public int minimumLengthEncoding(String[] words) 
    {
        Set<String> us = new HashSet<>(Arrays.asList(words));
        for (String word : words)
        {
            for (int i = 1; i < word.length(); i ++)
            {
                String suffix = word.substring(i, word.length());
                us.remove(suffix);
            }
        }

        int res = 0;
        for (String w : us)
        {
             res += w.length();
             res += 1;
        }
        return res;
    }
}
```


# （二）Trie树

1.值统计每条路径的长度即可。


```python3 []
class Trie:
    def __init__(self):
        self.child = [None for _ in range(26)]
        self.cnt = 0        #经过这个结点的单词个数

    def insert(self, word: str) -> None:
        root = self
        for c in word[::-1]:
            ID = ord(c) - ord('a')
            if root.child[ID] == None:
                root.child[ID] = Trie()
                root.cnt += 1
            root = root.child[ID]
        root.cnt += 1

    def search(self, word: str) -> int:
        root = self
        for c in word[::-1]:
            ID = ord(c) - ord('a')
            root = root.child[ID]
        return root.cnt 


class Solution:
    def minimumLengthEncoding(self, words: List[str]) -> int:
        T = Trie()

        words_us = set(words)

        for word in words_us:
            T.insert(word)
        
        res = 0
        for word in words_us:
            if T.search(word) == 1:       #是Trie树里一条路径最长的那个单词
                res += len(word) + 1
        return res
```

```c++ []
class Trie
{
public:
    Trie * child [26];
    int cnt;

    Trie()
    {
        memset(child, 0, sizeof(child));
        cnt = 0;
    }

    void insert(string word)
    {
        Trie * root = this;;
        for (int i = (int)word.size() -1; i > -1; i --)
        {
            int ID = word[i] - 'a';
            if (root->child[ID] == nullptr)
            {
                root->child[ID] = new Trie();
                root->cnt ++;
            }
            root = root->child[ID];
        }
        root->cnt ++;
    }

    int search(string word)
    {
        Trie * root = this;
        for (int i = (int)word.size() - 1 ; i > -1;  i --)
        {
            int ID = word[i] - 'a';
            root = root->child[ID];
        }
        return root->cnt;
    }

};

class Solution 
{
public:
    int minimumLengthEncoding(vector<string>& words) 
    {
        unordered_set<string> us(words.begin(), words.end());

        Trie * T = new Trie();

        for (string word : us)
            T->insert(word);
        
        int res = 0;
        for (string word : us)
            if (T->search(word) == 1)
                res += (int)word.size() + 1;
        
        return res;
    }
};
```

```java []
class Trie
{
    Trie [] child = new Trie [26];
    int cnt;

    Trie()
    {
        cnt = 0;
    }

    public void insert(String word)
    {
        Trie root = this;
        for (int i = word.length() - 1; i > -1; i --)
        {
            int ID = word.charAt(i) - 'a';
            if (root.child[ID] == null)
            {
                root.child[ID] = new Trie();
                root.cnt ++;
            }
            root = root.child[ID];
        }
        root.cnt ++;
    }

    public int search(String word)
    {
        Trie root = this;
        for (int i = word.length() - 1; i > -1; i --)
        {
            int ID = word.charAt(i) - 'a';
            root = root.child[ID];
        }
        return root.cnt;
    }

}

class Solution 
{
    public int minimumLengthEncoding(String[] words) 
    {
        Set<String> us = new HashSet(Arrays.asList(words));

        Trie T = new Trie();  
        for (String word : us)
            T.insert(word);
        
        int res = 0;
        for (String word : us)
        {
            if (T.search(word) == 1)
                res += word.length() + 1;
        }
        return res;

    }
}
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    1849    |    2876    |   64.3%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
