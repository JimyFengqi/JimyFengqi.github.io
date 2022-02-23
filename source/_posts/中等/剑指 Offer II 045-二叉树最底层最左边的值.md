---
title: 剑指 Offer II 045-二叉树最底层最左边的值
date: 2021-12-03 21:30:52
categories:
  - 中等
tags:
  - 树
  - 深度优先搜索
  - 广度优先搜索
  - 二叉树
---

> 原文链接: https://leetcode-cn.com/problems/LwUNpT




## 中文题目
<div><p>给定一个二叉树的 <strong>根节点</strong> <code>root</code>，请找出该二叉树的&nbsp;<strong>最底层&nbsp;最左边&nbsp;</strong>节点的值。</p>

<p>假设二叉树中至少有一个节点。</p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<p><img src="https://assets.leetcode.com/uploads/2020/12/14/tree1.jpg" style="width: 182px; " /></p>

<pre>
<strong>输入: </strong>root = [2,1,3]
<strong>输出: </strong>1
</pre>

<p><strong>示例 2: </strong></p>

<p><img src="https://assets.leetcode.com/uploads/2020/12/14/tree2.jpg" style="width: 242px; " /><strong> </strong></p>

<pre>
<strong>输入: </strong>[1,2,3,4,null,5,6,null,null,7]
<strong>输出: </strong>7
</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li>二叉树的节点个数的范围是 <code>[1,10<sup>4</sup>]</code></li>
	<li><meta charset="UTF-8" /><code>-2<sup>31</sup>&nbsp;&lt;= Node.val &lt;= 2<sup>31</sup>&nbsp;- 1</code>&nbsp;</li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 513&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/find-bottom-left-tree-value/">https://leetcode-cn.com/problems/find-bottom-left-tree-value/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# [剑指OfferII045.二叉树最底层最左边的值](https://leetcode-cn.com/problems/LwUNpT/solution/shua-chuan-jian-zhi-offer-day21-dui-lie-do26g/)
> https://leetcode-cn.com/problems/LwUNpT/solution/shua-chuan-jian-zhi-offer-day21-dui-lie-do26g/
> 
> 难度：中等

## 题目
给定一个二叉树的 根节点 root，请找出该二叉树的 最底层 最左边 节点的值。

假设二叉树中至少有一个节点。

提示:
- 二叉树的节点个数的范围是 [1,10 ^ 4]
- -2 ^ 31 <= Node.val <= 2 ^ 31 - 1 

## 示例：
```
示例 1:
输入:
    2
   / \
  1   3

输出:
1

示例 2:
输入:
        1
       / \
      2   3
     /   / \
    4   5   6
       /
      7

输出:
7
```

## 分析

首先，最简单的应该是BFS逐层遍历
1. 我们创建一个变量ret，用于记录每行的第一个val
2. 然后创建队列queue，由于题目说明至少有一个节点，则root无脑入队，开始while循环 
3. 判断每行的第一个节点，将ret变量更新为首个节点的值
4. 直到队列为空时，终止循环，返回ret即可。

## 解题

```python []
class Solution:
    def findBottomLeftValue(self, root):
        queue = deque([root])
        ret = root.val
        while queue:
            for i in range(len(queue)):
                q = queue.popleft()
                if i == 0:
                    ret = q.val
                if q.left:
                    queue.append(q.left)
                if q.right:
                    queue.append(q.right)
        return ret
```

```java []
class Solution {
    public int findBottomLeftValue(TreeNode root) {
        Queue<TreeNode> queue = new LinkedList<>();
        queue.add(root);
        int ret = root.val;
        while (!queue.isEmpty()) {
            int lg = queue.size();
            for (int i = 0; i < lg; i++) {
                TreeNode q = queue.poll();
                if (i == 0){
                    ret = q.val;
                }
                if (q.left != null) {
                    queue.add(q.left);
                }
                if (q.right != null) {
                    queue.add(q.right);
                }
            }
        }
        return ret;
    }
}
```

欢迎关注我的公众号: **清风Python**，带你每日学习Python算法刷题的同时，了解更多python小知识。

有喜欢力扣刷题的小伙伴可以加我微信（King_Uranus）互相鼓励，共同进步，一起玩转超级码力！

我的个人博客：[https://qingfengpython.cn](https://qingfengpython.cn)

力扣解题合集：[https://github.com/BreezePython/AlgorithmMarkdown](https://github.com/BreezePython/AlgorithmMarkdown)

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    4671    |    5795    |   80.6%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
