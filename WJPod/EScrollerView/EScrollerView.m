//
//  EScrollerView.m
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
//

#import "EScrollerView.h"

@implementation EScrollerView
@synthesize delegate;

- (void)dealloc {
	[scrollView release];
    [noteTitle release];
	delegate=nil;
    if (_pageControl) {
        [_pageControl release];
    }
    if (imageArray) {
        [imageArray release];
        imageArray=nil;
    }
    if (titleArray) {
        [titleArray release];
        titleArray=nil;
    }
    [super dealloc];
}



-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr withSuperController:(UIViewController *)controller withParameter:(NSArray *)parameter withFlag:(int)flag
{
    
    if ((self=[super initWithFrame:rect])) {
        
        if (imgArr.count==0) {
            return self;
        }
        
        parameterArr = parameter;
        tempController = controller;
        self.userInteractionEnabled=YES;
        titleArray=[titArr retain];
        NSMutableArray *tempArray=[NSMutableArray arrayWithArray:imgArr];
        [tempArray insertObject:[imgArr objectAtIndex:([imgArr count]-1)] atIndex:0];
        [tempArray addObject:[imgArr objectAtIndex:0]];
        imageArray=[[NSArray arrayWithArray:tempArray] retain];
        viewSize=rect;
        NSUInteger pageCount=[imageArray count];
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
        scrollView.pagingEnabled = YES;
        scrollView.clipsToBounds = YES;
        scrollView.contentSize = CGSizeMake(viewSize.size.width * pageCount, viewSize.size.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        for (int i=0; i<pageCount; i++) {
            NSString *imgURL=[imageArray objectAtIndex:i];
            UIImageView *imgView=[[[UIImageView alloc] init] autorelease];
            
            if (flag == 1) {
                imgView.layer.cornerRadius = 0;
                scrollView.layer.cornerRadius = 0;
                
            }
            
            
            if ([imgURL hasPrefix:@"http://"]) {
                
                NSURL *url = [NSURL URLWithString:imgURL];
                [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"首页-banner"]];
            }
            else
            {
                
                UIImage *img=[UIImage imageNamed:[imageArray objectAtIndex:i]];
                [imgView setImage:img];
            }
            
            [imgView setFrame:CGRectMake(viewSize.size.width*i, 0,viewSize.size.width, viewSize.size.height)];
            imgView.tag=i;
            UITapGestureRecognizer *Tap =[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)] autorelease];
            [Tap setNumberOfTapsRequired:1];
            [Tap setNumberOfTouchesRequired:1];
            imgView.userInteractionEnabled=YES;
            [imgView addGestureRecognizer:Tap];
//            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.clipsToBounds = YES;
            [scrollView addSubview:imgView];
        }
        [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        [self addSubview:scrollView];
        
        
        
        //说明文字层
        UIView *noteView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-25,self.bounds.size.width,25)];
        [noteView setBackgroundColor:[UIColor blackColor]];
        noteView.alpha = 0.2;
        
        float pageControlWidth=(pageCount-2)*10.0f+40.f;
        float pagecontrolHeight=20.0f;
        //        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-pageControlWidth),6, pageControlWidth, pagecontrolHeight)];
        //        pageControl.currentPage=0;
        //        pageControl.numberOfPages=(pageCount-2);
        //        [noteView addSubview:pageControl];
        
        CGFloat dotGapWidth = 6.0;
        //        UIImage *normalDotImage = [UIImage imageNamed:@"引导符_其他页"];
        //        UIImage *highlightDotImage = [UIImage imageNamed:@"引导符_当前页"];
        UIImage *normalDotImage = [UIImage imageNamed:@"发现-轮播-1"];
        UIImage *highlightDotImage = [UIImage imageNamed:@"发现-轮播-2"];
        
        _pageControl = [[MyPageControl alloc] initWithFrame:CGRectMake((self.frame.size.width-pageControlWidth)+19,10, pageControlWidth, pagecontrolHeight+10)
                                                normalImage:normalDotImage
                                           highlightedImage:highlightDotImage
                                                 dotsNumber:imgArr.count sideLength:dotGapWidth dotsGap:dotGapWidth];
        _pageControl.centerX = SCREEN_WIDTH/2+10+10;
        [noteView addSubview:self.pageControl];
        
        noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 6, self.frame.size.width-pageControlWidth-15, 20)];
        [noteTitle setText:[titleArray objectAtIndex:0]];
        [noteTitle setBackgroundColor:[UIColor clearColor]];
        [noteTitle setFont:[UIFont systemFontOfSize:13]];
        //        [noteView addSubview:noteTitle];
        
        
        [self addSubview:noteView];
        [noteView release];
        
        [self startTimer];
        
    }
    return self;
}



- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    int page1 = page;
    if (page == titleArray.count) {
        page = 1;
    }
    currentPageIndex=page;

    if (page1-1<0 || page==_pageControl.pageNumbers+1) {
        return;
    }
    _pageControl.currentPage=page1-1;
    


    //    [noteTitle setText:[titleArray objectAtIndex:titleIndex]];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    if (currentPageIndex==0) {
      
        [_scrollView setContentOffset:CGPointMake(([imageArray count]-2)*viewSize.size.width, 0)];
    }
    if (currentPageIndex==([imageArray count]-1)) {
       
        [_scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        
    }
}
- (void)imagePressed:(UITapGestureRecognizer *)sender
{

    if ([delegate respondsToSelector:@selector(EScrollerViewDidClicked:)]) {
        
//        if(sender.view.tag-1>parameterArr.count)
//        {
//            return;
//        }

//        NSDictionary *dic = parameterArr[sender.view.tag-1];
//        NSString *action_type = dic[@"action_type"];
        
//      
//        tempController.hidesBottomBarWhenPushed = YES;
//            HEXCAdvertisementViewController *advertisement = [[HEXCAdvertisementViewController alloc] init];
//            advertisement.advertLinkDict = dic;
//            [tempController.navigationController pushViewController:advertisement animated:YES];
//            tempController.hidesBottomBarWhenPushed = NO;
     
            
        
        
        [delegate EScrollerViewDidClicked:sender.view.tag];
    }
}

-(void)startTimer
{
    // 定时器 循环
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
//    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
}

// 定时器 绑定的方法
- (void)runTimePage
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page == titleArray.count) {
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }

    [self turnPage];
}

- (void)turnPage
{
    
    CGPoint newOffset = CGPointMake(scrollView.contentOffset.x + CGRectGetWidth(scrollView.frame), scrollView.contentOffset.y);
    
    [scrollView setContentOffset:newOffset animated:YES];
  
    
    
}
@end
