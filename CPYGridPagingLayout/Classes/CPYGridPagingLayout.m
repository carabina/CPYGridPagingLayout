//
//  CPYGridPagingLayout.m
//  CPYGridPagingLayout
//
//  Created by ciel on 2016/11/10.
//  Copyright © 2016年 CPY. All rights reserved.
//

#import "CPYGridPagingLayout.h"

@interface CPYGridPagingLayout ()

@property (nonatomic, assign) CGFloat itemWidth;

@property (nonatomic, assign) CGFloat itemHeight;

@property (nonatomic, strong) NSArray <UICollectionViewLayoutAttributes *> *attributes;

@property (nonatomic, assign) NSInteger pageNumber;

@end

@implementation CPYGridPagingLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setupDefault];
}

- (void)setupDefault {
    _numberOfLine = 2;
    _lineSpacing = 0;
    _itemSpacing = 0;
    _cloumOfLine = 4;
}

- (void)prepareLayout {
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    if (count == 0) {
        return;
    }
    
    NSInteger possiblePages = count / (self.numberOfLine * self.cloumOfLine);
    NSInteger reminder = count % (self.numberOfLine * self.cloumOfLine);
    self.pageNumber = (reminder == 0 ? possiblePages : (possiblePages + 1));
    
    CGFloat availableWidht = CGRectGetWidth(self.collectionView.bounds) - (self.cloumOfLine - 1) * self.itemSpacing;
    self.itemWidth = availableWidht / self.cloumOfLine;
    
    
    CGFloat avilableHeight = CGRectGetHeight(self.collectionView.bounds) - (self.numberOfLine - 1) * self.lineSpacing;
    self.itemHeight = avilableHeight / self.numberOfLine;
    
    NSMutableArray <NSNumber *> *xArr = [NSMutableArray array];
    CGFloat x = 0;
    for (int i = 0; i < self.cloumOfLine; i++) {
        [xArr addObject:@(x)];
        x += self.itemWidth;
        x += self.itemSpacing;
    }
    
    NSMutableArray *attributes = [NSMutableArray array];
    for (int i = 0 ; i < count; i++) {
        NSInteger pageItemNumber = self.cloumOfLine * self.numberOfLine;
        NSInteger page = i / pageItemNumber;
        
        NSInteger colum = i % pageItemNumber % self.cloumOfLine;
        NSInteger line = i % pageItemNumber / self.cloumOfLine;
        
        CGFloat x = xArr[colum].floatValue;
        x += page * CGRectGetWidth(self.collectionView.bounds);
        
        CGFloat y = (self.lineSpacing + self.itemHeight) * line;
        
        CGRect frame = CGRectMake(x, y, self.itemWidth, self.itemHeight);
        
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        attribute.frame = frame;
        [attributes addObject:attribute];
    }
    self.attributes = [attributes copy];
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(CGRectGetWidth(self.collectionView.bounds) * self.pageNumber, CGRectGetHeight(self.collectionView.bounds));
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *arr = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attribte in self.attributes) {
        if (CGRectIntersectsRect(attribte.frame, rect)) {
            [arr addObject:attribte];
        }
    }
    return [arr copy];
}

@end
