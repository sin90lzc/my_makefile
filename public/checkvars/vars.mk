%:
	@echo '$*=$($*)'
d-%:
	@echo '$*=$($*)'
	
	@echo '	origin = $(origin $*)'
#打出这个变量没有被展开的样子。比如上述示例中的 foo 变量	
	@echo '	 value = $(value $*)'
#有两个值，simple表示是一般展开的变量，recursive表示递归展开的变量
	@echo '	flavor = $(flavor $*)'
 
