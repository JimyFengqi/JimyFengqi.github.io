---
title: 剑指 Offer 56 - I-数组中数字出现的次数(数组中数字出现的次数 LCOF)
date: 2021-12-03 21:37:53
categories:
  - 中等
tags:
  - 位运算
  - 数组
---

> 原文链接: https://leetcode-cn.com/problems/shu-zu-zhong-shu-zi-chu-xian-de-ci-shu-lcof




## 中文题目
<div><p>一个整型数组 <code>nums</code> 里除两个数字之外，其他数字都出现了两次。请写程序找出这两个只出现一次的数字。要求时间复杂度是O(n)，空间复杂度是O(1)。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre><strong>输入：</strong>nums = [4,1,4,6]
<strong>输出：</strong>[1,6] 或 [6,1]
</pre>

<p><strong>示例 2：</strong></p>

<pre><strong>输入：</strong>nums = [1,2,10,4,1,4,3,3]
<strong>输出：</strong>[2,10] 或 [10,2]</pre>

<p>&nbsp;</p>

<p><strong>限制：</strong></p>

<ul>
	<li><code>2 &lt;= nums.length &lt;= 10000</code></li>
</ul>

<p>&nbsp;</p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解

本题和主站 260 是一样的. 除了这个，主站还有 136 和 137，645。 总共加起来本系列一共 `四道题`。 四道题全部都是位运算的套路，如果你想练习位运算的话，不要错过哦～～

#### 前菜

1. 异或的性质
   两个数字异或的结果`a^b`是将 a 和 b 的二进制每一位进行运算，得出的数字。 运算的逻辑是
   如果同一位的数字相同则为 0，不同则为 1

2. 异或的规律

- 任何数和本身异或则为 `0`

- 任何数和 0 异或是 `本身`

3. 异或满足交换律。 即 `a ^ b ^ c` ，等价于 `a ^ c ^ b`


OK，我们来看下这四道题吧。

#### 136. 只出现一次的数字 1

题目大意是除了一个数字出现一次，其他都出现了两次，让我们找到出现一次的数。我们执行一次全员异或即可。

```Python []
class Solution:
    def singleNumber(self, nums: List[int]) -> int:
        single_number = 0
        for num in nums:
            single_number ^= num
        return single_number
```
***复杂度分析***
- 时间复杂度：$O(N)$，其中N为数组长度。
- 空间复杂度：$O(1)$


#### 137. 只出现一次的数字 2

题目大意是除了一个数字出现一次，其他都出现了三次，让我们找到出现一次的数。 灵活运用位运算是本题的关键。

Python3:

```Python []
class Solution:
    def singleNumber(self, nums: List[int]) -> int:
        res = 0
        for i in range(32):
            cnt = 0  # 记录当前 bit 有多少个1
            bit = 1 << i  # 记录当前要操作的 bit
            for num in nums:
                if num & bit != 0:
                    cnt += 1
            if cnt % 3 != 0:
                # 不等于0说明唯一出现的数字在这个 bit 上是1
                res |= bit

        return res - 2 ** 32 if res > 2 ** 31 - 1 else res
```


- 为什么 Python 最后需要对返回值进行判断？

如果不这么做的话测试用例是 `[-2,-2,1,1,-3,1,-3,-3,-4,-2]` 的时候，就会输出 4294967292。 其原因在于 Python 是动态类型语言，在这种情况下其会将符号位置的 1 看成了值，而不是当作符号 “负数”。 这是不对的。 正确答案应该是 - 4，-4 的二进制码是 1111...100，就变成 `2^32-4=4294967292`，解决办法就是 减去 2 ** 32 。

> 之所以这样不会有问题的原因还在于题目限定的数组范围不会超过 2 ** 32

JavaScript:

```js []
var singleNumber = function(nums) {
  let res = 0;
  for (let i = 0; i < 32; i++) {
    let cnt = 0;
    let bit = 1 << i;
    for (let j = 0; j < nums.length; j++) {
      if (nums[j] & bit) cnt++;
    }
    if (cnt % 3 != 0) res = res | bit;
  }
  return res;
};
```

***复杂度分析***
- 时间复杂度：$O(N)$，其中N为数组长度。
- 空间复杂度：$O(1)$

#### 645. 错误的集合


这题没有限制空间复杂度，因此直接 hashmap 存储一下没问题。 不多说了，我们来看一种空间复杂度 $O(1)$ 的解法。

这里我们的思路是，将 nums 的所有索引提取出一个数组 idx，那么由 idx 和 nums 组成的数组构成 singleNumbers 的输入，其输出是唯二不同的两个数。

但是我们不知道哪个是缺失的，哪个是重复的，因此我们需要重新进行一次遍历，判断出哪个是缺失的，哪个是重复的。


> 和 `260. 只出现一次的数字 3` 思路基本一样，我直接复用了代码。


```Python []
class Solution:
    def singleNumbers(self, nums: List[int]) -> List[int]:
        ret = 0  # 所有数字异或的结果
        a = 0
        b = 0
        for n in nums:
            ret ^= n
        # 找到第一位不是0的
        h = 1
        while(ret & h == 0):
            h <<= 1
        for n in nums:
            # 根据该位是否为0将其分为两组
            if (h & n == 0):
                a ^= n
            else:
                b ^= n

        return [a, b]

    def findErrorNums(self, nums: List[int]) -> List[int]:
        nums = [0] + nums
        idx = []
        for i in range(len(nums)):
            idx.append(i)
        a, b = self.singleNumbers(nums + idx)
        for num in nums:
            if a == num:
                return [a, b]
        return [b, a]

```

感谢 @云龙 的提醒，上面的 h 计算过程甚至可以简化为 `h = res ^ (res & (res-1)) `

***复杂度分析***
- 时间复杂度：$O(N)$
- 空间复杂度：$O(N)$，这里我使用了 idx 数组。

实际上我这里只是为了重用之前的代码，让大家看出来套路。 其实根本不需要什么 idx 数组。 代码：

```py
class Solution:

    def findErrorNums(self, nums: List[int]) -> List[int]:
        ret = 0  # 所有数字异或的结果
        a = 0
        b = 0
        for n in nums:
            ret ^= n
        for i in range(1, len(nums) + 1):
            ret ^= i
        # 找到第一位不是0的
        h = 1
        while(ret & h == 0):
            h <<= 1
        for n in nums:
            # 根据该位是否为0将其分为两组
            if (h & n == 0):
                a ^= n
            else:
                b ^= n
        for n in range(1, len(nums) + 1):
            # 根据该位是否为0将其分为两组
            if (h & n == 0):
                a ^= n
            else:
                b ^= n
        for num in nums:
            if a == num:
                return [a, b]
            if b == num:
                return [b, a]
```

***复杂度分析***
- 时间复杂度：$O(N)$
- 空间复杂度：$O(1)$


#### 260. 只出现一次的数字 3(就是本题)

题目大意是除了两个数字出现一次，其他都出现了两次，让我们找到这个两个数。

我们进行一次全员异或操作，得到的结果就是那两个只出现一次的不同的数字的异或结果。

我们刚才讲了异或的规律中有一个 `任何数和本身异或则为0`， 因此我们的思路是能不能将这两个不同的数字分成两组 A 和 B。
分组需要满足两个条件.

1. 两个独特的的数字分成不同组

2. 相同的数字分成相同组

这样每一组的数据进行异或即可得到那两个数字。

问题的关键点是我们怎么进行分组呢？

由于异或的性质是，同一位相同则为 0，不同则为 1. 我们将所有数字异或的结果一定不是 0，也就是说至少有一位是 1.

我们随便取一个，分组的依据就来了， 就是你取的那一位是 0 分成 1 组，那一位是 1 的分成一组。
这样肯定能保证 `2. 相同的数字分成相同组`，不同的数字会被分成不同组么。 很明显当然可以， 因此我们选择是 1，也就是
说 `两个独特的的数字` 在那一位一定是不同的，因此两个独特元素一定会被分成不同组。


```Python []
class Solution:
    def singleNumbers(self, nums: List[int]) -> List[int]:
        ret = 0  # 所有数字异或的结果
        a = 0
        b = 0
        for n in nums:
            ret ^= n
        # 找到第一位不是0的
        h = 1
        while(ret & h == 0):
            h <<= 1
        for n in nums:
            # 根据该位是否为0将其分为两组
            if (h & n == 0):
                a ^= n
            else:
                b ^= n

        return [a, b]
```

***复杂度分析***
- 时间复杂度：$O(N)$，其中N为数组长度。
- 空间复杂度：$O(1)$


更多题解可以访问我的LeetCode题解仓库：https://github.com/azl397985856/leetcode  。 目前已经35K star啦。

关注公众号力扣加加，努力用清晰直白的语言还原解题思路，并且有大量图解，手把手教你识别套路，高效刷题。

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    122485    |    175817    |   69.7%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
