"""
random模块有多种用法

1，randint
"""
import random
#randint  有两个参数，表示随机选取的范围从a 到 b ,包括a和b。
number1=random.randint(1,10)
print(number1)


number2=random.randrange(1,10,2)#左闭右开，包含左，不包含右。而且可以在最后设置步长step。
print(number2)#两个随机数之间的步长是2

number3=random.random()#生成一个半开区间的随机浮点数，----> 0.42342
print(number3)