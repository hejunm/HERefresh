> 在iOS中下拉刷新和上拉加载更多组件（太长，下面就叫它pullToRefresh 组件了）使用的非常普遍。开源社区也有非常丰富的资源让你能够轻松的实现这个效果。观察各优秀app你会发现他们的pullToRefresh 组件都有自己的特色。如何才能快速的创建出私人定制版pullToRefresh 组件？ 也许你能从我的开源项目[HERefresh](https://github.com/hejunm/HERefresh)中获得一些灵感。

####HERefresh完成什么样的工作？
`HERefresh`是一个类簇。它维护着一个状态机，能过通过监听`UIScrollView`的`contentOffset`属性确定当前pullToRefresh组件应该切换到什么状态(说的简单，实现时考虑的东西还是挺多的)。然后根据具体状态对UI进行相应操作（通过调用`HERefreshView`的` func refresh(_ refresh:HERefresh,stateChangedTo state:HERefreshState)` 进行UI的修改）。

```
//状态
public enum HERefreshState: Equatable, CustomStringConvertible {
    case initial                    // 初始话
    case pulling(progress: Float)   // 下/上拉进度（0~1）
    case loading                    // 正在加载数据
    case finished                   // 加载结束
    case noMoreData                 // 没有更多数据（只在footer中有效）
}


//initial:   初始化操作。 例如调整contentInsert 从而隐藏 header（有动画）;添加动画（动画进度可通过手势进行控制）；
//pulling(progress: Float) :  下/上拉进度（0~1）你可以根据process值进行一些控制，例如动画执行的offset。  在process<1时松手，状态切换到initial， process>1时松手状态切换到loading。
//loading :  正在加载状态，此时不会响应下/上拉操作了，知道加载结束。
//finished:  当前切换到此状态时，refreshView并不会隐藏。在此状态时可以执行一些结束动画，结束动画执行结束后你再去将状态改为initial，此时refreshView会隐藏起来。这样子定制更加灵活。结束动画需要在HERefreshView的 func refresh(_ refresh:HERefresh,stateChangedTo state:HERefreshState)中进行定制。
```


####你需要做什么？
1， 创建一个继承自`HERefreshView`的类， 并根据状态修改UI或执行动画。
```
class HERefreshView: UIView,HERefreshDelegate {
	 func refresh(_ refresh: HERefresh, stateChangedTo state: HERefreshState){
		 assert(false, "You must override \(#function)")
	 }
}
protocol HERefreshDelegate:NSObjectProtocol {
    func refresh(_ refresh:HERefresh,stateChangedTo state:HERefreshState)
}

class HERefreshDefaultHeaderView: HERefreshView {
    //创建UI ...
    //相应状态变换    
   override func refresh(_ refresh:HERefresh,stateChangedTo state:HERefreshState){
                //do  something
    }
}
```
2，创建refreshView，指定refreshView的size。 创建 HERefreshHeader或者HERefreshFooter对象（HERefreshHeader用于下拉刷新，HERefreshFooter用于上拉加载更多）。
```
let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
let defaultHeaderView = HERefreshHeaderView(frame: frame)
```
3， 将HERefreshHeader添加到scrollView 上
```
self.tableView.addRefreshHeader(pullToMakeSoupHeader) {
// block，会在进入loading 状态是进行回调。
 }
```

----------


### 实现效果
####header-pullToMakeSoup
 创意来自[PullToRefresh](https://github.com/Yalantis/PullToMakeSoup)。  我在[demo](https://github.com/hejunm/HERefresh)中演示了如何使用`HERefresh` 来实现这个效果。动画的实现原理参考[这里](https://yalantis.com/blog/how-we-built-customizable-pull-to-refresh-pull-to-cook-soup-animation/?utm_source=github)。

![pullToMakeSoup](http://upload-images.jianshu.io/upload_images/1748276-34e733f77318d0be?imageMogr2/auto-orient/strip)

#### header-default

![header-default](http://upload-images.jianshu.io/upload_images/1748276-8185213b22e0aa76?imageMogr2/auto-orient/strip)

```
self.tableView.addDefaultHeader {
            //加载时进行回调， 模拟延时
            let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.data = 5
                self.tableView.reloadData()
                self.tableView.endRefreshHeader()
                self.tableView.canLoadMoreData(true)
            }
        }
```

####footer-default
folder-default完成上拉加载更多的功能。使用也是很简单，一句话：

```
self.tableView.addDefaultFooter {
   //模拟延时
   let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
   DispatchQueue.main.asyncAfter(deadline: delayTime) {
       self.data+=5
       self.tableView.reloadData()
       self.tableView.endRefreshFooter()
   }
}
```

通过配置属性实现不同的行为：

1， canAutoLoadMore
```
    ///自动加载更多。
    ///false:  上拉一定距离，松手后才会进行加载
    ///true:   当scrollView滑动到底部时就自动调用action块(默认值)
    var canAutoLoadMore = true
```

2， befordDistance

```
///当canAutoLoadMore = true时，在scrollView距离底部有一定距离时就开始提前加载。简书就有这样的效果。
var befordDistance:CGFloat = 0
```

3， isHiddenWhenNoMoreData

```
///没有更多数据时，是否隐藏refreshView。
var isHiddenWhenNoMoreData = false
``` 
//不隐藏
![不隐藏](http://upload-images.jianshu.io/upload_images/1748276-b73d8b435c7c6a2d?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
