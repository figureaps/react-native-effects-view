#import "DVEffectsView.h"
#import <objc/runtime.h>

@interface UIBlurEffect (Protected)
@property (nonatomic, readonly) id effectSettings;
@end

@interface CustomBlurEffect : UIBlurEffect
@end

@implementation CustomBlurEffect

+ (instancetype)effectWithStyle:(UIBlurEffectStyle)style
{
  id result = [super effectWithStyle:style];
  object_setClass(result, self);

  return result;
}

- (id)effectSettings
{
  id settings = [super effectSettings];
  [settings setValue:@2 forKey:@"blurRadius"];
  return settings;
}

- (id)copyWithZone:(NSZone*)zone
{
  id result = [super copyWithZone:zone];
  object_setClass(result, [self class]);
  return result;
}

@end

@interface DVEffectsView ()

@property (nonatomic, strong) UIVisualEffectView *effectsView;

@end

@implementation DVEffectsView

- (instancetype)init
{
    self = [super init];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if ([self.subviews containsObject:self.effectsView] == NO) {
        CustomBlurEffect *blurEffect = [self createBlurEffect];
        self.effectsView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [self.effectsView setFrame:self.bounds];
        [self insertSubview:self.effectsView atIndex:[self.subviews count]];

        if (self.vibrant == YES) {
            UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
            UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
            [vibrancyEffectView setFrame:self.bounds];

            // vibrancy view is always first
            [[vibrancyEffectView contentView] addSubview:self.subviews[0]];
            [[self.effectsView contentView] addSubview:vibrancyEffectView];
        }
    }
}

- (CustomBlurEffect *)createBlurEffect
{
    CustomBlurEffect *blurEffect;
    if ([self.blurStyle isEqualToString:@"extraLight"]) {
        blurEffect = [CustomBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    } else if ([self.blurStyle isEqualToString:@"dark"]) {
        blurEffect = [CustomBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    } else {
        blurEffect = [CustomBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }
    return blurEffect;
}

@end
