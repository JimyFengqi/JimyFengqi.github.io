---
title: 剑指 Offer II 077-链表排序
categories:
  - 中等
tags:
  - 链表
  - 双指针
  - 分治
  - 排序
  - 归并排序
abbrlink: 216463601
date: 2021-12-03 21:28:13
---

> 原文链接: https://leetcode-cn.com/problems/7WHec2




## 中文题目
<div><p>给定链表的头结点&nbsp;<code>head</code>&nbsp;，请将其按 <strong>升序</strong> 排列并返回 <strong>排序后的链表</strong> 。</p>

<ul>
</ul>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<p><img alt="" src="https://assets.leetcode.com/uploads/2020/09/14/sort_list_1.jpg" style="width: 302px; " /></p>

<pre>
<b>输入：</b>head = [4,2,1,3]
<b>输出：</b>[1,2,3,4]
</pre>

<p><strong>示例 2：</strong></p>

<p><img alt="" src="https://assets.leetcode.com/uploads/2020/09/14/sort_list_2.jpg" style="width: 402px; " /></p>

<pre>
<b>输入：</b>head = [-1,5,3,4,0]
<b>输出：</b>[-1,0,3,4,5]
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<b>输入：</b>head = []
<b>输出：</b>[]
</pre>

<p>&nbsp;</p>

<p><b>提示：</b></p>

<ul>
	<li>链表中节点的数目在范围&nbsp;<code>[0, 5 * 10<sup>4</sup>]</code>&nbsp;内</li>
	<li><code>-10<sup>5</sup>&nbsp;&lt;= Node.val &lt;= 10<sup>5</sup></code></li>
</ul>

<p>&nbsp;</p>

<p><b>进阶：</b>你可以在&nbsp;<code>O(n&nbsp;log&nbsp;n)</code> 时间复杂度和常数级空间复杂度下，对链表进行排序吗？</p>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 148&nbsp;题相同：<a href="https://leetcode-cn.com/problems/sort-list/">https://leetcode-cn.com/problems/sort-list/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# **分析**
因为题目中要求算法的时间复杂度为 O(nlogn)，考虑符合该时间复杂度的排序算法有堆排序、快速排序和归并排序。

若输入的是一个数组，那么堆排序就可以用数组实现最大堆。因为在数组中 O(1) 时间就可以根据下标得到数字，但是在链表中需要  O(n) 时间，所以不能直接利用链表实现，但是可以通过把链表转化为数组的方式实现，这样需要付出 O(n) 的空间代价。

考虑快速排序实现，快速排序中需要随机生成一个下标，并以该下标对应的数值进行中间值分区。同样还是存在堆排序中考虑的问题，在数组中 O(1) 时间就可以根据下标得到数字，但是在链表中需要  O(n) 时间。因此，快速排序对链表进行排序并不高效。

最后考虑归并排序，其主要思想是将两个已经排序的链表合并为一个排序的链表，这其中没有涉及需要 O(1) 时间就可以根据下标得到数字，所以可以考虑使用归并排序。

# **归并排序**
使用递归可以实现链表的归并排序，首先使用 split 函数将链表分为前后两半并返回后半部分的头节点。再将链表分成的两半使用递归实现排序，之后调用 merge 函数将两个已排序链表进行合并。其中 split 函数可以使用快慢指针法，而 merge 函数可以使用双指针法。

完整代码如下，时间复杂度为 O(nlogn)，空间复杂度为 O(logn)，使用迭代实现可以把空间复杂度优化为 O(1)。

```
class Solution {
private:
    // 确定中间节点
    ListNode* split(ListNode* head) {
        ListNode* slow = head;
        ListNode* fast = head->next;
        while (fast != nullptr && fast->next != nullptr) {
            slow = slow->next;
            fast = fast->next->next;
        }
        ListNode* second = slow->next;
        slow->next = nullptr;
        return second;
    }

    // 合并排序链表
    ListNode* merge(ListNode* head1, ListNode* head2) {
        ListNode* dummy = new ListNode();
        ListNode* cur = dummy;
        while (head1 != nullptr && head2 != nullptr) {
            if (head1->val < head2->val) {
                cur->next = head1;
                head1 = head1->next;
            }
            else {
                cur->next = head2;
                head2 = head2->next;
            }

            cur = cur->next;
        }
        cur->next = (head1 == nullptr) ? head2 : head1;

        ListNode* ret = dummy->next;
        delete dummy;
        dummy = nullptr;
        return ret;
    }

public:
    ListNode* sortList(ListNode* head) {
        if (head == nullptr || head->next == nullptr) {
            return head;
        }
        ListNode* head1 = head;
        ListNode* head2 = split(head);

        head1 = sortList(head1);
        head2 = sortList(head2);

        return merge(head1, head2);
    }
};
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    5968    |    10158    |   58.8%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
