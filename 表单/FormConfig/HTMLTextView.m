//
//  HTMLTextView.m
//  THStandardEdition
//
//  Created by Aaron on 2019/4/18.
//  Copyright © 2019年 程元杰. All rights reserved.
//

#import "HTMLTextView.h"
@interface HTMLTextView()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end
@implementation HTMLTextView

- (void)creatUI{
    [self addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
    }];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 获取webView的高度
        NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    js = [NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];

    NSInteger width = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth"] integerValue];
    CGFloat bili = width/SCREEN_WIDTH;
    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] integerValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.rowH = height/bili;
        [self reloadCell];
        [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height/bili);//更新高度
        }];
    });
}
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
        /*- 在加载网页时添加代码 -*/
        [_webView loadHTMLString:self.moduleInfo.label baseURL:nil];
    }
    return _webView;
}

@end
