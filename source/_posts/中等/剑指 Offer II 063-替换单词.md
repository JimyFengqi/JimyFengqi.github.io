---
title: 剑指 Offer II 063-替换单词
date: 2021-12-03 21:28:27
categories:
  - 中等
tags:
  - 字典树
  - 数组
  - 哈希表
  - 字符串
---

> 原文链接: https://leetcode-cn.com/problems/UhWRSj




## 中文题目
<div><p>在英语中，有一个叫做&nbsp;<code>词根(root)</code> 的概念，它可以跟着其他一些词组成另一个较长的单词&mdash;&mdash;我们称这个词为&nbsp;<code>继承词(successor)</code>。例如，词根<code>an</code>，跟随着单词&nbsp;<code>other</code>(其他)，可以形成新的单词&nbsp;<code>another</code>(另一个)。</p>

<p>现在，给定一个由许多词根组成的词典和一个句子，需要将句子中的所有<code>继承词</code>用<code>词根</code>替换掉。如果<code>继承词</code>有许多可以形成它的<code>词根</code>，则用最短的词根替换它。</p>

<p>需要输出替换之后的句子。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>dictionary = [&quot;cat&quot;,&quot;bat&quot;,&quot;rat&quot;], sentence = &quot;the cattle was rattled by the battery&quot;
<strong>输出：</strong>&quot;the cat was rat by the bat&quot;
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>dictionary = [&quot;a&quot;,&quot;b&quot;,&quot;c&quot;], sentence = &quot;aadsfasf absbs bbab cadsfafs&quot;
<strong>输出：</strong>&quot;a a b c&quot;
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>dictionary = [&quot;a&quot;, &quot;aa&quot;, &quot;aaa&quot;, &quot;aaaa&quot;], sentence = &quot;a aa a aaaa aaa aaa aaa aaaaaa bbb baba ababa&quot;
<strong>输出：</strong>&quot;a a a a a a a a bbb baba a&quot;
</pre>

<p><strong>示例 4：</strong></p>

<pre>
<strong>输入：</strong>dictionary = [&quot;catt&quot;,&quot;cat&quot;,&quot;bat&quot;,&quot;rat&quot;], sentence = &quot;the cattle was rattled by the battery&quot;
<strong>输出：</strong>&quot;the cat was rat by the bat&quot;
</pre>

<p><strong>示例 5：</strong></p>

<pre>
<strong>输入：</strong>dictionary = [&quot;ac&quot;,&quot;ab&quot;], sentence = &quot;it is abnormal that this solution is accepted&quot;
<strong>输出：</strong>&quot;it is ab that this solution is ac&quot;
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= dictionary.length&nbsp;&lt;= 1000</code></li>
	<li><code>1 &lt;= dictionary[i].length &lt;= 100</code></li>
	<li><code>dictionary[i]</code>&nbsp;仅由小写字母组成。</li>
	<li><code>1 &lt;= sentence.length &lt;= 10^6</code></li>
	<li><code>sentence</code>&nbsp;仅由小写字母和空格组成。</li>
	<li><code>sentence</code> 中单词的总量在范围 <code>[1, 1000]</code> 内。</li>
	<li><code>sentence</code> 中每个单词的长度在范围 <code>[1, 1000]</code> 内。</li>
	<li><code>sentence</code> 中单词之间由一个空格隔开。</li>
	<li><code>sentence</code>&nbsp;没有前导或尾随空格。</li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 648&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/replace-words/">https://leetcode-cn.com/problems/replace-words/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
先构造前缀树的数据结构然后完成需要的功能即可满足题目需求
```
class Solution {
    //前缀树数据结构是一个字符多叉树，用一个数组来保存其子节点， isValid用来标记截止到该节点是否为一个完整的单词
    class TrieNode{
        TrieNode[] kids;
        boolean isValid;
        public TrieNode(){
            kids = new TrieNode[26];
        }
    }

    TrieNode root = new TrieNode();
    public String replaceWords(List<String> dictionary, String sentence) {
        String[] words = new String[dictionary.size()];
        for(int i = 0; i < words.length; ++i) words[i] = dictionary.get(i);
        //建树过程
        for(String word : words){
            insert(root, word);
        }
        String[] strs = sentence.split(" ");
        for(int i = 0; i < strs.length; ++i){
            //如果可以在树中找到对应单词的前缀，那么将这个单词替换为它的前缀
            if(search(root, strs[i])){
                strs[i] = replace(strs[i], root);
            }
        }
        //用StringBuilder来把字符串数组还原成原字符串句子的转换目标字符串
        StringBuilder sb = new StringBuilder();
        for(String s : strs){
            sb.append(s).append(" ");
        }
        sb.deleteCharAt(sb.length()-1);
        return sb.toString();
    }
    //建前缀树模版
    public void insert(TrieNode root, String s){
        TrieNode node = root;
        for(char ch : s.toCharArray()){
            if(node.kids[ch - 'a'] == null) node.kids[ch - 'a'] = new TrieNode();
            node = node.kids[ch - 'a'];
        }
        node.isValid = true;
    }
    //查询是否存在传入的字符串的前缀
    public boolean search(TrieNode root, String s){
        TrieNode node = root;
        for(char ch : s.toCharArray()){
            if(node.isValid == true) break;
            if(node.kids[ch - 'a'] == null) return false;
            node = node.kids[ch - 'a'];
        }
        return true;
    }
    //将传入的字符串替换为它在前缀树中的前缀字符串
    public String replace(String s, TrieNode root){
        TrieNode node = root;
        StringBuilder sb = new StringBuilder();
        for(char ch : s.toCharArray()){
            if(node.isValid || node.kids[ch - 'a'] == null) break;
            node = node.kids[ch - 'a'];
            sb.append(ch);
        }
        return sb.toString();
    }
}
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    2405    |    3332    |   72.2%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
