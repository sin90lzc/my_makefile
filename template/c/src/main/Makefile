#项目根目录，暂时没找到好办法对ROOT进行设定，目前需要每个子模块的Makefile都要对ROOT进行设定
ROOT?=../..

#需要生成的可执行文件名称
BIN=main.out

#需要生成的静态函数库名称
LIBA=

#需要生成的动态函数库名称
LIBSO=

#生成静态函数库的默认依赖为所有objs
#LIBA_DEPS=

#生成动态函数库的默认依赖为所有objs
#LIBSO_DEPS=

#生成可执行文件的默认依赖为所有objs
#BIN_DEPS=

#函数库的搜索路径，默认为{ROOT}/build/lib
#LINK_LIB_PATH=

#用于链接的函数库，默认当前模块生成的函数库
LINK_LIB=libfoo.a libbar.a

#头文件搜索路径，默认为当前目录下的include目录，及根目录下的include目录。在这里设置的INC_PATH是在默认目录的基础上添加的新的搜索目录。
INC_PATH=../module1/include ../module2/include

include ${ROOT}/build/public.mk
