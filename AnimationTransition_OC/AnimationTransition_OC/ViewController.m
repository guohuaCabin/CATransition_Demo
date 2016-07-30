//
//  ViewController.m
//  AnimationTransition_OC
//
//  Created by TOMO on 16/7/29.
//  Copyright © 2016年 TOMO. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(strong,nonatomic)UIImageView *imageView;
@property(assign,nonatomic)NSInteger currentIndex;

@end

@implementation ViewController

static const NSInteger IMAGE_NUMBER = 3;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createImageView];
    [self swipeGesture];
}

- (void)createImageView
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    imageView.image = [UIImage imageNamed:@"00.jpg"];
    imageView.contentMode = UIViewContentModeScaleToFill;
    
    self.imageView = imageView;
    
    [self.view addSubview:self.imageView];
}
/**轻扫手势*/
- (void)swipeGesture
{
    /**轻扫手势--左手势*/
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureOfLeftClicked:)];
    
    /**手势方向*/
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    /**轻扫手势--右手势*/
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureOfRightClicked:)];
    
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
}
#pragma mark --向左滑动浏览下一张图片--
- (void)swipeGestureOfLeftClicked:(UISwipeGestureRecognizer *)swipeGesture
{
    /**左手势为YES*/
    [self transitionAnimation:YES];
}
#pragma mark --向右滑动浏览上一张图片--
- (void)swipeGestureOfRightClicked:(UISwipeGestureRecognizer *)swipeGesture
{
    [self transitionAnimation:NO];
}

- (void)transitionAnimation:(BOOL)isNext
{
    //创建转场动画对象
    CATransition *transition = [[CATransition alloc]init];
    
    /* The name of the transition. Current legal transition types include
     * `fade', `moveIn', `push' and `reveal'. Defaults to `fade'. */
    /**
     *   1.#define定义的常量
     kCATransitionFade   交叉淡化过渡  默认
     kCATransitionMoveIn 新视图移到旧视图上面,覆盖原图
     kCATransitionPush   新视图把旧视图推出去  ,推出
     kCATransitionReveal 将旧视图移开,显示下面的新视图 ,从底部显示
     
     2.用字符串表示
     pageCurl            向上翻一页
     pageUnCurl          向下翻一页
     rippleEffect        滴水效果
     suckEffect          收缩效果，如一块布被抽走
     cube                立方体效果
     oglFlip             上下翻转效果
     注意：
     还有很多私有API效果，使用的时候要小心，可能会导致app审核不被通过（悲剧啊，为啥有却不让用啊！好东西不应该被束之高阁！）
     fade     //交叉淡化过渡(不支持过渡方向)
     push     //新视图把旧视图推出去
     moveIn   //新视图移到旧视图上面
     reveal   //将旧视图移开,显示下面的新视图
     cube     //立方体翻滚效果
     oglFlip  //上下左右翻转效果
     suckEffect   //收缩效果，如一块布被抽走(不支持过渡方向)
     rippleEffect //滴水效果(不支持过渡方向)
     pageCurl     //向上翻页效果
     pageUnCurl   //向下翻页效果
     cameraIrisHollowOpen  //相机镜头打开效果(不支持过渡方向)
     cameraIrisHollowClose //相机镜头关上效果(不支持过渡方向)
     
     */
    //设置动画类型，注意对于苹果官方没有公开的动画类型智能使用字符串，并没有对应的常量意义
    // transaction.type=@"pageCurl";//控制图片的滑动类型
    if (isNext == YES) {
        transition.type     =   @"pageCurl";
        transition.subtype  =   kCATransitionFromRight;
    } else {
        transition.type     =   @"cube";
        transition.subtype  =   kCATransitionFromLeft;
    }
    //设置动画时长，默认为0
    transition.duration=1.0;
    
    /* The amount of progress through to the transition at which to begin
     * and end execution. Legal values are numbers in the range [0,1].
     * `endProgress' must be greater than or equal to `startProgress'.
     * Default values are 0 and 1 respectively. */
    //动画开始的进度
    //  transaction.startProgress=0.1;
    //动画结束的进度,,,结束的进度必须大于开始的进度
    //  transaction.endProgress=0.5;
    //动画的速度
    // transaction.speed=100.0;
    
    //设置转场后的新视图添加转场动画
    self.imageView.image=[self transitionImage:isNext];
    //添加动画效果
    [self.imageView.layer addAnimation:transition forKey:@"Animation"];
}

- (UIImage *)transitionImage:(BOOL)isNext
{
    if (isNext == YES) {
        self.currentIndex = (self.currentIndex + 1) % IMAGE_NUMBER;
    } else {
        self.currentIndex = (self.currentIndex - 1 + IMAGE_NUMBER) % IMAGE_NUMBER;
    }
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"0%ld.jpg",self.currentIndex]];
    
    return image;
}
@end
