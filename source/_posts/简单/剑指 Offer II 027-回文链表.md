---
title: 剑指 Offer II 027-回文链表
categories:
  - 简单
tags:
  - 栈
  - 递归
  - 链表
  - 双指针
abbrlink: 921451823
date: 2021-12-03 21:32:20
---

> 原文链接: https://leetcode-cn.com/problems/aMhZSa




## 中文题目
<div><p>给定一个链表的 <strong>头节点&nbsp;</strong><code>head</code><strong>&nbsp;，</strong>请判断其是否为回文链表。</p>

<p>如果一个链表是回文，那么链表节点序列从前往后看和从后往前看是相同的。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<p><strong><img alt="" src="https://pic.leetcode-cn.com/1626421737-LjXceN-image.png" /></strong></p>

<pre>
<strong>输入:</strong> head = [1,2,3,3,2,1]
<strong>输出:</strong> true</pre>

<p><strong>示例 2：</strong></p>

<p><strong><img alt="" src="https://pic.leetcode-cn.com/1626422231-wgvnWh-image.png" style="width: 138px; height: 62px;" /></strong></p>

<pre>
<strong>输入:</strong> head = [1,2]
<strong>输出:</strong> false
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li>链表 L 的长度范围为 <code>[1, 10<sup><span style="font-size: 9.449999809265137px;">5</span></sup>]</code></li>
	<li><code>0&nbsp;&lt;= node.val &lt;= 9</code></li>
</ul>

<p>&nbsp;</p>

<p><strong>进阶：</strong>能否用&nbsp;O(n) 时间复杂度和 O(1) 空间复杂度解决此题？</p>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 234&nbsp;题相同：<a href="https://leetcode-cn.com/problems/palindrome-linked-list/">https://leetcode-cn.com/problems/palindrome-linked-list/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
第一种思路：把链表每个节点的值存进数组，再双指针从左右两边向中间走比较两个值，若遍历过程中比较的两个值不同则不是回文，遍历完都相等则是回文；
第二种思路：快慢指针找链表终点以后在中间断开，反转后半部分链表节点，再比较反转以后新的后半部分链表头节点和初始链表头节点依次遍历的值。
第一种耗时9ms,第二种4ms，代码如下：
```
class Solution {
    //数组比较法
    public boolean isPalindrome(ListNode head) {
        List<Integer> ls = new ArrayList<>();
        while(head != null){
            ls.add(head.val);
            head = head.next;
        }
        int[] nums = new int[ls.size()];
        for(int i = 0; i < ls.size(); ++i) nums[i] = ls.get(i);
        int l = 0, r = nums.length-1;
        while(l < r){
            if(nums[l] != nums[r]) return false;
            l++;
            r--;
        }
        return true;
    }
}
```
```
class Solution {
    //中点反转比较法
    public boolean isPalindrome(ListNode head) {
        ListNode pre = new ListNode();
        pre.next = head;
        ListNode fast = pre, slow = pre;
        while(fast != null && fast.next != null){
            slow = slow.next;
            fast = fast.next.next;
        }
        ListNode tail = slow.next;
        slow.next = null;
        ListNode head1 = reverse(tail);
        while(head1 != null && head != null){
            if(head1.val != head.val) return false;
            head1 = head1.next;
            head = head.next;
        }
        return true;
    }

    public ListNode reverse(ListNode node){
        ListNode pre = null, cur = node;
        while(cur != null){
            ListNode r = cur.next;
            cur.next = pre;
            pre = cur;
            cur = r;
        }
        return pre;
    }
}
```
![截屏2021-12-01 上午1.05.11.png](../images/aMhZSa-0.png)




## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    10884    |    17766    |   61.3%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
