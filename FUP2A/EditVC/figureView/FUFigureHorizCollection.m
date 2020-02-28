//
//  FUFigureHorizCollection.m
//  FUFigureView
//
//  Created by L on 2019/4/17.
//  Copyright © 2019 L. All rights reserved.
//

#import "FUFigureHorizCollection.h"
#import "UIColor+FU.h"
#import "FUItemModel.h"

@interface FUFigureHorizCollection ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSInteger selectedIndex ;
}

@end

@implementation FUFigureHorizCollection

- (void)awakeFromNib {
    [super awakeFromNib];
    [self registerNib:[UINib nibWithNibName:@"FUFigureHorizCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"FUFigureHorizCollectionCell"];
    
    self.dataSource = self ;
    self.delegate = self ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FUAvatarEditedDoNotMethod:) name:FUAvatarEditedDoNot object:nil];
    
}

- (void)scrollCurrentToCenterWithAnimation:(BOOL)animation {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[FUManager shareInstance] getSelectedItemIndexOfSelectedType] inSection:0];
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
}


//- (void)loadCollectionData {
//	NSString * glasses = [self.glasses stringByDeletingPathExtension];
//	selectedIndex = [self.glassesArray containsObject:glasses] ? [self.glassesArray indexOfObject:glasses] : 0 ;
//	[self reloadData];
//    [self scrollCurrentToCenterWithAnimation:NO];
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[FUManager shareInstance]getItemArrayOfSelectedType].count ;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FUFigureHorizCollectionCell *cell = (FUFigureHorizCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"FUFigureHorizCollectionCell" forIndexPath:indexPath];
    
    FUItemModel *model = [[[FUManager shareInstance]getItemArrayOfSelectedType] objectAtIndex:indexPath.row];
    NSString *imagePath;
    
    imagePath = [NSString stringWithFormat:@"%@/%@",model.path,model.icon];
    UIImage * image = [UIImage imageNamed:imagePath];
    cell.imageView.image = image;
    
    NSInteger selectedIndex = [[FUManager shareInstance] getSelectedItemIndexOfSelectedType];
    cell.layer.borderWidth = selectedIndex == indexPath.row ? 2.0 : 0.0 ;
    cell.layer.borderColor = selectedIndex == indexPath.row ? [UIColor colorWithHexColorString:@"4C96FF"].CGColor : [UIColor clearColor].CGColor ;
    
    return cell ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FUItemModel *model = [[[FUManager shareInstance]getItemArrayOfSelectedType] objectAtIndex:indexPath.row];
    [[FUManager shareInstance] bindItemWithModel:model];
    
    if ([self.mDelegate respondsToSelector:@selector(didChangeGlassesWithHiddenColorViews:)])
    {
        [self.mDelegate didChangeGlassesWithHiddenColorViews:indexPath.row == 0?YES:NO];
    }
    
    [self reloadData];
    [self scrollCurrentToCenterWithAnimation:YES];
}

-(void)FUAvatarEditedDoNotMethod:(NSNotification *)not
{
    [self reloadData];
    [self scrollCurrentToCenterWithAnimation:YES];
}

@end

@implementation FUFigureHorizCollectionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.masksToBounds = YES ;
    self.layer.cornerRadius = 8.0 ;
}

@end
