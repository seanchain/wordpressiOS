//
//  ViewController.m
//  smalltest
//
//  Created by Sean Chain on 3/15/15.
//  Copyright (c) 2015 Sean Chain. All rights reserved.
//

#import "ViewController.h"
#import "HTMLParser.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize webview;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"http://chensihang.com/blog/?json=1"];
    NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    [self.view addSubview:label];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *arr = [json objectForKey:@"posts"];
    NSMutableArray *posts = [[NSMutableArray alloc] init];
    NSMutableArray *thumbnails = [[NSMutableArray alloc] init];
    for (NSDictionary *contentdata in arr) {
        NSString *temparr = [contentdata objectForKey:@"content"];
        [posts addObject:temparr];
        NSString *tempthumbnail = [contentdata objectForKey:@"thumbnail"];
        if (tempthumbnail == nil) {
            [thumbnails addObject:@""];
        }
        else
            [thumbnails addObject:tempthumbnail];
    }
    NSLog(@"%@", thumbnails);
    NSLog(@"%@", posts[0]);
    
    
    
    for (NSString *str in posts) {
        HTMLParser *parser = [[HTMLParser alloc] initWithString:str error:nil];
        HTMLNode *node = [parser body];
        HTMLNode *code = [node findChildTag:@"pre"];
        HTMLNode *para = [node findChildTag:@"p"];
        HTMLNode *link = [node findChildTag:@"a"];
        NSLog(@"%@", [code allContents]);
    }
    NSLog(@"%lu", [posts count]);
    [webview loadHTMLString:posts[0] baseURL:[NSURL URLWithString:@"http://www.chensihang.com/blog"]];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
