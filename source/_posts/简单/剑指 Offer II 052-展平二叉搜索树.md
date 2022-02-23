---
title: 剑指 Offer II 052-展平二叉搜索树
date: 2021-12-03 21:30:35
categories:
  - 简单
tags:
  - 栈
  - 树
  - 深度优先搜索
  - 二叉搜索树
  - 二叉树
---

> 原文链接: https://leetcode-cn.com/problems/NYBBNL




## 中文题目
<div><p>给你一棵二叉搜索树，请&nbsp;<strong>按中序遍历</strong> 将其重新排列为一棵递增顺序搜索树，使树中最左边的节点成为树的根节点，并且每个节点没有左子节点，只有一个右子节点。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<p><img alt="" src="https://assets.leetcode.com/uploads/2020/11/17/ex1.jpg" style="width: 600px; height: 350px;" /></p>

<pre>
<strong>输入：</strong>root = [5,3,6,2,4,null,8,1,null,null,null,7,9]
<strong>输出：</strong>[1,null,2,null,3,null,4,null,5,null,6,null,7,null,8,null,9]
</pre>

<p><strong>示例 2：</strong></p>

<p><img alt="" src="https://assets.leetcode.com/uploads/2020/11/17/ex2.jpg" style="width: 300px; height: 114px;" /></p>

<pre>
<strong>输入：</strong>root = [5,1,7]
<strong>输出：</strong>[1,null,5,null,7]
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li>树中节点数的取值范围是 <code>[1, 100]</code></li>
	<li><code>0 &lt;= Node.val &lt;= 1000</code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 897&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/increasing-order-search-tree/">https://leetcode-cn.com/problems/increasing-order-search-tree/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
class Solution {
    List<Integer> ls = new ArrayList<>();
    public TreeNode increasingBST(TreeNode root) {
        if(root == null) return null;
        inorder(root);
        TreeNode head = new TreeNode(ls.get(0));
        TreeNode pre = head;
        int i = 1;
        while(i < ls.size()){
            TreeNode node = new TreeNode(ls.get(i));
            pre.right = node;
            pre = pre.right;
            i++;
        }
        return head;
    }

    void inorder(TreeNode node){
        if(node == null) return;
        inorder(node.left);
        ls.add(node.val);
        inorder(node.right);
    }
}


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    5053    |    6801    |   74.3%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
