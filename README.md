# MASM-Labs
### 微机原理与系统课程实验

### Microcomputer Principles and Systems
[![](https://img.shields.io/badge/Lab-@lyc0930-brightgreen.svg?style=flat)](https://github.com/lyc0930) ![](https://img.shields.io/badge/USTC-2019Fall-critical.svg?style=flat)

***
## 实验环境

Visual Studio Professional 2017 MASM

参考Kip Irvine教授*Assembly Language for x86 Processors*一书的[运行教程](http://kipirvine.com/asm/gettingStartedVS2017/)与代码实例，受益匪浅。
***
[Microsoft Macro Assembler.zip](https://github.com/lyc0930/MASM-Labs/tree/master/Template)是个人导出的Visual Studio MASM项目模板文件。

## 实验内容
### [输入输出](https://github.com/lyc0930/MASM-Labs/tree/master/IO)
2019.11.20
#### 实验目的
- 掌握汇编程序的基本编写方式
- 学习汇编语言的基础I/O操作，为后续实验做准备
#### 实验内容
1. 创建一个名为`Input1.txt`的文件
2. 使用键盘输入一个包含大写字母、小写字母和数字的字符串，并将这个字符串写入文件中
3. 读取这个文件，将小写字母转换成大写形式，大写字母和数字保持不变，最后整个字符串输出到屏幕，并写入`Output1.txt`文件

### [分支程序设计](https://github.com/lyc0930/MASM-Labs/tree/master/Branch)
11.20
#### 实验目的
- 掌握汇编语言中比较和跳转命令
- 掌握汇编语言中循环命令的使用
#### 实验内容
1. 键盘输入一个数字$N$($0 < N < 10$)
2. 把$1 \sim N^2 $的自然数按行顺序存入二维数组
3. 在屏幕上打印出该数组的左下半三角
- 例：$N = 6$时，应打印成类似下图形式：
```
1
7 8
13 14 15
19 20 21 22
25 26 27 28 29
31 32 33 34 35 36
```

### [排序程序设计](https://github.com/lyc0930/MASM-Labs/tree/master/Sort)
11.27
#### 实验目的
- 综合运用汇编中的I/O、比较、跳转、循环等指令
- 掌握用汇编语言实现数字排序程序的方法
#### 实验内容
1. 从名为`Input3.txt`的文本文件中读取一组数字
2. 将这些数字从小到大进行排序
3. 将这些数字按照排序后的次序打印在屏幕上
4. 数字范围[-1024,1023]，排序数字不超过100个
5. 排序算法不限

### [子程序设计](https://github.com/lyc0930/MASM-Labs/tree/master/Subroutine)
12.4
#### 实验目的
- 掌握汇编语言中子程序的编写与调用方法
- 理解汇编语言中的递归调用
#### 实验内容
1. 编写一个程序，使用子程序调用的方式计算$n!$
2. $n$的值通过键盘输入
3. $n$的范围(0,20)
4. 程序设计中请注意运算结果的范围



