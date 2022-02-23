---
title: 剑指 Offer II 074-合并区间
date: 2021-12-03 21:28:15
categories:
  - 中等
tags:
  - 数组
  - 排序
---

> 原文链接: https://leetcode-cn.com/problems/SsGoHC




## 中文题目
<div><p>以数组 <code>intervals</code> 表示若干个区间的集合，其中单个区间为 <code>intervals[i] = [start<sub>i</sub>, end<sub>i</sub>]</code> 。请你合并所有重叠的区间，并返回一个不重叠的区间数组，该数组需恰好覆盖输入中的所有区间。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>intervals = [[1,3],[2,6],[8,10],[15,18]]
<strong>输出：</strong>[[1,6],[8,10],[15,18]]
<strong>解释：</strong>区间 [1,3] 和 [2,6] 重叠, 将它们合并为 [1,6].
</pre>

<p><strong>示例&nbsp;2：</strong></p>

<pre>
<strong>输入：</strong>intervals = [[1,4],[4,5]]
<strong>输出：</strong>[[1,5]]
<strong>解释：</strong>区间 [1,4] 和 [4,5] 可被视为重叠区间。</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= intervals.length &lt;= 10<sup>4</sup></code></li>
	<li><code>intervals[i].length == 2</code></li>
	<li><code>0 &lt;= start<sub>i</sub> &lt;= end<sub>i</sub> &lt;= 10<sup>4</sup></code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 56&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/merge-intervals/">https://leetcode-cn.com/problems/merge-intervals/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
思路和心得：

# （一）排序

```python3 []
class Solution:
    def merge(self, intervals: List[List[int]]) -> List[List[int]]:
        intervals.sort()
        res = []
        for s, e in intervals:
            if len(res) == 0 or res[-1][1] < s:
                res.append([s, e])
            else:
                res[-1][1] = max(res[-1][1], e)
        return res
```

```c++ []

class Solution 
{
public:
    vector<vector<int>> merge(vector<vector<int>>& intervals) 
    {
        sort(intervals.begin(),  intervals.end());

        vector<vector<int>> res;
        int rn = 0;
        for (int i = 0; i < (int)intervals.size(); i ++)
        {
            int s = intervals[i][0],  e = intervals[i][1];
            if (rn == 0 || res.back()[1] < s)
            {
                res.push_back(intervals[i]);
                rn ++;
            }
            else
            {
                res.back()[1] = max(res.back()[1], e);
            }
        }

        return res;
    }
};
```

```java []
class Solution 
{
    public int[][] merge(int[][] intervals) 
    {
        Arrays.sort(intervals, new Comparator<int []>()
        {
            public int compare(int [] a, int [] b)
            {
                return a[0] - b[0];
            }
        });

        List<int []> res = new ArrayList<>();
        int rn = 0;

        for (int i = 0; i < intervals.length; i ++)
        {
            int s = intervals[i][0],  e = intervals[i][1];
            if (rn == 0 || res.get(rn - 1)[1] < s)
            {
                res.add(intervals[i]);
                rn ++;
            }
            else
            {
                res.get(rn - 1)[1] = Math.max(res.get(rn - 1)[1], e);
            }
        }

        return res.toArray(new int [rn][]);

    }
}
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    3886    |    6851    |   56.7%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
