//
//  mainViewController.m
//  SLVoicePlayer
//
//  Created by kevin on 16/8/8.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import "mainViewController.h"
#import <JSONModel.h>
#import "VoiceModel.h"
#import "YTPlayerViewController.h"
@interface mainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSArray *textArr;
@end

@implementation mainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    [self.view addSubview:self.mainTableView];
    self.textArr =@[@"播放单个音频",@"播放一个音频队列"];
    self.title  = @"微博请关注：kevin ";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    cell.textLabel.text =self.textArr[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        NSString* path = [[NSBundle mainBundle] pathForResource:@"SLplayer" ofType:@"json"];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path options:NSDataReadingUncached error:nil] options:NSJSONReadingMutableContainers error:nil];
        VoiceListModel *voice = [[VoiceListModel alloc] initWithDictionary:dictionary error:nil];
        VoiceModel *voicemodel = voice.date[0];
    
 
        [[YTPlayerViewController shareInstance]playAudioWithArray:voice.date AndCurrentRow:0 AudioType:nil];
 
        
        
    
        
        
        [self.navigationController pushViewController:[YTPlayerViewController shareInstance] animated:YES];
   
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
