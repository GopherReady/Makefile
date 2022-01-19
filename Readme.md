## Makefile介绍

Makefile是在Linux环境下 C/C++ 程序开发必须要掌握的一个工程管理文件。当你使用make命令去编译一个工程项目时，make工具会首先到这个项目的根目录下去寻找Makefile文件，然后才能根据这个文件去编译程序。那Makefile在编译过程中到底起了什么作用呢？这还得从程序的编译链接过程说起。

在Windows下编写程序，你只要会使用集成开发环境（IDE，Integrated Development Environment）就可以了，因为IDE集成了程序的编写、编译、链接、运行、项目管理等一条龙服务，一个编程小白，安装好IDE后，新建一个文件，编写好程序，点击菜单栏上的运行（Run）按钮，程序就可以跑起来了，程序员不需要关心程序在底层是如何编译和运行的。

而在Linux下编写程序，因为早期没有成熟的IDE，一般都是使用不同的命令进行编译：将源文件分别使用编译器、汇编器、链接器编译成可执行文件，然后手动运行。



## Makefile主要功能

makefile带来的好处就是——“**自动化编译**”，一旦写好，只需要一个make命令，整个工程完全自动编译，极大的提高了软件开发的效率。 **make是一个命令工具，是一个解释makefile中指令的命令工具**，一般来说，大多数的IDE都有这个命令，比如：Delphi的make，Visual C++的nmake，Linux下GNU的make。可见，makefile都成为了一种在工程方面的编译方法。

## Makefile如何编写

### 规则

规则是Makefile的基本组成单元。一个规则通常由目标、目标依赖和命令三部分构成：

```
<target> : <prerequisites> 
[tab]  <commands>
目标：目标依赖
[tab] 命令
a.out: hello.c    
[tab] gcc -o a.out hello.c
```

上面第一行冒号前面的部分，叫做"目标"（target），冒号后面的部分叫做"前置条件"（prerequisites）；第二行必须由一个tab键起首，后面跟着"命令"（commands）。

"目标"是必需的，不可省略；"前置条件"和"命令"都是可选的，但是两者之中必须至少存在一个。

一个规则中的三个部分并不是都必须要有的。一个Makefile文件中可能包含多个规则，有的规则可能无目标依赖，仅仅是为了实现某种操作。如下面的clean命令：

```makefile
clean:    
	rm -f a.out hello.o
```

当我们使用make clean命令清理编译的文件时，会调用这个规则中的命令，不需要什么依赖，仅仅是执行删除操作，所以这个规则中并没有目标依赖。

当然，一个规则中也可以没有命令，仅仅包含目标和目标依赖，仅仅用来描述一种依赖关系。但一个规则中一定要有一个目标。

### 默认目标

一个Makefile文件里通常会有多个目标，一般会选择第一个作为默认目标。正常情况下，当你想编译生成a.out时，要使用make a.out命令，但为什么直接使用make，没有指定参数，也能生成a.out的呢？这是因为在上面的Makefile文件中，a.out是文件中的第一个目标，当我们在make编译时没有给make指定要生成的目标，make就会选择Makefile文件中的第一个目标作为默认目标。

#### 多规则目标

多个规则可能是同一个目标，make在解析Makefile文件时，会将具有相同目标的规则的依赖文件合并。

```makefile
a.out: hello.c    gcc -o a.out hello.ca.out: module.c
```

Make在解析Makefile构建依赖关系树时，会将这两个规则合并为：

```makefile
a.out: hello.c module.c    gcc -o a.out hello.c other.c
```

#### 伪目标

有时候我们设置一个目标，并不是真正生成这个文件，如上面的clean目标，而是仅仅为了执行某个操作。当我们执行make clean时，clean这个目标并没有生成对应的目标文件clean，因此，clean也可以设置为伪目标。伪目标并不是一个真正的文件，可以看做是一个标签。

```makefile
.PHONY: clean
a.out: hello.o
    gcc -o a.out hello.o
hello.o: hello.c
    gcc -c -o hello.o hello.c
clean:
    rm -f a.out hello.o
```

#### Makefile 变量

为了更好地编写和维护Makefile，在Makefile中通常会使用很多变量。我们可以在Makefile中定义一个变量val，使用使用 $(val) 或 ${val} 的形式去引用它。

```makefile
PROJECT="example"
default:
	@echo ${PROJECT}
```

#### Makefile中执行命令

```makefile
PROJECT="example"

default:
	@echo ${PROJECT}
	python --version

gitstatus:
	git status

node-v:
	node -v
```

输出结果

```powershell
Admin@CREATEITV   base  ~\golang\src\github.com\GopherReady\makefile                                                                                                   [16:29]
❯ make default
example
python --version
Python 3.8.10
Admin@CREATEITV   base  ~\golang\src\github.com\GopherReady\makefile                                                                                                   [16:29]
❯ make gitStatus
git status
fatal: not a git repository (or any of the parent directories): .git
mingw32-make: *** [Makefile:8: gitStatus] Error 128
Admin@CREATEITV   base  ~\golang\src\github.com\GopherReady\makefile                                                                                                   [16:29]
❯ make gitstatus
git status
fatal: not a git repository (or any of the parent directories): .git
mingw32-make: *** [Makefile:8: gitstatus] Error 128
Admin@CREATEITV   base  ~\golang\src\github.com\GopherReady\makefile                                                                                                   [16:29]
❯ make node-v
node -v
v16.13.0
```

### 语法

#### 注释

井号（#）在Makefile中表示注释。

```makefile
# 这是注释
result.txt: source.txt
    # 这是注释
    cp source.txt result.txt # 这也是注释
```

#### 关闭echo

正常情况下，make会打印每条命令，然后再执行，这就叫做回声（echoing）。在命令的前面加上@，就可以关闭回声。

```makefile
test:
    @# 这是测试
```

#### 通配符

用来指定一组符合条件的文件名。Makefile 的通配符与 Bash 一致，主要有星号（*）、问号（？）和 [...] 。比如， *.o 表示所有后缀名为o的文件。

#### 模式匹配

Make命令允许对文件名，进行类似正则运算的匹配，主要用到的匹配符是%。比如，假定当前目录下有 f1.c 和 f2.c 两个源码文件，需要将它们编译为对应的对象文件。



## makefile示例

```makefile
PROJECT = "My Fancy Node.js project"

all: install test server

test: ;@echo "Testing ${PROJECT}....."; \
    export NODE_PATH=.; \
    ./node_modules/mocha/bin/mocha;

install: ;@echo "Installing ${PROJECT}....."; \
    npm install

update: ;@echo "Updating ${PROJECT}....."; \
    git pull --rebase; \
    npm install

clean : ;
    rm -rf node_modules

.PHONY: test server install clean update
```

### GOland文件三端编译

```makefile
# 三端编译
cross_build: build_windows build-linux build_mac
build-linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD) -o $(BINARY_UNIX) -v

build_windows:
	CGO_ENABLED=1 GOOS=windows GOARCH=amd64 $(GOBUILD) -o $(BINARY_WIN) -v

build_mac:
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 $(GOBUILD) -o $(BUILD_MAC) -v
```

只需要`make cross_build`即可

## 参考：

http://www.ruanyifeng.com/blog/2015/02/make.html

https://seisman.github.io/how-to-write-makefile/introduction.html

