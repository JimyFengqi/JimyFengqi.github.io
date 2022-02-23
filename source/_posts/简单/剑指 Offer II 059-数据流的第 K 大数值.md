---
title: 剑指 Offer II 059-数据流的第 K 大数值
categories:
  - 简单
tags:
  - 树
  - 设计
  - 二叉搜索树
  - 二叉树
  - 数据流
  - 堆（优先队列）
abbrlink: 3581628246
date: 2021-12-03 21:28:33
---

> 原文链接: https://leetcode-cn.com/problems/jBjn9C




## 中文题目
<div><p>设计一个找到数据流中第 <code>k</code> 大元素的类（class）。注意是排序后的第 <code>k</code> 大元素，不是第 <code>k</code> 个不同的元素。</p>

<p>请实现 <code>KthLargest</code>&nbsp;类：</p>

<ul>
	<li><code>KthLargest(int k, int[] nums)</code> 使用整数 <code>k</code> 和整数流 <code>nums</code> 初始化对象。</li>
	<li><code>int add(int val)</code> 将 <code>val</code> 插入数据流 <code>nums</code> 后，返回当前数据流中第 <code>k</code> 大的元素。</li>
</ul>

<p>&nbsp;</p>

<p><strong>示例：</strong></p>

<pre>
<strong>输入：</strong>
[&quot;KthLargest&quot;, &quot;add&quot;, &quot;add&quot;, &quot;add&quot;, &quot;add&quot;, &quot;add&quot;]
[[3, [4, 5, 8, 2]], [3], [5], [10], [9], [4]]
<strong>输出：</strong>
[null, 4, 5, 5, 8, 8]

<strong>解释：</strong>
KthLargest kthLargest = new KthLargest(3, [4, 5, 8, 2]);
kthLargest.add(3);   // return 4
kthLargest.add(5);   // return 5
kthLargest.add(10);  // return 5
kthLargest.add(9);   // return 8
kthLargest.add(4);   // return 8
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= k &lt;= 10<sup>4</sup></code></li>
	<li><code>0 &lt;= nums.length &lt;= 10<sup>4</sup></code></li>
	<li><code>-10<sup>4</sup> &lt;= nums[i] &lt;= 10<sup>4</sup></code></li>
	<li><code>-10<sup>4</sup> &lt;= val &lt;= 10<sup>4</sup></code></li>
	<li>最多调用 <code>add</code> 方法 <code>10<sup>4</sup></code> 次</li>
	<li>题目数据保证，在查找第 <code>k</code> 大元素时，数组中至少有 <code>k</code> 个元素</li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 703&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/kth-largest-element-in-a-stream/">https://leetcode-cn.com/problems/kth-largest-element-in-a-stream/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
# **最小堆**
此问题属于 topK 问题，是一类典型的题目。处理此类问题最直观的想法就是排序，但是使用排序并不是高效的方法，因为题目只关心第 k 大的数字并且数据是动态的，排序处理时间复杂度太高。堆就是解决一个动态数据集合中的 topK 问题的利器。最小堆经常用来求取数据集合中 k 个值最大的元素，而最大堆经常用来求取数据集合中 k 个值最小的元素。这道题使用最小堆来实现，C ++ 中存在堆的实现
- **默认最大堆 ：** priority_queue<int> big_heap
- **最小堆 ：**    priority_queue<int, vector<int>, greater<int>> small_heap

堆的插入和删除操作的时间复杂度均为 O(logk)，完整代码如下。
```
class KthLargest {
private:
    priority_queue<int, vector<int>, greater<int>> heap;
    int size;
public:
    KthLargest(int k, vector<int>& nums) {
        size = k;
        for (auto& num : nums) {
            if (heap.size() < size) {
                heap.push(num);
            }
            else if (num > heap.top()) {
                heap.pop();
                heap.push(num);
            }
        }
    }
    
    int add(int val) {
        if (heap.size() < size) {
            heap.push(val);
        }
        else if (val > heap.top()) {
            heap.pop();
            heap.push(val);
        }
        return heap.top();
    }
};
```

另外感谢[@aikez](/u/aikez/)同学指出可以在 KthLargest 函数中调用 add 函数减少代码量。
```
class KthLargest {
private:
    priority_queue<int, vector<int>, greater<int>> heap;
    int size;
public:
    KthLargest(int k, vector<int>& nums) {
        size = k;
        for (auto& num : nums) {
            add(num);
        }
    }
    
    int add(int val) {
        if (heap.size() < size) {
            heap.push(val);
        }
        else if (val > heap.top()) {
            heap.pop();
            heap.push(val);
        }
        return heap.top();
    }
};
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    3391    |    5375    |   63.1%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
