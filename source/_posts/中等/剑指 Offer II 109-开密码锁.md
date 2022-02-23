---
title: 剑指 Offer II 109-开密码锁
categories:
  - 中等
tags:
  - 广度优先搜索
  - 数组
  - 哈希表
  - 字符串
abbrlink: 4255344571
date: 2021-12-03 21:30:47
---

> 原文链接: https://leetcode-cn.com/problems/zlDJc7




## 中文题目
<div><p>一个密码锁由 4&nbsp;个环形拨轮组成，每个拨轮都有 10 个数字： <code>&#39;0&#39;, &#39;1&#39;, &#39;2&#39;, &#39;3&#39;, &#39;4&#39;, &#39;5&#39;, &#39;6&#39;, &#39;7&#39;, &#39;8&#39;, &#39;9&#39;</code> 。每个拨轮可以自由旋转：例如把 <code>&#39;9&#39;</code> 变为&nbsp;<code>&#39;0&#39;</code>，<code>&#39;0&#39;</code> 变为 <code>&#39;9&#39;</code> 。每次旋转都只能旋转一个拨轮的一位数字。</p>

<p>锁的初始数字为 <code>&#39;0000&#39;</code> ，一个代表四个拨轮的数字的字符串。</p>

<p>列表 <code>deadends</code> 包含了一组死亡数字，一旦拨轮的数字和列表里的任何一个元素相同，这个锁将会被永久锁定，无法再被旋转。</p>

<p>字符串 <code>target</code> 代表可以解锁的数字，请给出解锁需要的最小旋转次数，如果无论如何不能解锁，返回 <code>-1</code> 。</p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<pre>
<strong>输入：</strong>deadends = [&quot;0201&quot;,&quot;0101&quot;,&quot;0102&quot;,&quot;1212&quot;,&quot;2002&quot;], target = &quot;0202&quot;
<strong>输出：</strong>6
<strong>解释：</strong>
可能的移动序列为 &quot;0000&quot; -&gt; &quot;1000&quot; -&gt; &quot;1100&quot; -&gt; &quot;1200&quot; -&gt; &quot;1201&quot; -&gt; &quot;1202&quot; -&gt; &quot;0202&quot;。
注意 &quot;0000&quot; -&gt; &quot;0001&quot; -&gt; &quot;0002&quot; -&gt; &quot;0102&quot; -&gt; &quot;0202&quot; 这样的序列是不能解锁的，因为当拨动到 &quot;0102&quot; 时这个锁就会被锁定。
</pre>

<p><strong>示例 2:</strong></p>

<pre>
<strong>输入:</strong> deadends = [&quot;8888&quot;], target = &quot;0009&quot;
<strong>输出：</strong>1
<strong>解释：</strong>
把最后一位反向旋转一次即可 &quot;0000&quot; -&gt; &quot;0009&quot;。
</pre>

<p><strong>示例 3:</strong></p>

<pre>
<strong>输入:</strong> deadends = [&quot;8887&quot;,&quot;8889&quot;,&quot;8878&quot;,&quot;8898&quot;,&quot;8788&quot;,&quot;8988&quot;,&quot;7888&quot;,&quot;9888&quot;], target = &quot;8888&quot;
<strong>输出：</strong>-1
<strong>解释：
</strong>无法旋转到目标数字且不被锁定。
</pre>

<p><strong>示例 4:</strong></p>

<pre>
<strong>输入:</strong> deadends = [&quot;0000&quot;], target = &quot;8888&quot;
<strong>输出：</strong>-1
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;=&nbsp;deadends.length &lt;= 500</code></li>
	<li><code><font face="monospace">deadends[i].length == 4</font></code></li>
	<li><code><font face="monospace">target.length == 4</font></code></li>
	<li><code>target</code> <strong>不在</strong> <code>deadends</code> 之中</li>
	<li><code>target</code> 和 <code>deadends[i]</code> 仅由若干位数字组成</li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 752&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/open-the-lock/">https://leetcode-cn.com/problems/open-the-lock/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
简单题，解释都在代码对应的注释中。
找“邻居”的方法代码写得有些冗余，可自行优化。
```
class Solution {
    public int openLock(String[] deadends, String target) {
        //用双向广度优先遍历方法，哈希集合代替队列，因为哈希集合判断一个节点是否访问过只需要O(1)的时间，整个算法可大幅提升时间复杂度
        Set<String> dead = new HashSet<>(Arrays.asList(deadends));
        if(target.equals("0000")) return 0;
        if(dead.contains("0000") || dead.contains(target)) return -1;
        //起始节点集合
        Set<String> set1 = new HashSet<>();
        //目标节点集合
        Set<String> set2 = new HashSet<>();
        set1.add("0000");
        set2.add(target);
        Set<String> vis = new HashSet<>();//记录已经访问(到达)过的邻居
        vis.add("0000");
        int len = 1; 
        //双向遍历可以避免访问很多不满足条件的节点从而大幅提高搜索效率
        while(!set1.isEmpty() && !set2.isEmpty()){
            //我们要保证从节点较小的那个集合开始广度遍历，这里固定从set1开始
            if(set1.size() > set2.size()){
                Set<String> tmp = set1;
                set1 = set2;
                set2 = tmp;
            }
            //set3用来保存set1一趟遍历的“邻居”
            Set<String> set3 = new HashSet<>();
            for(String s : set1){
                List<String> neighbors = getNeighbors(s);
                for(String neighbor : neighbors){
                    //如果邻居属于死亡节点，直接跳过
                    if(dead.contains(neighbor)) continue;
                    //如果本次遍历的邻居就是目标节点，则找到一条从起始到目标节点的最短路径
                    if(set2.contains(neighbor)) return len;
                    //如果本次遍历的“邻居”未曾到达，把它加进邻居集合里并标记已访问
                    if(!vis.contains(neighbor)){
                        set3.add(neighbor);
                        vis.add(neighbor);
                    }
                }
            }
            //到这里说明通过一趟遍历没有找到一条路径，就把路径长度+1，同时把本趟邻居集合当作下一趟开始遍历的起始节点集合
            len++;
            set1 = set3;
        }
        return -1;
    }

    //求传入的字符串“邻居”集合
    public List<String> getNeighbors(String s){
        List<String> ls = new LinkedList<>();
        char[] ch = s.toCharArray();
        StringBuilder sb = new StringBuilder(s);
        for(int i = 0; i < ch.length; ++i){
            char old = ch[i];
            ch[i] = ch[i] == '0' ? '9' : (char)(ch[i]-1);
            sb.setCharAt(i, ch[i]);
            ls.add(sb.toString());
            sb.setCharAt(i, old);
            ch[i] = old;
            ch[i] = ch[i] == '9' ? '0' : (char)(ch[i]+1);
            sb.setCharAt(i, ch[i]);
            ls.add(sb.toString());
            sb.setCharAt(i, old);
            ch[i] = old;
        }
        return ls;
    }
}
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    1880    |    3136    |   59.9%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
