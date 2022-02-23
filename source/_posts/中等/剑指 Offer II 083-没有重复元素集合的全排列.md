---
title: 剑指 Offer II 083-没有重复元素集合的全排列
date: 2021-12-03 21:32:59
categories:
  - 中等
tags:
  - 数组
  - 回溯
---

> 原文链接: https://leetcode-cn.com/problems/VvJkup




## 中文题目
<div><p>给定一个不含重复数字的整数数组 <code>nums</code> ，返回其 <strong>所有可能的全排列</strong> 。可以 <strong>按任意顺序</strong> 返回答案。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>nums = [1,2,3]
<strong>输出：</strong>[[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>nums = [0,1]
<strong>输出：</strong>[[0,1],[1,0]]
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>nums = [1]
<strong>输出：</strong>[[1]]
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 6</code></li>
	<li><code>-10 &lt;= nums[i] &lt;= 10</code></li>
	<li><code>nums</code> 中的所有整数 <strong>互不相同</strong></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 46&nbsp;题相同：<a href="https://leetcode-cn.com/problems/permutations/">https://leetcode-cn.com/problems/permutations/</a>&nbsp;</p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
在学习回溯算法之前，你最好对树的 DFS 熟悉，因为回溯的问题基本都可以抽象成树形结构问题

你之所以觉得回溯难，是因为你的树形结构及其算法不熟悉

本题最后会提供 Java 、C++、Python、JavaScript 四种语言的实现代码

#### 1. 首先，这道题目可以抽象为树形结构，请看下面的视频解释：

![14_全排列：抽象成树形结构.mp4](74771a89-2538-4332-8eab-5d207fb2f4d9)

#### 2. 然后，我们使用 DFS 遍历上面抽象出来的树形结构，得到所有的路径（即组合），请看视频解释：

![..._0_全排列：拿到数组所有的组合.mp4](6c775066-287e-414e-a67f-fc417b199505)

代码如下：
```java
public List<List<Integer>> permute(int[] nums) {
    List<List<Integer>> res = new ArrayList<>();
    List<Integer> path = new ArrayList<>();
    dfs(nums, -1, path, res);
    return res;
}

private void dfs(int[] nums, int index,
                    List<Integer> path,
                    List<List<Integer>> res) {
    if (path.size() == nums.length) return;

    if (index != -1) path.add(nums[index]);
    if (path.size() == nums.length) {
        res.add(new ArrayList<>(path));
    }

    for (int i = 0; i < nums.length; i++) {
        dfs(nums, i, path, res);
    }

    // 回溯的过程中，将当前的节点从 path 中删除
    if (index != -1) path.remove(path.size() - 1);
}
```

#### 3. 然后，我们可以总结出回溯算法框架代码，请看下面的视频：

![15_1_全排列：回溯代码框架.mp4](c2b252e9-d302-4d2f-8a0e-6e1b62bd3d12)

代码如下：
```java
public List<List<Integer>> permute(int[] nums) {
    List<List<Integer>> res = new ArrayList<>();
    List<Integer> path = new ArrayList<>();
    dfs(nums, path, res);
    return res;
}

private void dfs(int[] nums,
                    List<Integer> path,
                    List<List<Integer>> res) {
    if (path.size() == nums.length) {
        res.add(new ArrayList<>(path));
        return;
    }
    for (int i = 0; i < nums.length; i++) {
        path.add(nums[i]);
        dfs(nums, path, res);
        // 回溯的过程中，将当前的节点从 path 中删除
        path.remove(path.size() - 1);
    }
}
```

#### 4. 剪枝去重，得到最终的组合

![16_全排列：剪枝去重.mp4](7aebe706-7c37-4f6c-9f46-644402eb12b8)

代码如下：
```java
// O(n! * n^2)
public List<List<Integer>> permute(int[] nums) {
    List<List<Integer>> res = new ArrayList<>();
    List<Integer> path = new ArrayList<>();
    dfs(nums, path, res);
    return res;
}

private void dfs(int[] nums,
                    List<Integer> path,
                    List<List<Integer>> res) { // O(n^2)
    if (path.size() == nums.length) {
        res.add(new ArrayList<>(path));
        return;
    }
    for (int i = 0; i < nums.length; i++) {
        // 剪枝，判断重复使用的数字
        if (path.contains(nums[i])) continue;
        path.add(nums[i]);
        dfs(nums, path, res);
        // 回溯的过程中，将当前的节点从 path 中删除
        path.remove(path.size() - 1);
    }
}
````
降低时间复杂度的代码如下：
```Java []
// O(n! * n)
public List<List<Integer>> permute(int[] nums) {
    List<List<Integer>> res = new ArrayList<>();
    List<Integer> path = new ArrayList<>();
    boolean[] used = new boolean[nums.length];
    dfs(nums, path, res, used);
    return res;
}

private void dfs(int[] nums,
                    List<Integer> path,
                    List<List<Integer>> res,
                    boolean[] used) { // O(n)
    if (path.size() == nums.length) {
        res.add(new ArrayList<>(path));
        return;
    }
    for (int i = 0; i < nums.length; i++) {
        // 剪枝，判断重复使用的数字
        if (used[i]) continue;
        path.add(nums[i]);
        used[i] = true;
        dfs(nums, path, res, used);
        // 回溯的过程中，将当前的节点从 path 中删除
        path.remove(path.size() - 1);
        used[i] = false;
    }
}
```
```C++ []
public:
    vector<vector<int>> permute(vector<int>& nums) {
        vector<vector<int>> res;
        vector<int> path;
        vector<bool> used = vector<bool>(nums.size());
        dfs(nums, path, res, used);
        return res;
    }

    void dfs(vector<int> nums,
                vector<int>& path,
                vector<vector<int>>& res,
                vector<bool>& used) {
        if (path.size() == nums.size()) {
            res.emplace_back(path);
            return;
        }

        for (int i = 0; i < nums.size(); i++) {
            if (used[i]) continue;
            path.push_back(nums[i]);
            used[i] = true;
            dfs(nums, path, res, used);
            path.pop_back();
            used[i] = false;
        }
    }
```
```javascript []
var permute = function(nums) {
    const res = [], path = []
    const used = new Array(nums.length).fill(false)

    const dfs = () => {
        if (path.length == nums.length) {
            res.push(path.slice())
            return
        }

        for (let i = 0; i < nums.length; i++) {
            if (used[i]) continue
            path.push(nums[i])
            used[i] = true
            dfs()
            path.pop()
            used[i] = false
        }
    }

    dfs()
    return res
};
```
```python []
def permute(self, nums: List[int]) -> List[List[int]]:
    res, path, used = [], [], [False] * len(nums)

    def dfs() -> None:
        if len(path) == len(nums):
            res.append(path[:])
            return

        for i in range(len(nums)):
            if used[i]: continue
            path.append(nums[i])
            used[i] = True
            dfs()
            path.pop()
            used[i] = False

    dfs()
    return res
```
```Golang []
func permute(nums []int) [][]int {
    var res, path = make([][]int, 0), make([]int, 0)
    var used = make([]bool, len(nums))

    var dfs func()
    dfs = func() {
        if len(path) == len(nums) {
            var temp = make([]int, len(path))
            copy(temp, path)
            res = append(res, temp)
            return
        }

        for i := range nums {
            if used[i] {
                continue
            }
            path = append(path, nums[i])
            used[i] = true
            dfs()
            path = path[:len(path) - 1]
            used[i] = false
        }
    }

    dfs()

    return res
}
```

在刷题的时候：
1. 如果你觉得自己数据结构与算法**基础不够扎实**，那么[请点这里](http://www.tangweiqun.com/api/31104/offer083?av=1&cv=1)，这里包含了**一个程序员 5 年内需要的所有算法知识**

2. 如果你感觉刷题**太慢**，或者感觉**很困难**，或者**赶时间**，那么[请点这里](http://www.tangweiqun.com/api/35548/offer083?av=1&cv=1)。这里**用 365 道高频算法题，带你融会贯通算法知识，做到以不变应万变**

3. **回溯、贪心和动态规划，是算法面试中的三大难点内容**，如果你只是想搞懂这三大难点内容 [请点这里](http://www.tangweiqun.com/api/38100/offer083?av=1&cv=1)

**以上三个链接中的内容，都支持 Java/C++/Python/js/go 五种语言** 


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    4938    |    5733    |   86.1%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
