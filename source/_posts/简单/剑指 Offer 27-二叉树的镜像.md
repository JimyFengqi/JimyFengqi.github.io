---
title: 剑指 Offer 27-二叉树的镜像(二叉树的镜像  LCOF)
categories:
  - 简单
tags:
  - 树
  - 深度优先搜索
  - 广度优先搜索
  - 二叉树
abbrlink: 501570289
date: 2021-12-03 21:39:41
---

> 原文链接: https://leetcode-cn.com/problems/er-cha-shu-de-jing-xiang-lcof




## 中文题目
<div><p>请完成一个函数，输入一个二叉树，该函数输出它的镜像。</p>

<p>例如输入：</p>

<p><code>&nbsp; &nbsp; &nbsp;4<br>
&nbsp; &nbsp;/ &nbsp; \<br>
&nbsp; 2 &nbsp; &nbsp; 7<br>
&nbsp;/ \ &nbsp; / \<br>
1 &nbsp; 3 6 &nbsp; 9</code><br>
镜像输出：</p>

<p><code>&nbsp; &nbsp; &nbsp;4<br>
&nbsp; &nbsp;/ &nbsp; \<br>
&nbsp; 7 &nbsp; &nbsp; 2<br>
&nbsp;/ \ &nbsp; / \<br>
9 &nbsp; 6 3&nbsp; &nbsp;1</code></p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre><strong>输入：</strong>root = [4,2,7,1,3,6,9]
<strong>输出：</strong>[4,7,2,9,6,3,1]
</pre>

<p>&nbsp;</p>

<p><strong>限制：</strong></p>

<p><code>0 &lt;= 节点个数 &lt;= 1000</code></p>

<p>注意：本题与主站 226 题相同：<a href="https://leetcode-cn.com/problems/invert-binary-tree/">https://leetcode-cn.com/problems/invert-binary-tree/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
**二叉树镜像定义：** 对于二叉树中任意节点 $root$ ，设其左 / 右子节点分别为 $left, right$ ；则在二叉树的镜像中的对应 $root$ 节点，其左 / 右子节点分别为 $right, left$ 。

![Picture1.png](../images/er-cha-shu-de-jing-xiang-lcof-0.png){:width=450}

#### 方法一：递归法

- 根据二叉树镜像的定义，考虑递归遍历（dfs）二叉树，交换每个节点的左 / 右子节点，即可生成二叉树的镜像。

##### 递归解析：

1. **终止条件：** 当节点 $root$ 为空时（即越过叶节点），则返回 $null$ ；
2. **递推工作：**
   1. 初始化节点 $tmp$ ，用于暂存 $root$ 的左子节点；
   2. 开启递归 **右子节点** $mirrorTree(root.right)$ ，并将返回值作为 $root$ 的 **左子节点** 。
   3. 开启递归 **左子节点** $mirrorTree(tmp)$ ，并将返回值作为 $root$ 的 **右子节点** 。
3. **返回值：** 返回当前节点 $root$ ；

> **Q：** 为何需要暂存 $root$ 的左子节点？
> **A：** 在递归右子节点 “$root.left = mirrorTree(root.right);$” 执行完毕后， $root.left$ 的值已经发生改变，此时递归左子节点 $mirrorTree(root.left)$ 则会出问题。

<![Picture2.png](../images/er-cha-shu-de-jing-xiang-lcof-1.png),![Picture3.png](../images/er-cha-shu-de-jing-xiang-lcof-2.png),![Picture4.png](../images/er-cha-shu-de-jing-xiang-lcof-3.png),![Picture5.png](../images/er-cha-shu-de-jing-xiang-lcof-4.png),![Picture6.png](../images/er-cha-shu-de-jing-xiang-lcof-5.png),![Picture7.png](../images/er-cha-shu-de-jing-xiang-lcof-6.png),![Picture8.png](../images/er-cha-shu-de-jing-xiang-lcof-7.png),![Picture9.png](../images/er-cha-shu-de-jing-xiang-lcof-8.png),![Picture10.png](../images/er-cha-shu-de-jing-xiang-lcof-9.png),![Picture11.png](../images/er-cha-shu-de-jing-xiang-lcof-10.png),![Picture12.png](../images/er-cha-shu-de-jing-xiang-lcof-11.png)>

##### 复杂度分析：

- **时间复杂度 $O(N)$ ：** 其中 $N$ 为二叉树的节点数量，建立二叉树镜像需要遍历树的所有节点，占用 $O(N)$ 时间。
- **空间复杂度 $O(N)$ ：** 最差情况下（当二叉树退化为链表），递归时系统需使用 $O(N)$ 大小的栈空间。

#### 代码：

Python 利用平行赋值的写法（即 $a, b = b, a$ ），可省略暂存操作。其原理是先将等号右侧打包成元组 $(b,a)$ ，再序列地分给等号左侧的 $a, b$ 序列。

```Java []
class Solution {
    public TreeNode mirrorTree(TreeNode root) {
        if(root == null) return null;
        TreeNode tmp = root.left;
        root.left = mirrorTree(root.right);
        root.right = mirrorTree(tmp);
        return root;
    }
}
```

```C++ []
class Solution {
public:
    TreeNode* mirrorTree(TreeNode* root) {
        if (root == nullptr) return nullptr;
        TreeNode* tmp = root->left;
        root->left = mirrorTree(root->right);
        root->right = mirrorTree(tmp);
        return root;
    }
};
```

```Python []
class Solution:
    def mirrorTree(self, root: TreeNode) -> TreeNode:
        if not root: return
        root.left, root.right = self.mirrorTree(root.right), self.mirrorTree(root.left)
        return root
```

```Python []
class Solution:
    def mirrorTree(self, root: TreeNode) -> TreeNode:
        if not root: return
        tmp = root.left
        root.left = self.mirrorTree(root.right)
        root.right = self.mirrorTree(tmp)
        return root
```

#### 方法二：辅助栈（或队列）

- 利用栈（或队列）遍历树的所有节点 $node$ ，并交换每个 $node$ 的左 / 右子节点。

##### 算法流程：

1. **特例处理：** 当 $root$ 为空时，直接返回 $null$ ；
2. **初始化：** 栈（或队列），本文用栈，并加入根节点 $root$ 。
3. **循环交换：** 当栈 $stack$ 为空时跳出；
   1. **出栈：** 记为 $node$ ；
   2. **添加子节点：** 将 $node$ 左和右子节点入栈；
   3. **交换：** 交换 $node$ 的左 / 右子节点。
4. **返回值：** 返回根节点 $root$ 。

<![Picture13.png](../images/er-cha-shu-de-jing-xiang-lcof-12.png),![Picture14.png](../images/er-cha-shu-de-jing-xiang-lcof-13.png),![Picture15.png](../images/er-cha-shu-de-jing-xiang-lcof-14.png),![Picture16.png](../images/er-cha-shu-de-jing-xiang-lcof-15.png),![Picture17.png](../images/er-cha-shu-de-jing-xiang-lcof-16.png),![Picture18.png](../images/er-cha-shu-de-jing-xiang-lcof-17.png),![Picture19.png](../images/er-cha-shu-de-jing-xiang-lcof-18.png),![Picture20.png](../images/er-cha-shu-de-jing-xiang-lcof-19.png),![Picture21.png](../images/er-cha-shu-de-jing-xiang-lcof-20.png),![Picture22.png](../images/er-cha-shu-de-jing-xiang-lcof-21.png),![Picture23.png](../images/er-cha-shu-de-jing-xiang-lcof-22.png),![Picture24.png](../images/er-cha-shu-de-jing-xiang-lcof-23.png),![Picture25.png](../images/er-cha-shu-de-jing-xiang-lcof-24.png),![Picture26.png](../images/er-cha-shu-de-jing-xiang-lcof-25.png),![Picture27.png](../images/er-cha-shu-de-jing-xiang-lcof-26.png)>

##### 复杂度分析：

- **时间复杂度 $O(N)$ ：** 其中 $N$ 为二叉树的节点数量，建立二叉树镜像需要遍历树的所有节点，占用 $O(N)$ 时间。
- **空间复杂度 $O(N)$ ：** 如下图所示，最差情况下，栈 $stack$ 最多同时存储 $\frac{N + 1}{2}$ 个节点，占用 $O(N)$ 额外空间。

![Picture0.png](../images/er-cha-shu-de-jing-xiang-lcof-27.png){:width=450}

##### 代码：

```Python []
class Solution:
    def mirrorTree(self, root: TreeNode) -> TreeNode:
        if not root: return
        stack = [root]
        while stack:
            node = stack.pop()
            if node.left: stack.append(node.left)
            if node.right: stack.append(node.right)
            node.left, node.right = node.right, node.left
        return root
```

```Java []
class Solution {
    public TreeNode mirrorTree(TreeNode root) {
        if(root == null) return null;
        Stack<TreeNode> stack = new Stack<>() {{ add(root); }};
        while(!stack.isEmpty()) {
            TreeNode node = stack.pop();
            if(node.left != null) stack.add(node.left);
            if(node.right != null) stack.add(node.right);
            TreeNode tmp = node.left;
            node.left = node.right;
            node.right = tmp;
        }
        return root;
    }
}
```

```C++ []
class Solution {
public:
    TreeNode* mirrorTree(TreeNode* root) {
        if(root == nullptr) return nullptr;
        stack<TreeNode*> stack;
        stack.push(root);
        while (!stack.empty())
        {
            TreeNode* node = stack.top();
            stack.pop();
            if (node->left != nullptr) stack.push(node->left);
            if (node->right != nullptr) stack.push(node->right);
            TreeNode* tmp = node->left;
            node->left = node->right;
            node->right = tmp;
        }
        return root;
    }
};
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    207094    |    261259    |   79.3%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
