---
title: MongoDB 客户端与服务端版本不匹配——从 mongo 升级到 mongosh
author: Fengqi
categories: follow_your_commit
tags:
  - MongoDB
  - mongosh
  - 环境配置
abbrlink: 839517673
date: 2026-10-21 10:50:00
---

## 一、现象

本地用脚本别名连接数据库时，提示客户端与服务端版本不匹配：

```
MongoDB shell version v4.4.10        ← 客户端(旧)
MongoDB server version: 8.0.28       ← 服务端(新)
WARNING: shell and server versions do not match
```

服务端已升级到 8.0.28，而本地连库用的还是 4.4.10 的旧 `mongo` shell。

## 二、根因

**MongoDB 从 6.0 版本起，移除了旧的 `mongo` 命令行客户端**，改用新的
`mongosh`（MongoDB Shell）。在当前环境中验证：

- 加载 `mongodb/8.0.x` 模块后，它的 `bin/` 里**只有服务端组件**（`mongod`、`mongos`），
  **没有 `mongo` 客户端**，也没有 `mongosh`。
- 系统里旧的 `mongo` 客户端只有 5.x 及更早版本（如 4.4.10）还带。
- 所以当执行 `which mongo` 时，会「回退」命中某处仍提供 `mongo` 的旧版本（4.4.10），
  造成「我明明加载了 8.0，客户端却是 4.4.10」的错觉。

关键结论：**加载服务端的 8.0 模块，永远不会给你 `mongo` 客户端**，因为 8.0 根本不含它。

## 三、解决方案

新客户端 `mongosh` 在当前环境是一个**独立的模块**，与服务端模块分开：

- 服务端模块：`mongodb/8.0.x`（提供 `mongod`/`mongos`）
- 客户端模块：`mongosh/2.x`（提供 `mongosh`，最新约 2.3.x）

`mongosh 2.x` 官方支持连接 MongoDB 8.0，是推荐的匹配组合。

### 改动两处

**1. 加载 mongosh 模块**（在加载 mongodb 模块之后）：
```csh
module load mongodb/8.0.x
module load mongosh/2.3.x
```

**2. 把连接别名里的命令 `mongo` 改成 `mongosh`**：
连接字符串、`--host`、`--username`、`--password`、`--authenticationDatabase`
这些参数 `mongosh` 都兼容，**只需把命令名从 `mongo` 换成 `mongosh`**。

### 验证

升级后连接，提示变为版本匹配，警告消失：
```
Using MongoDB:    8.0.28
Using Mongosh:    2.3.x
```

## 四、注意事项

- `mongosh` 与旧 `mongo` 在**命令行参数**上兼容，但**交互脚本语法**是现代 JS
  （Node.js REPL）。日常查询（`show dbs`、`db.coll.find()` 等）都正常；个别旧式
  全局函数写法在 `mongosh` 里可能行为不同，老脚本需少量调整。
- `mongoexport` / `mongoimport` 属于另一套独立工具（database-tools），**不受影响**。
- 升级后可能出现提示：
  `Found ~/.mongorc.js, but not ~/.mongoshrc.js`。这是因为 `mongosh` 读取的启动
  脚本文件名不同（`~/.mongoshrc.js`，而非旧的 `~/.mongorc.js`）。若旧文件为空，
  直接删除即可消除提示；若有自定义内容，复制/改名为 `~/.mongoshrc.js`。

## 五、通俗解释（大白话版）

你家的「门锁」（数据库服务端）换成了最新款（8.0），但你手里还拿着**老款遥控器**
（`mongo` 4.4）去开它。虽然老遥控器勉强还能开，但系统一直警告「遥控器和锁型号对不上」，
万一哪天不兼容就麻烦了。

你以为「我装了新锁配套的东西呀」——问题是，**新锁的套装里压根没附带遥控器**
（8.0 不再提供 `mongo` 客户端），你手上那个老遥控器是从别处翻出来的旧货。

解决办法：去领一个**新款遥控器**（`mongosh`，它是单独发放的），然后把家里所有
「开门快捷按钮」（连接别名）都改成用新遥控器。这样型号就对上了，也不再报警告。

（另外：新遥控器的「个人设置文件」换了名字，老的设置文件它不认——如果老文件是空的，
删掉就清净了。）
