---
title: MongoDB 批量操作报 Unauthorized 的两种常见原因
author: Fengqi
categories: follow_your_commit
tags:
  - MongoDB
  - mongosh
  - 权限
  - 系统集合
date: 2026-10-21 10:55:00
---

本文整理两个在用 `mongosh` 做批量操作时常见、但原因完全不同的 `Unauthorized` 报错。

---

## 问题一：批量删除集合时，卡在 `system.profile` 上

### 现象

执行「遍历所有集合并逐个 drop」时报错：

```js
db.getCollectionNames().forEach(function(c) { db.getCollection(c).drop(); });
```
```
MongoServerError[Unauthorized]: not authorized on <数据库名> to execute command
{ drop: "system.profile", ... }
```

### 根因

报错卡在 **`system.profile`** 这个集合上。它是 MongoDB 的**系统集合**（内置的性能
分析集合，名字以 `system.` 开头）。普通业务账号对**系统集合没有 drop 权限**，所以
循环遍历到它时被拒绝。

### 为什么旧 mongo「看起来能跑」、mongosh 却报错

1. **列出的集合不同**：旧 `mongo` 的 `getCollectionNames()` 往往不返回 `system.*`
   系统集合；而新 `mongosh` + 新服务端会把它们也列出来，于是循环尝试 drop 它。
2. **错误处理不同**：旧 `mongo` 对脚本里的错误更宽容（可能只打印、不中断）；
   `mongosh` 会把服务端返回的错误作为异常抛出，中断整个循环。

所以「旧 mongo 能跑」其实是假象——系统集合它本来也删不掉（权限决定），只是把失败
悄悄忽略了。`mongosh` 只是更严格、更如实地把错误报了出来。**这不是 mongosh 的 bug。**

### 解决：跳过系统集合

```js
db.getCollectionNames().forEach(function(c) {
  if (!c.startsWith("system.")) {
    db.getCollection(c).drop();
  }
});
```

这样循环会跳过 `system.*`，只删有权限的业务集合，不再报 Unauthorized。该写法在旧
`mongo` 和新 `mongosh` 上都兼容。

---

## 问题二：`use` 错了数据库名，导致整库 Unauthorized

### 现象

```js
use <别名同名的库>
switched to db <别名同名的库>
db.getCollectionNames().forEach(...)
```
```
MongoServerError[Unauthorized]: not authorized on <别名同名的库> to execute command
{ listCollections: 1, ... }
```

连 `listCollections`（`getCollectionNames()` 的底层命令）都被拒绝。

### 根因

**切错数据库了。** 连接别名的名字（比如 `xxx_green`）**不等于**数据库的真实名字
（比如 `prefix_xxx_green`，带前缀）。

连接时的提示其实已经给出了正确库名：
```
Connecting to: mongodb://...<正确库名:带前缀>?...&authSource=<正确库名>
[primary] <正确库名>>        ← 连上后默认就在正确的库
```

账号的授权范围（`authSource`）是**带前缀的真实库名**。当执行 `use <少了前缀的名字>`
时，切到了一个**无权访问**的库，所以任何操作（包括列集合）都被拒绝。

### 解决

连上后**不需要 `use`**——连接字符串已经把你带到正确的库（看提示符确认）。直接执行
命令即可。若确实要切换，必须用**完整的真实库名**（带前缀）。

执行前先确认当前库：
```js
db.getName()     // 应返回带前缀的真实库名
```

---

## 通俗解释（大白话版）

### 问题一：删不掉「系统自带的抽屉」

你想清空一个储物间里**所有抽屉**。但其中有几个是**房东锁死的系统抽屉**
（`system.*`），只有房东能动。你一把钥匙挨个开，开到系统抽屉时被卡住——「你无权动这个」。

- **旧工具**：开到系统抽屉开不动，它**默默跳过**，你没察觉，以为「全清空了」。
- **新工具**：开不动就**当场喊停并报警**，所以你看到了报错。

其实两种工具都删不掉系统抽屉（权限决定），新工具只是更诚实。正确做法是：遍历时
**主动跳过名字以 `system.` 开头的抽屉**，只清自己的业务抽屉。

### 问题二：走错了房间

每个储物间有个**门牌真名**（带前缀，如 `prefix_green`），但你图方便用的**快捷按钮**
叫 `green`。你进门后又手动「切换到名叫 `green` 的房间」——可根本没有这个房间，或者
这个房间**不归你管**。于是保安说「你无权进 `green`」。

其实你一按快捷按钮，系统**已经把你送进了正确的房间**（门牌上写着真名）。你**不用再
手动切换**；非要切，也得报**门牌真名**，而不是快捷按钮的名字。进门先看一眼门牌
（`db.getName()`）确认没走错，就不会被保安拦下。
