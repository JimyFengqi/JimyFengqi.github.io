---
title: 剑指 Offer II 115-重建序列
date: 2021-12-03 21:30:29
categories:
  - 中等
tags:
  - 图
  - 拓扑排序
  - 数组
---

> 原文链接: https://leetcode-cn.com/problems/ur2n8P




## 中文题目
<div><p>请判断原始的序列&nbsp;<code>org</code>&nbsp;是否可以从序列集&nbsp;<code>seqs</code>&nbsp;中唯一地 <strong>重建&nbsp;</strong>。</p>

<p>序列&nbsp;<code>org</code>&nbsp;是 1 到 n 整数的排列，其中 1 &le; n &le; 10<sup>4</sup>。<strong>重建&nbsp;</strong>是指在序列集 <code>seqs</code> 中构建最短的公共超序列，即&nbsp;&nbsp;<code>seqs</code>&nbsp;中的任意序列都是该最短序列的子序列。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入: </strong>org = [1,2,3], seqs = [[1,2],[1,3]]
<strong>输出: </strong>false
<strong>解释：</strong>[1,2,3] 不是可以被重建的唯一的序列，因为 [1,3,2] 也是一个合法的序列。
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入: </strong>org = [1,2,3], seqs = [[1,2]]
<strong>输出: </strong>false
<strong>解释：</strong>可以重建的序列只有 [1,2]。
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入: </strong>org = [1,2,3], seqs = [[1,2],[1,3],[2,3]]
<strong>输出: </strong>true
<strong>解释：</strong>序列 [1,2], [1,3] 和 [2,3] 可以被唯一地重建为原始的序列 [1,2,3]。
</pre>

<p><strong>示例 4：</strong></p>

<pre>
<strong>输入: </strong>org = [4,1,5,2,6,3], seqs = [[5,2,6,3],[4,1,5,2]]
<strong>输出: </strong>true
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= n &lt;= 10<sup>4</sup></code></li>
	<li><code>org</code> 是数字 <code>1</code> 到 <code>n</code> 的一个排列</li>
	<li><code>1 &lt;= segs[i].length &lt;= 10<sup>5</sup></code></li>
	<li><code>seqs[i][j]</code> 是 <code>32</code> 位有符号整数</li>
</ul>

<p>&nbsp;</p>

<p>注意：本题与主站 444&nbsp;题相同：<a href="https://leetcode-cn.com/problems/sequence-reconstruction/">https://leetcode-cn.com/problems/sequence-reconstruction/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# **拓扑排序**
按照题目的要求，若在 seqs 的某个序列中数字 i 出现在数字 j 之前，那么由 seqs 重建的序列中数字 i 一定出现在 j 之前，也就是说重建的序列 org 就是由 seqs 确定的拓扑排序。题目中要求 org 是由 seqs 重建的唯一的序列，即序列 org 为由 seqs 确定的唯一的拓扑排序。

需要使用一个哈希表记录由 seqs 构建图的各节点的邻接表，用一个数组记录各节点的入度。之后在使用队列进行广度优先搜索确定图的拓扑排序时，因为需要满足唯一性，所以每次入度为 0 的节点必须唯一，且需要与 org 中一一对应。完整代码如下，因为节点数 v 为 org.size()，边的个数 e 为 O(sum(seqs[i].size))，所以时间复杂度为 O(v + e)。
```
class Solution {
public:
    bool sequenceReconstruction(vector<int>& org, vector<vector<int>>& seqs) {
        // 建图
        unordered_map<int, unordered_set<int>> graph;
        vector<int> inDegree(org.size() + 1, -1);
        for (auto& seq : seqs) {
            for (int& n : seq) {
                // 节点需要合法
                if (n < 1 || n > org.size()) {
                    return false;
                }
                if (!graph.count(n)) {
                    graph[n] = {};
                }
                if (inDegree[n] == -1) {
                    inDegree[n] = 0;
                }
            }
            for (int i = 0; i < seq.size() - 1; ++i) {
                int num1 = seq[i];
                int num2 = seq[i + 1];
                if (!graph[num1].count(num2)) {
                    graph[num1].insert(num2);
                    inDegree[num2]++;
                }
            }
        }
        
        // 初始化队列
        queue<int> que;
        int index = 0;
        for (int i = 1; i < inDegree.size(); ++i) {
            if (inDegree[i] == 0) {
                // 存在唯一入度为 0 的节点，且与 org[0] 相等
                if (que.size() == 0 && org[index++] == i) {
                    que.push(i);
                }
                else {
                    return false;
                }
            }
        }

        // BFS
        while (!que.empty()) {
            int node = que.front();
            que.pop();
            for (auto& n : graph[node]) {
                inDegree[n]--;
                if (inDegree[n] == 0) {
                    // 每次只存在唯一入度为 0 的节点，且与 org[index] 相等
                    if (que.size() == 0 && org[index++] == n) {
                        que.push(n);
                    }
                    else {
                        return false;
                    }                    
                }
            }
        }

        return index == org.size();
    }
};
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    1197    |    3852    |   31.1%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
