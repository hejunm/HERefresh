//
//  PullToMakeSoupHeaderView.swift
//  PullToRefereach
//
//  Created by 贺俊孟 on 16/11/13.
//  Copyright © 2016年 User. All rights reserved.
//

import UIKit



class PullToMakeSoupHeaderView: HERefreshView {
    
    @IBOutlet fileprivate var pan: UIImageView!
    @IBOutlet fileprivate var cover: UIImageView!
    @IBOutlet fileprivate var carrot: UIImageView!
    @IBOutlet fileprivate var potato: UIImageView!
    @IBOutlet fileprivate var leftPea: UIImageView!
    @IBOutlet fileprivate var rightPea: UIImageView!
    @IBOutlet fileprivate var circle: UIImageView!
    @IBOutlet fileprivate var water: UIImageView!
    @IBOutlet fileprivate var flame: UIImageView!
    @IBOutlet fileprivate var shadow: UIImageView!
    
    
    fileprivate var bubbleTimer: Timer?
    fileprivate let animationDuration = 0.3
    
    override func refresh(_ refresh: HERefresh, stateChangedTo state: HERefreshState) {
        switch state {
        case .initial:
            setStateInitial()
        case .pulling(let progress):
            setStatePulling(CGFloat(progress))
        case .loading:
            startLoading()
        case .finished:
            setStateFinished(refresh: refresh)
        default:
            break
        }
    }
    
    func setStateInitial(){
        let centerX = self.bounds.width / 2
        
        // Circle
        self.circle.center = CGPoint(x: centerX, y: self.bounds.height / 2)
        self.circle.alpha = 0.0
        
        // Pan
        self.pan.removeAllAnimations()
        self.pan.addAnimation(panTranslationY)
        self.pan.layer.timeOffset = 0.0

        
        // Potato
        self.potato.removeAllAnimations()
        self.potato.addAnimation(potatoPosition)
        self.potato.addAnimation(potatoOpacity)
        self.potato.addAnimation(potatoRotation)
        self.potato.layer.timeOffset = 0.0
        
        
        // Carrot
        self.carrot.removeAllAnimations()
        self.carrot.addAnimation(carrotPosition)
        self.carrot.addAnimation(carrotOpacity)
        self.carrot.addAnimation(carrotRotation)
        self.carrot.layer.timeOffset = 0.0
        
        // Left pea
        self.leftPea.removeAllAnimations()
        self.leftPea.addAnimation(leftPeaPosition)
        self.leftPea.addAnimation(leftPeaOpacity)
        self.leftPea.layer.timeOffset = 0.0
        
        
        // Right pea
        self.rightPea.removeAllAnimations()
        self.rightPea.addAnimation(rightPeaPosition)
        self.rightPea.addAnimation(rightPeaOpacity)
        
        self.rightPea.layer.timeOffset = 0.0
        
        
        // Cover
        self.cover.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        self.cover.removeAllAnimations()
        self.cover.addAnimation(coverPosition)
        self.cover.addAnimation(coverRotation)
        self.cover.layer.timeOffset = 0.0
        
        // Flame
        self.flame.image = nil
        self.flame.stopAnimating()
        self.flame.animationImages = nil
        
        
        //shadow
        self.shadow.alpha = 0
        
        // Water
        self.water.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        self.water.transform = CGAffineTransform(scaleX: 1, y: 0.00001);
    }
    
    func setStatePulling(_ progress: CGFloat) {
        let speed: CGFloat = 1.5
        
        let speededProgress: CGFloat = progress * speed > 1 ? 1 : progress * speed
        
        self.circle.alpha = progress
        self.circle.transform = CGAffineTransform.identity.scaledBy(x: speededProgress, y: speededProgress);
        self.circle.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2 + self.bounds.height - (self.bounds.height * progress))
        
        self.pan.alpha = progress
        self.pan.layer.timeOffset = Double(speededProgress) * animationDuration
        
        
        func progressWithOffset(_ offset: Double, _ progress: Double) -> Double {
            return progress < offset ? 0 : (progress - offset) * 1/(1 - offset)
        }
        
        self.cover.layer.timeOffset = animationDuration * progressWithOffset(0.9, Double(progress))
        self.carrot.layer.timeOffset = animationDuration * progressWithOffset(0.5, Double(progress))
        self.potato.layer.timeOffset = animationDuration * progressWithOffset(0.8, Double(progress))
        self.leftPea.layer.timeOffset = animationDuration * progressWithOffset(0.5, Double(progress))
        self.rightPea.layer.timeOffset = animationDuration * progressWithOffset(0.8, Double(progress))
    }
    
    func startLoading(){
        self.circle.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        
        self.pan.layer.timeOffset = animationDuration
        self.carrot.layer.timeOffset = animationDuration
        self.potato.layer.timeOffset = animationDuration
        self.leftPea.layer.timeOffset = animationDuration
        self.rightPea.layer.timeOffset = animationDuration
        self.cover.layer.timeOffset = animationDuration

        // Water & Cover
        self.water.center = CGPoint(x: self.water.center.x, y: self.pan.center.y + 22)
        self.water.clipsToBounds = true
        coverAnimationInLoading()
        
        // Bubbles
        bubbleTimer = Timer.scheduledTimer(timeInterval: 0.12, target: self, selector: #selector(PullToMakeSoupHeaderView.addBubble), userInfo: nil, repeats: true)
        flamesAnimationInLoading()
    }
    
    func setStateFinished(refresh: HERefresh){
        bubbleTimer?.invalidate()
        refresh.state = .initial
    }
   
    
    //MARK:  Initial   animation
    lazy var panTranslationY:CAKeyframeAnimation = {
        return CAKeyframeAnimation.animationWith(
            AnimationType.TranslationY,
            values: [-200, 0],
            keyTimes: [0, 0.8],
            duration: self.animationDuration,
            beginTime:0)
    }()
    
    lazy var potatoPosition:CAKeyframeAnimation = {
        return CAKeyframeAnimation.animationPosition(
            PocketSVG.pathFromSVGFileNamed("potato-path-only",
                                           origin: CGPoint(x: self.bounds.width/2 - 65, y: 0),
                                           mirrorX: true,
                                           mirrorY: false,
                                           scale: 1),
            duration: self.animationDuration,
            timingFunction:TimingFunction.easeIn,
            beginTime:0)
    }()
    
    lazy var potatoOpacity:CAKeyframeAnimation = {
        return CAKeyframeAnimation.animationWith(
            AnimationType.Opacity,
            values: [0, 1],
            keyTimes: [0, 1],
            duration: self.animationDuration,
            beginTime:0)
    }()
    
    lazy var potatoRotation:CAKeyframeAnimation = {
        return CAKeyframeAnimation.animationWith(
            AnimationType.Rotation,
            values: [5.663, 4.836, 3.578],
            keyTimes: [0, 0.5, 1],
            duration: self.animationDuration,
            beginTime:0)
    }()
    
    lazy var carrotPosition:CAKeyframeAnimation = {
        return CAKeyframeAnimation.animationPosition(
            PocketSVG.pathFromSVGFileNamed("carrot-path-only",
                                           origin: CGPoint(x: self.bounds.width/2 + 11, y: 5),
                                           mirrorX: true,
                                           mirrorY: false,
                                           scale: 0.5),
            duration: self.animationDuration,
            timingFunction:TimingFunction.easeIn,
            beginTime:0)
    }()
    
    lazy var carrotOpacity:CAKeyframeAnimation = {
        return CAKeyframeAnimation.animationWith(
            AnimationType.Opacity,
            values: [0, 1],
            keyTimes: [0, 1],
            duration: self.animationDuration,
            beginTime: 0)
    }()
    
    lazy var carrotRotation:CAKeyframeAnimation = {
        return CAKeyframeAnimation.animationWith(
            AnimationType.Rotation,
            values: [4.131, 5.149, 6.294],
            keyTimes: [0, 0.5, 1],
            duration: self.animationDuration,
            beginTime:0)
    }()
    
    lazy var leftPeaPosition:CAKeyframeAnimation = {
        return CAKeyframeAnimation.animationPosition(
            PocketSVG.pathFromSVGFileNamed("pea-from-left-path-only",
                                           origin: CGPoint(x: self.bounds.width/2 - 80, y: 6),
                                           mirrorX: false,
                                           mirrorY: false,
                                           scale: 1),
            duration: self.animationDuration,
            timingFunction:TimingFunction.easeIn,
            beginTime:0)
    }()
    
    lazy var leftPeaOpacity:CAKeyframeAnimation = {
        return CAKeyframeAnimation.animationWith(
            AnimationType.Opacity,
            values: [0, 1],
            keyTimes: [0, 1],
            duration: self.animationDuration,
            beginTime:0)
    }()
    
    lazy var rightPeaPosition:CAKeyframeAnimation = {
        return  CAKeyframeAnimation.animationPosition(
            PocketSVG.pathFromSVGFileNamed("pea-from-right-path-only",
                                           origin: CGPoint(x: self.bounds.width/2 - 10, y: -19),
                                           mirrorX: true,
                                           mirrorY: false,
                                           scale: 1),
            duration: self.animationDuration,
            timingFunction:TimingFunction.easeIn,
            beginTime:0)
    }()
    
    lazy var rightPeaOpacity:CAKeyframeAnimation = {
        return  CAKeyframeAnimation.animationWith(
            AnimationType.Opacity,
            values: [0, 1],
            keyTimes: [0, 1],
            duration: self.animationDuration,
            beginTime:0)
    }()
    
    lazy var coverPosition:CAKeyframeAnimation = {
        return   CAKeyframeAnimation.animationPosition(
            PocketSVG.pathFromSVGFileNamed("cover-path-only",
                                           origin: CGPoint(x: self.bounds.width/2 + 34, y: -54),
                                           mirrorX: true,
                                           mirrorY: true,
                                           scale: 0.5),
            duration: self.animationDuration,
            timingFunction:TimingFunction.easeIn,
            beginTime:0)
    }()
    
    lazy var coverRotation:CAKeyframeAnimation = {
        return CAKeyframeAnimation.animationWith(
            AnimationType.Rotation,
            values: [2.009, 0],
            keyTimes: [0, 1],
            duration: self.animationDuration,
            beginTime:0)
    }()
    
    //MARK:loading animation
    fileprivate func coverAnimationInLoading(){
        UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.shadow.alpha = 1
            self.water.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: { completed in
                self.cover.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                let coverRotationAnimation = CAKeyframeAnimation.animationWith(
                    AnimationType.Rotation,
                    values: [0.05, 0, -0.05, 0, 0.07, -0.03, 0],
                    keyTimes: [0, 0.2, 0.4, 0.6, 0.8, 0.9, 1],
                    duration: 0.5,
                    beginTime:0
                )
                
                let coverPositionAnimation = CAKeyframeAnimation.animationWith(
                    AnimationType.TranslationY,
                    values: [-2, 0, -2, 1, -3, 0],
                    keyTimes: [0, 0.3, 0.5, 0.7, 0.9, 1],
                    duration: 0.5,
                    beginTime: 0)
                
                let animationGroup = CAAnimationGroup()
                animationGroup.duration = 1;
                animationGroup.repeatCount = FLT_MAX;
                
                animationGroup.animations = [coverRotationAnimation, coverPositionAnimation];
                
                self.cover.layer.add(animationGroup, forKey: "group")
                self.cover.layer.speed = 1
        })
    }
    
    fileprivate func flamesAnimationInLoading(){
        // Flame
        var lightsImages = [UIImage]()
        for i in 1...11 {
            let imageName = NSString(format: "Flames%.4d", i)
            let image = UIImage(named: imageName as String, in: Bundle(for: type(of: self)), compatibleWith: nil)
            lightsImages.append(image!)
        }
        self.flame.animationImages = lightsImages
        self.flame.animationDuration = 0.7
        self.flame.startAnimating()
        
        let delayTime = DispatchTime.now() + Double(Int64(0.7 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            var lightsImages = [UIImage]()
            for i in 11...68 {
                let imageName = NSString(format: "Flames%.4d", i)
                let image = UIImage(named: imageName as String, in: Bundle(for: type(of: self)), compatibleWith: nil)
                lightsImages.append(image!)
            }
            
            self.flame.animationImages = lightsImages
            self.flame.animationDuration = 2
            self.flame.animationRepeatCount = 0
            self.flame.startAnimating()
        }
    }
    
    func addBubble() {
        let radius: CGFloat = 1
        let x = CGFloat(arc4random_uniform(UInt32(self.water.frame.size.width)))
        let circle = UIView(frame: CGRect(x: x, y: self.water.frame.size.height, width: 2*radius, height: 2*radius))
        circle.layer.cornerRadius = radius
        circle.layer.borderWidth = 1
        circle.layer.masksToBounds = true
        circle.layer.borderColor = UIColor.white.cgColor
        self.water.addSubview(circle)
        UIView.animate(withDuration: 1.3, animations: {
            let radius:CGFloat = 4
            circle.layer.frame = CGRect(x: x, y: -20, width: 2*radius, height: 2*radius)
            circle.layer.cornerRadius = radius
            }, completion: { _ in
                circle.removeFromSuperview()
        })
    }
}
