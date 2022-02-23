---
title: LCP 14-切分数组
date: 2021-12-03 21:33:51
categories:
  - 困难
tags:
  - 数组
  - 数学
  - 动态规划
  - 数论
---

> 原文链接: https://leetcode-cn.com/problems/qie-fen-shu-zu


## 英文原文
<div></div>

## 中文题目
<div><p>给定一个整数数组 <code>nums</code> ，小李想将 <code>nums</code> 切割成若干个非空子数组，使得每个子数组最左边的数和最右边的数的最大公约数大于 1 。为了减少他的工作量，请求出最少可以切成多少个子数组。</p>

<p><strong>示例 1：</strong></p>

<blockquote>
<p>输入：<code>nums = [2,3,3,2,3,3]</code></p>

<p>输出：<code>2</code></p>

<p>解释：最优切割为 [2,3,3,2] 和 [3,3] 。第一个子数组头尾数字的最大公约数为 2 ，第二个子数组头尾数字的最大公约数为 3 。</p>
</blockquote>

<p><strong>示例 2：</strong></p>

<blockquote>
<p>输入：<code>nums = [2,3,5,7]</code></p>

<p>输出：<code>4</code></p>

<p>解释：只有一种可行的切割：[2], [3], [5], [7]</p>
</blockquote>

<p><strong>限制：</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 10^5</code></li>
	<li><code>2 &lt;= nums[i] &lt;= 10^6</code></li>
</ul>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
官方和解释和网友的数学演算都很完备了。这里只是个人觉得比较好理解的解释，请各位网友大神指正。

1，首先我们确定的是这题用动态规划的思路来解这道题。那就是假设`f[0]--f[i-1]`都已经算好了。现在要算`f[i]`

2，在`nums[0]--nums[i-1]`的基础上，加入一下`nums[i]`会发生什么？有2种情况。
    - 1）`nums[i]`单独一组，那么`f[i] = f[i-1]+1`; 
    - 2）`nums[i]`与`nums[0]--nums[i-1]`之间的某一个数的公约数大小于1，假设这个下标为`j`，那么`f[i] = f[j-1] + 1`。因为`nums[j]--nums[i]`可以组成一组。

3，到此其实已经可以算出答案了，`j`由`0`到`i-1`遍历一次，`f[i]`取2种情况中的最小值。但是时间超出了限制，由此引入质数分解来优化遍历效率。思路是用一个map记住因子p在`0`到`i-1`之中的最小f值，用这个值来比较就可以了。理解不了？没关系，下面的4到7都是为了实现这个思路。

4，当j进行遍历的时候，并不需要每个数字都算一遍。举个例子，`nums[i]= 12  = 2*2*3`。那么只需要遍历`nums[0]--nums[i-1]`之中包含有质数因子2和3的数字，把他们算一遍就可以了。

5，第4步说着容易，但代码怎么写啊？因为因子分解这种事情本来就很困难，不然加密算法就不安全了。这里题目正好有数字范围的限制`2<=nums[i]<=10^6`。所以因子分解可行
    - 1）有一个数组primeFactor,它的长度是`10^6+1`。初始值是全0
    - 2）从2开始，如果当前值是0，那么把当前值设置为下标值i，并且每隔i的数字也设置为i。例如刚刚开始数组是
            `[0,0,0,0,0,0,0,0,0,0......]`
第一次：     `[0,0,2,0,2,0,2,0,2,0......]`
第二次：     `[0,0,2,3,2,0,3,0,2,3......]`
第三次：     `[0,0,2,3,2,5,3,0,2,3......]`
    这样做了之后，就会得到一个数组，它的下标`i`必然有`num[i]`这个因子。例如 `nums[6] = 3`。那么6必然有因子3，那么进行因子分解就是对这个数组进行迭代查找的过程。

6，再说第4步，就算我把`nums[i]`进行因子分解了，那我也必须要遍历前面的数字，我才知道它有没有这些因子啊。但其实只需要一个map就可以解决这个问题了，它是因子到最小解下标的映射。是怎么做的呢？举个例子
    - 1）假设`nums[i] = 2*3*5*7`。现在要查找i之前的所有含有因子2的数字。假设`map.get(2) -> [3,6,8,11]`。那么要遍历的数字就是`[nums[3],nums[6],nums[8],nums[11]]`。要做这件事很容易，只需要把当前值的所有因子放到map里面就可以了。
    - 2）但是我们是否需要一个数组呢？其实并不需要。例如`nums[i]`与`nums[3],nums[6],nums[8],nums[11]`是有共同因子2的，我只需要`f[2]+1, f[5]+1, f[7]+1, f[10]+1`之中最小的那一个就可以了。假设是`f[5]+1`。那么我只需要`map.put(2,6)`;后面如果遇到需要遍历因子2的解，结果还会是这一组数字，最小的还会是那个值。因此只需要记住最小的那个就可以了。
    - 3)最后遍历完了之后，如果发现`f[i]`比`f[6]`还要小的话，要更新map，即`map.put(2,i)`。这是因为`nums[i]`也有因子2，它是当前含有因子2中最小的解了。
    - 4）用同样的方法计算因子3，5，7解。`f[i]`取最小的那个解就可以了

7，到此，可以得到正解了。体会：自然语言比不上数学公式那么简洁准确。给数学大神致敬！

```
public class LCP14 {

    private int[] minPrime = new int[1000000 + 1];

    private Map<Integer, Integer> primeMinIndex = new HashMap<>();

    private void init() {
        for (int i = 2; i < minPrime.length; i++) {
            if (minPrime[i] < 2) {
                for (int j = i; j < minPrime.length; j += i) {
                    minPrime[j] = i;
                }
            }
        }
    }

    public int splitArray(int[] nums) {
        init();
        int[] ans = new int[nums.length];
        for (int i = 0; i < nums.length; i++) {
            int n = nums[i];
            ans[i] = i > 0 ? ans[i - 1] + 1 : 1;
            while (n > 1) {
                int factor = minPrime[n];
                int minIndex = -1;
                if (primeMinIndex.containsKey(factor)) {
                    minIndex = primeMinIndex.get(factor);
                } else {
                    minIndex = i;
                    primeMinIndex.put(factor, minIndex);
                }
                if (minIndex > 0) {
                    ans[i] = Math.min(ans[i], ans[minIndex - 1] + 1);
                } else {
                    ans[i] = 1;
                }
                if (ans[i] < ans[minIndex]) {
                    primeMinIndex.put(factor, i);
                }
                n = n / factor;
            }
        }
        return ans[nums.length - 1];
    }
}
```




## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    2818    |    13196    |   21.4%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
