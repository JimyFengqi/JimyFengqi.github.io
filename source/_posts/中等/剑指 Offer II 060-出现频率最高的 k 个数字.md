---
title: 剑指 Offer II 060-出现频率最高的 k 个数字
date: 2021-12-03 21:28:32
categories:
  - 中等
tags:
  - 数组
  - 哈希表
  - 分治
  - 桶排序
  - 计数
  - 快速选择
  - 排序
  - 堆（优先队列）
---

> 原文链接: https://leetcode-cn.com/problems/g5c51o




## 中文题目
<div><p>给定一个整数数组 <code>nums</code> 和一个整数 <code>k</code>&nbsp;，请返回其中出现频率前 <code>k</code> 高的元素。可以按 <strong>任意顺序</strong> 返回答案。</p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<pre>
<strong>输入: </strong>nums = [1,1,1,2,2,3], k = 2
<strong>输出: </strong>[1,2]
</pre>

<p><strong>示例 2:</strong></p>

<pre>
<strong>输入: </strong>nums = [1], k = 1
<strong>输出: </strong>[1]</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 10<sup>5</sup></code></li>
	<li><code>k</code> 的取值范围是 <code>[1, 数组中不相同的元素的个数]</code></li>
	<li>题目数据保证答案唯一，换句话说，数组中前 <code>k</code> 个高频元素的集合是唯一的</li>
</ul>

<p>&nbsp;</p>

<p><strong>进阶：</strong>所设计算法的时间复杂度 <strong>必须</strong> 优于 <code>O(n log n)</code> ，其中 <code>n</code><em>&nbsp;</em>是数组大小。</p>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 347&nbsp;题相同：<a href="https://leetcode-cn.com/problems/top-k-frequent-elements/">https://leetcode-cn.com/problems/top-k-frequent-elements/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
思路和心得：



# （一）最小堆

1.维持一个容量为k的最小堆

```python3 []
class Solution:
    def topKFrequent(self, nums: List[int], k: int) -> List[int]:
        num_freq = collections.Counter(nums)
        minHeap = []

        for x, f in num_freq.items():
            if len(minHeap) == k:
                if minHeap[0][0] < f:
                    heapq.heappop(minHeap)
                    heapq.heappush(minHeap, (f, x))
            else:
                heapq.heappush(minHeap, (f, x))
        
        res = []
        while minHeap:
            f, x = heapq.heappop(minHeap)
            res.append(x)
        return res
```

```c++ []
class Solution 
{
public:
    struct cmp1
    {
        bool operator () (pair<int,int> & a, pair<int, int> & b)
        {
            return a.second > b.second;
        }
    };

    vector<int> topKFrequent(vector<int>& nums, int k) 
    {
        unordered_map<int,  int> num_freq;
        for (int x : nums)
            num_freq[x] ++;
        
        priority_queue<pair<int,int>, vector<pair<int,int>>, cmp1> minHeap;
        
        for (auto [x, f] : num_freq)
        {
            if (minHeap.size() == k)
            {
                if (minHeap.top().second < f)
                {
                    minHeap.pop();
                    minHeap.push({x, f});
                }
            }
            else
            {
                minHeap.push({x, f});
            }
        }

        vector<int> res;
        while (!minHeap.empty())
        {
            auto [x, f] = minHeap.top();    minHeap.pop();
            res.push_back(x);
        }
        return res;
    }
};
```

```java []
class xf
{
    public int x;
    public int f;

    xf(int x_, int f_)
    {
        x = x_;
        f = f_;
    }

}

class Solution 
{
    public int[] topKFrequent(int[] nums, int k) 
    {
        Map<Integer, Integer> num_freq = new HashMap<>();
        for (int x : nums)
            num_freq.put(x, num_freq.getOrDefault(x, 0) + 1);
        
        PriorityQueue<xf> minHeap = new PriorityQueue<>(new Comparator<xf>()
        {
            public int compare(xf a, xf b)
            {
                return a.f - b.f;
            }
        });

        for (Map.Entry<Integer, Integer> entry : num_freq.entrySet())
        {
            int x = entry.getKey();
            int f = entry.getValue();
            if (minHeap.size() == k)
            {
                if (minHeap.peek().f < f)
                {
                    minHeap.poll();
                    minHeap.offer(new xf(x, f));
                }
            }
            else
            {
                minHeap.offer(new xf(x, f));
            }
        }

        int [] res = new int [k];
        for (int i = 0; i < k; i ++)
        {
            xf a = minHeap.poll();
            res[i] = a.x;
        }
        return res;
    }
}
```

c++ 自定义类，运算符重载，千万不要忘记 const!!!!!!!!

```c++ []
struct xf
{
    int x;
    int f;
   
    xf(int x_, int f_)
    {
      x = x_;
      f = f_;
   }

   //重载 < 运算符
   bool operator <(const xf b) const
   {
       return f > b.f;
   }
   
};

class Solution 
{
public:
    vector<int> topKFrequent(vector<int>& nums, int k) 
    {
        unordered_map<int,  int> num_freq;
        for (int x : nums)
            num_freq[x] ++;
        
        priority_queue<xf> minHeap;
        
        for (auto [x, f] : num_freq)
        {
            if ((int)minHeap.size() == k)
            {
                if (minHeap.top().f < f)
                {
                    minHeap.pop();
                    minHeap.push( xf(x, f));
                }
            }
            else
            {
                minHeap.push( xf(x, f));
            }
        }

        vector<int> res;
        while (!minHeap.empty())
        {
            xf a = minHeap.top();    minHeap.pop();
            res.push_back(a.x);
        }
        return res;
    }
};
```


# （二）快排--分治


```python3 []
class Solution:
    def topKFrequent(self, nums: List[int], k: int) -> List[int]:
        n = len(nums)
        num_freq = collections.Counter(nums)

        self.res = []
        xfs = list(num_freq.items())

        xfn = len(xfs)
        self.quick_sort(xfs, 0, xfn - 1, k)
    
        return self.res
    
    #-------大于等于的都交换到左侧。快排的第三种写法
    def quick_sort(self, xfs, l: int, r: int, k: int) -> None:
        pivot_xf = xfs[l]
        pivot_f = xfs[l][1]
        idx = l
        for i in range(l + 1, r + 1, 1):
            if xfs[i][1] >= pivot_f:            
                idx += 1
                xfs[idx], xfs[i] = xfs[i], xfs[idx]
        xfs[l], xfs[idx] = xfs[idx], xfs[l] 

        if k == idx - l + 1:
            for i in range(l, idx + 1):
                self.res.append(xfs[i][0])
        elif k < idx - l + 1:
            self.quick_sort(xfs, l, idx - 1, k)
        else:
            for i in range(l, idx + 1):
                self.res.append(xfs[i][0])
            self.quick_sort(xfs, idx + 1, r, k - (idx - l + 1))
```

```c++ []
class Solution 
{
public:
    vector<pair<int, int>> xfs;
    vector<int> res;

    vector<int> topKFrequent(vector<int>& nums, int k) 
    {   
        unordered_map<int, int> num_freq;
        for (int x : nums)
            num_freq[x] ++;

        for (auto xf: num_freq)
            xfs.push_back(xf);
        int xfn = xfs.size();
        
        quick_sort(0, xfn -1, k);
        return res;
    }

    void quick_sort(int l, int r, int k)
    {
        pair<int, int> pivot_xf = xfs[l];
        int pivot_f = pivot_xf.second;

        int idx = l;
        for (int i = l + 1; i < r + 1; i ++)
        {
            if (pivot_f <= xfs[i].second)
            {
                idx ++;
                swap(xfs[idx], xfs[i]);
            }
        }
        swap(xfs[l], xfs[idx]);

        if (k == idx - l + 1)
        {
            for (int i = l; i < idx + 1; i ++)
            {
                res.push_back(xfs[i].first);
            }
        }
        else if (k < idx - l + 1)
        {
            quick_sort(l, idx - 1, k);
        }
        else
        {
            for (int i = l; i < idx + 1; i ++)
                res.push_back(xfs[i].first);
            quick_sort(idx + 1, r, k - (idx - l + 1));
        }
    }
};
```

```java []
class Node
{
    int x;
    int f;

    Node(int x_, int f_)
    {
        x = x_;
        f = f_;
    }
}

class Solution 
{
    List<Node> xfs = new ArrayList<>();
    int [] res;
    int res_i = 0;

    public int[] topKFrequent(int[] nums, int k) 
    {
        res = new int [k];
        Map<Integer, Integer> num_freq = new HashMap<>();
        for  (int x : nums)
            num_freq.put(x, num_freq.getOrDefault(x, 0) + 1);
        
        for (Map.Entry<Integer, Integer> entry : num_freq.entrySet())
        {
            int x = entry.getKey();
            int f = entry.getValue();
            xfs.add(new Node(x, f));
        }

        int xfn = xfs.size();

        quick_sort(0, xfn - 1, k);
        return res;
    }

    public void quick_sort(int l, int r, int k)
    {
        Node pivot_xf = xfs.get(l);
        int pivot_f = pivot_xf.f;
        
        int idx = l;
        for (int i = l + 1; i < r + 1; i ++)
        {
            if (pivot_f <= xfs.get(i).f)
            {
                idx ++;
                Node tmp = xfs.get(idx);
                xfs.set(idx, xfs.get(i));
                xfs.set(i, tmp);
            }
        }
        Node tmp = xfs.get(idx);
        xfs.set(idx, xfs.get(l));
        xfs.set(l, tmp);
    
        if (k == idx - l + 1)
        {
            for (int i = l; i < idx + 1; i ++)
                res[res_i ++] = xfs.get(i).x;
        }
        else if (k < idx - l + 1)
        {
            quick_sort(l, idx - 1, k);
        }
        else
        {
            for (int i = l; i < idx + 1; i ++)
                res[res_i ++] = xfs.get(i).x;
            quick_sort(idx + 1, r, k - (idx - l + 1));
        }
    }
}
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    3656    |    5393    |   67.8%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
