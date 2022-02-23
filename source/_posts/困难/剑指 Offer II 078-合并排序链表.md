---
title: 剑指 Offer II 078-合并排序链表
date: 2021-12-03 21:28:12
categories:
  - 困难
tags:
  - 链表
  - 分治
  - 堆（优先队列）
  - 归并排序
---

> 原文链接: https://leetcode-cn.com/problems/vvXgSW




## 中文题目
<div><p>给定一个链表数组，每个链表都已经按升序排列。</p>

<p>请将所有链表合并到一个升序链表中，返回合并后的链表。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>lists = [[1,4,5],[1,3,4],[2,6]]
<strong>输出：</strong>[1,1,2,3,4,4,5,6]
<strong>解释：</strong>链表数组如下：
[
  1-&gt;4-&gt;5,
  1-&gt;3-&gt;4,
  2-&gt;6
]
将它们合并到一个有序链表中得到。
1-&gt;1-&gt;2-&gt;3-&gt;4-&gt;4-&gt;5-&gt;6
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>lists = []
<strong>输出：</strong>[]
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>lists = [[]]
<strong>输出：</strong>[]
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>k == lists.length</code></li>
	<li><code>0 &lt;= k &lt;= 10^4</code></li>
	<li><code>0 &lt;= lists[i].length &lt;= 500</code></li>
	<li><code>-10^4 &lt;= lists[i][j] &lt;= 10^4</code></li>
	<li><code>lists[i]</code> 按 <strong>升序</strong> 排列</li>
	<li><code>lists[i].length</code> 的总和不超过 <code>10^4</code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 23&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/merge-k-sorted-lists/">https://leetcode-cn.com/problems/merge-k-sorted-lists/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# **最小堆**
这道题有个很朴素的想法，使用 k 个指针分别指向链表的头节点，每次都从这 k 个节点中选取值最小的节点确定为合并后的链表的第一个节点。然后将指向最小值节点的指针向后移动一步，再比较这 k 个节点中选取值最小的节点确定为下一个节点。重复以上过程，所有链表就会被合并。

这个思路需要反复比较 k 个节点的值，因为只关心值最小的节点，所以可以使用最小堆优化。完整代码如下，如果共有 k 个链表，所有链表的节点总数为 n，那么空间复杂度为 O(k)，时间复杂度为 O(nlogk)。

```
class Solution {
public:
    ListNode* mergeKLists(vector<ListNode*>& lists) {
        // 最小堆
        auto cmp = [&](const ListNode* lhs, const ListNode* rhs) {
            return lhs->val > rhs->val;
        };
        priority_queue<ListNode*, vector<ListNode*>, decltype(cmp)> heap(cmp);

        ListNode* dummy = new ListNode();
        ListNode* cur = dummy;
        for (auto& node : lists) {
            if (node != nullptr) {
                heap.push(node);
            }
        }

        while (!heap.empty()) {
            ListNode* node = heap.top();
            heap.pop();
            if (node->next != nullptr) {
                heap.push(node->next);
            }
            cur->next = node;
            cur = cur->next;
        }

        ListNode* ret = dummy->next;
        delete dummy;
        dummy = nullptr;

        return ret;
    }
};
```
# **归并排序**
其实这道题也可以使用归并排序的思想考虑，输入的 k 个链表可以分成两部分。如果将前 k/2 和后 k/2 个链表分别合并成两个排序链表，再将这两个链表合成一个链表，那么问题就解决了。合并前 k/2 和后 k/2 个链表和合并 k 个链表属于同一个问题，可以调用递归函数解决。

完整代码如下，其中 merge 函数与面试题 77 中一样，都是实现合并两个两个有序链表。因为递归调用的深度为 O(logk)，总节点数为 n，那么时间复杂度为 O(nlogk)，空间复杂度为 O(logk)。

```
class Solution {
private:
    // 归并链表
    ListNode* mergeLists(vector<ListNode*>& lists, int start, int end) {
        if (start == end) {
            return lists[start];
        }
        int mid = start + ((end - start) >> 1);
        ListNode* head1 = mergeLists(lists, start, mid);
        ListNode* head2 = mergeLists(lists, mid + 1, end);
        return merge(head1, head2);
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
    ListNode* mergeKLists(vector<ListNode*>& lists) {
        if (lists.size() == 0) {
            return nullptr;
        }
        return mergeLists(lists, 0, lists.size() - 1);
    }
};
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    4579    |    7159    |   64.0%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
