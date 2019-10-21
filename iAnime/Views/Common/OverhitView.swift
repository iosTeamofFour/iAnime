import UIKit

class OverhitView: UIView {

    /*
        ScrollView内部如果不是可以自动伸缩大小的StackView的话，
        就需要在内部放置一个View帮助他确定内容大小。
     
        如果View中的内容不是IB摆好的，而是代码动态加的，那么View可能
        就没有办法自动调整frame size。就需要开发者手动更新内层View的大小以及ScrollView的ContentSize。
     
        而如果此时View上带有约束，那么会造成当滚动View的时候，View的frame size 会因为约束的原因发生变化。
        一旦View.frame size小于content size, 那么就会造成超出frame Size的部分没有响应，这是因为View
        的默认hitTest函数会检测单击点是否在View的frame中，如果不在就自动扔掉点击事件。
     
        而为了达成让frame外的内容也可以点击，就需要重写定位View的hitTest函数（如下所示），取消掉
        frame区域检测，直接向下路由点击事件。
    */
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if(!isUserInteractionEnabled || isHidden || alpha <= 0.01) {
            return nil
        }
        for view in subviews.reversed() {
            let convertPoint = view.convert(point, from: self)
            let hitTestView = view.hitTest(convertPoint, with: event)
            if hitTestView != nil {
                return hitTestView
            }
        }
        return self
    }
}
