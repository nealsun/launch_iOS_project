//
//  RefreshTableHeaderView.m
//  ipad_reader
//
//  Created by reed zhu on 10-12-11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "PLTableRefreshControl.h"

static void *contentOffsetObservingKey = &contentOffsetObservingKey;

@implementation PLTableRefreshControl {
    PLPullState _innerState;
    UIEdgeInsets _originalContentInset;
    CGFloat _decelerationStartOffset;

    UILabel *_indicateLabel;
    UILabel *_textLabel;
    UIImageView *_arrow;
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
    self.frame = CGRectMake(0, 0, 320, 60);

    _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_down"]];
    _arrow.frame = CGRectOffset(_arrow.bounds, 56, 18);
    [self addSubview:_arrow];

    _indicateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _indicateLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _indicateLabel.textAlignment = NSTextAlignmentCenter;
    _indicateLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    _indicateLabel.backgroundColor = [UIColor clearColor];
    _indicateLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    _indicateLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    _indicateLabel.frame = CGRectMake(0.0f, self.frame.size.height - 48.0f, self.frame.size.width, 20.0f);
    [self addSubview:_indicateLabel];

    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    _textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    _textLabel.frame = CGRectMake(0.0f, self.frame.size.height - 30.0f, self.frame.size.width, 20.0f);
    [self addSubview:_textLabel];

    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.center = _arrow.center;

    [self addSubview:_spinner];

    [self setState:PLPullStateNormal];

}

#pragma mark - protocol
- (void)setState:(PLPullState)state {
    switch (state) {
        case PLPullStatePulling:

			_indicateLabel.text = NSLocalizedString(@"松开刷新", @"松开来更新状态");
            [UIView beginAnimations:@"ratation" context:nil];
            [UIView setAnimationDuration:0.18];
            _arrow.transform = CGAffineTransformMakeRotation(M_PI);
            [UIView commitAnimations];

			break;
		case PLPullStateNormal:

			if (_innerState == PLPullStatePulling) {
                [UIView beginAnimations:@"ratation" context:nil];
                [UIView setAnimationDuration:0.18];
                _arrow.transform = CGAffineTransformIdentity;
                [UIView commitAnimations];
			}

			_indicateLabel.text = NSLocalizedString(@"下拉刷新", @"拖动来更新状态");
			[_spinner stopAnimating];
            [UIView beginAnimations:@"ratation" context:nil];
            [UIView setAnimationDuration:0.18];
            _arrow.transform = CGAffineTransformIdentity;
            _arrow.hidden = NO;
            [UIView commitAnimations];

			break;
		case PLPullStateRefreshing:

			_indicateLabel.text = NSLocalizedString(@"正在刷新", @"加载状态");
			[_spinner startAnimating];
            [UIView beginAnimations:@"ratation" context:nil];
            [UIView setAnimationDuration:0.18];
            _arrow.hidden = YES;
            [UIView commitAnimations];

			break;

    }
    _innerState = state;
}

- (PLPullState)state {
    return _innerState;
}

- (void)setString:(NSString *)string {
    _textLabel.text = string;
}

- (NSString *)string {
    return _textLabel.text;
}

- (void)beginRefreshing {
    UIScrollView *scrollview = (UIScrollView *)self.superview;
    [scrollview setContentOffset:CGPointMake(0, -self.bounds.size.height) animated:YES];
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
    CGFloat pullHeight = -scrollview.contentOffset.y - _originalContentInset.top;
    CGFloat triggerHeight = self.bounds.size.height;
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
        // Adjust inset to make sure potential header view is shown correctly if user pulls down scroll view while in refreshing state
        CGFloat offset = MAX(scrollview.contentOffset.y * -1, 0);
		offset = MIN(offset, self.bounds.size.height);
		scrollview.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
    }
    else if (_decelerationStartOffset > 0) {
        // Deceleration started before reaching the header 'rubber band' area; hide the refresh control
        [self setState:PLPullStateNormal];
    }else if (pullHeight < triggerHeight) {
        [self setState:PLPullStateNormal];
    }
    else if (pullHeight >= triggerHeight || (pullHeight > 0 && previousPullHeight >= triggerHeight)) {

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
                inset.top += self.bounds.size.height;
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

//    if (pullHeight > self.bounds.size.height) {
//        // Center in the rubberbanding area
//        CGPoint rubberBandCenter = (CGPoint) {
//            .x = CGRectGetMidX(self.superview.bounds),
//            .y = scrollview.contentOffset.y / 2.0
//        };
//        self.center = rubberBandCenter;
//    }
//    else {
//    [self repositionAboveContent];
//    }
}

- (void)repositionAboveContent {
    CGRect scrollBounds = self.superview.bounds;
    UIEdgeInsets inset = [(UIScrollView *)self.superview contentInset];
    CGFloat height = self.bounds.size.height;
    CGRect newFrame = (CGRect){
        .origin.x = 0,
        .origin.y = -height ,
        .size.width = scrollBounds.size.width,
        .size.height = height
    };
    self.frame = newFrame;
}

- (void)dealloc {

}
@end
