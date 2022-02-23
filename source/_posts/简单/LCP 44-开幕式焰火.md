---
title: LCP 44-开幕式焰火
categories:
  - 简单
tags:
  - 树
  - 深度优先搜索
  - 广度优先搜索
  - 哈希表
  - 二叉树
abbrlink: 2343996246
date: 2021-12-03 21:28:03
---

> 原文链接: https://leetcode-cn.com/problems/sZ59z6


## 英文原文
<div></div>

## 中文题目
<div>「力扣挑战赛」开幕式开始了，空中绽放了一颗二叉树形的巨型焰火。
给定一棵二叉树 `root` 代表焰火，节点值表示巨型焰火这一位置的颜色种类。请帮小扣计算巨型焰火有多少种不同的颜色。


**示例 1：**
>输入：`root = [1,3,2,1,null,2]`
>
>输出：`3`
>
>解释：焰火中有 3 个不同的颜色，值分别为 1、2、3

**示例 2：**
>输入：`root = [3,3,3]`
>
>输出：`1`
>
>解释：焰火中仅出现 1 个颜色，值为 3

**提示：**
- `1 <= 节点个数 <= 1000`
- `1 <= Node.val <= 1000`


</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
思路和心得：

# （一）dfs+无序集合

```python3 []
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
class Solution:
    def numColor(self, root: TreeNode) -> int:
        def dfs(rt):
            if rt:
                us.add(rt.val)
                dfs(rt.left)
                dfs(rt.right)
        
        us = set()
        dfs(root)
        return len(us)
        
```

```c++ []
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode(int x) : val(x), left(NULL), right(NULL) {}
 * };
 */
class Solution 
{
public:
    unordered_set<int> us;

    void dfs(TreeNode * rt)
    {
        if (rt)
        {
            us.insert(rt->val);
            dfs(rt->left);
            dfs(rt->right);
        }
    }

    int numColor(TreeNode* root) 
    {
        dfs(root);
        return (int)us.size();
    }
};
```

```java []
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode(int x) { val = x; }
 * }
 */
class Solution 
{
    Set<Integer> us = new HashSet<>();

    public void dfs(TreeNode rt)
    {
        if (rt != null)
        {
            us.add(rt.val);
            dfs(rt.left);
            dfs(rt.right);
        }
    }

    public int numColor(TreeNode root) 
    {
        dfs(root);
        return us.size();
    }
}
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    3345    |    4063    |   82.3%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
