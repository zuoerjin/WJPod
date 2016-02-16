//
//  EScrollerView.h
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
//

#import <UIKit/UIKit.h>
#import "MyPageControl.h"

@protocol EScrollerViewDelegate <NSObject>
@optional
-(void)EScrollerViewDidClicked:(NSUInteger)index;
@end

@interface EScrollerView : UIView<UIScrollViewDelegate> {
	CGRect viewSize;
	UIScrollView *scrollView;
	NSArray *imageArray;
    NSArray *titleArray;
//    UIPageControl *pageControl;
    id<EScrollerViewDelegate> delegate;
    int currentPageIndex;
    UILabel *noteTitle;
    
    NSArray *parameterArr;
    
    UIViewController *tempController;
}
@property (nonatomic, retain) NSTimer *updateTimer;
@property(nonatomic,retain)id<EScrollerViewDelegate> delegate;
@property (nonatomic , strong) MyPageControl *pageControl;

-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr withSuperController:(UIViewController *)controller withParameter:(NSArray *)parameter withFlag:(int)flag;
@end
