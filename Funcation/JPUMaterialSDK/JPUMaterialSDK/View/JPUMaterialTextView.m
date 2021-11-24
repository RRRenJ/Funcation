//
//  JPUMaterialTextView.m
//  EditVideoText
//
//  Created by foundao on 2021/10/20.
//

#import "JPUMaterialTextView.h"

@interface JPUMaterialTextView ()

@property (nonatomic,weak) UILabel *placehoderLabel;

@end

@implementation JPUMaterialTextView



- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
   
        UILabel *placehoderLabel = [[UILabel alloc]init];
        placehoderLabel.numberOfLines = 0;
        [self addSubview:placehoderLabel];
        self.placehoderLabel = placehoderLabel;
        self.placehoderColor = [UIColor lightGrayColor];
        self.font = [UIFont systemFontOfSize:14];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    UILabel *placehoderLabel = [[UILabel alloc]init];
    placehoderLabel.numberOfLines = 0;
    [self addSubview:placehoderLabel];
    self.placehoderLabel = placehoderLabel;
    self.placehoderColor = [UIColor lightGrayColor];
    self.font = [UIFont systemFontOfSize:14];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    
}
- (void)textDidChange{
    
    self.placehoderLabel.hidden = self.text.length != 0;
    
}

- (void)setText:(NSString *)text{
    [super setText:text];
    [self textDidChange];
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    self.placehoderLabel.font = font;
    [self setNeedsLayout];
}

- (void)setPlacehoderColor:(UIColor *)placehoderColor{
    _placehoderColor = placehoderColor;
    self.placehoderLabel.textColor = placehoderColor;
}

- (void)setIsAutoHeight:(BOOL)isAutoHeight{
    _isAutoHeight = isAutoHeight;
    [self setNeedsLayout];
}

- (void)setPlacehoder:(NSString *)placehoder{
    
    _placehoder = [placehoder copy];
    self.placehoderLabel.text = placehoder;
    [self setNeedsLayout];
}

- (void)layoutSubviews{
   
    [super layoutSubviews];
    CGSize maxSize = CGSizeMake(self.placehoderLabel.frame.size.width-10, MAXFLOAT);
    CGRect LabelFrame = [self.placehoder boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.placehoderLabel.font,NSFontAttributeName, nil] context:nil];
    self.placehoderLabel.frame = CGRectMake(5, 8, self.frame.size.width - 10, LabelFrame.size.height);
    
    CGRect textFrame = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width-10,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil] context:nil];

    
    if (textFrame.size.height > self.frame.size.height && self.isAutoHeight) {
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, textFrame.size.height);
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

@end
