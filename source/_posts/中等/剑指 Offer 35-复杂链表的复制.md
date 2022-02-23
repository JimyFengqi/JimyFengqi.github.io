---
title: 剑指 Offer 35-复杂链表的复制(复杂链表的复制  LCOF)
categories:
  - 中等
tags:
  - 哈希表
  - 链表
abbrlink: 3717441413
date: 2021-12-03 21:39:12
---

> 原文链接: https://leetcode-cn.com/problems/fu-za-lian-biao-de-fu-zhi-lcof




## 中文题目
<div><p>请实现 <code>copyRandomList</code> 函数，复制一个复杂链表。在复杂链表中，每个节点除了有一个 <code>next</code> 指针指向下一个节点，还有一个 <code>random</code> 指针指向链表中的任意节点或者 <code>null</code>。</p>

<p>&nbsp;</p>

<p><strong>示例 1：</strong></p>

<p><img alt="" src="https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2020/01/09/e1.png"></p>

<pre><strong>输入：</strong>head = [[7,null],[13,0],[11,4],[10,2],[1,0]]
<strong>输出：</strong>[[7,null],[13,0],[11,4],[10,2],[1,0]]
</pre>

<p><strong>示例 2：</strong></p>

<p><img alt="" src="https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2020/01/09/e2.png"></p>

<pre><strong>输入：</strong>head = [[1,1],[2,1]]
<strong>输出：</strong>[[1,1],[2,1]]
</pre>

<p><strong>示例 3：</strong></p>

<p><strong><img alt="" src="https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2020/01/09/e3.png"></strong></p>

<pre><strong>输入：</strong>head = [[3,null],[3,0],[3,null]]
<strong>输出：</strong>[[3,null],[3,0],[3,null]]
</pre>

<p><strong>示例 4：</strong></p>

<pre><strong>输入：</strong>head = []
<strong>输出：</strong>[]
<strong>解释：</strong>给定的链表为空（空指针），因此返回 null。
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>-10000 &lt;= Node.val &lt;= 10000</code></li>
	<li><code>Node.random</code>&nbsp;为空（null）或指向链表中的节点。</li>
	<li>节点数目不超过 1000 。</li>
</ul>

<p>&nbsp;</p>

<p><strong>注意：</strong>本题与主站 138 题相同：<a href="https://leetcode-cn.com/problems/copy-list-with-random-pointer/">https://leetcode-cn.com/problems/copy-list-with-random-pointer/</a></p>

<p>&nbsp;</p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
#### 解题思路：

> 普通链表的节点定义如下：

```Python []
# Definition for a Node.
class Node:
    def __init__(self, x: int, next: 'Node' = None):
        self.val = int(x)
        self.next = next
```

```Java []
// Definition for a Node.
class Node {
    int val;
    Node next;
    public Node(int val) {
        this.val = val;
        this.next = null;
    }
}
```

```C++ []
// Definition for a Node.
class Node {
public:
    int val;
    Node* next;
    Node(int _val) {
        val = _val;
        next = NULL;
    }
};
```

> 本题链表的节点定义如下：

```Python []
# Definition for a Node.
class Node:
    def __init__(self, x: int, next: 'Node' = None, random: 'Node' = None):
        self.val = int(x)
        self.next = next
        self.random = random
```

```Java []
// Definition for a Node.
class Node {
    int val;
    Node next, random;
    public Node(int val) {
        this.val = val;
        this.next = null;
        this.random = null;
    }
}
```

```C++ []
// Definition for a Node.
class Node {
public:
    int val;
    Node* next;
    Node* random;
    Node(int _val) {
        val = _val;
        next = NULL;
        random = NULL;
    }
};
```

给定链表的头节点 `head` ，复制普通链表很简单，只需遍历链表，每轮建立新节点 + 构建前驱节点 `pre` 和当前节点 `node` 的引用指向即可。

本题链表的节点新增了 `random` 指针，指向链表中的 **任意节点** 或者 $null$ 。这个 `random` 指针意味着在复制过程中，除了构建前驱节点和当前节点的引用指向 `pre.next` ，还要构建前驱节点和其随机节点的引用指向  `pre.random` 。

**本题难点：** 在复制链表的过程中构建新链表各节点的 `random` 引用指向。

![Picture1.png](../images/fu-za-lian-biao-de-fu-zhi-lcof-0.png){:width=450}

```Python []
class Solution:
    def copyRandomList(self, head: 'Node') -> 'Node':
        cur = head
        dum = pre = Node(0)
        while cur:
            node = Node(cur.val) # 复制节点 cur
            pre.next = node      # 新链表的 前驱节点 -> 当前节点
            # pre.random = '???' # 新链表的 「 前驱节点 -> 当前节点 」 无法确定
            cur = cur.next       # 遍历下一节点
            pre = node           # 保存当前新节点
        return dum.next
```

```Java []
class Solution {
    public Node copyRandomList(Node head) {
        Node cur = head;
        Node dum = new Node(0), pre = dum;
        while(cur != null) {
            Node node = new Node(cur.val); // 复制节点 cur
            pre.next = node;               // 新链表的 前驱节点 -> 当前节点
            // pre.random = "???";         // 新链表的 「 前驱节点 -> 当前节点 」 无法确定
            cur = cur.next;                // 遍历下一节点
            pre = node;                    // 保存当前新节点
        }
        return dum.next;
    }
}
```

```C++ []
class Solution {
public:
    Node* copyRandomList(Node* head) {
        Node* cur = head;
        Node* dum = new Node(0), *pre = dum;
        while(cur != nullptr) {
            Node* node = new Node(cur->val); // 复制节点 cur
            pre->next = node;                // 新链表的 前驱节点 -> 当前节点
            // pre->random = "???";          // 新链表的 「 前驱节点 -> 当前节点 」 无法确定
            cur = cur->next;                 // 遍历下一节点
            pre = node;                      // 保存当前新节点
        }
        return dum->next;
    }
};
```

> 本文介绍 「哈希表」 ，「拼接 + 拆分」 两种方法。哈希表方法比较直观；拼接 + 拆分方法的空间复杂度更低。

#### 方法一：哈希表

利用哈希表的查询特点，考虑构建 **原链表节点** 和 **新链表对应节点** 的键值对映射关系，再遍历构建新链表各节点的 `next` 和 `random` 引用指向即可。

##### 算法流程：

1. 若头节点 `head` 为空节点，直接返回 $null$ ；
2. **初始化：** 哈希表 `dic` ， 节点 `cur` 指向头节点；
3. **复制链表：**
   1. 建立新节点，并向 `dic` 添加键值对 `(原 cur 节点, 新 cur 节点）` ；
   2. `cur` 遍历至原链表下一节点；
4. **构建新链表的引用指向：**
   1. 构建新节点的 `next` 和 `random` 引用指向；
   2. `cur` 遍历至原链表下一节点；
5. **返回值：** 新链表的头节点 `dic[cur]` ；

##### 复杂度分析：

- **时间复杂度 $O(N)$ ：** 两轮遍历链表，使用 $O(N)$ 时间。
- **空间复杂度 $O(N)$ ：** 哈希表 `dic` 使用线性大小的额外空间。

<![Picture2.png](../images/fu-za-lian-biao-de-fu-zhi-lcof-1.png),![Picture3.png](../images/fu-za-lian-biao-de-fu-zhi-lcof-2.png),![Picture4.png](../images/fu-za-lian-biao-de-fu-zhi-lcof-3.png),![Picture5.png](../images/fu-za-lian-biao-de-fu-zhi-lcof-4.png),![Picture6.png](../images/fu-za-lian-biao-de-fu-zhi-lcof-5.png),![Picture7.png](../images/fu-za-lian-biao-de-fu-zhi-lcof-6.png),![Picture8.png](../images/fu-za-lian-biao-de-fu-zhi-lcof-7.png),![Picture9.png](../images/fu-za-lian-biao-de-fu-zhi-lcof-8.png),![Picture10.png](../images/fu-za-lian-biao-de-fu-zhi-lcof-9.png),![Picture11.png](../images/fu-za-lian-biao-de-fu-zhi-lcof-10.png),![Picture12.png](../images/fu-za-lian-biao-de-fu-zhi-lcof-11.png),![Picture13.png](../images/fu-za-lian-biao-de-fu-zhi-lcof-12.png)>

##### 代码：

```Python []
class Solution:
    def copyRandomList(self, head: 'Node') -> 'Node':
        if not head: return
        dic = {}
        # 3. 复制各节点，并建立 “原节点 -> 新节点” 的 Map 映射
        cur = head
        while cur:
            dic[cur] = Node(cur.val)
            cur = cur.next
        cur = head
        # 4. 构建新节点的 next 和 random 指向
        while cur:
            dic[cur].next = dic.get(cur.next)
            dic[cur].random = dic.get(cur.random)
            cur = cur.next
        # 5. 返回新链表的头节点
        return dic[head]
```

```Java []
class Solution {
    public Node copyRandomList(Node head) {
        if(head == null) return null;
        Node cur = head;
        Map<Node, Node> map = new HashMap<>();
        // 3. 复制各节点，并建立 “原节点 -> 新节点” 的 Map 映射
        while(cur != null) {
            map.put(cur, new Node(cur.val));
            cur = cur.next;
        }
        cur = head;
        // 4. 构建新链表的 next 和 random 指向
        while(cur != null) {
            map.get(cur).next = map.get(cur.next);
            map.get(cur).random = map.get(cur.random);
            cur = cur.next;
        }
        // 5. 返回新链表的头节点
        return map.get(head);
    }
}
```

```C++ []
class Solution {
public:
    Node* copyRandomList(Node* head) {
        if(head == nullptr) return nullptr;
        Node* cur = head;
        unordered_map<Node*, Node*> map;
        // 3. 复制各节点，并建立 “原节点 -> 新节点” 的 Map 映射
        while(cur != nullptr) {
            map[cur] = new Node(cur->val);
            cur = cur->next;
        }
        cur = head;
        // 4. 构建新链表的 next 和 random 指向
        while(cur != nullptr) {
            map[cur]->next = map[cur->next];
            map[cur]->random = map[cur->random];
            cur = cur->next;
        }
        // 5. 返回新链表的头节点
        return map[head];
    }
};
```

#### 方法二：拼接 + 拆分

考虑构建 `原节点 1 -> 新节点 1 -> 原节点 2 -> 新节点 2 -> ……` 的拼接链表，如此便可在访问原节点的 `random` 指向节点的同时找到新对应新节点的 `random` 指向节点。

##### 算法流程：

1. **复制各节点，构建拼接链表:**

    - 设原链表为 $node1 \rightarrow node2 \rightarrow \cdots$ ，构建的拼接链表如下所示：

$$
node1 \rightarrow node1_{new} \rightarrow node2 \rightarrow node2_{new} \rightarrow \cdots
$$

2. **构建新链表各节点的 `random` 指向：**

    - 当访问原节点 `cur` 的随机指向节点 `cur.random` 时，对应新节点 `cur.next` 的随机指向节点为 `cur.random.next` 。

3. **拆分原 / 新链表：**

    - 设置 `pre` / `cur` 分别指向原 / 新链表头节点，遍历执行 `pre.next = pre.next.next` 和 `cur.next = cur.next.next` 将两链表拆分开。

4. 返回新链表的头节点 `res` 即可。

##### 复杂度分析：

- **时间复杂度 $O(N)$ ：** 三轮遍历链表，使用 $O(N)$ 时间。
- **空间复杂度 $O(1)$ ：** 节点引用变量使用常数大小的额外空间。

<![Picture14.png](../images/fu-za-lian-biao-de-fu-zhi-lcof-13.png),![Picture15.png](../images/fu-za-lian-biao-de-fu-zhi-lcof-14.png),![Picture16.png](../images/fu-za-lian-biao-de-fu-zhi-lcof-15.png),![Picture17.png](../images/fu-za-lian-biao-de-fu-zhi-lcof-16.png),![Picture18.png](../images/fu-za-lian-biao-de-fu-zhi-lcof-17.png),![Picture19.png](../images/fu-za-lian-biao-de-fu-zhi-lcof-18.png),![Picture20.png](../images/fu-za-lian-biao-de-fu-zhi-lcof-19.png)>

##### 代码：

```Python []
class Solution:
    def copyRandomList(self, head: 'Node') -> 'Node':
        if not head: return
        cur = head
        # 1. 复制各节点，并构建拼接链表
        while cur:
            tmp = Node(cur.val)
            tmp.next = cur.next
            cur.next = tmp
            cur = tmp.next
        # 2. 构建各新节点的 random 指向
        cur = head
        while cur:
            if cur.random:
                cur.next.random = cur.random.next
            cur = cur.next.next
        # 3. 拆分两链表
        cur = res = head.next
        pre = head
        while cur.next:
            pre.next = pre.next.next
            cur.next = cur.next.next
            pre = pre.next
            cur = cur.next
        pre.next = None # 单独处理原链表尾节点
        return res      # 返回新链表头节点
```

```Java []
class Solution {
    public Node copyRandomList(Node head) {
        if(head == null) return null;
        Node cur = head;
        // 1. 复制各节点，并构建拼接链表
        while(cur != null) {
            Node tmp = new Node(cur.val);
            tmp.next = cur.next;
            cur.next = tmp;
            cur = tmp.next;
        }
        // 2. 构建各新节点的 random 指向
        cur = head;
        while(cur != null) {
            if(cur.random != null)
                cur.next.random = cur.random.next;
            cur = cur.next.next;
        }
        // 3. 拆分两链表
        cur = head.next;
        Node pre = head, res = head.next;
        while(cur.next != null) {
            pre.next = pre.next.next;
            cur.next = cur.next.next;
            pre = pre.next;
            cur = cur.next;
        }
        pre.next = null; // 单独处理原链表尾节点
        return res;      // 返回新链表头节点
    }
}
```

```C++ []
class Solution {
public:
    Node* copyRandomList(Node* head) {
        if(head == nullptr) return nullptr;
        Node* cur = head;
        // 1. 复制各节点，并构建拼接链表
        while(cur != nullptr) {
            Node* tmp = new Node(cur->val);
            tmp->next = cur->next;
            cur->next = tmp;
            cur = tmp->next;
        }
        // 2. 构建各新节点的 random 指向
        cur = head;
        while(cur != nullptr) {
            if(cur->random != nullptr)
                cur->next->random = cur->random->next;
            cur = cur->next->next;
        }
        // 3. 拆分两链表
        cur = head->next;
        Node* pre = head, *res = head->next;
        while(cur->next != nullptr) {
            pre->next = pre->next->next;
            cur->next = cur->next->next;
            pre = pre->next;
            cur = cur->next;
        }
        pre->next = nullptr; // 单独处理原链表尾节点
        return res;      // 返回新链表头节点
    }
};
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    135981    |    189234    |   71.9%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
