//
//  MYRefreshComponent.m
//  MYRefresh
//
//  Created by sunjinshuai on 2017/11/11.
//  Copyright © 2017年 sunjinshuai. All rights reserved.
//

#import "MYRefreshComponent.h"
#import "MYRefreshAnimationView.h"
#import "UIScrollView+MYExtension.h"
#import "UIView+Position.h"
#import "MYRefreshConst.h"

@implementation UILabel(MYRefresh)
+ (instancetype)my_label {
    UILabel *label = [[self alloc] init];
    label.font = MYRefreshLabelFont;
    label.textColor = MYRefreshLabelTextColor;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (CGFloat)my_textWith {
    CGFloat stringWidth = 0;
    CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
    if (self.text.length > 0) {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        stringWidth =[self.text
                      boundingRectWithSize:size
                      options:NSStringDrawingUsesLineFragmentOrigin
                      attributes:@{
                                   NSFontAttributeName:self.font
                                   }
                      context:nil].size.width;
#else
        
        stringWidth = [self.text sizeWithFont:self.font
                            constrainedToSize:size
                                lineBreakMode:NSLineBreakByCharWrapping].width;
#endif
    }
    return stringWidth;
}
@end

@interface MYRefreshComponent ()

@property (nonatomic, strong) MYRefreshAnimationView *animationView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation MYRefreshComponent

- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
        
        self.state = MYRefreshStatePulling;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        
        self.state = MYRefreshStatePulling;
    }
    return self;
}

- (void)setupUI {
    _animationView = [[MYRefreshAnimationView alloc] init];
    [self addSubview:_animationView];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = MYRefreshLabelFont;
    _textLabel.textColor = MYRefreshLabelTextColor;
    _textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_textLabel];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    [super willMoveToSuperview:newSuperview];
    
    if (![newSuperview isKindOfClass:[UIScrollView class]] && newSuperview) {
        return;
    }
    [self removeObservers];
    if (newSuperview) {
        // 设置宽度
        self.width = newSuperview.width;
        // 设置位置
        self.x = -_scrollView.my_insetLeft;
        
        _scrollView = (UIScrollView *)newSuperview;
        // 允许垂直
        _scrollView.alwaysBounceVertical = YES;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.my_inset;
        
        [self updateRect];
        [self addObservers];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat labelWidth = self.bounds.size.width/3;
    CGFloat height = MYRefreshHeight;
    CGFloat animationWidth = height * 0.4;
    
    _textLabel.bounds = CGRectMake(0, 0, labelWidth, height);
    _textLabel.center = CGPointMake(self.bounds.size.width / 2 + animationWidth / 2, self.bounds.size.height/2.0f);
    
    _animationView.frame = CGRectMake(CGRectGetMinX(_textLabel.frame) - animationWidth, 0, animationWidth, height);
    _animationView.center = CGPointMake(_animationView.center.x, self.bounds.size.height/2.0f);
}

- (void)updateRect{
}

// 设置回调对象和方法
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action {
    self.refreshingTarget = target;
    self.refreshingAction = action;
}

#pragma mark -
#pragma mark KVO

- (void)addObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [_scrollView addObserver:self forKeyPath:MYRefreshKeyPathContentOffset options:options context:nil];
    [_scrollView addObserver:self forKeyPath:MYRefreshKeyPathContentSize options:options context:nil];
}

- (void)removeObservers {
    [self.superview removeObserver:self forKeyPath:MYRefreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:MYRefreshKeyPathContentSize];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled) {
        return;
    }
    
    // 这个就算看不见也需要处理
    if ([keyPath isEqualToString:MYRefreshKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    
    if (self.hidden) {
        return;
    }
    if ([keyPath isEqualToString:MYRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if([keyPath isEqualToString:MYRefreshKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
}

- (void)startRefreshing {
    self.state = MYRefreshStateRefreshing;
    self.refreshProgress = 1;
    [self sendRefresingCallBack];
    [_animationView startAnimation];
}

- (void)endRefreshing {
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, MYRefreshAnimationDuration * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        [_animationView endAnimation];
        self.state = MYRefreshStatePulling;
        self.refreshProgress = 0;
    });
}

- (void)sendRefresingCallBack {
    
    if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
        MYRefreshMsgSend(MYRefreshMsgTarget(self.refreshingTarget), self.refreshingAction, self);
    }
    if (_refreshingBlock) {
        _refreshingBlock();
    }
}

- (void)setState:(MYRefreshState)state {
    _state = state;
    switch (state) {
        case MYRefreshStatePulling:
            _textLabel.text = _stateTitle[MYStatePullingKey];
            break;
        case MYRefreshStateWillRefresh:
            _textLabel.text = _stateTitle[MYStateWillRefreshKey];
            break;
        case MYRefreshStateRefreshing:
            _textLabel.text = _stateTitle[MYStateRefreshingKey];
            break;
            
        default:
            break;
    }
}

- (void)setRefreshProgress:(CGFloat)refreshProgress {
    _refreshProgress = refreshProgress;
    
    _animationView.progress = refreshProgress;
    self.alpha = refreshProgress;
    
    refreshProgress = refreshProgress > 1 ? 1 : refreshProgress;
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, refreshProgress * MYRefreshHeight);
}

- (BOOL)isRefreshing {
    return _state == MYRefreshStateRefreshing;
}

@end
