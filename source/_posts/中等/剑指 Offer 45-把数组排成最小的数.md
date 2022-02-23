---
title: 剑指 Offer 45-把数组排成最小的数(把数组排成最小的数 LCOF)
categories:
  - 中等
tags:
  - 贪心
  - 字符串
  - 排序
abbrlink: 3852672399
date: 2021-12-03 21:37:46
---

> 原文链接: https://leetcode-cn.com/problems/ba-shu-zu-pai-cheng-zui-xiao-de-shu-lcof




## 中文题目
<div><p>输入一个非负整数数组，把数组里所有数字拼接起来排成一个数，打印能拼接出的所有数字中最小的一个。</p>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<pre><strong>输入:</strong> <code>[10,2]</code>
<strong>输出:</strong> &quot;<code>102&quot;</code></pre>

<p><strong>示例&nbsp;2:</strong></p>

<pre><strong>输入:</strong> <code>[3,30,34,5,9]</code>
<strong>输出:</strong> &quot;<code>3033459&quot;</code></pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>0 &lt; nums.length &lt;= 100</code></li>
</ul>

<p><strong>说明: </strong></p>

<ul>
	<li>输出结果可能非常大，所以你需要返回一个字符串而不是整数</li>
	<li>拼接起来的数字可能会有前导 0，最后结果不需要去掉前导 0</li>
</ul>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
#### 解题思路：

此题求拼接起来的最小数字，本质上是一个排序问题。设数组 $nums$ 中任意两数字的字符串为 $x$ 和 $y$ ，则规定 **排序判断规则** 为：

- 若拼接字符串 $x + y > y + x$ ，则 $x$ “大于” $y$ ；
- 反之，若 $x + y < y + x$ ，则 $x$ “小于” $y$ ；

> $x$ “小于” $y$  代表：排序完成后，数组中 $x$ 应在 $y$ 左边；“大于” 则反之。

根据以上规则，套用任何排序方法对 $nums$ 执行排序即可。

![Picture1.png](../images/ba-shu-zu-pai-cheng-zui-xiao-de-shu-lcof-0.png){:width=450}

##### 算法流程：

1. **初始化：** 字符串列表 $strs$ ，保存各数字的字符串格式；
2. **列表排序：** 应用以上 “排序判断规则” ，对 $strs$ 执行排序；
3. **返回值：** 拼接 $strs$ 中的所有字符串，并返回。

**复杂度分析：**

- **时间复杂度 $O(N \log N)$ ：** $N$ 为最终返回值的字符数量（ $strs$ 列表的长度 $\leq N$ ）；使用快排或内置函数的平均时间复杂度为 $O(N \log N)$ ，最差为 $O(N^2)$ 。
- **空间复杂度 $O(N)$ ：** 字符串列表 $strs$ 占用线性大小的额外空间。

<![Picture2.png](../images/ba-shu-zu-pai-cheng-zui-xiao-de-shu-lcof-1.png),![Picture3.png](../images/ba-shu-zu-pai-cheng-zui-xiao-de-shu-lcof-2.png),![Picture4.png](../images/ba-shu-zu-pai-cheng-zui-xiao-de-shu-lcof-3.png)>

#### 代码：

本文列举 **快速排序** 和 **内置函数** 两种排序方法，其他排序方法也可实现。

##### 快速排序：

需修改快速排序函数中的排序判断规则。字符串大小（字典序）对比的实现方法：

- Python/C++ 中可直接用 `<` , `>`；
- Java 中使用函数 `A.compareTo(B)`；

```Python []
class Solution:
    def minNumber(self, nums: List[int]) -> str:
        def quick_sort(l , r):
            if l >= r: return
            i, j = l, r
            while i < j:
                while strs[j] + strs[l] >= strs[l] + strs[j] and i < j: j -= 1
                while strs[i] + strs[l] <= strs[l] + strs[i] and i < j: i += 1
                strs[i], strs[j] = strs[j], strs[i]
            strs[i], strs[l] = strs[l], strs[i]
            quick_sort(l, i - 1)
            quick_sort(i + 1, r)
        
        strs = [str(num) for num in nums]
        quick_sort(0, len(strs) - 1)
        return ''.join(strs)
```

```Java []
class Solution {
    public String minNumber(int[] nums) {
        String[] strs = new String[nums.length];
        for(int i = 0; i < nums.length; i++)
            strs[i] = String.valueOf(nums[i]);
        quickSort(strs, 0, strs.length - 1);
        StringBuilder res = new StringBuilder();
        for(String s : strs)
            res.append(s);
        return res.toString();
    }
    void quickSort(String[] strs, int l, int r) {
        if(l >= r) return;
        int i = l, j = r;
        String tmp = strs[i];
        while(i < j) {
            while((strs[j] + strs[l]).compareTo(strs[l] + strs[j]) >= 0 && i < j) j--;
            while((strs[i] + strs[l]).compareTo(strs[l] + strs[i]) <= 0 && i < j) i++;
            tmp = strs[i];
            strs[i] = strs[j];
            strs[j] = tmp;
        }
        strs[i] = strs[l];
        strs[l] = tmp;
        quickSort(strs, l, i - 1);
        quickSort(strs, i + 1, r);
    }
}
```

```C++ []
class Solution {
public:
    string minNumber(vector<int>& nums) {
        vector<string> strs;
        for(int i = 0; i < nums.size(); i++)
            strs.push_back(to_string(nums[i]));
        quickSort(strs, 0, strs.size() - 1);
        string res;
        for(string s : strs)
            res.append(s);
        return res;
    }
private:
    void quickSort(vector<string>& strs, int l, int r) {
        if(l >= r) return;
        int i = l, j = r;
        while(i < j) {
            while(strs[j] + strs[l] >= strs[l] + strs[j] && i < j) j--;
            while(strs[i] + strs[l] <= strs[l] + strs[i] && i < j) i++;
            swap(strs[i], strs[j]);
        }
        swap(strs[i], strs[l]);
        quickSort(strs, l, i - 1);
        quickSort(strs, i + 1, r);
    }
};
```

##### 内置函数：

需定义排序规则：

- Python 定义在函数 `sort_rule(x, y)` 中；
- Java 定义为 `(x, y) -> (x + y).compareTo(y + x)` ；
- C++ 定义为 `(string& x, string& y){ return x + y < y + x; }` ；

```Python []
class Solution:
    def minNumber(self, nums: List[int]) -> str:
        def sort_rule(x, y):
            a, b = x + y, y + x
            if a > b: return 1
            elif a < b: return -1
            else: return 0
        
        strs = [str(num) for num in nums]
        strs.sort(key = functools.cmp_to_key(sort_rule))
        return ''.join(strs)
```

```Java []
class Solution {
    public String minNumber(int[] nums) {
        String[] strs = new String[nums.length];
        for(int i = 0; i < nums.length; i++)
            strs[i] = String.valueOf(nums[i]);
        Arrays.sort(strs, (x, y) -> (x + y).compareTo(y + x));
        StringBuilder res = new StringBuilder();
        for(String s : strs)
            res.append(s);
        return res.toString();
    }
}
```

```C++ []
class Solution {
public:
    string minNumber(vector<int>& nums) {
        vector<string> strs;
        string res;
        for(int i = 0; i < nums.size(); i++)
            strs.push_back(to_string(nums[i]));
        sort(strs.begin(), strs.end(), [](string& x, string& y){ return x + y < y + x; });
        for(int i = 0; i < strs.size(); i++)
            res.append(strs[i]);
        return res;
    }
};
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    118682    |    212276    |   55.9%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
