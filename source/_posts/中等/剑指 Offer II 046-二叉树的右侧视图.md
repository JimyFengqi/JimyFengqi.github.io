---
title: 剑指 Offer II 046-二叉树的右侧视图
date: 2021-12-03 21:30:51
categories:
  - 中等
tags:
  - 树
  - 深度优先搜索
  - 广度优先搜索
  - 二叉树
---

> 原文链接: https://leetcode-cn.com/problems/WNC0Lk




## 中文题目
<div><p>给定一个二叉树的 <strong>根节点</strong> <code>root</code>，想象自己站在它的右侧，按照从顶部到底部的顺序，返回从右侧所能看到的节点值。</p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<p><img src="https://assets.leetcode.com/uploads/2021/02/14/tree.jpg" style="width: 270px; " /></p>

<pre>
<strong>输入:</strong>&nbsp;[1,2,3,null,5,null,4]
<strong>输出:</strong>&nbsp;[1,3,4]
</pre>

<p><strong>示例 2:</strong></p>

<pre>
<strong>输入:</strong>&nbsp;[1,null,3]
<strong>输出:</strong>&nbsp;[1,3]
</pre>

<p><strong>示例 3:</strong></p>

<pre>
<strong>输入:</strong>&nbsp;[]
<strong>输出:</strong>&nbsp;[]
</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li>二叉树的节点个数的范围是 <code>[0,100]</code></li>
	<li><meta charset="UTF-8" /><code>-100&nbsp;&lt;= Node.val &lt;= 100</code>&nbsp;</li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 199&nbsp;题相同：<a href="https://leetcode-cn.com/problems/binary-tree-right-side-view/">https://leetcode-cn.com/problems/binary-tree-right-side-view/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
欲哭无泪，昨天腾讯面试面到的没写出来，今天发现就是当天剑指offerII计划的第三题啊啊，为啥我没勤快一点

```
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def rightSideView(self, root):
        res = []
        if not root:
            return res
        else:
            cur, res = [], []
            cur.append(root.left)
            cur.append(root.right)
            res.append(root.val)
        
        while cur:
            next_layer, view = [], []
            for node in cur: # 访问当前层所有的节点，记录他们的子节点
                if node:
                    next_layer.append(node.left)
                    next_layer.append(node.right)
                    view.append(node.val)
            if view: # 此题目标操作
                res.append(view[-1]) 
            cur = next_layer # 进入下一子层
        return res
```



## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    4390    |    6087    |   72.1%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
