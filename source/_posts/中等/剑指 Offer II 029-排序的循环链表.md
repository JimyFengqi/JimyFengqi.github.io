---
title: 剑指 Offer II 029-排序的循环链表
categories:
  - 中等
tags:
  - 链表
abbrlink: 3466504993
date: 2021-12-03 21:32:19
---

> 原文链接: https://leetcode-cn.com/problems/4ueAj6




## 中文题目
<div><p>给定<strong>循环单调非递减列表</strong>中的一个点，写一个函数向这个列表中插入一个新元素&nbsp;<code>insertVal</code> ，使这个列表仍然是循环升序的。</p>

<p>给定的可以是这个列表中任意一个顶点的指针，并不一定是这个列表中最小元素的指针。</p>

<p>如果有多个满足条件的插入位置，可以选择任意一个位置插入新的值，插入后整个列表仍然保持有序。</p>

<p>如果列表为空（给定的节点是 <code>null</code>），需要创建一个循环有序列表并返回这个节点。否则。请返回原先给定的节点。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<p><img alt="" src="https://assets.leetcode.com/uploads/2019/01/19/example_1_before_65p.jpg" style="height: 149px; width: 250px;" /><br />
&nbsp;</p>

<pre>
<strong>输入：</strong>head = [3,4,1], insertVal = 2
<strong>输出：</strong>[3,4,1,2]
<strong>解释：</strong>在上图中，有一个包含三个元素的循环有序列表，你获得值为 3 的节点的指针，我们需要向表中插入元素 2 。新插入的节点应该在 1 和 3 之间，插入之后，整个列表如上图所示，最后返回节点 3 。

<img alt="" src="https://assets.leetcode.com/uploads/2019/01/19/example_1_after_65p.jpg" style="height: 149px; width: 250px;" />
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>head = [], insertVal = 1
<strong>输出：</strong>[1]
<strong>解释：</strong>列表为空（给定的节点是 <code>null</code>），创建一个循环有序列表并返回这个节点。
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>head = [1], insertVal = 0
<strong>输出：</strong>[1,0]
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>0 &lt;= Number of Nodes &lt;= 5 * 10^4</code></li>
	<li><code><font face="monospace">-10^6 &lt;= Node.val &lt;= 10^6</font></code></li>
	<li><code>-10^6 &lt;=&nbsp;insertVal &lt;= 10^6</code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 708&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/insert-into-a-sorted-circular-linked-list/">https://leetcode-cn.com/problems/insert-into-a-sorted-circular-linked-list/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
其实就三种情况，
1. 在中间能够找到一个节点`cur`，满足`cur->val<=val<=cur->next->val`，直接插入即可
2. 找不到，则一定是所有的值都比它小或大，其实都会插入到边界跳跃点，即找到`cur`，满足`val<=cur->next->val<cur->val`(比最小的还小）或`cur->next->val<cur->val<=val`（比最大的还大）

因此其实就三个不等式，`cur->val<=val`, `cur->next->val>=val`, `cur->next->val>=cur->val`，三个式子中满足一个或三个时，cur即为插入点。

```cpp [cpp1]
class Solution {
public:
    Node* insert(Node* head, int insertVal) {
        if(head==nullptr) {
            head = new Node(insertVal);
            head->next = head;
            return head;
        }
        auto cur = head;
        while(cur->next!=head){
            if((cur->val<=insertVal)^(cur->next->val>=insertVal)^(cur->next->val>=cur->val)) break;
            cur = cur->next;
        }
        cur->next = new Node(insertVal, cur->next);
        return head;
    }
}
```

上面是异或写的，下面用if拆了一下，可能更清晰一点。

```cpp [cpp2]
class Solution {
public:
    Node* insert(Node* head, int insertVal) {
        if(head==nullptr) {
            head = new Node(insertVal);
            head->next = head;
            return head;
        }
        auto cur = head;
        while(cur->next!=head){
            if(cur->next->val<cur->val){
                if(cur->next->val>=insertVal) break;
                else if(cur->val<=insertVal) break;
            }
            if(cur->val<=insertVal&&cur->next->val>=insertVal) break;
            cur = cur->next;
        }
        cur->next = new Node(insertVal, cur->next);
        return head;
    }
}

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    3878    |    12978    |   29.9%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
