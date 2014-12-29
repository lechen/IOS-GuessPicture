//
//  ViewController.m
//  0327_超级猜图
//
//  Created by LE on 14/12/19.
//  Copyright (c) 2014年 LE. All rights reserved.
//

#import "ViewController.h"
#import "PictureInfoModel.h"

@interface ViewController () <UIAlertViewDelegate,UIActionSheetDelegate>
/**
 *  成绩
 */
@property (weak, nonatomic) IBOutlet UIButton *scoreNUm;
/**
 *  下一题按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *nextQuestionBtn;
/**
 *  帮助按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;
/**
 *  提示按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *hintBtn;
/**
 *  大图点击事件
 */
- (IBAction)bigPictureClick;
/**
 *  “下一题”的click事件
 */
- (IBAction)nextPicture;
/**
 *  点击主图片
 */
- (IBAction)mainBtnClick;
/**
 *  提示按钮单击事件
 */
- (IBAction)hintClick;

/**
 *  所有PictureInfo
 */
@property(nonatomic,strong) NSMutableArray *pictureArray;
/**
 *  当前第几题
 */
@property(nonatomic,assign) int index;
/**
 *  主图片按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mainBtn;
/**
 *  主图片的title
 */
@property (weak, nonatomic) IBOutlet UILabel *pTitle;
/**
 *  序号
 */
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
/**
 *  盛放answerBtn的view
 */
@property (weak, nonatomic) IBOutlet UIView *answerView;
/**
 *  盛放选项的view
 */
@property (weak, nonatomic) IBOutlet UIView *optionsView;
/**
 *  黑色背景
 */
@property (weak,nonatomic) UIButton *cover;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.index = -1;
    [self nextPicture];
    
}

- (IBAction)bigPictureClick {
    //新建阴影图片
    UIButton *cover = [[UIButton alloc] init];
    self.cover = cover;
    //设置frame
    self.cover.frame = self.view.bounds;
    //设置颜色
    self.cover.backgroundColor = [UIColor blackColor];
    self.cover.alpha = 0.0;
    [self.view addSubview:self.cover];
    
    //为阴影添加单击事件
    [self.cover addTarget:self action:@selector(smallPicture) forControlEvents:UIControlEventTouchUpInside];
    
    //mainBtn换到最前面
    [self.view bringSubviewToFront:self.mainBtn];
    
    //mainBtn放大，并调整位置
    CGFloat mainBtnX = 0;
    CGFloat mainBtnY = (self.view.frame.size.height - self.view.frame.size.width) * 0.5;
    CGFloat mainBtnW = self.view.frame.size.width;
    CGFloat mainBtnH = mainBtnW;
    
    //动画效果
    [UIView animateWithDuration:1.0 animations:^{
        //设置透明度
        self.cover.alpha = 0.7;
        self.mainBtn.frame = CGRectMake(mainBtnX, mainBtnY, mainBtnW, mainBtnH);
    }];
    
}
/**
 *  移除阴影，并恢复小图
 */
-(void)smallPicture{
    
    [UIView animateWithDuration:1.0 animations:^{
        //背景透明度变为0，然后删除
        self.cover.alpha = 0;
        //mainBtn变回原大小，原位置
        self.mainBtn.frame = CGRectMake(85, 80, 150, 150);
    } completion:^(BOOL finished) {
        //移除阴影(从内存中移除)
        [self.cover removeFromSuperview];
        self.cover = nil;
    }];
    
}

-(IBAction)nextPicture{
    //判断是否是最后一题
    if (self.index == self.pictureArray.count - 1) {
        
        //从底部弹窗
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"恭喜通关！" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:@"其他", nil];
        [actionSheet showInView:self.view];
        
        /**
         delegate:self表明用当前controller做代理，来监听alertView，该controller要实现UIAlertViewDelegate协议，可以实现该协议内的方法对alertView的监听；
        //屏幕中间弹框
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"恭喜通关！" message:@"敬请期待，后续更新！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 10;
        [alertView show];
         

        //第二个弹窗，用tag区别弹窗
        UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"恭喜通关！" message:@"敬请期待，后续更新！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView2.tag = 20;
        [alertView2 show];
         */
        return;
    }
    
    self.index++;
    //根据index获取对应的数据模型
    PictureInfoModel *pictureInfo = self.pictureArray[self.index];
    
    //设置显示内容
    self.pTitle.text = pictureInfo.title;
    self.numLabel.text = [NSString stringWithFormat:@"%d/%d",self.index + 1,self.pictureArray.count];
    [self.mainBtn setImage:[UIImage imageNamed:pictureInfo.icon] forState:UIControlStateNormal];
    
    //防止数组越界
    self.nextQuestionBtn.enabled = self.index != (self.pictureArray.count - 1);
    
    //添加答案框
    [self addAnswerBtn:pictureInfo];
    
    //添加待选项
    [self addOptionBtn:pictureInfo];

}
/**
 *  监听“取消”按钮
 */
-(void)actionSheetCancel:(UIActionSheet *)actionSheet{
    NSLog(@"监听取消按钮");
}

/**
 *  实现UIAlertViewDelegate的该方法，可以对过按钮监听
 */
//-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (alertView.tag == 10) {
//        NSLog(@"监听第一个按钮");
//    }else if(alertView.tag == 20){
//        NSLog(@"监听第二个按钮");
//    }
//}
/**
 * 添加待选项
 */
-(void) addOptionBtn:(PictureInfoModel *)pictureInfo{
    //删除上一题的待选项
    [self.optionsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int count = pictureInfo.options.count;
    for (int i = 0; i < count; i++) {
        UIButton *optionBtn = [[UIButton alloc] init];
        //设置背景色
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];
        
        //设置文字、  颜色
        [optionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [optionBtn setTitle:pictureInfo.options[i] forState:UIControlStateNormal];
        
        //设置位置
        int totalCol = 7;
        int row = i / totalCol;
        int col = i % totalCol;
        CGFloat optionBtnW = 35;
        CGFloat optionBtnH = 35;
        CGFloat margin = 10;
        CGFloat leftMargin = (self.optionsView.frame.size.width - optionBtnW * totalCol - margin * (totalCol -1)) * 0.5;
        CGFloat optionBtnX = leftMargin + (optionBtnW + margin) * col;
        CGFloat optionBtnY = row * (optionBtnH + margin);
        optionBtn.frame = CGRectMake(optionBtnX, optionBtnY, optionBtnW, optionBtnH);
        
        //添加到optionView
        [self.optionsView addSubview:optionBtn];
        
        //为optionBut加事件
        [optionBtn addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 *  待选项点击事件
 */
-(void)optionClick:(UIButton *)optionBtn{
    //查出答案框中第一个空白的框,并赋值
    for (UIButton *answerBtn in self.answerView.subviews) {
        NSString *answerTitle = [answerBtn titleForState:UIControlStateNormal];
        if (answerTitle == nil) {
            //该optionBtn文字添加到answerBtn上
            [answerBtn setTitle:[optionBtn titleForState:UIControlStateNormal] forState:UIControlStateNormal];
            [answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            //该optionBtn消失
            optionBtn.hidden = YES;
            break;
        }
        
    }
    
    //判断答案框是否填满
    BOOL isFull = YES;
    NSMutableString *tempAnswer = [[NSMutableString alloc] init];
    //判断答案是否正确
    for (UIButton *btn in self.answerView.subviews) {
        NSString *answerTitle = [btn titleForState:UIControlStateNormal];
        
        if (answerTitle.length == 0) {
            isFull = NO;
            break;
        }else{
            [tempAnswer appendString:answerTitle];
        }

    }
    
    //判断答案
    if (isFull) {
        PictureInfoModel *pictureInfo = self.pictureArray[self.index];
        if ([tempAnswer isEqualToString:pictureInfo.answer]) {
            //答案框里文字变色
            for (UIButton *btn in self.answerView.subviews) {
                [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            }
            
            //加分
            int score = [self.scoreNUm titleForState:UIControlStateNormal].intValue;
            [self.scoreNUm setTitle:[NSString stringWithFormat:@"%d",score + 1000] forState:UIControlStateNormal];
            
            //下一题
            [self performSelector:@selector(nextPicture) withObject:nil afterDelay:1.0];
        }else{
            //答案框里字体变红
            for (UIButton *answerBtn in self.answerView.subviews) {
                [answerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
        
    }
}

/**
 *  添加答案框
 */
-(void) addAnswerBtn:(PictureInfoModel *)pictureInfo{
    //删除上一题的答案框
    [self.answerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int answerLength = pictureInfo.answer.length;
    //加载答案框
    for (int i = 0; i < answerLength; i++) {
        UIButton *answerBtn = [[UIButton alloc] init];
        //设置字体颜色
        [answerBtn setTintColor:[UIColor blackColor]];
        //设置按钮颜色
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        //设置位置
        CGFloat margin = 10;
        CGFloat answerBtnH = 35;
        CGFloat answerBtnW = 35;
        CGFloat leftMargin = (self.answerView.frame.size.width - (answerBtnW + margin) * answerLength + margin) * 0.5;
        CGFloat answerBtnX =  leftMargin + (answerBtnW + margin) * i;
        answerBtn.frame = CGRectMake(answerBtnX, 0, answerBtnW, answerBtnH);
        [self.answerView addSubview:answerBtn];
        
        //为answerBtn加事件
        [answerBtn addTarget:self action:@selector(answerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 *  答案点击事件
 */
-(void) answerBtnClick:(UIButton *)answerBtn{
    for (UIButton * optionBtn in self.optionsView.subviews) {
        if ([optionBtn.currentTitle isEqualToString:answerBtn.currentTitle] && optionBtn.hidden == YES) {
            optionBtn.hidden = NO;
            break;
        }
    }
    //该答案框清空
    [answerBtn setTitle:nil forState:UIControlStateNormal];
}

/**
 *  住图片按钮点击
 */
- (IBAction)mainBtnClick {
    //为放大后的图片添加点击事件
    if (self.cover != nil) {
        [self smallPicture];
    }else{
        [self bigPictureClick];
    }
}
/**
 *  提示按钮单击事件
 */
- (IBAction)hintClick {
    //清空答案框内容
    for (UIButton *btn in self.answerView.subviews) {
        //[btn setTitle:nil forState:UIControlStateNormal];
        [self answerBtnClick:btn];
    }
    //为第一个答案框赋值
    PictureInfoModel *pictureInfo = self.pictureArray[self.index];
    NSString *firstStr = [pictureInfo.answer substringToIndex:1];
    NSLog(@"----------------%@",firstStr);
    for (UIButton *btn in self.optionsView.subviews) {
        if ([firstStr isEqual:[btn titleForState:UIControlStateNormal]]) {
            [self optionClick:btn];
            break;
        }
    }
    
    //减分
    int score = [self.scoreNUm titleForState:UIControlStateNormal].intValue;
    [self.scoreNUm setTitle:[NSString stringWithFormat:@"%d",score - 1000] forState:UIControlStateNormal];
    
}

/**
 *  控制状态栏的样式
 */
- (UIStatusBarStyle)preferredStatusBarStyle{
    // 白色
    return UIStatusBarStyleLightContent;
}

/**
 *  重写pictureArray的getter方法;
 *
 *  @return 装有PictureInfoModel的NSArray
 */
-(NSArray *)pictureArray{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"questions" ofType:@"plist"];
    NSArray  *objs = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *pictures = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in objs) {
        PictureInfoModel *pictureInfo = [PictureInfoModel pictureWithDictionary:dict];
        [pictures addObject:pictureInfo];
    }
    _pictureArray = pictures;
    return _pictureArray;
}

@end
