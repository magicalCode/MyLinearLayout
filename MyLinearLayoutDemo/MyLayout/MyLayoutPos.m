//
//  MyLayoutPos.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "MyLayoutPos.h"
#import "MyLayoutPosInner.h"
#import "MyLayoutBase.h"



@implementation MyLayoutPos
{
    CGFloat _offsetVal;
    CGFloat _minVal;
    CGFloat _maxVal;
    id _posVal;

}

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _view = nil;
        _pos = MGRAVITY_NONE;
        _posVal = nil;
        _posValType = MyLayoutValueType_NULL;
        _offsetVal = 0;
        _minVal = -CGFLOAT_MAX;
        _maxVal = CGFLOAT_MAX;
    }
    
    return self;
}

-(void)setNeedLayout
{
    if (_view.superview != nil && [_view.superview isKindOfClass:[MyLayoutBase class]])
    {
        MyLayoutBase* lb = (MyLayoutBase*)_view.superview;
        if (!lb.isLayouting)
            [_view.superview setNeedsLayout];
    }
    
}


-(NSNumber*)posNumVal
{
    if (_posVal == nil)
        return nil;
    
    if (_posValType == MyLayoutValueType_NSNumber)
        return _posVal;
    
    return nil;
    
}


-(MyLayoutPos*)posRelaVal
{
    if (_posVal == nil)
        return nil;
    
    if (_posValType == MyLayoutValueType_Layout)
        return _posVal;
    
    return nil;
    
}



-(MyLayoutPos*)posArrVal
{
    if (_posVal == nil)
        return nil;
    
    if (_posValType == MyLayoutValueType_Array)
        return _posVal;
    
    return nil;
    
}


-(CGFloat)margin
{
    CGFloat retVal = _offsetVal;
    
    if (self.posNumVal != nil)
        retVal +=self.posNumVal.doubleValue;
    
    return [self validMargin:retVal];
}


-(CGFloat)validMargin:(CGFloat)margin
{
    margin = MAX(_minVal, margin);
    return MIN(_maxVal, margin);
}



-(MyLayoutPos* (^)(CGFloat val))offset
{
    return ^id(CGFloat val){
        
        _offsetVal = val;
        
        [self setNeedLayout];
        
        return self;
    };
}

-(MyLayoutPos* (^)(CGFloat val))min
{
    return ^id(CGFloat val){
        
        _minVal = val;
        
        [self setNeedLayout];
        
        return self;
    };
}

-(MyLayoutPos* (^)(CGFloat val))max
{
    return ^id(CGFloat val){
        
        _maxVal = val;
        
        [self setNeedLayout];
        
        return self;
    };
}


-(MyLayoutPos* (^)(id val))equalTo
{
    return ^id(id val){
        
        _posVal = val;
        if ([val isKindOfClass:[NSNumber class]])
            _posValType = MyLayoutValueType_NSNumber;
        else if ([val isKindOfClass:[MyLayoutPos class]])
            _posValType = MyLayoutValueType_Layout;
        else if ([val isKindOfClass:[NSArray class]])
            _posValType = MyLayoutValueType_Array;
        else
            _posValType = MyLayoutValueType_NULL;
        
        [self setNeedLayout];
        
        return self;
    };
    
}


+(NSString*)posstrFromPos:(MyLayoutPos*)posobj showView:(BOOL)showView
{
    
    NSString *viewstr = @"";
    if (showView)
    {
        viewstr = [NSString stringWithFormat:@"View:%p.", posobj.view];
    }
    
    NSString *posStr = @"";
    
    switch (posobj.pos) {
        case MGRAVITY_HORZ_LEFT:
            posStr = @"LeftPos";
            break;
        case MGRAVITY_HORZ_CENTER:
            posStr = @"CenterXPos";
            break;
        case MGRAVITY_HORZ_RIGHT:
            posStr = @"RightPos";
            break;
        case MGRAVITY_VERT_TOP:
            posStr = @"TopPos";
            break;
        case MGRAVITY_VERT_CENTER:
            posStr = @"CenterYPos";
            break;
        case MGRAVITY_VERT_BOTTOM:
            posStr = @"BottomPos";
            break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@%@",viewstr,posStr];

    
}

-(NSString*)description
{
    NSString *posValStr = @"";
    switch (_posValType) {
        case MyLayoutValueType_NULL:
            posValStr = @"nil";
            break;
        case MyLayoutValueType_NSNumber:
            posValStr = [_posVal description];
            break;
        case MyLayoutValueType_Layout:
            posValStr = [MyLayoutPos posstrFromPos:_posVal showView:YES];
            break;
        case MyLayoutValueType_Array:
        {
            posValStr = @"[";
            for (NSObject *obj in _posVal)
            {
                if ([obj isKindOfClass:[MyLayoutPos class]])
                {
                    posValStr = [posValStr stringByAppendingString:[MyLayoutPos posstrFromPos:(MyLayoutPos*)obj showView:YES]];
                }
                else
                {
                    posValStr = [posValStr stringByAppendingString:[obj description]];

                }
                
                if (obj != [_posVal lastObject])
                    posValStr = [posValStr stringByAppendingString:@", "];
                
            }
            
            posValStr = [posValStr stringByAppendingString:@"]"];
            
        }
        default:
            break;
    }

    return [NSString stringWithFormat:@"%@=%@, Offset=%g, Max=%g, Min=%g",[MyLayoutPos posstrFromPos:self showView:NO], posValStr, _offsetVal, _maxVal == CGFLOAT_MAX ? NAN : _maxVal , _minVal == -CGFLOAT_MAX ? NAN : _minVal];
   
}



@end

