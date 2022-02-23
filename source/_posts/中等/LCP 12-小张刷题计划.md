---
title: LCP 12-小张刷题计划
date: 2021-12-03 21:33:47
categories:
  - 中等
tags:
  - 数组
  - 二分查找
---

> 原文链接: https://leetcode-cn.com/problems/xiao-zhang-shua-ti-ji-hua


## 英文原文
<div></div>

## 中文题目
<div><p>为了提高自己的代码能力，小张制定了 <code>LeetCode</code> 刷题计划，他选中了 <code>LeetCode</code> 题库中的 <code>n</code> 道题，编号从 <code>0</code> 到 <code>n-1</code>，并计划在 <code>m</code> 天内<strong>按照题目编号顺序</strong>刷完所有的题目（注意，小张不能用多天完成同一题）。</p>

<p>在小张刷题计划中，小张需要用 <code>time[i]</code> 的时间完成编号 <code>i</code> 的题目。此外，小张还可以使用场外求助功能，通过询问他的好朋友小杨题目的解法，可以省去该题的做题时间。为了防止&ldquo;小张刷题计划&rdquo;变成&ldquo;小杨刷题计划&rdquo;，小张每天最多使用一次求助。</p>

<p>我们定义 <code>m</code> 天中做题时间最多的一天耗时为 <code>T</code>（小杨完成的题目不计入做题总时间）。请你帮小张求出最小的 <code>T</code>是多少。</p>

<p><strong>示例 1：</strong></p>

<blockquote>
<p>输入：<code>time = [1,2,3,3], m = 2</code></p>

<p>输出：<code>3</code></p>

<p>解释：第一天小张完成前三题，其中第三题找小杨帮忙；第二天完成第四题，并且找小杨帮忙。这样做题时间最多的一天花费了 3 的时间，并且这个值是最小的。</p>
</blockquote>

<p><strong>示例 2：</strong></p>

<blockquote>
<p>输入：<code>time = [999,999,999], m = 4</code></p>

<p>输出：<code>0</code></p>

<p>解释：在前三天中，小张每天求助小杨一次，这样他可以在三天内完成所有的题目并不花任何时间。</p>
</blockquote>

<p>&nbsp;</p>

<p><strong>限制：</strong></p>

<ul>
	<li><code>1 &lt;= time.length &lt;= 10^5</code></li>
	<li><code>1 &lt;= time[i] &lt;= 10000</code></li>
	<li><code>1 &lt;= m &lt;= 1000</code></li>
</ul>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
```cpp
    bool check(vector<int>& a, int t, int m){//每组累加和在<=t的情况下 能否在m组内分完
        int cnt = 1, rest = t,maxx = -1;//cnt为分的总组数 rest为当前组组剩余容量
        bool flag = true;//可以求助
        for(int i = 0; i < a.size(); i++){
            maxx = max(maxx,a[i]);//维护当前组的最大值
            if(rest >= a[i]) rest -= a[i];//能装下时就直接装
            else if(flag) flag = false,rest += maxx,i--;//装不下且可以求助时，把当前的最费时的那个拿去求助
            else cnt++, maxx = -1,flag = true, rest = t, i--;//装不下 且无法求助时 只能从第二天开始了(开始下一组)
        }
        return cnt <= m;//m组内能分完即可(=m天内能看完)
    }
    int minTime(vector<int>& time, int m) {
        int n = time.size();
        int l = 0, r = 0;
        for(int i = 0; i < n; i++) r += time[i];//获取一天最多耗时是多少
        while(l < r){//二分 T        l<= T <=r
            int T = l + r >> 1;
            if(check(time,T,m)) r = T;//判断在当前T的限制下能否在m天内看完 如果可以就减小T 即 r = T
            else l = T+1;
        }
        return r;
    }
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    6841    |    16525    |   41.4%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
