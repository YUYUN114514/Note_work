###### 综述
> Git是目前世界上最先进的分布式版本控制系统
>

## 0.Git 安装
```c
//检查是否安装
git

//Linux
sudo apt-get install git
//windows
//直接下安装包install 或者
//安装scoop

//设置环境目录SCOOP,安装路径
$env:SCOOP='E:\UserScoop'
[Environment]::SetEnvironmentVariable('USERSCOOP', $env:SCOOP, 'User')

//官方指定安装指令   
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
//ok了

//安装git
scoop install git

//显示版本
git -v
//升级
scoop update git
//配置git信息
$ git config --global user.name "Your Name"
$ git config --global user.email "email@example.com"
```

## 1.本地操作
#### 1.建立版本库
```c
//创建文件夹
mkdir floder

cd floder
//初始化
git init

//ok了

//新建文件test.txt

//提交到暂存区
git add test.txt
git add floder/    (提交整个文件夹)

//提交到工作区
git commmit -m "message of commit"

//ok已提交到工作区
```

#### 2.版本管理
```c
//版本状态
git status


//日志
git log
git log --pretty=oneline

//修改日志
git reflog

//回退上一个版本
//--hard会回退到上个版本的已提交状态
//--soft会回退到上个版本的未提交状态
//--mixed会回退到上个版本已添加但未提交的状态
git reset --hard HEAD^

//回退指定版本
git reset --hard ID
//查看与最新版本的区别
git diff HEAD -- file




//丢弃工作区修改
git checkout -- filename
//撤销暂存区的修改
git reset HEAD filename

//删除文件
rm filename
git rm filename

//恢复删除的文件
git checkout -- filename 
```







## 2.远程仓库操作
#### 1.远程同步(仓库/分支.SSH)
###### 1.SSH密匙
```c
ssh-keygen -t rsa -C "2022210165.hit@vip.163.com"
//生成ssh密匙
//copy id.rsa.pub公匙添加到远程用户的ssh密匙权限里


//添加远程库
git remote add origin git@github.com:michaelliao/learngit.git
//删除与远程库的绑定关系
git remote rm origin
//查看连接的所有远程库
git remote

//把master分支推送到origin库里
git push -u origin master (第一次)
git push origin master

//从远程库克隆
git clone git@github.com:YUYUN114514/仓库.git
```





## 3.分支管理
```c
//分支查看
git branch
//更改分支
git switch <branchxx>

//创建新分支
git checkout -b <branchxx>
git switch -c <branchxx>

//合并分支
//先更改到主master分支
git switch <master>
git merge <branchxx>
//保存branchxx分支修改记录一同提交
git merge --no-ff -m "merge with no-ff" <branchxx>

//删除分支
git branch -d <branchxx>


```



