---
title: 剑指 Offer II 056-二叉搜索树中两个节点之和
date: 2021-12-03 21:28:36
categories:
  - 简单
tags:
  - 树
  - 深度优先搜索
  - 广度优先搜索
  - 二叉搜索树
  - 哈希表
  - 双指针
  - 二叉树
---

> 原文链接: https://leetcode-cn.com/problems/opLdQZ




## 中文题目
<div><p>给定一个二叉搜索树的 <strong>根节点</strong> <code>root</code>&nbsp;和一个整数 <code>k</code> , 请判断该二叉搜索树中是否存在两个节点它们的值之和等于 <code>k</code> 。假设二叉搜索树中节点的值均唯一。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入: </strong>root =<strong> </strong>[8,6,10,5,7,9,11], k = 12
<strong>输出: </strong>true
<strong>解释: </strong>节点 5 和节点 7 之和等于 12
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入: </strong>root =<strong> </strong>[8,6,10,5,7,9,11], k = 22
<strong>输出: </strong>false
<strong>解释: </strong>不存在两个节点值之和为 22 的节点
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li>二叉树的节点个数的范围是&nbsp;&nbsp;<code>[1, 10<sup>4</sup>]</code>.</li>
	<li><code>-10<sup>4</sup>&nbsp;&lt;= Node.val &lt;= 10<sup>4</sup></code></li>
	<li><code>root</code>&nbsp;为二叉搜索树</li>
	<li><code>-10<sup>5</sup>&nbsp;&lt;= k &lt;= 10<sup>5</sup></code></li>
</ul>

<p>&nbsp;</p>

<p>注意：本题与主站 653 题相同：&nbsp;<a href="https://leetcode-cn.com/problems/two-sum-iv-input-is-a-bst/">https://leetcode-cn.com/problems/two-sum-iv-input-is-a-bst/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# **哈希表**
解决该问题的直观思路就是利用哈希表来保存当前节点的值。可以采用任何形式的二叉树遍历方式，每当遍历到一个节点，若该节点的值为 m，则就在哈希表内查找是否存在 k - m 的节点，若存在则返回 true，反之则保存该节点的值到哈希表，并开始遍历下一个节点。

这种方式适合任意形式的二叉树，若二叉树的节点数为 n，深度为 h，则时间复杂度为 O(n)，因为中序遍历时的栈的空间复杂度为 O(h)，哈希表的空间复杂度为 O(n)，所以总的空间复杂度为 O(n) 。代码如下
```
class Solution {
public:
    bool findTarget(TreeNode* root, int k) {
        if (root == nullptr) {
            return false;
        }
        unordered_set<int> nums;
        stack<TreeNode*> sta;
        TreeNode* cur = root;
        while (cur != nullptr || !sta.empty()) {
            while (cur != nullptr) {
                sta.push(cur);
                cur = cur->left;
            }
            cur = sta.top();
            sta.pop();
            if (nums.count(k - cur->val)) {
                return true;
            }
            nums.insert(cur->val);
            cur = cur->right;
        }
        return false;
    }
};
```
# **双指针**
[剑指offer 2 面试题6](https://leetcode-cn.com/problems/kLl5u1/solution/jian-zhi-offer-2-mian-shi-ti-6-shu-zhong-db75/) 中介绍了如何利用双指针在排序的数组中查找和为 k 的两个数。考虑到二叉搜索树的中序遍历结果就是一个升序的数组，所以可以在这里使用双指针。一种直观的想法是先完成一次二叉搜索树的中序遍历，将结果保存在数组中则可以完全使用面试题 6 中的方法。但是联想到前一题 [剑指offer 2 面试题55](https://leetcode-cn.com/problems/kTOapQ/solution/jian-zhi-offer-2-mian-shi-ti-55-shu-zhon-83vh/) ，在面试题 54 中可以做到在 O(1) 时间内得到中序遍历的下一个结果，而无需事先先得到中序遍历的结果数组。在使用双指针的时候，第一个指针指向第一个数字。第二个指针指向最后一个数字，然后每一步判断移动相应的指针。第一个指针的遍历顺序需要从小到大遍历二叉搜索树，可以从面试题 55 中找到答案。同时第二个指针的遍历顺序需要从大到小遍历二叉搜索树，受 [剑指offer 2 面试题54](https://leetcode-cn.com/problems/w6cpku/solution/jian-zhi-offer-2-mian-shi-ti-54-shu-zhon-s6jg/) 启发，交换中序遍历算法中的指向左右子节点的指针，就可以实现按照从大到小的顺序遍历二叉搜索树。

代码如下，时间复杂度为 O(n)，空间复杂度为 O(h)。
```
class Solution {
public:
    bool findTarget(TreeNode* root, int k) {
        if (root == nullptr) {
            return false;
        }
        leftCur = root;
        rightCur = root;
        int left = leftInorderTra();
        int right = rightInorderTra();
        while (left < right) {
            int sum = left + right;
            if (sum == k) {
                return true;
            }
            if (sum > k) {
                right = rightInorderTra();
            }
            else {
                left = leftInorderTra();
            }
        }
        return false;
    }
private:
    TreeNode* leftCur;
    TreeNode* rightCur;
    stack<TreeNode*> leftSta;
    stack<TreeNode*> rightSta;

    int leftInorderTra() {
        while (leftCur != nullptr) {
            leftSta.push(leftCur);
            leftCur = leftCur->left;
        }
        leftCur = leftSta.top();
        leftSta.pop();
        int ret = leftCur->val;
        leftCur = leftCur->right;
        return ret;
    }

    int rightInorderTra() {
        while (rightCur != nullptr) {
            rightSta.push(rightCur);
            rightCur = rightCur->right;
        }
        rightCur = rightSta.top();
        rightSta.pop();
        int ret = rightCur->val;
        rightCur = rightCur->left;
        return ret;
    }
};
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    4974    |    6935    |   71.7%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
