---
title: 剑指 Offer II 085-生成匹配的括号
categories:
  - 中等
tags:
  - 字符串
  - 动态规划
  - 回溯
abbrlink: 2160326860
date: 2021-12-03 21:32:53
---

> 原文链接: https://leetcode-cn.com/problems/IDBivT




## 中文题目
<div><p>正整数&nbsp;<code>n</code>&nbsp;代表生成括号的对数，请设计一个函数，用于能够生成所有可能的并且 <strong>有效的 </strong>括号组合。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>n = 3
<strong>输出：</strong>[&quot;((()))&quot;,&quot;(()())&quot;,&quot;(())()&quot;,&quot;()(())&quot;,&quot;()()()&quot;]
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>n = 1
<strong>输出：</strong>[&quot;()&quot;]
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= n &lt;= 8</code></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 22&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/generate-parentheses/">https://leetcode-cn.com/problems/generate-parentheses/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
在学习回溯算法之前，你最好对树的 DFS 熟悉，因为回溯的问题基本都可以抽象成树形结构问题。

你之所以觉得回溯难，是因为你的树形结构及其算法不熟悉。

如果树的 DFS 不熟悉的话，或者想全面系统的学习回溯、贪心和动态规划的话，请看这里：[构建数据结构与算法的知识体系](https://ke.qq.com/course/package/31104?tuin=1bf872a6)。

#### 1. 将问题抽象成树形结构遍历问题

![..._括号生成：抽象成二叉树遍历问题.mp4](296b7686-9b33-4ed0-b2b2-7069eec8be4d)

代码如下：

```java
public List<String> generateParenthesis(int n) {
    List<String> res = new ArrayList<>();
    if (n <= 0) return res;
    dfs(n, "", res);
    return res;
}

private void dfs(int n, String path, List<String> res) {
    if (path.length() == 2 * n) {
        res.add(path);
        return;
    }

    dfs(n, path + "(", res);
    dfs(n, path + ")", res);
}
```

#### 2. 剪枝策略

![42_括号生成：剪枝策略.mp4](e2e55d33-5bd1-458f-b8fe-3ca8a609ecea)

代码如下：
```Java []
public List<String> generateParenthesis(int n) {
    List<String> res = new ArrayList<>();
    if (n <= 0) return res;
    dfs(n, "", res, 0, 0);
    return res;
}

private void dfs(int n, String path, List<String> res, int open, int close) {
    if (open > n || close > open) return;

    if (path.length() == 2 * n) {
        res.add(path);
        return;
    }

    dfs(n, path + "(", res, open + 1, close);
    dfs(n, path + ")", res, open, close + 1);
}
```
```C++ []
public:
    vector<string> generateParenthesis(int n) {
        vector<string> res;
        if (n <= 0) return res;
        dfs(n, "", res, 0, 0);
        return res;
    }

    void dfs(int n, string path, vector<string>& res, int open, int close) {
        if (open > n || close > open) return;

        if (path.length() == 2 * n) {
            res.push_back(path);
            return;
        }

        dfs(n, path + "(", res, open + 1, close);
        dfs(n, path + ")", res, open, close + 1);
    }
```
```python []
def generateParenthesis(self, n: int) -> List[str]:
    res = []
    if n <= 0: return res

    def dfs(path, open, close) -> None:
        if open > n or close > open:
            return
        if len(path) == 2 * n:
            res.append(path)
            return

        dfs(path + "(", open + 1, close)
        dfs(path + ")", open, close + 1)

    dfs("", 0, 0)
    return res
```
```javascript []
var generateParenthesis = function(n) {
    const res = []
    if (n <= 0) return res

    const dfs = (path, open, close) => {
        if (open > n || close > open) return
        if (path.length == 2 * n) {
            res.push(path)
            return
        }
        dfs(path + "(", open + 1, close)
        dfs(path + ")", open, close + 1)
    }

    dfs("", 0, 0)
    return res
};
```

#### 3. 另一种代码实现

![43_括号生成：另一种实现.mp4](7e98e5e7-01ba-47be-b2b8-850b21861942)

代码如下：
```java
public List<String> generateParenthesis(int n) {
    List<String> res = new ArrayList<>();
    if (n <= 0) return res;
    dfs(n, "", res, 0, 0);
    return res;
}

private void dfs(int n, String path, List<String> res, int open, int close) {
    if (path.length() == 2 * n) {
        res.add(path);
        return;
    }
    if (open < n) {
        dfs(n, path + "(", res, open + 1, close);
    }
    if (close < open) {
        dfs(n, path + ")", res, open, close + 1);
    }
}
```


在刷题的时候：
1. 如果你觉得自己数据结构与算法**基础不够扎实**，那么[请点这里](http://www.tangweiqun.com/api/31104/offer085?av=1&cv=1)，这里包含了**一个程序员 5 年内需要的所有算法知识**。

2. 如果你感觉刷题**太慢**，或者感觉**很困难**，或者**赶时间**，那么[请点这里](http://www.tangweiqun.com/api/35548/offer085?av=1&cv=1)。这里**用 365 道高频算法题，带你融会贯通算法知识，做到以不变应万变**。

3. **回溯、贪心和动态规划，是算法面试中的三大难点内容**，如果你只是想搞懂这三大难点内容 [请点这里](http://www.tangweiqun.com/api/38100/offer085?av=1&cv=1)。

**以上三个链接中的内容，都支持 Java/C++/Python/js 四种语言** 




## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    4798    |    5637    |   85.1%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
