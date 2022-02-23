---
title: 剑指 Offer II 035-最小时间差
categories:
  - 中等
tags:
  - 数组
  - 数学
  - 字符串
  - 排序
abbrlink: 2792814658
date: 2021-12-03 21:32:04
---

> 原文链接: https://leetcode-cn.com/problems/569nqc




## 中文题目
<div><p>给定一个 24 小时制（小时:分钟 <strong>&quot;HH:MM&quot;</strong>）的时间列表，找出列表中任意两个时间的最小时间差并以分钟数表示。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<pre>
<strong>输入：</strong>timePoints = [&quot;23:59&quot;,&quot;00:00&quot;]
<strong>输出：</strong>1
</pre>

<p><strong>示例 2：</strong></p>

<pre>
<strong>输入：</strong>timePoints = [&quot;00:00&quot;,&quot;23:59&quot;,&quot;00:00&quot;]
<strong>输出：</strong>0
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>2 &lt;= timePoints &lt;= 2 * 10<sup>4</sup></code></li>
	<li><code>timePoints[i]</code> 格式为 <strong>&quot;HH:MM&quot;</strong></li>
</ul>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 539&nbsp;题相同：&nbsp;<a href="https://leetcode-cn.com/problems/minimum-time-difference/">https://leetcode-cn.com/problems/minimum-time-difference/</a></p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
我们注意到，时间点最多只有 `24 * 60` 个，因此，当 timePoints 长度超过 `24 * 60`，说明有重复的时间点，提前返回 0。

接下来：

首先，遍历时间列表，将其转换为“分钟制”列表 `mins`，比如，对于时间点 `13:14`，将其转换为 `13 * 60 + 14`。

接着将“分钟制”列表**按升序排列**，然后将此列表的最小时间 `mins[0]` 加上 `24 * 60` 追加至列表尾部，**用于处理最大值、最小值的差值这种特殊情况**。

最后遍历“分钟制”列表，找出相邻两个时间的最小值即可。

```python [sol1-Python3]
class Solution:
    def findMinDifference(self, timePoints: List[str]) -> int:
        if len(timePoints) > 24 * 60:
            return 0
        mins = sorted(int(t[:2]) * 60 + int(t[3:]) for t in timePoints)
        mins.append(mins[0] + 24 * 60)
        res = mins[-1]
        for i in range(1, len(mins)):
            res = min(res, mins[i] - mins[i - 1])
        return res
```

```java [sol1-Java]
class Solution {
    public int findMinDifference(List<String> timePoints) {
        if (timePoints.size() > 24 * 60) {
            return 0;
        }
        List<Integer> mins = new ArrayList<>();
        for (String t : timePoints) {
            String[] time = t.split(":");
            mins.add(Integer.parseInt(time[0]) * 60 + Integer.parseInt(time[1]));
        }
        Collections.sort(mins);
        mins.add(mins.get(0) + 24 * 60);
        int res = 24 * 60;
        for (int i = 1; i < mins.size(); ++i) {
            res = Math.min(res, mins.get(i) - mins.get(i - 1));
        }
        return res;
    }
}
```

```cpp [sol1-C++]
class Solution {
public:
    int findMinDifference(vector<string>& timePoints) {
        if (timePoints.size() > 24 * 60) return 0;
        vector<int> mins;
        for (auto t : timePoints)
            mins.push_back(stoi(t.substr(0, 2)) * 60 + stoi(t.substr(3)));
        sort(mins.begin(), mins.end());
        mins.push_back(mins[0] + 24 * 60);
        int res = 24 * 60;
        for (int i = 1; i < mins.size(); ++i)
            res = min(res, mins[i] - mins[i - 1]);
        return res;
    }
};
```

```go [sol1-Golang]
func findMinDifference(timePoints []string) int {
	if len(timePoints) > 24*60 {
		return 0
	}
	var mins []int
	for _, t := range timePoints {
		time := strings.Split(t, ":")
		h, _ := strconv.Atoi(time[0])
		m, _ := strconv.Atoi(time[1])
		mins = append(mins, h*60+m)
	}
	sort.Ints(mins)
	mins = append(mins, mins[0]+24*60)
	res := 24 * 60
	for i := 1; i < len(mins); i++ {
		res = min(res, mins[i]-mins[i-1])
	}
	return res
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}
```

---

😄 欢迎 Star 关注 Doocs 开源社区项目：https://github.com/doocs/leetcode

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    4049    |    6072    |   66.7%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
