.PHONY:all clean


MKDIR=mkdir
RM=rm
AR=ar

RMFLAGS=-rf
ARFLAGS=crs
SO_CFLAGS=-shared -fPIC

CC=gcc
CFLAGS?=

#用于存放对象文件的目录
DIR_OBJS=objs

#用于存放可执行文件的目录
DIR_BINS=${ROOT}/build/bin

#用于存放由gcc -MM生成的依赖关系文件的目录
DIR_DEPS=deps

#用于存放动态或静态函数库的目录
DIR_LIBS=${ROOT}/build/lib

#makefile在执行include的时候,如果include的文件需要由规则生成或更新，那么make会重新执行一次makefile(从include开始重新执行，包括重新初始化变量）。
#又由于deps目录的修改时间始终较.dep文件新，再一次执行makefile时也会再次对include文件更新，这样就会进入死循环。
#因此在这里需要对deps目录作判断，如果deps目录存在，则不再作为.dep文件的依赖
ifeq ("$(wildcard ${DIR_DEPS})","")
DIR_DEPS_TMP:=${DIR_DEPS}
endif

#如果一个目标依赖于目录的时候，都要添加目录是否存在的判断。
#因为在第二次make的时候，依赖目录始终较目标为新，造成不必要的重新编译
ifeq ("$(wildcard ${DIR_BINS})","")
DIR_BINS_TMP:=${DIR_BINS}
endif

#如果一个目标依赖于目录的时候，都要添加目录是否存在的判断。
#因为在第二次make的时候，依赖目录始终较目标为新，造成不必要的重新编译
ifeq ("$(wildcard ${DIR_OBJS})","")
DIR_OBJS_TMP:=${DIR_OBJS}
endif

DIRS=${DIR_OBJS} ${DIR_DEPS}

#make clean时需要清理的文件
FILES2CLEAN=${DIR_OBJS} ${DIR_DEPS}

#可执行文件目标
ifneq ("${BIN}","")
BIN:=$(addprefix ${DIR_BINS}/,${BIN})
FILES2CLEAN+=${BIN}
endif

#生成静态库文件目标
ifneq ("${LIBA}","")
LIBA:=$(addprefix ${DIR_LIBS}/,${LIBA})
FILES2CLEAN+=${LIBA}
endif

#生成动态库文件目标
ifneq ("${LIBSO}","")
LIBSO:=$(addprefix ${DIR_LIBS}/,${LIBSO})
FILES2CLEAN+=${LIBSO}
endif

#源文件列表
SRCS:=$(wildcard *.c)

#需要生成的对象文件列表
OBJS:=${SRCS:.c=.o}

OBJS:=${addprefix ${DIR_OBJS}/,${OBJS}}

#需要生成的依赖文件列表
DEPS:=${SRCS:.c=.dep}

DEPS:=${addprefix ${DIR_DEPS}/,${DEPS}}

#生成静态函数库的默认依赖为所有objs
LIBA_DEPS?=${OBJS}

#生成动态函数库的默认依赖为所有objs
LIBSO_DEPS?=${OBJS}

#生成可执行文件的默认依赖为所有objs
BIN_DEPS?=${OBJS}

#函数库的搜索路径，默认为{ROOT}/build/lib
LINK_LIB_PATH?=${DIR_LIBS}
ifneq (${LINK_LIB_PATH},"")
LINK_LIB_PATH:=$(addprefix -L,${LINK_LIB_PATH})
endif

#用于链接的函数库，默认当前模块生成的函数库
LINK_LIB?=${LIBA} ${LIBSO}
LINK_LIB:=$(notdir ${LINK_LIB})
LINK_LIB:=${LINK_LIB:.a=}
LINK_LIB:=${LINK_LIB:.so=}
LINK_LIB:=$(strip $(patsubst lib%,%,${LINK_LIB}))
#LINK_LIB:=$(strip $(patsubst lib,,$($($(notdir ${LINK_LIB}):.a=):.so=)))
ifneq (${LINK_LIB},"")
LINK_LIB:=$(addprefix -l,${LINK_LIB})
endif

#头文件搜索路径，默认为当前目录下的include目录
INC_PATH:=${INC_PATH} ./include ${ROOT}/include
ifneq (${INC_PATH},"")
INC_PATH:=$(addprefix -I,${INC_PATH})
endif

#all目标
all:${LIBA} ${LIBSO} ${BIN}

#引入依赖文件，如果不存在相应的依赖文件，由对应的目标生成。
ifneq (${MAKECMDGOALS},clean)
-include ${DEPS}
endif


#一些目录的生成
${DIRS}:
	${MKDIR} -p $@

#可执行文件的生成规则
${BIN}:${DIR_BINS_TMP} ${BIN_DEPS}
	${CC} -o $@ ${LINK_LIB_PATH} ${filter %.o,$^} ${LINK_LIB}

#动态函数库生成规则
${LIBSO}:${LIBSO_DEPS}
	${CC} ${SO_CFLAGS} -o $@ $^

#静态函数库生成规则
${LIBA}:${LIBA_DEPS}
	${AR} ${ARFLAGS} $@ $^	

#对象文件的生成规则
${DIR_OBJS}/%.o:${DIR_OBJS_TMP} %.c
	${CC} -o $@ ${INC_PATH} -c ${CFLAGS} ${filter %.c,$^}

#依赖文件的生成规则
${DIR_DEPS}/%.dep:${DIR_DEPS_TMP} %.c
	@echo "Making $@ ..."
	@set -e; \
	${RM} ${RMFLAGS} $@.$$$$; \
	${CC} -MM ${INC_PATH} ${filter %.c,$^} > $@.$$$$; \
	sed 's,\(.*\)\.o[:]*,${DIR_OBJS}/\1.o $@:,g' < $@.$$$$ > $@;\
	${RM} ${RMFLAGS} $@.$$$$

#清理目标规则
clean:
	${RM} ${RMFLAGS} ${FILES2CLEAN}

