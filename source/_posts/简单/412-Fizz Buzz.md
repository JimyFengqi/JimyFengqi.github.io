---
title: 412-Fizz Buzz
categories:
  - 简单
tags:
  - 数学
  - 字符串
  - 模拟
abbrlink: 3405167973
date: 2021-12-03 22:46:03
---

> 原文链接: https://leetcode-cn.com/problems/fizz-buzz


## 英文原文
<div><p>Given an integer <code>n</code>, return <em>a string array</em> <code>answer</code> (<strong>1-indexed</strong>) <em>where</em>:</p>

<ul>
	<li><code>answer[i] == &quot;FizzBuzz&quot;</code> if <code>i</code> is divisible by <code>3</code> and <code>5</code>.</li>
	<li><code>answer[i] == &quot;Fizz&quot;</code> if <code>i</code> is divisible by <code>3</code>.</li>
	<li><code>answer[i] == &quot;Buzz&quot;</code> if <code>i</code> is divisible by <code>5</code>.</li>
	<li><code>answer[i] == i</code> if non of the above conditions are true.</li>
</ul>

<p>&nbsp;</p>
<p><strong>Example 1:</strong></p>
<pre><strong>Input:</strong> n = 3
<strong>Output:</strong> ["1","2","Fizz"]
</pre><p><strong>Example 2:</strong></p>
<pre><strong>Input:</strong> n = 5
<strong>Output:</strong> ["1","2","Fizz","4","Buzz"]
</pre><p><strong>Example 3:</strong></p>
<pre><strong>Input:</strong> n = 15
<strong>Output:</strong> ["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz"]
</pre>
<p>&nbsp;</p>
<p><strong>Constraints:</strong></p>

<ul>
	<li><code>1 &lt;= n &lt;= 10<sup>4</sup></code></li>
</ul>
</div>

## 中文题目
<div><p>给你一个整数 <code>n</code> ，找出从 <code>1</code> 到 <code>n</code> 各个整数的 Fizz Buzz 表示，并用字符串数组 <code>answer</code>（<strong>下标从 1 开始</strong>）返回结果，其中：</p>

<ul>
	<li><code>answer[i] == "FizzBuzz"</code> 如果 <code>i</code> 同时是 <code>3</code> 和 <code>5</code> 的倍数。</li>
	<li><code>answer[i] == "Fizz"</code> 如果 <code>i</code> 是 <code>3</code> 的倍数。</li>
	<li><code>answer[i] == "Buzz"</code> 如果 <code>i</code> 是 <code>5</code> 的倍数。</li>
	<li><code>answer[i] == i</code> 如果上述条件全不满足。</li>
</ul>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>n = 3
<strong>输出：</strong>["1","2","Fizz"]
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>n = 5
<strong>输出：</strong>["1","2","Fizz","4","Buzz"]
</pre>

<p><strong>示例 3：</strong></p>

<pre>
<strong>输入：</strong>n = 15
<strong>输出：</strong>["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz"]</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= n &lt;= 10<sup>4</sup></code></li>
</ul>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
## 模拟

根据题意进行模拟。

代码：
```Java []
class Solution {
    public List<String> fizzBuzz(int n) {
        List<String> ans = new ArrayList<>();
        for (int i = 1; i <= n; i++) {
            String cur = "";
            if (i % 3 == 0) cur += "Fizz";
            if (i % 5 == 0) cur += "Buzz";
            if (cur.length() == 0) cur = i + "";
            ans.add(cur);
        }
        return ans;
    }
}
```
* 时间复杂度：$O(n)$
* 空间复杂度：$O(n)$

---

## 其他「模拟」相关内容

题目简单？考虑加餐一道 [01 背包变形题](https://mp.weixin.qq.com/s?__biz=MzU4NDE3MTEyMA==&mid=2247488868&idx=1&sn=5e54a1d091a8249d3033a28fc299076d&chksm=fd9cbe7bcaeb376d1ee8a753ebc57358e5605fc1a3b51865eb0f758fb3e6e4688e1b0acfa902&token=730964724&lang=zh_CN#rd)。

或是考虑加练如下「模拟」题目 🍭🍭

| 题目                                                                                 | 题解                                                                                                                                                                      | 难度 | 推荐指数   |
| ------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ---------- |
| [2. 两数相加](https://leetcode-cn.com/problems/add-two-numbers/)                     | [LeetCode 题解链接](https://leetcode-cn.com/problems/add-two-numbers/solution/po-su-jie-fa-shao-bing-ji-qiao-by-ac_oie-etln/)                             | 中等 | 🤩🤩🤩🤩🤩 |
| [5. 最长回文子串](https://leetcode-cn.com/problems/longest-palindromic-substring/)   | [LeetCode 题解链接](https://leetcode-cn.com/problems/longest-palindromic-substring/solution/shua-chuan-lc-po-su-jie-fa-manacher-suan-i2px/) | 中等 | 🤩🤩🤩🤩🤩 |
| [6. Z 字形变换 ](https://leetcode-cn.com/problems/zigzag-conversion/)                | [LeetCode 题解链接](https://leetcode-cn.com/problems/zigzag-conversion/solution/shua-chuan-lc-zhi-guan-gui-lu-jie-fa-shu-8226/)         | 中等 | 🤩🤩🤩     |
| [7. 整数反转 ](https://leetcode-cn.com/problems/reverse-integer/)                    | [LeetCode 题解链接](https://leetcode-cn.com/problems/reverse-integer/solution/shua-chuan-lc-bu-wan-mei-jie-fa-wan-mei-919rd/)                 | 简单 | 🤩🤩🤩     |
| [8. 字符串转换整数 (atoi)](https://leetcode-cn.com/problems/string-to-integer-atoi/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/string-to-integer-atoi/solution/shua-chuan-lc-jian-ji-jie-fa-by-ac_oier-69tp/)                        | 中等 | 🤩🤩🤩     |
| [12. 整数转罗马数字](https://leetcode-cn.com/problems/integer-to-roman/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/integer-to-roman/solution/shua-chuan-lc-tan-xin-jie-fa-by-ac_oier-5kbw/) | 中等 | 🤩🤩 |
| [13. 罗马数字转整数](https://leetcode-cn.com/problems/roman-to-integer/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/roman-to-integer/solution/shua-chuan-lc-ha-xi-biao-by-ac_oier-mooy/) | 简单 | 🤩🤩 |
| [14. 最长公共前缀](https://leetcode-cn.com/problems/longest-common-prefix/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/longest-common-prefix/solution/shua-chuan-lc-die-dai-mo-ni-by-ac_oier-8t4q/) | 简单 | 🤩🤩🤩🤩 |
| [31. 下一个排列](https://leetcode-cn.com/problems/next-permutation/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/next-permutation/solution/miao-dong-xi-lie-100-cong-xia-yi-ge-pai-gog8j/) | 中等 | 🤩🤩🤩 |
| [38. 外观数列](https://leetcode-cn.com/problems/count-and-say/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/count-and-say/solution/shua-chuan-lc-100-mo-ni-ti-shi-yong-shao-w8jl/) | 简单 | 🤩🤩 |
| [43. 字符串相乘](https://leetcode-cn.com/problems/multiply-strings/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/multiply-strings/solution/zhi-yao-ni-hui-shou-suan-cheng-fa-zhe-ti-ainl/) | 中等 | 🤩🤩🤩🤩 |
| [58. 最后一个单词的长度](https://leetcode-cn.com/problems/length-of-last-word/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/length-of-last-word/solution/gong-shui-san-xie-jian-dan-zi-fu-chuan-m-tt6t/) | 中等 | 🤩🤩🤩🤩 |
| [59. 螺旋矩阵 II](https://leetcode-cn.com/problems/spiral-matrix-ii/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/spiral-matrix-ii/solution/yi-ti-shuang-jie-xiang-jie-xing-zhuang-j-24x8/) | 中等 | 🤩🤩🤩🤩 |
| [65. 有效数字](https://leetcode-cn.com/problems/valid-number/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/valid-number/solution/gong-shui-san-xie-zi-fu-chuan-mo-ni-by-a-7cgc/) | 困难 | 🤩🤩🤩 |
| [68. 文本左右对齐](https://leetcode-cn.com/problems/text-justification/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/text-justification/solution/gong-shui-san-xie-zi-fu-chuan-mo-ni-by-a-s3v7/) | 困难 | 🤩🤩🤩 |
| [73. 矩阵置零](https://leetcode-cn.com/problems/set-matrix-zeroes/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/set-matrix-zeroes/solution/xiang-jie-fen-san-bu-de-o1-kong-jian-jie-dbxd/) | 中等 | 🤩🤩🤩🤩 |
| [165. 比较版本号](https://leetcode-cn.com/problems/compare-version-numbers/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/compare-version-numbers/solution/gong-shui-san-xie-jian-dan-zi-fu-chuan-m-xsod/) | 中等 | 🤩🤩🤩🤩 |
| [166. 分数到小数](https://leetcode-cn.com/problems/fraction-to-recurring-decimal/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/fraction-to-recurring-decimal/solution/gong-shui-san-xie-mo-ni-shu-shi-ji-suan-kq8c4/) | 中等 | 🤩🤩🤩🤩 |
| [168. Excel表列名称](https://leetcode-cn.com/problems/excel-sheet-column-title/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/excel-sheet-column-title/solution/gong-shui-san-xie-cong-1-kai-shi-de-26-j-g2ur/) | 简单 | 🤩🤩🤩 |
| [171. Excel表列序号](https://leetcode-cn.com/problems/excel-sheet-column-number/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/excel-sheet-column-number/solution/gong-shui-san-xie-tong-yong-jin-zhi-zhua-y5fm/) | 简单 | 🤩🤩🤩 |
| [190. 颠倒二进制位](https://leetcode-cn.com/problems/reverse-bits/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/reverse-bits/solution/yi-ti-san-jie-dui-cheng-wei-zhu-wei-fen-ub1hi/) | 简单 | 🤩🤩🤩 |
| [233. 数字 1 的个数](https://leetcode-cn.com/problems/number-of-digit-one/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/number-of-digit-one/solution/gong-shui-san-xie-jiang-shu-wei-dp-wen-t-c9oi/) | 困难 | 🤩🤩🤩🤩 |
| [263. 丑数](https://leetcode-cn.com/problems/ugly-number/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/ugly-number/solution/gong-shui-san-xie-jian-dan-de-fen-qing-k-dlvg/) | 简单 | 🤩🤩 |
| [273. 整数转换英文表示](https://leetcode-cn.com/problems/integer-to-english-words/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/integer-to-english-words/solution/gong-shui-san-xie-zi-fu-chuan-da-mo-ni-b-0my6/) | 困难 | 🤩🤩🤩🤩 |
| [284. 顶端迭代器](https://leetcode-cn.com/problems/peeking-iterator/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/peeking-iterator/solution/gong-shui-san-xie-die-dai-qi-ji-ben-ren-b77lz/) | 中等 | 🤩🤩🤩🤩 |
| [345. 反转字符串中的元音字母](https://leetcode-cn.com/problems/reverse-vowels-of-a-string/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/reverse-vowels-of-a-string/solution/gong-shui-san-xie-note-bie-pian-shuang-z-c8ii/) | 简单 | 🤩🤩🤩 |
| [405. 数字转换为十六进制数](https://leetcode-cn.com/problems/convert-a-number-to-hexadecimal/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/convert-a-number-to-hexadecimal/solution/gong-shui-san-xie-yi-ti-shuang-jie-jin-z-d93o/) | 简单 | 🤩🤩🤩🤩 |
| [413. 等差数列划分](https://leetcode-cn.com/problems/arithmetic-slices/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/arithmetic-slices/solution/gong-shui-san-xie-shuang-zhi-zhen-qiu-ji-ef1q/) | 中等 | 🤩🤩🤩🤩 |
| [414. 第三大的数](https://leetcode-cn.com/problems/third-maximum-number/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/third-maximum-number/solution/gong-shui-san-xie-yi-ti-shuang-jie-pai-x-pmln/) | 中等 | 🤩🤩🤩🤩 |
| [434. 字符串中的单词数](https://leetcode-cn.com/problems/number-of-segments-in-a-string/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/number-of-segments-in-a-string/solution/gong-shui-san-xie-jian-dan-zi-fu-mo-ni-t-0gx6/) | 简单 | 🤩🤩🤩🤩 |
| [443. 压缩字符串](https://leetcode-cn.com/problems/string-compression/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/string-compression/solution/gong-shui-san-xie-shuang-zhi-zhen-yuan-d-bppu/) | 中等 | 🤩🤩🤩🤩 |
| [451. 根据字符出现频率排序](https://leetcode-cn.com/problems/sort-characters-by-frequency/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/sort-characters-by-frequency/solution/gong-shui-san-xie-shu-ju-jie-gou-yun-yon-gst9/) | 中等 | 🤩🤩🤩🤩 |
| [457. 环形数组是否存在循环](https://leetcode-cn.com/problems/circular-array-loop/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/circular-array-loop/solution/gong-shui-san-xie-yi-ti-shuang-jie-mo-ni-ag05/) | 中等 | 🤩🤩🤩🤩 |
| [482. 密钥格式化](https://leetcode-cn.com/problems/license-key-formatting/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/license-key-formatting/solution/gong-shui-san-xie-jian-dan-zi-fu-chuan-m-piya/) | 简单 | 🤩🤩🤩🤩 |
| [528. 按权重随机选择](https://leetcode-cn.com/problems/random-pick-with-weight/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/random-pick-with-weight/solution/gong-shui-san-xie-yi-ti-shuang-jie-qian-8bx50/) | 中等 | 🤩🤩🤩🤩 |
| [541. 反转字符串 II](https://leetcode-cn.com/problems/reverse-string-ii/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/reverse-string-ii/solution/gong-shui-san-xie-jian-dan-zi-fu-chuan-m-p88f/) | 简单 | 🤩🤩🤩🤩🤩 |
| [551. 学生出勤记录 I](https://leetcode-cn.com/problems/student-attendance-record-i/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/student-attendance-record-i/solution/gong-shui-san-xie-jian-dan-mo-ni-ti-by-a-hui7/) | 简单 | 🤩🤩🤩 |
| [566. 重塑矩阵](https://leetcode-cn.com/problems/reshape-the-matrix/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/reshape-the-matrix/solution/jian-dan-ti-zhong-quan-chu-ji-ke-yi-kan-79gv5/) | 简单 | 🤩🤩🤩 |
| [645. 错误的集合](https://leetcode-cn.com/problems/set-mismatch/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/set-mismatch/solution/gong-shui-san-xie-yi-ti-san-jie-ji-shu-s-vnr9/) | 简单 | 🤩🤩🤩 |
| [726. 原子的数量](https://leetcode-cn.com/problems/number-of-atoms/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/number-of-atoms/solution/gong-shui-san-xie-shi-yong-xiao-ji-qiao-l5ak4/) | 困难 | 🤩🤩🤩🤩 |
| [766. 托普利茨矩阵](https://leetcode-cn.com/problems/toeplitz-matrix/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/toeplitz-matrix/solution/cong-ci-pan-du-qu-cheng-ben-fen-xi-liang-f20w/) | 简单 | 🤩🤩🤩 |
| [867. 转置矩阵](https://leetcode-cn.com/problems/transpose-matrix/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/transpose-matrix/solution/yi-you-wei-jin-huo-xu-ni-neng-kan-kan-zh-m53m/) | 简单 | 🤩🤩🤩🤩 |
| [896. 单调数列](https://leetcode-cn.com/problems/monotonic-array/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/monotonic-array/solution/wei-shi-yao-yi-ci-bian-li-yao-bi-liang-c-uglp/) | 简单 | 🤩🤩🤩🤩 |
| [1047. 删除字符串中的所有相邻重复项](https://leetcode-cn.com/problems/remove-all-adjacent-duplicates-in-string/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/remove-all-adjacent-duplicates-in-string/solution/cong-30-dao-100wu-chong-shi-xian-jie-jue-vkah/) | 简单 | 🤩🤩🤩🤩 |
| [1104. 二叉树寻路](https://leetcode-cn.com/problems/path-in-zigzag-labelled-binary-tree/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/path-in-zigzag-labelled-binary-tree/solution/gong-shui-san-xie-yi-ti-shuang-jie-mo-ni-rw2d/) | 中等 | 🤩🤩🤩 |
| [1436. 旅行终点站](https://leetcode-cn.com/problems/destination-city/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/destination-city/solution/gong-shui-san-xie-jian-dan-fang-jia-mo-n-y47c/) | 简单 | 🤩🤩🤩🤩🤩 |
| [1480. 一维数组的动态和](https://leetcode-cn.com/problems/running-sum-of-1d-array/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/running-sum-of-1d-array/solution/gong-shui-san-xie-yi-wei-qian-zhui-he-mo-g8hn/) | 简单 | 🤩🤩🤩🤩🤩 |
| [1486. 数组异或操作](https://leetcode-cn.com/problems/xor-operation-in-an-array/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/xor-operation-in-an-array/solution/gong-shui-san-xie-yi-ti-shuang-jie-mo-ni-dggg/) | 简单 | 🤩🤩🤩 |
| [1583. 统计不开心的朋友](https://leetcode-cn.com/problems/count-unhappy-friends/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/count-unhappy-friends/solution/gong-shui-san-xie-ha-xi-biao-mo-ni-ti-by-2qy0/) | 中等 | 🤩🤩🤩🤩 |
| [1646. 获取生成数组中的最大值](https://leetcode-cn.com/problems/get-maximum-in-generated-array/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/get-maximum-in-generated-array/solution/gong-shui-san-xie-jian-dan-mo-ni-ti-by-a-sj53/) | 简单 | 🤩🤩🤩🤩 |
| [1720. 解码异或后的数组](https://leetcode-cn.com/problems/decode-xored-array/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/decode-xored-array/solution/gong-shui-san-xie-li-yong-yi-huo-xing-zh-p1bi/) | 简单 | 🤩🤩🤩 |
| [1736. 替换隐藏数字得到的最晚时间](https://leetcode-cn.com/problems/latest-time-by-replacing-hidden-digits/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/latest-time-by-replacing-hidden-digits/solution/gong-shui-san-xie-ti-huan-yin-cang-shu-z-2l1h/) | 简单 | 🤩🤩🤩🤩 |
| [1743. 从相邻元素对还原数组](https://leetcode-cn.com/problems/restore-the-array-from-adjacent-pairs/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/restore-the-array-from-adjacent-pairs/solution/gong-shui-san-xie-yi-ti-shuang-jie-dan-x-elpx/) | 中等 | 🤩🤩🤩🤩 |
| [1748. 唯一元素的和](https://leetcode-cn.com/problems/sum-of-unique-elements/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/sum-of-unique-elements/solution/mo-ni-ti-po-su-jie-fa-by-ac_oier-ff69/) | 简单 | 🤩🤩       |
| [1763. 最长的美好子字符串](https://leetcode-cn.com/problems/longest-nice-substring/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/longest-nice-substring/solution/cong-shu-ju-fan-wei-xuan-ze-he-gua-suan-n3y2a/) | 简单 | 🤩🤩🤩      |
| [1834. 单线程 CPU](https://leetcode-cn.com/problems/single-threaded-cpu/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/single-threaded-cpu/solution/gong-shui-san-xie-shu-ju-jie-gou-yun-yon-1qk0/) | 中等 | 🤩🤩🤩🤩 |
| [1893. 检查是否区域内所有整数都被覆盖](https://leetcode-cn.com/problems/check-if-all-the-integers-in-a-range-are-covered/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/check-if-all-the-integers-in-a-range-are-covered/solution/gong-shui-san-xie-yi-ti-shuang-jie-mo-ni-j83x/) | 简单 | 🤩🤩🤩🤩 |
| [1894. 找到需要补充粉笔的学生编号](https://leetcode-cn.com/problems/find-the-student-that-will-replace-the-chalk/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/find-the-student-that-will-replace-the-chalk/solution/gong-shui-san-xie-yi-ti-shuang-jie-qian-kpqsk/) | 中等 | 🤩🤩🤩🤩 |
| [面试题 10.02. 变位词组](https://leetcode-cn.com/problems/group-anagrams-lcci/) | [LeetCode 题解链接](https://leetcode-cn.com/problems/group-anagrams-lcci/solution/gong-shui-san-xie-tong-ji-bian-wei-ci-de-0iqe/) | 中等 | 🤩🤩🤩🤩 |


**注：以上目录整理来自 [wiki](https://github.com/SharingSource/LogicStack-LeetCode/wiki/模拟)，任何形式的转载引用请保留出处。**

---

## 最后

**如果有帮助到你，请给题解点个赞和收藏，让更多的人看到 ~ ("▔□▔)/**

也欢迎你 [关注我](https://oscimg.oschina.net/oscnet/up-19688dc1af05cf8bdea43b2a863038ab9e5.png)（公主号后台回复「送书」即可参与长期看题解学算法送实体书活动）或 加入[「组队打卡」](https://leetcode-cn.com/u/ac_oier/)小群 ，提供写「证明」&「思路」的高质量题解。

所有题解已经加入 [刷题指南](https://github.com/SharingSource/LogicStack-LeetCode/wiki)，欢迎 star 哦 ~ 

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    105793    |    149152    |   70.9%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
