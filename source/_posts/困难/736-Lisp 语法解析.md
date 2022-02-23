---
title: 736-Lisp 语法解析(Parse Lisp Expression)
date: 2021-12-03 22:38:18
categories:
  - 困难
tags:
  - 栈
  - 递归
  - 哈希表
  - 字符串
---

> 原文链接: https://leetcode-cn.com/problems/parse-lisp-expression


## 英文原文
<div><p>You are given a string expression representing a Lisp-like expression to return the integer value of.</p>

<p>The syntax for these expressions is given as follows.</p>

<ul>
	<li>An expression is either an integer, let expression, add expression, mult expression, or an assigned variable. Expressions always evaluate to a single integer.</li>
	<li>(An integer could be positive or negative.)</li>
	<li>A let expression takes the form <code>&quot;(let v<sub>1</sub> e<sub>1</sub> v<sub>2</sub> e<sub>2</sub> ... v<sub>n</sub> e<sub>n</sub> expr)&quot;</code>, where let is always the string <code>&quot;let&quot;</code>, then there are one or more pairs of alternating variables and expressions, meaning that the first variable <code>v<sub>1</sub></code> is assigned the value of the expression <code>e<sub>1</sub></code>, the second variable <code>v<sub>2</sub></code> is assigned the value of the expression <code>e<sub>2</sub></code>, and so on sequentially; and then the value of this let expression is the value of the expression <code>expr</code>.</li>
	<li>An add expression takes the form <code>&quot;(add e<sub>1</sub> e<sub>2</sub>)&quot;</code> where add is always the string <code>&quot;add&quot;</code>, there are always two expressions <code>e<sub>1</sub></code>, <code>e<sub>2</sub></code> and the result is the addition of the evaluation of <code>e<sub>1</sub></code> and the evaluation of <code>e<sub>2</sub></code>.</li>
	<li>A mult expression takes the form <code>&quot;(mult e<sub>1</sub> e<sub>2</sub>)&quot;</code> where mult is always the string <code>&quot;mult&quot;</code>, there are always two expressions <code>e<sub>1</sub></code>, <code>e<sub>2</sub></code> and the result is the multiplication of the evaluation of e1 and the evaluation of e2.</li>
	<li>For this question, we will use a smaller subset of variable names. A variable starts with a lowercase letter, then zero or more lowercase letters or digits. Additionally, for your convenience, the names <code>&quot;add&quot;</code>, <code>&quot;let&quot;</code>, and <code>&quot;mult&quot;</code> are protected and will never be used as variable names.</li>
	<li>Finally, there is the concept of scope. When an expression of a variable name is evaluated, within the context of that evaluation, the innermost scope (in terms of parentheses) is checked first for the value of that variable, and then outer scopes are checked sequentially. It is guaranteed that every expression is legal. Please see the examples for more details on the scope.</li>
</ul>

<p>&nbsp;</p>
<p><strong>Example 1:</strong></p>

<pre>
<strong>Input:</strong> expression = &quot;(let x 2 (mult x (let x 3 y 4 (add x y))))&quot;
<strong>Output:</strong> 14
<strong>Explanation:</strong> In the expression (add x y), when checking for the value of the variable x,
we check from the innermost scope to the outermost in the context of the variable we are trying to evaluate.
Since x = 3 is found first, the value of x is 3.
</pre>

<p><strong>Example 2:</strong></p>

<pre>
<strong>Input:</strong> expression = &quot;(let x 3 x 2 x)&quot;
<strong>Output:</strong> 2
<strong>Explanation:</strong> Assignment in let statements is processed sequentially.
</pre>

<p><strong>Example 3:</strong></p>

<pre>
<strong>Input:</strong> expression = &quot;(let x 1 y 2 x (add x y) (add x y))&quot;
<strong>Output:</strong> 5
<strong>Explanation:</strong> The first (add x y) evaluates as 3, and is assigned to x.
The second (add x y) evaluates as 3+2 = 5.
</pre>

<p><strong>Example 4:</strong></p>

<pre>
<strong>Input:</strong> expression = &quot;(let x 2 (add (let x 3 (let x 4 x)) x))&quot;
<strong>Output:</strong> 6
<strong>Explanation:</strong> Even though (let x 4 x) has a deeper scope, it is outside the context
of the final x in the add-expression.  That final x will equal 2.
</pre>

<p><strong>Example 5:</strong></p>

<pre>
<strong>Input:</strong> expression = &quot;(let a1 3 b2 (add a1 1) b2)&quot;
<strong>Output:</strong> 4
<strong>Explanation:</strong> Variable names can contain digits after the first character.
</pre>

<p>&nbsp;</p>
<p><strong>Constraints:</strong></p>

<ul>
	<li><code>1 &lt;= expression.length &lt;= 2000</code></li>
	<li>There are no leading or trailing spaces in <code>exprssion</code>.</li>
	<li>All tokens are separated by a single space in <code>expressoin</code>.</li>
	<li>The answer and all intermediate calculations of that answer are guaranteed to fit in a <strong>32-bit</strong> integer.</li>
	<li>The expression is guaranteed to be legal and evaluate to an integer.</li>
</ul>
</div>

## 中文题目
<div><p>给定一个类似 Lisp 语句的表达式 <code>expression</code>，求出其计算结果。</p>

<p>表达式语法如下所示:</p>

<ul>
	<li>表达式可以为整数，let 语法，add 语法，mult 语法，或赋值的变量。表达式的结果总是一个整数。</li>
	<li>(整数可以是正整数、负整数、0)</li>
	<li><strong>let</strong> 语法表示为&nbsp;<code>(let v1 e1 v2 e2 ... vn en expr)</code>,&nbsp;其中&nbsp;<code>let</code>语法总是以字符串&nbsp;<code>&quot;let&quot;</code>来表示，接下来会跟随一个或多个交替变量或表达式，也就是说，第一个变量&nbsp;<code>v1</code>被分配为表达式&nbsp;<code>e1</code>&nbsp;的值，第二个变量&nbsp;<code>v2</code>&nbsp;被分配为表达式&nbsp;<code>e2</code>&nbsp;的值，<strong>以此类推</strong>；最终 let 语法的值为&nbsp;<code>expr</code>表达式的值。</li>
	<li><strong>add </strong>语法表示为&nbsp;<code>(add e1 e2)</code>，其中&nbsp;<code>add</code>&nbsp;语法总是以字符串&nbsp;<code>&quot;add&quot;</code>来表示，该语法总是有两个表达式<code>e1</code>、<code>e2</code>, 该语法的最终结果是&nbsp;<code>e1</code> 表达式的值与&nbsp;<code>e2</code>&nbsp;表达式的值之<strong>和</strong>。</li>
	<li><strong>mult</strong> 语法表示为&nbsp;<code>(mult e1 e2)</code>&nbsp;，其中&nbsp;<code>mult</code>&nbsp;语法总是以字符串<code>&quot;mult&quot;</code>表示， 该语法总是有两个表达式 <code>e1</code>、<code>e2</code>，该语法的最终结果是&nbsp;<code>e1</code> 表达式的值与&nbsp;<code>e2</code>&nbsp;表达式的值之<strong>积</strong>。</li>
	<li>在该题目中，变量的命名以小写字符开始，之后跟随0个或多个小写字符或数字。为了方便，&quot;add&quot;，&quot;let&quot;，&quot;mult&quot;会被定义为&quot;关键字&quot;，不会在表达式的变量命名中出现。</li>
	<li>最后，要说一下作用域的概念。计算变量名所对应的表达式时，在计算上下文中，首先检查最内层作用域（按括号计），然后按顺序依次检查外部作用域。我们将保证每一个测试的表达式都是合法的。有关作用域的更多详细信息，请参阅示例。</li>
</ul>

<p>&nbsp;</p>

<p><strong>示例：</strong></p>

<pre><strong>输入:</strong> (add 1 2)
<strong>输出:</strong> 3

<strong>输入:</strong> (mult 3 (add 2 3))
<strong>输出:</strong> 15

<strong>输入:</strong> (let x 2 (mult x 5))
<strong>输出:</strong> 10

<strong>输入:</strong> (let x 2 (mult x (let x 3 y 4 (add x y))))
<strong>输出:</strong> 14
<strong>解释:</strong> 
表达式 (add x y), 在获取 x 值时, 我们应当由最内层依次向外计算, 首先遇到了 x=3, 所以此处的 x 值是 3.


<strong>输入:</strong> (let x 3 x 2 x)
<strong>输出:</strong> 2
<strong>解释:</strong> let 语句中的赋值运算按顺序处理即可

<strong>输入:</strong> (let x 1 y 2 x (add x y) (add x y))
<strong>输出:</strong> 5
<strong>解释:</strong> 
第一个 (add x y) 计算结果是 3，并且将此值赋给了 x 。
第二个 (add x y) 计算结果就是 3+2 = 5 。

<strong>输入:</strong> (let x 2 (add (let x 3 (let x 4 x)) x))
<strong>输出:</strong> 6
<strong>解释:</strong> 
(let x 4 x) 中的 x 的作用域仅在()之内。所以最终做加法操作时，x 的值是 2 。

<strong>输入:</strong> (let a1 3 b2 (add a1 1) b2) 
<strong>输出: </strong>4
<strong>解释:</strong> 
变量命名时可以在第一个小写字母后跟随数字.
</pre>

<p>&nbsp;</p>

<p><strong>注意:</strong></p>

<ul>
	<li>我们给定的&nbsp;<code>expression</code>&nbsp;表达式都是格式化后的：表达式前后没有多余的空格，表达式的不同部分(关键字、变量、表达式)之间仅使用一个空格分割，并且在相邻括号之间也没有空格。我们给定的表达式均为合法的且最终结果为整数。</li>
	<li>我们给定的表达式长度最多为 2000&nbsp;(表达式也不会为空，因为那不是一个合法的表达式)。</li>
	<li>最终的结果和中间的计算结果都将是一个 32 位整数。</li>
</ul>

<p>&nbsp;</p>
</div>

## 通过代码
<RecoDemo>
</RecoDemo>


## 官方题解
####  方法：递归分析法 [Accepted]
**算法：**
这个问题从表达式的语法看相对简单，但是在解决的过程中会出现较大的困难。

表达式中会包含子表达式，这种情况适合用递归来解决。

一个难点是如何管理变量的正确范围。我们可以用栈来存放变量和值的对应关系，当进入变量作用的括号范围时，就将变量和值的哈希映射添加到栈中，当出括号内时，就弹出栈顶元素。

`evaluate` 方法会检查每个表达式 `expression` 采用的形式
- 如果 `expression` 是数字开头，则它是一个整数：返回它。 
- 如果 `expression` 以字母开头，则它是一个变量。则检查该变量的作用域。 
- 否则我们将 `expression` 中的标记（变量或表达式）分组，通过计算 `bal = '(' 的数量减去 ')' 的数量`，当 `bal` 为零时，则我们得到一个标记。举个例子：`(add 1 (add 2 3))` 可以获得两个标记 `'1'` 和 `'(add 2 3)'`。
- 计算每个标记并返回它们的加法或乘法得结果。 
- 对于 `let` 表达式，按顺序计算每个表达式并将其值分配给当前作用域中的变量，然后返回对最终表达式的求值。 
 
```Python [ ]
def implicit_scope(func):
    def wrapper(*args):
        args[0].scope.append({})
        ans = func(*args)
        args[0].scope.pop()
        return ans
    return wrapper

class Solution(object):
    def __init__(self):
        self.scope = [{}]

    @implicit_scope
    def evaluate(self, expression):
        if not expression.startswith('('):
            if expression[0].isdigit() or expression[0] == '-':
                return int(expression)
            for local in reversed(self.scope):
                if expression in local: return local[expression]

        tokens = list(self.parse(expression[5 + (expression[1] == 'm'): -1]))
        if expression.startswith('(add'):
            return self.evaluate(tokens[0]) + self.evaluate(tokens[1])
        elif expression.startswith('(mult'):
            return self.evaluate(tokens[0]) * self.evaluate(tokens[1])
        else:
            for j in xrange(1, len(tokens), 2):
                self.scope[-1][tokens[j-1]] = self.evaluate(tokens[j])
            return self.evaluate(tokens[-1])

    def parse(self, expression):
        bal = 0
        buf = []
        for token in expression.split():
            bal += token.count('(') - token.count(')')
            buf.append(token)
            if bal == 0:
                yield " ".join(buf)
                buf = []
        if buf:
            yield " ".join(buf)
```

```Java [ ]
class Solution {
    ArrayList<Map<String, Integer>> scope;
    public Solution() {
        scope = new ArrayList();
        scope.add(new HashMap());
    }

    public int evaluate(String expression) {
        scope.add(new HashMap());
        int ans = evaluate_inner(expression);
        scope.remove(scope.size() - 1);
        return ans;
    }

    public int evaluate_inner(String expression) {
        if (expression.charAt(0) != '(') {
            if (Character.isDigit(expression.charAt(0)) || expression.charAt(0) == '-')
                return Integer.parseInt(expression);
            for (int i = scope.size() - 1; i >= 0; --i) {
                if (scope.get(i).containsKey(expression))
                    return scope.get(i).get(expression);
            }
        }

        List<String> tokens = parse(expression.substring(
                expression.charAt(1) == 'm' ? 6 : 5, expression.length() - 1));
        if (expression.startsWith("add", 1)) {
            return evaluate(tokens.get(0)) + evaluate(tokens.get(1));
        } else if (expression.startsWith("mult", 1)) {
            return evaluate(tokens.get(0)) * evaluate(tokens.get(1));
        } else {
            for (int j = 1; j < tokens.size(); j += 2) {
                scope.get(scope.size() - 1).put(tokens.get(j-1), evaluate(tokens.get(j)));
            }
            return evaluate(tokens.get(tokens.size() - 1));
        }
    }

    public List<String> parse(String expression) {
        List<String> ans = new ArrayList();
        int bal = 0;
        StringBuilder buf = new StringBuilder();
        for (String token: expression.split(" ")) {
            for (char c: token.toCharArray()) {
                if (c == '(') bal++;
                if (c == ')') bal--;
            }
            if (buf.length() > 0) buf.append(" ");
            buf.append(token);
            if (bal == 0) {
                ans.add(new String(buf));
                buf = new StringBuilder();
            }
        }
        if (buf.length() > 0)
            ans.add(new String(buf));

        return ans;
    }
}
```

**复杂度分析**

* 时间复杂度：$O(N^2)$。其中 $N$ 指的是 `expression` 的长度。每个表达式只计算一次，但在计算过程中可能要搜索整个范围。 
* 空间复杂度：$O(N^2)$，在进行中间求值时，我们可以将 $O(N)$ 个新字符串传递给 `evaluate` 函数，每个字符串的长度为 $O(N)$。通过优化，可以将总空间复杂度降低到 $O(N)$。

## 统计信息
| 通过次数 | 提交次数 | AC比率 |
| :------: | :------: | :------: |
|    1615    |    3442    |   46.9%   |

## 提交历史
| 提交时间 | 提交结果 | 执行时间 |  内存消耗  | 语言 |
| :------: | :------: | :------: | :--------: | :--------: |


## 相似题目
|                             题目                             | 难度 |
| :----------------------------------------------------------: | :---------: |
| [三元表达式解析器](https://leetcode-cn.com/problems/ternary-expression-parser/) | 中等|
| [原子的数量](https://leetcode-cn.com/problems/number-of-atoms/) | 困难|
| [基本计算器 IV](https://leetcode-cn.com/problems/basic-calculator-iv/) | 困难|
