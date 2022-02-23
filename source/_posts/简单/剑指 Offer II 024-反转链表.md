---
title: 剑指 Offer II 024-反转链表
date: 2021-12-03 21:32:24
categories:
  - 简单
tags:
  - 递归
  - 链表
---

> 原文链接: https://leetcode-cn.com/problems/UHnkqh




## 中文题目
<div><p>给定单链表的头节点 <code>head</code> ，请反转链表，并返回反转后的链表的头节点。</p>

<div class="original__bRMd">
<div>
<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>
<img alt="" src="https://assets.leetcode.com/uploads/2021/02/19/rev1ex1.jpg" style="width: 302px; " />
<pre>
<strong>输入：</strong>head = [1,2,3,4,5]
<strong>输出：</strong>[5,4,3,2,1]
</pre>

<p><strong>示例 2：</strong></p>
<img alt="" src="https://assets.leetcode.com/uploads/2021/02/19/rev1ex2.jpg" style="width: 102px;" />
<pre>
<strong>输入：</strong>head = [1,2]
<strong>输出：</strong>[2,1]
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>head = []
<strong>输出：</strong>[]
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li>链表中节点的数目范围是 <code>[0, 5000]</code></li>
	<li><code>-5000 &lt;= Node.val &lt;= 5000</code></li>
</ul>

<p>&nbsp;</p>

<p><strong>进阶：</strong>链表可以选用迭代或递归方式完成反转。你能否用两种方法解决这道题？</p>
</div>
</div>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 206&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/reverse-linked-list/">https://leetcode-cn.com/problems/reverse-linked-list/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解


# 1. 迭代解法

请看视频：

![206_1_迭代解法.mp4](ec194742-c125-429f-9d36-173f5fc7b8fa)

代码如下：
```java []
public ListNode reverseList(ListNode head) {
    ListNode prev = null;
    ListNode curr = head;
    while (curr != null) {
        ListNode next = curr.next;
        curr.next = prev;
        prev = curr;
        curr = next;
    }
    return prev;
}
```
```C++ []
public:
    ListNode* reverseList1(ListNode* head) {
        ListNode* prev = nullptr;
        ListNode* curr = head;
        while (curr) {
            ListNode* next = curr->next;
            curr->next = prev;
            prev = curr;
            curr = next;
        }
        return prev;
    }
```
```Python []
def reverseList(self, head: ListNode) -> ListNode:
    prev, curr = None, head
    while curr is not None:
        next = curr.next
        curr.next = prev
        prev = curr
        curr = next
    return prev
```
```javascript []
var reverseList = function(head) {
    let prev = null, curr = head
    while (curr) {
        const next = curr.next
        curr.next = prev
        prev = curr
        curr = next
    }
    return prev
};
```
```Golang []
// 迭代
func reverseList1(head *ListNode) *ListNode {
    var prev *ListNode = nil
    var curr = head
    for curr != nil {
        var next = curr.Next
        curr.Next = prev
        prev = curr
        curr = next
    }
    return prev
}
```

# 2. 递归解法
## 2.1 为什么可以使用递归
请看视频：
![...06_2_为什么可以使用递归实现.mp4](58a00b4f-068d-4efa-985c-dcec2cdd0b23)


## 2.2 递归解法思路
请看视频：
![206_3_递归实现.mp4](83295b82-8ab6-4c45-bf37-7e562a899fb1)

代码如下：
```java []
public ListNode reverseList(ListNode head) {
    // 1. 递归终止条件
    if (head == null || head.next == null) {
        return head;
    }
    ListNode p = reverseList(head.next);
    head.next.next = head;
    head.next = null;
    return p;
}
```
```C++ []
public:
    ListNode* reverseList(ListNode* head) {
        // 1. 递归终止条件
        if (head == nullptr || head->next == nullptr) return head;
        ListNode* p = reverseList(head->next);
        head->next->next = head;
        head->next = nullptr;
        return p;
    }
```
```Python []
def reverseList(self, head: ListNode) -> ListNode:
    # 1. 递归终止条件
    if head is None or head.next is None:
        return head
    
    p = self.reverseList(head.next)
    head.next.next = head
    head.next = None

    return p
```
```javascript []
var reverseList = function(head) {
    // 1. 递归终止条件
    if (head == null || head.next == null) return head
    const p = reverseList(head.next)
    head.next.next = head
    head.next = null
    return p
};
```
```Golang []
// 递归
func reverseList(head *ListNode) *ListNode {
    // 1. 递归终止条件
    if head == nil || head.Next == nil {
        return head
    }
    var p = reverseList(head.Next)
    head.Next.Next = head
    head.Next = nil
    return p
}
```

在刷题的时候：
1. 如果你觉得自己数据结构与算法**基础不够扎实**，那么[请点这里](http://www.tangweiqun.com/api/31104/offer024?av=1&cv=1)，这里包含了**一个程序员 5 年内需要的所有算法知识**。

2. 如果你感觉刷题**太慢**，或者感觉**很困难**，或者**赶时间**，那么[请点这里](http://www.tangweiqun.com/api/35548/offer024?av=1&cv=1)。这里**用 365 道高频算法题，带你融会贯通算法知识，做到以不变应万变**。

3. **回溯、贪心和动态规划，是算法面试中的三大难点内容**，如果你只是想搞懂这三大难点内容 [请点这里](http://www.tangweiqun.com/api/38100/offer024?av=1&cv=1)。

**以上三个链接中的内容，都支持 Java/C++/Python/js/go 五种语言** 

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    18829    |    24594    |   76.6%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
