#####iPad 开发
#####UIPoperController
######实现功能：

1.	UIPoverController 从BarButtonItem 中显示
2.	UIPoverController 从View 的控件中显示
3.	UIPoverController 显示的时候要求依然能够响应后面的控件
4.	modal视图的使用：UIModalPresentationStyle,UIModalTransitionStyle 


##美团项目开发

### TODOList
####前两天
1. 启动图片图标等设置
2. 删除storyBoard，使用代码创建主页
2. 导航栏的搭建
3. 分类下拉菜单
4. 城市列表的使用
5.	添加一个遮盖的方法
	-	用的时候进行添加view，使用自动布局来实现
	-	开始的时候就添加好了，然后设置alpha ，或者是hidden,这种方式可以在xib中添加遮盖，简化代码
	
6.	搜索功能的实现：用新的控制器来管理搜索结果
	-  将新的控制添加到原来控制器的addChildViewController：，两个控制器的view是父子关系，那么他们的控制器也应该是父子关系
	- 添加约束，显示viewController 的view 
	- 使用谓词（过滤器）技术进行搜索，当然也可以自己遍历数组搜索
7. 分类下拉菜单和城市列表的合并使用，提取dropDown，建立数据源，然后我们的dropDown 就可以与数据独立变得通用了
	1. 我们可以模仿tableView 来写数据源，需要哪些数据就从代理获取数据就可以了
	2. 这样写的数据源方法可能会很多，比较长的代码函数名字，我们还可以让代理返回值返回一个简单的数据代理给我们，数据代理中包含了我们需要的数据的getter方法，相当于有两层间接层
	3. 对于事件的监听，我们同样可以模仿tableView来建立一个delegate，来告诉delegate 我们现在发生了什么事件
8.  封装一个控件的时候，我们要建立的是一个可以通用的view类型，一个view 需要设置数据，所以我们建立数据源代理来提供数据，同时一个view 可能会需要响应一些事件操作，那么我们可以设置一个delegate 来响应我们的事件操作。 当然如果只是响应一个方法，那么我们完全可以使用addTarget：action 的方式来让外部使用者响应该事件。 总之，要面向抽象（协议）做事情，而不是具体的某个数据类或者是controller类。 这里的抽象就是：dataSource, delegate。 同时对于暴露在外面的接口应该越少越好，保证自己的安全性也很重要。

9. 	向网络请求数据，向大众点评的公开API请求数据的
	- [大众点评开发者](http://developer.dianping.com/app/documentation/demo)
	
####第三天
10. HomeViewController 显示来自服务器的数据 ，先定义模型，然后定义CollecitonViewController,自定义cell,这里的定义cell选择使用xib来进行，因为界面之间的元素比较固定
11. 如果想要完整的保存服务器返回的数字的小数位数，应该用NSString 或者NSNumber
12. 原价中间有个横线，采用drawRect：方式画出来，自定义UILabel控件来做
13. homeViewCOntroller 设置上下左右的间距
14. 监听屏幕控制器转动方向，设置上下左右的间距 ：什么时候刷新界面，我们可以选择在整个业务流程上的某一个一定要调用的函数中进行调用，抓住问题的关键，HOOK住你哦
15. 显示新单，NSDateFormatter 方法的使用，别常用哦，这个方法听说很消耗内存

16. 上拉刷新：时刻可以上拉刷新
17. 多次请求网络数据，我们选择将上次的网路请求结果忽略，只接受最后一次网络请求的数据，所以要将最后一次网络请求的数据进行保存 
18. 请求失败，要对用户进行提醒，结束刷新，同时对请求的其他操作进行恢复处理，保证原子性一致性哦，使用的是HUD提醒框架，提醒的方向有问题的时候一般是因为错误提醒默认加载到了最后一个window上面，window的原点不随着pad旋转而变化
19. 下拉刷新
20. 当用户点击其他的分类区域排序等信息的时候，下拉开始刷新，请求数据
21. 控制尾部刷新控件的刷新和隐藏，将当前保存的数据信息进行保存 和总数进行比较，如果没有更多的数据的时候，我们将下拉刷新控件进行隐藏
22. 多次请求冲突时候，选择最后一次请求的返回结果，其他请求结果予以丢弃
22. 如果发现没有数据，进行显示提醒用户,可以放在请求数据获取结果的地方，也可以放在CollectionView 刷新会调用的地方，比如numberOfSectionsInCollectionView:代理方法中,同时没有数据的时候，下拉刷新按钮也要进行隐藏
23. 添加搜索排序功能，和HomeViewController长得很像，所以可以抽取父类，这里会用到模板方法模式，将一些通用的数据放到父类中，将可以变的部分放到子类中，同时不影响整个算法结构，只是将这个算法的某个步骤延迟子类中实现
24. 设置全局背景颜色，使用宏定义哇，将颜色放到共有参数中，我以前是搞了一个全局的基类控制器来做背景色的控制的，然后所有的类来继承它，该方法的缺陷是我还得把tableViewController之类的类进行继承封装
25. searchBar 成为titleView的时候会自动拉伸，不管是设置frame还是设置autoResizingmask，还是自动布局都不可以，方法是使得中间层UIView  
26. awesomeMenu菜单的使用，主要是浏览记录和收藏
 
###第四天
1. 搜索界面弹出提示，请选择城市后再搜索 
2. 团购详情界面，放在父类中实现，因为收藏和主页都可以选择弹出团购详情
3. 详情界面单独支持横屏
4. 发现服务器返回的页面不是我们想要的，我们可以用在webview中执行JS对H5页面进行一些修改：删除某些元素；主要用到的工具是firebug,
	- webView 查看所有的加载页面源码，写入相关的页面		
		NSSTtring *html = [webview stringByEvaluatingJavaScriptFromString:@"document.getElememtsByTagName('html')[0].outerHtml;"]
		NSLog(@"%@",html);
	- 在火狐浏览器中利用js结合firebug修改相关的页面这里主要是删除一些html元素
	- webview中执行这些JS语句
5. UILabel 在自动布局中可以只定义位置，不定义宽高，系统会自动添加约束，让高度宽度自适应的
6. 支持过期随时退款，需要再次请求服务器的数据才能获得
7. calender来获取给定时间到当前时间相差多少时多少分多少秒，判断什么时候过期  ，对deadLine日期要追加一天，因为比如说是今天过期，那么是默认今天晚上12点过期，相当于是追加了一天
8. 收藏，fmdb ，表的设计，注意数据库的索引是从1开始的，不是0 哦，这里很容易犯错的
9. 存放在document中的数据是不给删除的，网络上下载的数据如果想要删除，那么最好放在cache文件夹下
10. 是否收藏成功进行提醒 
11. 收藏界面没有内容的时候，显示没有数据的view
12. 详情界面和收藏界面进行数据传递
13. 收藏的数据进行上拉刷新
14. 尾部控件的显示和收藏放在nubmerOfInSection：中实现

###开发过程中约到的一些问题和知识点
1.	pch 的添加： 在build setting 中搜索 prefix header，添加/path/to/yourPch.pch
1.  当设置使用了popverController的contentViewController 设置了autolayout 的时候，在显示的时候发现控件不显示，原因可能是因为自动伸缩变化	
	 两种方法：
	
		1. 在awakeFromNib方法中调用self.view.autoresizingMask = UIViewAutoresizingNone; //	子控件不需要跟随父控件的尺寸变化而伸缩时候，进行设置 
		2.在xib 中自动布局之前，先取消自动布局，然后将autoresize 中对宽高的自动缩放去掉（IB中进行的操作）
2.	xib的file's owner 是指控制器，尤其是在定义了一个view的情况下也是这样子的
3.	搜索框开始编辑文字是依赖于键盘弹出，结束编辑工作是依赖于键盘收起来
4.	delegate模式中，给一个nil 对象调用方法，不会报错，但是如果如果给一个非nil对象调用方法，但是该对象方法链条中根本没有该方法，那么我们此时就会崩溃，所以使用respondToSelector 方法进行自省是非常重要的。
5.	代码可以动态创建控件，随着数据源的变化而变化，固定的控件数据，则可以通过xib storyBoard 来进行处理。 代码创建的优势在于动态性，使用xib创建的优势在于固定便捷，快速创建；所以我们应该对固定界面部分使用xib，对于随着数据可能动态变化的部分尽可能多的使用代码来进行创建，这样可以在重用和效率之间找到一个好的平衡点。
6.	对于autolayout 和 使用frame 的几点说明：控件数量可变的时候一定要是用frame来控制位置，autolayout来控制控件数量固定，随着横屏竖屏简单缩放变化，但是对于位置上的而重大的改变还是使用frame 来进行控制好了，frame 也是可以进行相对布局的。
7.	dismissViewController 做了哪些事情
	1.	父类dismissViewController： 自己将要消失，那么自己的子控制器也将会消失，同时如果自己不是modal出来的，那么还是继续递归寻找父类的父控制器
	2. 子类dismissViewController： 自己将要消失，如果自己不是modal出来的，那么还会递归寻找父类的父控制器是否是被modal出来的   
	3. self.presentedViewController 引用这自己modal出来的子控制器，self.presentingViewController引用这modal出自己的控制器
8.	一份固定的plist数据在多个地方使用的时候，我们最好建造一个单例模式的数据工具类，用来获取该数据
9.	内部类的定义和使用：在类内部在定义一个类的方式，可以将该类的声明范围进行很好的限定，可以自定义button继承原来的button,然后将数据和一些常用的设置操作进行绑定封装，当然也可以用butto类的tag来做某些事情 
10.	UILabel使用自动布局的时候，可以不添加宽度约束，如果不添加宽度约束，那么该Label的控件的宽度应该是和自己的内容一样的
14. UILabel的文字其实是drawRect: 画出来的，可以画条线：或者画一个高度为1的矩形框
15. 项目结构分层：MVC,MVVM，MVP
16. 删除一个数组中的对象的时候，它会默认调用isEqual:方法给该对象进行比较，我们想要删除自定义的对象的时候，如果我们想要按照内容是否相同来删除的时候，我们可以重写该对象的isEqual：方法就可以了

###开发过程中常用的代码风格
1. 规范注释的使用：在公开接口方面提供注释，属性和方法都要提供，这样可以方便和别的同行进行交接合作
2. 注意空格的使用: 函数名怎么写，属性怎么写，方法内部什么时候用空格
3. pragma mark - 规范使用
4. 花括号的使用}后面要有一行空行
5. 参考：
	- [Coding Guidelines for Cocoa](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CodingGuidelines/CodingGuidelines.html)
	- [Google Objective-C Style Guide](https://google.github.io/styleguide/objcguide.xml?showone=Spaces_vs._Tabs#Spaces_vs._Tabs)
	- [Objective-C代码规范](http://www.cocoachina.com/ios/20140520/8484.html)










































