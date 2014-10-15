//
//  LoadMoreViewCell.m
//  PRIS_iPhone
//
//  Created by ios on 11-8-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PLLoadMoreViewControl.h"


static void *contentOffsetObservingKey = &contentOffsetObservingKey;

@implementation PLLoadMoreViewControl {
    PLPullState _innerState;
    UIEdgeInsets _originalContentInset;
    CGFloat _decelerationStartOffset;

    UILabel *_indicateLabel;
    UIActivityIndicatorView *_spinner;
}


- (id)init {
    self = [super init];
    if (self) {
        [self commonInit];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)commonInit {
    self.frame = CGRectMake(0, 0, 320, 40);

    _indicateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    _indicateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _indicateLabel.textAlignment = NSTextAlignmentCenter;
    _indicateLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    _indicateLabel.backgroundColor = [UIColor clearColor];
    _indicateLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    _indicateLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    _indicateLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self addSubview:_indicateLabel];


    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.center = CGPointMake(self.bounds.size.width/2 - 50, self.bounds.size.height/2);

    [self addSubview:_spinner];

    [self setState:PLPullStateNormal];

}

#pragma mark - protocol
- (void)setState:(PLPullState)state {
    switch (state) {
        case PLPullStatePulling:

			_indicateLabel.text = NSLocalizedString(@"松开加载更多", @"松开来更新状态");

			break;
		case PLPullStateNormal:

			_indicateLabel.text = NSLocalizedString(@"上拉刷新", @"拖动来更新状态");
			[_spinner stopAnimating];


			break;
		case PLPullStateRefreshing:

			_indicateLabel.text = NSLocalizedString(@"正在载入更多", @"加载状态");
			[_spinner startAnimating];

			break;

    }
    _innerState = state;
}

- (PLPullState)state {
    return _innerState;
}

- (void)beginRefreshing {

}

- (void)endRefreshing {
    [UIView animateWithDuration:0.2 animations:^{
        UIScrollView *scrollview = (UIScrollView *)self.superview;
        scrollview.contentInset = _originalContentInset;
    } completion:^(BOOL finished) {
        _innerState = PLPullStateNormal;
    }];
}
#pragma - end protocol
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self.superview removeObserver:self forKeyPath:@"contentOffset" context:contentOffsetObservingKey];
}

- (void)didMoveToSuperview {
    UIView *superview = self.superview;

    // Reposition ourself in the scrollview
    if ([superview isKindOfClass:[UIScrollView class]]) {
        [self repositionAboveContent];

        [superview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld context:contentOffsetObservingKey];

        _originalContentInset = [(UIScrollView *)superview contentInset];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context != contentOffsetObservingKey) {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }

    if ([self.superview isKindOfClass:[UIScrollView class]] == NO) {
        return;
    }
    UIScrollView *scrollview = (UIScrollView *)self.superview;
    CGFloat pullHeight = scrollview.contentOffset.y + _originalContentInset.top;
    CGFloat triggerHeight = self.bounds.size.height + scrollview.contentSize.height - scrollview.bounds.size.height + _originalContentInset.bottom + _originalContentInset.top;
    CGFloat previousPullHeight = -[change[NSKeyValueChangeOldKey] CGPointValue].y;


    // Track when deceleration starts
    if (scrollview.isDecelerating == NO) {
        _decelerationStartOffset = 0;
    }
    else if (scrollview.isDecelerating && _decelerationStartOffset == 0) {
        _decelerationStartOffset = scrollview.contentOffset.y;
    }


    // Transition to the next state
    if (_innerState == PLPullStateRefreshing) {

    }else if (pullHeight < triggerHeight) {
        [self setState:PLPullStateNormal];
    }
    else if (pullHeight >= triggerHeight || previousPullHeight < triggerHeight) {

        if (scrollview.isDragging) {
            // Just waiting for them to let go, then we'll refresh
            [self setState:PLPullStatePulling];
        }
        else if (([self allControlEvents] & UIControlEventValueChanged) == 0) {
            NSLog(@"No action configured for UIControlEventValueChanged event, not transitioning to refreshing state");
        }
        else {
            // They let go! Refresh!
            [self setState:PLPullStateRefreshing];

            [UIView animateWithDuration:0.2 animations:^{
                UIEdgeInsets inset = _originalContentInset;
                inset.bottom += self.bounds.size.height;
                scrollview.contentInset = inset;
            } completion:^(BOOL finished) {
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }];


        }
    }
    else if (scrollview.decelerating == NO && pullHeight > 0) {
        [self setState:PLPullStatePulling];
    }
    else {
        [self setState:PLPullStateNormal];
    }
}

- (void)repositionAboveContent {
    CGRect scrollBounds = self.superview.bounds;
    UIEdgeInsets inset = [(UIScrollView *)self.superview contentInset];
    CGFloat height = self.bounds.size.height;
    CGRect newFrame = (CGRect){
        .origin.x = 0,
        .origin.y = [(UIScrollView *)self.superview contentSize].height ,
        .size.width = scrollBounds.size.width,
        .size.height = height
    };
    self.frame = newFrame;
}

@end
