<h1 id="qEXd-1764871085095">**1.基础语法**</h1>
```python
1.中文编码
文字开头加入
# -*- coding: UTF-8 -*-解决

2.基础语句
>>>print ("hello")
#不需要分号换行
if

    else：
    if
    else：
    else：
#缩进表示逻辑不可省去

3.变量类型
>>>list：
number
string
list
tuple
dictionary

number支持：int float long complex,复数

string： "abcdef"
索引：s1[1：5]="bcdef"
s1="123456"
s2="7890"
s3=s1+s2="1234567890"

list: list1=[a,b,c,d,e]
索引同上
列表允许更新，允许对元素重新赋值

tuple： tuple1=(a,b,c,d,e)
元组不允许更新，不能重新赋值，但能连接
as: tuple3=tuple1+tuple2

dictionary：由索引key和值value组成

#创建空典
dict={}
#添加元素
dict['one']="this is one"
dict[2]="this is 2"
#输出完整字典
print dict

4.运算符：
算术运算符pass
比较运算符pass
赋值运算符pass  a **=c 幂指数运算
逻辑运算符pass
位运算符  pass
成员运算符(in/not in)：return Ture / Flase

5.循环语句
while a<10:
    print(a)
else： #循环结束可用else

for ar in sequence：
    statements(ar)
#迭代执行
fruit = ['a','b','c']
for index in range(len(fruits)):
    print(fruit[indix])
else: #循环结束可用else

    break/continue/pass语句

6.python.function

def functionname(parameters)
    "documents"
    statement()
    return
可变与不可变对象，即传入为型参还是实参
tuple/number/string为不可变对象，传入为形参
list/dictionary

a.定义必备参数与不定长参数：
def functionname(str)
    print str
    return [expresssion]
调用：
必备参数：functionnname(a)
关键词参数：fcname(str="my string")
默认参数：跟缺省定义一样
不定长参数：
def function(arg1,*vartuple)
    statements(arg)
    .....
    return 

其中所有不定长的参数将被存储在artuple中使用

7.module

from module import a,b,c,d...
在module中引入abdc...
引入所有用*替代
```

<h1 id="XRRGJ">2.面向对象编程</h1>
+ 类(Class): 用来描述具有相同的属性和方法的对象的集合。它定义了该集合中每个对象所共有的属性和方法。对象是类的实例
+ #class
+ 类变量：类变量在整个实例化的对象中是公用的。类变量定义在类中且在函数体之外。类变量通常不作为实例变量使用。
+ #类里面的私有/公有变量
+ 数据成员：类变量或者实例变量, 用于处理类及其实例对象的相关的数据。
+ #express exactly
+ 方法重写：如果从父类继承的方法不能满足子类的需求，可以对其进行改写，这个过程叫方法的覆盖（override），也称为方法的重写。
+ #方法复用/覆盖
+ 局部变量：定义在方法中的变量，只作用于当前实例的类。
+ #class里函数定义所用的变量
+ 实例变量：在类的声明中，属性是用变量来表示的。这种变量就称为实例变量，是在类声明的内部但是在类的其他成员方法之外声明的。
+ #创建的类实例变量
+ 继承：即一个派生类（derived class）继承基类（base   
class）的字段和方法。继承也允许把一个派生类的对象作为一个基类对象对待。例如，有这样一个设计：一个Dog类型的对象派生自Animal类，这是模拟"是一个（is-a）"关系（例图，Dog是一个Animal）。
+ 实例化：创建一个类的实例，类的具体对象。
+ 创建类实例
+ 方法：类中定义的函数。
+ express exactly
+ 对象：通过类定义的数据结构实例。对象包括两个数据成员（类变量和实例变量）和方法。
+ express exactly

```python
.创建类：

class Classname：
    <变量声明>    
    
                
    #__表示私有，不可从外部访问，功能近似于c++的构造函数
    #self表示的是类的实例，而非类的定义                                                                                                                                                                                                                    
    def __init__(self,name,salary)
        self.na.....
        <self中元素的初始化>
        
    def function1(self)：
        statements...
    def function2(self):
        statements...


创建类的实例：
class1 = Classname(name1,salary1)
#创建第一个类的实例，参数为构造函数中的定义参数


2.访问属性
emp1.displayEmployee()
emp2.displayEmployee()
可以添加，删除，修改类的属性，如下所示：
emp1.age = 7  # 添加一个 'age' 属性
emp1.age = 8  # 修改 'age' 属性
del emp1.age  # 删除 'age' 属性

Python内置类属性
__dict__ : 类的属性（包含一个字典，由类的数据属性组成） 
__doc__ :类的文档字符串 
__name__: 类名 
__module__:   类定义所在的模块（类的全名是'__main__.className'，如果类位于一个导入模块mymod中，那么className.__module__ 等于 mymod） 
__bases__ : 类的所有父类构成元素（包含了一个由所有父类组成的元组） 

3.类的继承
class Parent:        # 定义父类
   parentAttr = 100
   def __init__(self):
      print "调用父类构造函数"
 
   def parentMethod(self):
      print '调用父类方法'
 
   def setAttr(self, attr):
      Parent.parentAttr = attr
 
   def getAttr(self):
      print "父类属性 :", Parent.parentAttr
 
class Child(Parent): # 定义子类
   def __init__(self):
      print "调用子类构造方法"
 
   def childMethod(self):
      print '调用子类方法'

####
关于构造函数，如果子类不重写__init__,就直接使用父类构造
如果重写了__init__ 时，要继承父类的构造方法，可以使用 super 关键字：(重写一部分)
class Son(Father):
    def __init__(self, name):
        super(Son, self).__init__(name)
        print ("hi")
        self.name =  name
继承父类但重写
###
方法重写(函数覆盖，子类覆盖父类)
#!/usr/bin/python
# -*- coding: UTF-8 -*-
 
class Parent:        # 定义父类
   def myMethod(self):
      print '调用父类方法'
 
class Child(Parent): # 定义子类
   def myMethod(self):
      print '调用子类方法'
 
c = Child()          # 子类实例
c.myMethod()         # 子类调用重写方法

4.类属性与方法
私有变量与公共变量
class JustCounter:
    __secretCount = 0  # 私有变量
    publicCount = 0    # 公开变量
 
    def count(self):
        self.__secretCount += 1
        self.publicCount += 1
        print self.__secretCount
 
counter = JustCounter()
counter.count()
counter.count()
print counter.publicCount
print counter.__secretCount  # 报错，实例不能访问私有变量
```



