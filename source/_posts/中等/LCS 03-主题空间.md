---
title: LCS 03-主题空间
date: 2021-12-03 21:33:07
categories:
  - 中等
tags:
  - 深度优先搜索
  - 广度优先搜索
  - 并查集
  - 数组
  - 矩阵
---

> 原文链接: https://leetcode-cn.com/problems/YesdPw


## 英文原文
<div></div>

## 中文题目
<div>「以扣会友」线下活动所在场地由若干主题空间与走廊组成，场地的地图记作由一维字符串型数组 `grid`，字符串中仅包含 `"0"～"5"` 这 6 个字符。地图上每一个字符代表面积为 1 的区域，其中 `"0"` 表示走廊，其他字符表示主题空间。相同且连续（连续指上、下、左、右四个方向连接）的字符组成同一个主题空间。

假如整个 `grid` 区域的外侧均为走廊。请问，不与走廊直接相邻的主题空间的最大面积是多少？如果不存在这样的空间请返回 `0`。

**示例 1:**
>输入：`grid = ["110","231","221"]`
>
>输出：`1`
>
>解释：4 个主题空间中，只有 1 个不与走廊相邻，面积为 1。
>![image.png](https://pic.leetcode-cn.com/1613708145-rscctN-image.png)


**示例 2:**
>输入：`grid = ["11111100000","21243101111","21224101221","11111101111"]`
>
>输出：`3`
>
>解释：8 个主题空间中，有 5 个不与走廊相邻，面积分别为 3、1、1、1、2，最大面积为 3。
>![image.png](https://pic.leetcode-cn.com/1613707985-KJyiXJ-image.png)


**提示：**
- `1 <= grid.length <= 500`
- `1 <= grid[i].length <= 500`
- `grid[i][j]` 仅可能是 `"0"～"5"`

</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 高赞题解
### 解题思路
我采用的是将不合格的全打上标记，然后再从合适的位置开始向四周遍历，然后再更替最大面积
虽然代码看着多，但速度还是蛮快的
### 代码

```cpp
class Solution {
public:
int dp[4][2]={{1,0},{-1,0},{0,1},{0,-1}};
bool flag[505][505];
    int largestArea(vector<string>& grid){ 
       int n=grid.size(),m=grid[0].size(),sum=0,cnt=0;
       auto dfs=[&](auto dfs,int x,int y,char z)->void{ //为非'0'
           flag[x][y]=true;
           for(int i=0;i<4;++i){
               int xx=x+dp[i][0],yy=y+dp[i][1];
               if(xx>=0&&xx<n&&yy>=0&&yy<m&&!flag[xx][yy]&&grid[xx][yy]==z)
                   dfs(dfs,xx,yy,z);
           }
       };
        auto dfs1=[&](auto dfs1,int x,int y)->void{     //为'0'
            if(grid[x][y]!='0'){  //关键！与0相邻的字符，会映射到与该字符相同的其他字符
               dfs(dfs,x,y,grid[x][y]);
                return;
            }
           flag[x][y]=true;
           for(int i=0;i<4;++i){
               int xx=x+dp[i][0],yy=y+dp[i][1];
               if(xx>=0&&xx<n&&yy>=0&&yy<m&&!flag[xx][yy])
                   dfs1(dfs1,xx,yy);
           }
       };
        auto cha=[&](auto cha,int x,int y,char z)->void{
           flag[x][y]=true;
           cnt++;
           for(int i=0;i<4;++i){
               int xx=x+dp[i][0],yy=y+dp[i][1];
               if(xx>=0&&xx<n&&yy>=0&&yy<m&&!flag[xx][yy]&&grid[xx][yy]==z)
                   cha(cha,xx,yy,z);
           }
        };
       for(int i=0;i<n;++i){      
           if(!flag[i][0]&&grid[i][0]!='0')
             dfs(dfs,i,0,grid[i][0]);  
           else
             dfs1(dfs1,i,0);  
           if(!flag[i][m-1]&&grid[i][m-1]!='0')
             dfs(dfs,i,m-1,grid[i][m-1]);
           else
             dfs1(dfs1,i,m-1);  
       }
           
        for(int i=0;i<m;++i){
            if(!flag[0][i]&&grid[0][i]!='0')
             dfs(dfs,0,i,grid[0][i]);  
           else
             dfs1(dfs1,0,i);  
           if(!flag[n-1][i]&&grid[n-1][i]!='0')
             dfs(dfs,n-1,i,grid[n-1][i]);
           else
             dfs1(dfs1,n-1,i); 
        }
            
        for(int i=0;i<n;++i)
            for(int j=0;j<m;++j){
                if(grid[i][j]=='0'&&!flag[i][j]){
                    dfs1(dfs1,i,j);
                }
            }
        
        
        for(int i=1;i<n-1;++i){
         for(int j=1;j<m-1;++j){
                if(!flag[i][j]&&grid[i][j]!='0'){
                    cnt=0;
                    cha(cha,i,j,grid[i][j]);
                    sum=max(sum,cnt);
                }                   
            }   
        }
      return sum;
    }
};
```

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    1921    |    4679    |   41.1%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |
