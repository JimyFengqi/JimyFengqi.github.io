---
title: 剑指 Offer II 076-数组中的第 k 大的数字
date: 2021-12-03 21:28:13
categories:
  - 中等
tags:
  - 数组
  - 分治
  - 快速选择
  - 排序
  - 堆（优先队列）
---

> 原文链接: https://leetcode-cn.com/problems/xx4gT2




## 中文题目
<div><p>给定整数数组 <code>nums</code> 和整数 <code>k</code>，请返回数组中第 <code><strong>k</strong></code> 个最大的元素。</p>

<p>请注意，你需要找的是数组排序后的第 <code>k</code> 个最大的元素，而不是第 <code>k</code> 个不同的元素。</p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<pre>
<strong>输入:</strong> <code>[3,2,1,5,6,4] 和</code> k = 2
<strong>输出:</strong> 5
</pre>

<p><strong>示例&nbsp;2:</strong></p>

<pre>
<strong>输入:</strong> <code>[3,2,3,1,2,4,5,5,6] 和</code> k = 4
<strong>输出:</strong> 4</pre>

<p>&nbsp;</p>

<p><strong>提示： </strong></p>

<ul>
	<li><code>1 &lt;= k &lt;= nums.length &lt;= 10<sup>4</sup></code></li>
	<li><code>-10<sup>4</sup>&nbsp;&lt;= nums[i] &lt;= 10<sup>4</sup></code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 215&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/kth-largest-element-in-an-array/">https://leetcode-cn.com/problems/kth-largest-element-in-an-array/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
思路和心得：


# （一）大根堆--调库

```python3 []
class Solution:
    def findKthLargest(self, nums: List[int], k: int) -> int:
        maxHeap = []
        for x in nums:
            heapq.heappush(maxHeap, -x)
        for _ in range(k - 1):
            heapq.heappop(maxHeap)
        return -maxHeap[0]
```

```c++ []
class Solution 
{
public:
    int findKthLargest(vector<int>& nums, int k) 
    {
        priority_queue<int, vector<int>, less<int>> maxHeap;
        for (int x : nums)
            maxHeap.push(x);
        for (int _ = 0; _ < k - 1; _ ++)
            maxHeap.pop();
        return maxHeap.top();
    }
};
```

```java []
class Solution 
{
    public int findKthLargest(int[] nums, int k) 
    {
        PriorityQueue<Integer> maxHeap = new PriorityQueue<>(new Comparator<>()
        {
            public int compare(Integer a, Integer b)
            {
                return b - a;
            }
        });

        for (int x : nums)
            maxHeap.offer(x);
        for (int ee = 0; ee < k - 1; ee ++)
            maxHeap.poll();
        return maxHeap.peek();
    }
}
```

# （二）手撸大根堆

```python3 []
class Solution:
    def findKthLargest(self, nums: List[int], k: int) -> int:
        n = len(nums)
        self.build_maxHeap(nums)
        for i in range(k-1):
            nums[0], nums[n-1-i] = nums[n-1-i], nums[0]
            self.adjust_down(nums, 0, n-1-i-1)
        return nums[0]


    def build_maxHeap(self, nums: List[int]) -> None:
        n = len(nums)
        for root in range(n//2, -1, -1):
            self.adjust_down(nums, root, n - 1)

    def adjust_down(self, nums: List[int], root: int, hi: int) -> None: 
        if root > hi:
            return 
        t = nums[root]
        child = 2 * root + 1
        while child <= hi:
            if child + 1 <= hi and nums[child] < nums[child + 1]:
                child += 1
            if t >= nums[child]:
                break
            nums[root] = nums[child]
            root = child
            child = 2 * root + 1
        nums[root] = t
```

```c++ []
class Solution 
{
public:
    int findKthLargest(vector<int>& nums, int k) 
    {
        int n = nums.size();
        build_maxHeap(nums);
        for (int i = 0; i < k - 1; i ++)
        {
            swap(nums[0], nums[n-1-i]);
            adjust_down(nums, 0, n-1-i - 1);
        }
        return nums[0];
    }


    void build_maxHeap(vector<int> & nums)
    {
        int n = nums.size();
        for (int root = n/2; root > -1; root --)
            adjust_down(nums, root, n - 1);
    }

    void adjust_down(vector<int> & nums, int root, int hi)
    {
        if (root > hi)
            return ;
        int t = nums[root];
        int child = 2 * root + 1;
        while (child <= hi)
        {
            if (child + 1 <= hi && nums[child] < nums[child + 1])
                child ++;
            if (t > nums[child])
                break;
            nums[root] = nums[child];
            root = child;
            child = 2 * root + 1;
        }
        nums[root] = t;
    }
};
```

```java []
class Solution 
{
    public int findKthLargest(int[] nums, int k) 
    {
        int n = nums.length;
        build_maxHeap(nums);
        for (int i = 0; i < k - 1; i ++)
        {
            int tmp = nums[0];
            nums[0] = nums[n-1-i];
            nums[n-1-i] = tmp;
            adjust_down(nums, 0, n-1-i - 1);
        }
        return nums[0];
    }


    public void build_maxHeap(int [] nums)
    {
        int n = nums.length;
        for (int root = n/2; root > -1; root --)
        {
            adjust_down(nums, root, n - 1);
        }
    }

    public void adjust_down(int [] nums, int root, int hi)
    {
        if (root > hi)
            return ;
        int t = nums[root];
        int child = 2 * root + 1;
        while (child <= hi)
        {
            if (child + 1 <= hi && nums[child] < nums[child + 1])
                child ++;
            if (t > nums[child])
                break;
            nums[root] = nums[child];
            root = child;
            child = 2 * root + 1;
        }
        nums[root] = t;
    }
}
```

# （三）快排（快速选择）


## （1）左右挖坑互填

```python3 []
class Solution:
    def findKthLargest(self, nums: List[int], k: int) -> int:
        n = len(nums)
        l = 0
        r = n - 1
        while True:
            idx = self.partition(nums, l, r)
            if idx == k - 1:
                return nums[idx]
            elif idx < k - 1:
                l = idx + 1
            else:
                r = idx - 1


    #----左右挖坑互填
    def partition(self, nums: List[int], l: int, r: int) -> int:
        pivot = nums[l]
        while l < r:
            while l < r and nums[r] <= pivot:    
                r -= 1
            nums[l] = nums[r]
            while l < r and nums[l] >= pivot:
                l += 1
            nums[r] = nums[l]

        nums[l] = pivot
        return l

```

```c++ []
class Solution 
{
public:
    int findKthLargest(vector<int>& nums, int k) 
    {
        int n = nums.size();
        int l = 0;
        int r = n - 1;
        while (true)
        {
            int idx = partition(nums, l, r);
            if (idx == k - 1)
                return nums[idx];
            else if (idx < k - 1)
                l = idx + 1;
            else    
                r = idx - 1;
        }
    }

    //----左右挖坑互填
    int partition(vector<int> & nums, int l, int r)
    {
        int pivot = nums[l];
        while (l < r)
        {
            while (l < r && nums[r] <= pivot)
                r --;
            nums[l] = nums[r];
            while (l < r && nums[l] >= pivot)
                l ++;
            nums[r] = nums[l];
        }
        nums[l] = pivot;
        return l;
    }
};
```

```java []
class Solution 
{
    public int findKthLargest(int[] nums, int k) 
    {
        int n = nums.length;
        int l = 0;
        int r = n - 1;
        while (true)
        {
            int idx = partition(nums, l, r);
            if (idx == k - 1)
                return nums[idx];
            else if (idx < k - 1)
                l = idx + 1;
            else    
                r = idx - 1;
        }

    }

    //----左右挖坑互填
    public int partition(int [] nums, int l, int r)
    {   
        int pivot = nums[l];
        while (l < r)
        {
            while (l < r && nums[r] <= pivot)
                r --;
            nums[l] = nums[r];
            while (l < r && nums[l] >= pivot)
                l ++;
            nums[r] = nums[l];
        }
        nums[l] = pivot;
        return l;
    }
}
```

## （2）左右交换

```python3 []
class Solution:
    def findKthLargest(self, nums: List[int], k: int) -> int:
        n = len(nums)
        l = 0
        r = n - 1
        while True:
            idx = self.partition(nums, l, r)
            if idx == k - 1:
                return nums[idx]
            elif idx < k - 1:
                l = idx + 1
            else:
                r = idx - 1


    #----左右交换
    def partition(self, nums: List[int], l: int, r: int) -> int:
        pivot = nums[l]
        begin = l
        while l < r:
            while l < r and nums[r] <= pivot:
                r -= 1
            while l < r and nums[l] >= pivot:
                l += 1
            if l < r:
                nums[l], nums[r] = nums[r], nums[l]
        nums[begin], nums[l] = nums[l], nums[begin]
        return l
```

```c++ []
class Solution 
{
public:
    int findKthLargest(vector<int>& nums, int k) 
    {
        int n = nums.size();
        int l = 0;
        int r = n - 1;
        while (true)
        {
            int idx = partition(nums, l, r);
            if (idx == k - 1)
                return nums[idx];
            else if (idx < k - 1)
                l = idx + 1;
            else    
                r = idx - 1;
        }
    }

    //----左右交换
    int partition(vector<int> & nums, int l, int r)
    {
        int pivot = nums[l];
        int begin = l;
        while (l < r)
        {
            while (l < r && nums[r] <= pivot)
                r --;
            while (l < r && nums[l] >= pivot)
                l ++;
            if (l < r)
                swap(nums[l], nums[r]);
        }
        swap(nums[begin], nums[l]);
        return l;
    }
};
```

```java []
class Solution 
{
    public int findKthLargest(int[] nums, int k) 
    {
        int n = nums.length;
        int l = 0;
        int r = n - 1;
        while (true)
        {
            int idx = partition(nums, l, r);
            if (idx == k - 1)
                return nums[idx];
            else if (idx < k - 1)
                l = idx + 1;
            else    
                r = idx - 1;
        }

    }

    //----左右交换
    public int partition(int [] nums, int l, int r)
    {   
        int pivot = nums[l];
        int begin = l;
        while (l < r)
        {
            while (l < r && nums[r] <= pivot)
                r --;
            while (l < r && nums[l] >= pivot)
                l ++ ;
            if (l < r)
            {
                int tmp = nums[l];
                nums[l] = nums[r];
                nums[r] = tmp;
            }
        }
        
        int tmp = nums[begin];
        nums[begin] = nums[l];
        nums[l] = tmp;
        return l;
    }
}
```

## （3）单方向遍历

```python3 []
class Solution:
    def findKthLargest(self, nums: List[int], k: int) -> int:
        n = len(nums)
        l = 0
        r = n - 1
        while True:
            idx = self.partition(nums, l, r)
            if idx == k - 1:
                return nums[idx]
            elif idx < k - 1:
                l = idx + 1
            else:
                r = idx - 1


    #----单向遍历
    def partition(self, nums: List[int], l: int, r: int) -> int:
        pivot = nums[l]
        idx = l
        for i in range(l + 1, r + 1):
            if nums[i] >= pivot:
                idx += 1
                nums[idx], nums[i] = nums[i], nums[idx]
        nums[idx], nums[l] = nums[l], nums[idx]
        return idx
```

```c++ []
class Solution 
{
public:
    int findKthLargest(vector<int>& nums, int k) 
    {
        int n = nums.size();
        int l = 0;
        int r = n - 1;
        while (true)
        {
            int idx = partition(nums, l, r);
            if (idx == k - 1)
                return nums[idx];
            else if (idx < k - 1)
                l = idx + 1;
            else    
                r = idx - 1;
        }
    }

    //----单向遍历
    int partition(vector<int> & nums, int l, int r)
    {
        int pivot = nums[l];
        int idx = l;
        for (int i = l + 1; i < r + 1; i ++)
        {
            if (nums[i] >= pivot)
            {
                idx ++;
                swap(nums[idx], nums[i]);
            }
        }
        swap(nums[l], nums[idx]);
        return idx;
    }
};
```

```java []
class Solution 
{
    public int findKthLargest(int[] nums, int k) 
    {
        int n = nums.length;
        int l = 0;
        int r = n - 1;
        while (true)
        {
            int idx = partition(nums, l, r);
            if (idx == k - 1)
                return nums[idx];
            else if (idx < k - 1)
                l = idx + 1;
            else    
                r = idx - 1;
        }

    }

    //----左右挖坑互填
    public int partition(int [] nums, int l, int r)
    {   
        int pivot = nums[l];
        int idx = l;
        for (int i = l + 1; i < r + 1; i ++)
        {
            if (nums[i] >= pivot)
            {
                idx ++;
                int tmp = nums[idx];
                nums[idx] = nums[i];
                nums[i] = tmp;
            }
        }
        int tmp = nums[l];
        nums[l] = nums[idx];
        nums[idx] = tmp;
        return idx;
    }
}
```



## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    6763    |    9878    |   68.5%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
