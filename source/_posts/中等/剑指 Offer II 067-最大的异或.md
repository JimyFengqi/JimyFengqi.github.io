---
title: 剑指 Offer II 067-最大的异或
date: 2021-12-03 21:28:23
categories:
  - 中等
tags:
  - 位运算
  - 字典树
  - 数组
  - 哈希表
---

> 原文链接: https://leetcode-cn.com/problems/ms70jA




## 中文题目
<div><p>给定一个整数数组 <code>nums</code> ，返回<em> </em><code>nums[i] XOR nums[j]</code> 的最大运算结果，其中 <code>0 &le; i &le; j &lt; n</code> 。</p>

<p>&nbsp;</p>

<div class="original__bRMd">
<div>
<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>nums = [3,10,5,25,2,8]
<strong>输出：</strong>28
<strong>解释：</strong>最大运算结果是 5 XOR 25 = 28.</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>nums = [0]
<strong>输出：</strong>0
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>nums = [2,4]
<strong>输出：</strong>6
</pre>

<p><strong>示例 4：</strong></p>

<pre>
<strong>输入：</strong>nums = [8,10,2]
<strong>输出：</strong>10
</pre>

<p><strong>示例 5：</strong></p>

<pre>
<strong>输入：</strong>nums = [14,70,53,83,49,91,36,80,92,51,66,70]
<strong>输出：</strong>127
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= nums.length &lt;= 2 * 10<sup>4</sup></code></li>
	<li><code>0 &lt;= nums[i] &lt;= 2<sup>31</sup> - 1</code></li>
</ul>
</div>
</div>

<p>&nbsp;</p>

<p><strong>进阶：</strong>你可以在 <code>O(n)</code> 的时间解决这个问题吗？</p>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 421&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/maximum-xor-of-two-numbers-in-an-array/">https://leetcode-cn.com/problems/maximum-xor-of-two-numbers-in-an-array/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
### 解题思路
> 本文是根据 前缀树(trie) 来解决的，如果不知道前缀树的小伙伴们可以去看看[《实现前缀树》](https://leetcode-cn.com/problems/QC3q1f/solution/offerii062shi-xian-qian-zhui-shu-by-logi-utoz/)，以小白的视角对前缀树进行了简单的解释。

在一个数组中求两个数的异或最大值，需要考虑一下几点。
*  大的数异或后带来的增益较大，所以优先考虑大的数进行异或，也就是先考虑高位。
*  只有当两个二进制位不同，二进制位才会为1，所以，我们尽量找到两个很多位都不同的数进行异或。

现在来看看解题思路：
1. 构建前缀树：将所有的数都插入前缀树中。与普通前缀树不同，这里是根据一个数的二进制位来插入，普通前缀树是根据单词中的字符来插入。还有一点需要注意的是，我们优先考虑高位，所以是从高位到低位进行插入。
```java
// 定义前缀树
class TrieNode{
    TrieNode[] next;
    public TrieNode(){
        next = new TrieNode[2]; // 代表 0 1 两个二进制位
    }
}
```
2. 对于 `nums` 中的每个数 `num` ，都到前缀树中去搜索`num`最大异或的那个数，然后计算最大异或值，最后，从这些异或值中挑出最大的一个就是要的答案。

**重点：搜索的方法**
异或值最大，我们就要尽量让每个异或位都和 `num` 对应的二进制位不同。
* 如果 `num` 当前位为 0，就到 `next[1]` 去搜索；
* 如果 `num` 当前位为 1，就到  `next[0]` 去搜索;
* 如果与 `num` 当前位相反的那一位为空，那就只能到相同的那一位去搜索了。 


### 代码

```java
class Solution {
    // 定义前缀树
    class TrieNode{
        TrieNode[] next;
        public TrieNode(){
            next = new TrieNode[2];
        }
    }
    // 前缀树根节点
    private TrieNode trie;

    public int findMaximumXOR(int[] nums) {
        // 记录异或最大值
        int maxXOR = Integer.MIN_VALUE;
        // 构建前缀树：将所有数都插入前缀树中。
        buildTrie(nums);
        // 查询每个数异或的最大值
        for(int num : nums){
            maxXOR = Math.max(maxXOR, searchMaxXOR(num));
        }
        // 返回最终异或的最大值
        return maxXOR;
    }

    private void buildTrie(int[] nums){
        // 初始化前缀树的根节点
        trie = new TrieNode();
        // 将所有数都插入前缀树
        for(int num : nums){
            TrieNode cur = trie;
            // 这里也可以是 31，但由于 nums 中的数都是正数，第32位是标记位肯定都为0，异或后的结果为0，所以就不考虑这一位了。
            for(int i = 30; i >= 0; i--){
                int d = num >> i & 1;
                if(cur.next[d] == null){
                    cur.next[d] = new TrieNode();
                }
                cur = cur.next[d];
            }
        }
    }

    private int searchMaxXOR(int num){
        TrieNode cur = trie;
        // 与 num 异或值最大的数
        int xorNum = 0;

        for(int i = 30; i >= 0; i--){
            // d : num 当前"二进制位"
            int d = num >> i & 1;
            // 获取 与 d 相反的二进制位，由于 d 不是 0 就是 1
            // 当 d = 0, (d-1) * -1 = 1 ; 当 d = 1, (d - 1) * -1 = 0;
            int theOther = (d - 1) * -1;
            // 由于异或要最大，则尽量走与 num 当前二进制位 d 相反的一位，
            // 如果相反的一位为空，则只好走相同的一位了。
            if(cur.next[theOther] == null){
                cur = cur.next[d];
                xorNum = xorNum * 2 + d; // 记录走的路径，走的路径就是最后与 num 异或最大的数
            }else{
                cur = cur.next[theOther];
                xorNum = xorNum * 2 +theOther;
            }
        }
        // 返回 num 异或的最大值
        return num ^ xorNum;
    }
}
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    1869    |    2750    |   68.0%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
