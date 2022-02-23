---
title: 剑指 Offer II 053-二叉搜索树中的中序后继
categories:
  - 中等
tags:
  - 树
  - 深度优先搜索
  - 二叉搜索树
  - 二叉树
abbrlink: 2755114557
date: 2021-12-03 21:30:30
---

> 原文链接: https://leetcode-cn.com/problems/P5rCT8




## 中文题目
<div><p>给定一棵二叉搜索树和其中的一个节点 <code>p</code> ，找到该节点在树中的中序后继。如果节点没有中序后继，请返回 <code>null</code> 。</p>

<p>节点&nbsp;<code>p</code>&nbsp;的后继是值比&nbsp;<code>p.val</code>&nbsp;大的节点中键值最小的节点，即按中序遍历的顺序节点 <code>p</code> 的下一个节点。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<p><img alt="" src="https://assets.leetcode.com/uploads/2019/01/23/285_example_1.PNG" style="height: 117px; width: 122px;" /></p>

<pre>
<strong>输入：</strong>root = [2,1,3], p = 1
<strong>输出：</strong>2
<strong>解释：</strong>这里 1 的中序后继是 2。请注意 p 和返回值都应是 TreeNode 类型。
</pre>

<p><strong>示例&nbsp;2：</strong></p>

<p><img alt="" src="https://assets.leetcode.com/uploads/2019/01/23/285_example_2.PNG" style="height: 229px; width: 246px;" /></p>

<pre>
<strong>输入：</strong>root = [5,3,6,2,4,null,null,1], p = 6
<strong>输出：</strong>null
<strong>解释：</strong>因为给出的节点没有中序后继，所以答案就返回 <code>null 了。</code>
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li>树中节点的数目在范围 <code>[1, 10<sup>4</sup>]</code> 内。</li>
	<li><code>-10<sup>5</sup> &lt;= Node.val &lt;= 10<sup>5</sup></code></li>
	<li>树中各节点的值均保证唯一。</li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 285&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/inorder-successor-in-bst/">https://leetcode-cn.com/problems/inorder-successor-in-bst/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
### 解题思路
- 下一个节点的值一定不会小于节点p的值，而是大于或等于节点p的值的所有节点中值最小的一个

- 从根节点开始，每到达一个节点就比较根节点的值和节点p的值
- 如果当前节点的值小于或等于节点p的值，那么节点p的下一个节点应该在它的右子树


- 如果当前节点的值大于或等于节点p的值，那么当前节点有可能是p的下一个节点，此时当前节点的值比节点p的值大，但节点p的下一个节点是所有比它大的节点中值最小的一个，因此接下来前往当前节点的左子树，确定是否能找到值更小，但仍然大于节点p的值的节点

### 代码

```javascript
/**
 * @param {TreeNode} root
 * @param {TreeNode} p
 * @return {TreeNode}
 */
var inorderSuccessor = function(root, p) {
  let cur = root;
  let result = null;
  while (cur) {
    if (cur.val > p.val) {
      result = cur;
      cur = cur.left;
    } else {
      cur = cur.right;
    }
  }
  return result;
};
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    4747    |    7410    |   64.1%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
