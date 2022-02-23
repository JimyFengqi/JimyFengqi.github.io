---
title: 剑指 Offer II 031-最近最少使用缓存
categories:
  - 中等
tags:
  - 设计
  - 哈希表
  - 链表
  - 双向链表
abbrlink: 1553836004
date: 2021-12-03 21:32:12
---

> 原文链接: https://leetcode-cn.com/problems/OrIXps




## 中文题目
<div><div class="title__3Vvk">
<p>运用所掌握的数据结构，设计和实现一个&nbsp; <a href="https://baike.baidu.com/item/LRU" target="_blank">LRU (Least Recently Used，最近最少使用) 缓存机制</a> 。</p>

<p>实现 <code>LRUCache</code> 类：</p>

<ul>
	<li><code>LRUCache(int capacity)</code> 以正整数作为容量&nbsp;<code>capacity</code> 初始化 LRU 缓存</li>
	<li><code>int get(int key)</code> 如果关键字 <code>key</code> 存在于缓存中，则返回关键字的值，否则返回 <code>-1</code> 。</li>
	<li><code>void put(int key, int value)</code>&nbsp;如果关键字已经存在，则变更其数据值；如果关键字不存在，则插入该组「关键字-值」。当缓存容量达到上限时，它应该在写入新数据之前删除最久未使用的数据值，从而为新的数据值留出空间。</li>
</ul>

<p>&nbsp;</p>

<p><strong>示例：</strong></p>

<pre>
<strong>输入</strong>
[&quot;LRUCache&quot;, &quot;put&quot;, &quot;put&quot;, &quot;get&quot;, &quot;put&quot;, &quot;get&quot;, &quot;put&quot;, &quot;get&quot;, &quot;get&quot;, &quot;get&quot;]
[[2], [1, 1], [2, 2], [1], [3, 3], [2], [4, 4], [1], [3], [4]]
<strong>输出</strong>
[null, null, null, 1, null, -1, null, -1, 3, 4]

<strong>解释</strong>
LRUCache lRUCache = new LRUCache(2);
lRUCache.put(1, 1); // 缓存是 {1=1}
lRUCache.put(2, 2); // 缓存是 {1=1, 2=2}
lRUCache.get(1);    // 返回 1
lRUCache.put(3, 3); // 该操作会使得关键字 2 作废，缓存是 {1=1, 3=3}
lRUCache.get(2);    // 返回 -1 (未找到)
lRUCache.put(4, 4); // 该操作会使得关键字 1 作废，缓存是 {4=4, 3=3}
lRUCache.get(1);    // 返回 -1 (未找到)
lRUCache.get(3);    // 返回 3
lRUCache.get(4);    // 返回 4
</pre>

<p>&nbsp;</p>

<p><strong>提示：</strong></p>

<ul>
	<li><code>1 &lt;= capacity &lt;= 3000</code></li>
	<li><code>0 &lt;= key &lt;= 10000</code></li>
	<li><code>0 &lt;= value &lt;= 10<sup>5</sup></code></li>
	<li>最多调用 <code>2 * 10<sup>5</sup></code> 次 <code>get</code> 和 <code>put</code></li>
</ul>
</div>

<p>&nbsp;</p>

<p><strong>进阶</strong>：是否可以在&nbsp;<code>O(1)</code> 时间复杂度内完成这两种操作？</p>

<p>&nbsp;</p>

<p><meta charset="UTF-8" />注意：本题与主站 146&nbsp;题相同：<a href="https://leetcode-cn.com/problems/lru-cache/">https://leetcode-cn.com/problems/lru-cache/</a>&nbsp;</p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
### 解题思路
可以把最新访问的节点放在链表头部或尾部，对应头插法和尾插法

### 代码

```java
class LRUCache {
    //头插法
    class Node{
        Node pre, next;
        int key, val;
        public Node(){

        }
        public Node(int key, int val){
            this.key = key;
            this.val = val;
        }
    }

    Node head = new Node();
    Node tail = new Node();
    int size = 0;
    Map<Integer, Node> map;

    public void deleteNode(Node node){
        node.next.pre = node.pre;
        node.pre.next = node.next;
    }

    public void moveToHead(Node node){
        deleteNode(node);
        addToHead(node);
    }

    public void addToHead(Node node){
        Node after = head.next;
        head.next = node;
        node.next = after;
        after.pre = node;
        node.pre = head;
    }

    public LRUCache(int capacity) {
        size = capacity;
        map = new HashMap<>();
        head.next = tail;
        tail.pre = head;
    }
    
    public int get(int key) {
        if(!map.containsKey(key)) return -1;
        Node node = map.get(key);
        moveToHead(node);
        return node.val;
    }
    
    public void put(int key, int value) {
        if(map.containsKey(key)){
            Node node = map.get(key);
            node.val = value;
            map.put(key, node);
            moveToHead(node);
        }else{
            if(map.size() == size){
                Node node = tail.pre;
                deleteNode(node);
                map.remove(node.key);
            }
            Node node = new Node(key, value);
            map.put(key, node);
            addToHead(node);
        }
    }
}

/**
 * Your LRUCache object will be instantiated and called as such:
 * LRUCache obj = new LRUCache(capacity);
 * int param_1 = obj.get(key);
 * obj.put(key,value);
 */
```
```
class LRUCache {
    //尾插法
    class Node{
        Node pre;
        Node next;
        int key;
        int value;
        public Node(int key, int value){
            this.key = key;
            this.value = value;
        }
    }

    public void deleteNode(Node node){
        node.next.pre = node.pre;
        node.pre.next = node.next;
    }

    public void addToTail(Node node){
        node.next = tail;
        tail.pre.next = node;
        node.pre = tail.pre;
        tail.pre = node;
    }

    public void moveToTail(Node node){
        deleteNode(node);
        addToTail(node);
    }

    Map<Integer,Node> map;
    int size;
    Node head;
    Node tail;

    public LRUCache(int capacity) {
        map = new HashMap<>();
        size = capacity;
        head = new Node(0,0);
        tail = new Node(0,0);
        head.next = tail;
        tail.pre = head;
    }
    
    public int get(int key) {
        if(!map.containsKey(key)) return -1;
        Node node = map.get(key);
        moveToTail(node);
        return node.value;
    }
    
    public void put(int key, int value) {
        if(map.containsKey(key)){
            Node node = map.get(key);
            node.value = value;
            moveToTail(node);
        }else{
            if(map.size() == size){
                Node prev = head.next;
                deleteNode(prev);
                map.remove(prev.key);
            }
            Node node = new Node(key, value);
            addToTail(node);
            map.put(key, node);
        }
    }
}

/**
 * Your LRUCache object will be instantiated and called as such:
 * LRUCache obj = new LRUCache(capacity);
 * int param_1 = obj.get(key);
 * obj.put(key,value);
 */
```


## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    4019    |    7351    |   54.7%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
