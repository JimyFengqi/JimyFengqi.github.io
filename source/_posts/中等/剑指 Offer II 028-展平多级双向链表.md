---
title: 剑指 Offer II 028-展平多级双向链表
date: 2021-12-03 21:32:19
categories:
  - 中等
tags:
  - 深度优先搜索
  - 链表
  - 双向链表
---

> 原文链接: https://leetcode-cn.com/problems/Qv1Da2




## 中文题目
<div><p>多级双向链表中，除了指向下一个节点和前一个节点指针之外，它还有一个子链表指针，可能指向单独的双向链表。这些子列表也可能会有一个或多个自己的子项，依此类推，生成多级数据结构，如下面的示例所示。</p>

<p>给定位于列表第一级的头节点，请扁平化列表，即将这样的多级双向链表展平成普通的双向链表，使所有结点出现在单级双链表中。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>head = [1,2,3,4,5,6,null,null,null,7,8,9,10,null,null,11,12]
<strong>输出：</strong>[1,2,3,7,8,11,12,9,10,4,5,6]
<strong>解释：
</strong>
输入的多级列表如下图所示：

<img src="https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/10/12/multilevellinkedlist.png" style="height: 363px; width: 640px;" />

扁平化后的链表如下图：

<img src="https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/10/12/multilevellinkedlistflattened.png" style="height: 80px; width: 1100px;" />
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>head = [1,2,null,3]
<strong>输出：</strong>[1,3,2]
<strong>解释：

</strong>输入的多级列表如下图所示：

  1---2---NULL
  |
  3---NULL
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>head = []
<strong>输出：</strong>[]
</pre>

<p>&nbsp;</p>

<p><strong>如何表示测试用例中的多级链表？</strong></p>

<p>以 <strong>示例 1</strong> 为例：</p>

<pre>
 1---2---3---4---5---6--NULL
         |
         7---8---9---10--NULL
             |
             11--12--NULL</pre>

<p>序列化其中的每一级之后：</p>

<pre>
[1,2,3,4,5,6,null]
[7,8,9,10,null]
[11,12,null]
</pre>

<p>为了将每一级都序列化到一起，我们需要每一级中添加值为 null 的元素，以表示没有节点连接到上一级的上级节点。</p>

<pre>
[1,2,3,4,5,6,null]
[null,null,7,8,9,10,null]
[null,11,12,null]
</pre>

<p>合并所有序列化结果，并去除末尾的 null 。</p>

<pre>
[1,2,3,4,5,6,null,null,null,7,8,9,10,null,null,11,12]</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li>节点数目不超过 <code>1000</code></li>
	<li><code>1 &lt;= Node.val &lt;= 10^5</code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 430&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/flatten-a-multilevel-doubly-linked-list/">https://leetcode-cn.com/problems/flatten-a-multilevel-doubly-linked-list/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
思路和心得：

1.递归和迭代两种都要掌握。经常问，经常用，经常考


# （一）dfs


```python3 []
"""
# Definition for a Node.
class Node:
    def __init__(self, val, prev, next, child):
        self.val = val
        self.prev = prev
        self.next = next
        self.child = child
"""

class Solution:
    def flatten(self, head: 'Node') -> 'Node':
        if head == None:
            return head
        
        dummy = Node(-1, None, None, None)

        def dfs(pre: 'Node', cur: 'Node') -> 'Node':
            if cur == None:
                return pre   

            pre.next = cur
            cur.prev = pre

            nxt_head = cur.next         #相当于4

            tail = dfs(cur, cur.child)  #相当于dfs(3, 7)
            cur.child = None
            
            return dfs(tail, nxt_head)  #相当于dfs(12, 4)
        
        dfs(dummy, head)
        dummy.next.prev = None
        return dummy.next
```

```c++ []
/*
// Definition for a Node.
class Node {
public:
    int val;
    Node* prev;
    Node* next;
    Node* child;
};
*/

class Solution 
{
public:
    Node * dummy;

    Node* flatten(Node* head) 
    {
        if (head == NULL)
            return head;

        this->dummy = new Node(-1, NULL, NULL, NULL);
        dfs(dummy, head);
        dummy->next->prev = NULL;
        return dummy->next;
    }

    Node * dfs(Node * pre, Node * cur)
    {
        if (cur == NULL)
            return pre;
        
        pre->next = cur;
        cur->prev = pre;

        Node * next_head = cur->next;

        Node * tail = dfs(cur, cur->child);
        cur->child = NULL;

        return dfs(tail, next_head);
    }
};
```

```java []
/*
// Definition for a Node.
class Node {
    public int val;
    public Node prev;
    public Node next;
    public Node child;
};
*/

class Solution 
{
    Node dummy;

    public Node flatten(Node head) 
    {
        if (head == null)
            return head;

        this.dummy = new Node(-1, null, null, null); 
        dfs(dummy, head);
        dummy.next.prev = null;
        return dummy.next;
    }

    public Node dfs (Node pre, Node cur)
    {
        if (cur == null)
            return pre;
        
        pre.next = cur;
        cur.prev = pre;

        Node next_head = cur.next;

        Node tail = dfs(cur, cur.child);
        cur.child = null;

        return dfs(tail, next_head);
    }
}
```


# （二）栈迭代


```python3 []
"""
# Definition for a Node.
class Node:
    def __init__(self, val, prev, next, child):
        self.val = val
        self.prev = prev
        self.next = next
        self.child = child
"""

class Solution:
    def flatten(self, head: 'Node') -> 'Node':
        if head == None:
            return head

        dummy = Node(-1, None, None, None)

        pre = dummy
        stk = [head]

        while stk:
            x = stk.pop()
            
            pre.next = x
            x.prev = pre

            if x.next:
                stk.append(x.next)
            if x.child:
                stk.append(x.child)
                x.child = None
            
            pre = x
        
        dummy.next.prev = None
        return dummy.next
```

```c++ []
/*
// Definition for a Node.
class Node {
public:
    int val;
    Node* prev;
    Node* next;
    Node* child;
};
*/

class Solution 
{
public:
    Node* flatten(Node* head) 
    {
        if (head == NULL)
            return head;

        Node * dummy = new Node(-1, NULL, NULL, NULL);

        Node * pre = dummy;
        stack<Node *> stk;
        stk.push(head);

        while (!stk.empty())
        {
            Node * x = stk.top();    stk.pop();

            pre->next = x;
            x->prev = pre;

            if (x->next)
                stk.push(x->next);
            if (x->child)
            {
                stk.push(x->child);
                x->child = NULL;
            }

            pre = x;
        }

        dummy->next->prev = NULL;
        return dummy->next;
    }
};
```

```java []
/*
// Definition for a Node.
class Node {
    public int val;
    public Node prev;
    public Node next;
    public Node child;
};
*/

class Solution 
{
    public Node flatten(Node head) 
    {
        if (head == null)
            return head;
        
        Node dummy = new Node(-1, null, null, null);

        Node pre = dummy;
        Deque<Node> stk = new LinkedList<>();
        stk.push(head);

        while (!stk.isEmpty())
        {
            Node x = stk.poll();

            pre.next = x;
            x.prev = pre;

            if (x.next != null)
                stk.push(x.next);
            if (x.child != null)
            {
                stk.push(x.child);
                x.child = null;
            }

            pre = x;
        }

        dummy.next.prev = null;
        return dummy.next;

    }
}
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    3656    |    5801    |   63.0%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
