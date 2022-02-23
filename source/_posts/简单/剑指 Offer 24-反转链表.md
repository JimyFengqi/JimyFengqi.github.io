---
title: 剑指 Offer 24-反转链表(反转链表 LCOF)
categories:
  - 简单
tags:
  - 递归
  - 链表
abbrlink: 1959976533
date: 2021-12-03 21:39:19
---

> 原文链接: https://leetcode-cn.com/problems/fan-zhuan-lian-biao-lcof




## 中文题目
<div><p>定义一个函数，输入一个链表的头节点，反转该链表并输出反转后链表的头节点。</p>

<p>&nbsp;</p>

<p><strong>示例:</strong></p>

<pre><strong>输入:</strong> 1-&gt;2-&gt;3-&gt;4-&gt;5-&gt;NULL
<strong>输出:</strong> 5-&gt;4-&gt;3-&gt;2-&gt;1-&gt;NULL</pre>

<p>&nbsp;</p>

<p><strong>限制：</strong></p>

<p><code>0 &lt;= 节点个数 &lt;= 5000</code></p>

<p>&nbsp;</p>

<p><strong>注意</strong>：本题与主站 206 题相同：<a href="https://leetcode-cn.com/problems/reverse-linked-list/">https://leetcode-cn.com/problems/reverse-linked-list/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
我清晰记得，以前在数据结构课上，老师和我们说：涉及到链表的操作，一定要在纸上把过程先画出来，再写程序。

现在想想，这句话简直就是真理！



#### 好理解的双指针



- 定义两个指针： $pre$ 和 $cur$ ；$pre$ 在前 $cur$ 在后。
- 每次让 $pre$ 的 $next$ 指向 $cur$ ，实现一次局部反转
- 局部反转完成之后， $pre$ 和 $cur$ 同时往前移动一个位置
- 循环上述过程，直至 $pre$ 到达链表尾部



![](../images/fan-zhuan-lian-biao-lcof-0.gif)




#### 代码

```cpp
class Solution {
public:
    ListNode* reverseList(ListNode* head) {
        ListNode* cur = NULL, *pre = head;
        while (pre != NULL) {
            ListNode* t = pre->next;
            pre->next = cur;
            cur = pre;
            pre = t;
        }
        return cur;
    }
};
```



#### 简洁的递归



- 使用递归函数，一直递归到链表的最后一个结点，该结点就是反转后的头结点，记作 $ret$ .
- 此后，每次函数在返回的过程中，让当前结点的下一个结点的 $next$ 指针指向当前节点。
- 同时让当前结点的 $next$ 指针指向 $NULL$ ，从而实现从链表尾部开始的局部反转
- 当递归函数全部出栈后，链表反转完成。




![](../images/fan-zhuan-lian-biao-lcof-1.gif)




#### 代码

```cpp
class Solution {
public:
    ListNode* reverseList(ListNode* head) {
        if (head == NULL || head->next == NULL) {
            return head;
        }
        ListNode* ret = reverseList(head->next);
        head->next->next = head;
        head->next = NULL;
        return ret;
    }
};
```





#### 妖魔化的双指针


- 原链表的头结点就是反转之后链表的尾结点，使用 $head$ 标记 .
- 定义指针 $cur$，初始化为 $head$ .
- 每次都让 $head$ 下一个结点的 $next$ 指向 $cur$  ，实现一次局部反转
- 局部反转完成之后，$cur$ 和 $head$ 的 $next$ 指针同时 往前移动一个位置
- 循环上述过程，直至 $cur$ 到达链表的最后一个结点 .


![](../images/fan-zhuan-lian-biao-lcof-2.gif)



#### 代码

```cpp
class Solution {
public:
    ListNode* reverseList(ListNode* head) {
        if (head == NULL) { return NULL; }
        ListNode* cur = head;
        while (head->next != NULL) {
            ListNode* t = head->next->next;
            head->next->next = cur;
            cur = head->next;
            head->next = t;
        }
        return cur;
    }
};
```



#### 最后

希望以上讲解能帮助您理解链表的反转过程。但无论是文字描述，还是动图演示，都比不了自己在纸上对着代码画一遍来得深刻。

至此，您已经掌握了链表反转的三种实现方式，欢迎大家留言讨论。


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    319003    |    429556    |   74.3%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
