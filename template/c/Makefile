#源代码目录
override DIR_SRC=src

#主模块名称，名称与src目录下的目录名一致
override MAIN=main

#模块1名称，名称与src目录下的目录名一致
override MODULE1=module1

#模块2名称，名称与src目录下的目录名一致
override MODULE2=module2

override ALL_MODULES:=${MODULE1} ${MODULE2} ${MAIN}

.PHONY:all clean ${ALL_MODULES}

all:${ALL_MODULES}

${MODULE1}:
	@cd ${DIR_SRC}/${MODULE1};${MAKE} ${MAKECMDGOALS}
	
${MODULE2}:
	@cd ${DIR_SRC}/${MODULE2};${MAKE} ${MAKECMDGOALS}

${MAIN}:
	@cd ${DIR_SRC}/${MAIN};${MAKE} ${MAKECMDGOALS}

clean:${ALL_MODULES}
