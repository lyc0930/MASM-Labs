# MASM-Labs
### 微机原理与系统课程实验

### Microcomputer Principles and Systems
[![](https://img.shields.io/badge/Lab-@lyc0930-brightgreen.svg?style=flat)](https://github.com/lyc0930) ![](https://img.shields.io/badge/USTC-2019Fall-inactive.svg?style=flat)

***
## 实验环境

Visual Studio Professional 2017 MASM

参考Kip Irvine教授*Assembly Language for x86 Processors*一书的[运行教程](http://kipirvine.com/asm/gettingStartedVS2017/)与代码实例，受益匪浅。
***
[Microsoft Macro Assembler.zip]()是个人导出的Visual Studio MASM项目模板文件。

## 实验内容
### [输入输出]()
2019.11.20
#### 实验目的
- 掌握汇编程序的基本编写方式
- 学习汇编语言的基础I/O操作，为后续实验做准备
#### 实验内容
1. 创建一个名为`Input1.txt`的文件
2. 使用键盘输入一个包含大写字母、小写字母和数字的字符串，并将这个字符串写入文件中
3. 读取这个文件，将小写字母转换成大写形式，大写字母和数字保持不变，最后整个字符串输出到屏幕，并写入`Output1.txt`文件

### [分支程序设计]()
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

