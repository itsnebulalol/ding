#include "DIRootListController.h"

@implementation DIRootListController
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
        appearanceSettings.tintColor = [UIColor colorWithRed: 0.76 green: 0.61 blue: 0.83 alpha: 1.00];
        appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithWhite:0 alpha:0];
        self.hb_appearanceSettings = appearanceSettings;

		self.applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" 
                                    style:UIBarButtonItemStylePlain
                                    target:self 
                                    action:@selector(apply:)];
        self.applyButton.tintColor = [UIColor colorWithRed: 0.76 green: 0.61 blue: 0.83 alpha: 1.00];
		self.navigationItem.rightBarButtonItem = self.applyButton;
    }
    return self;
}

- (void)apply:(id)sender {
	pid_t pid;
	const char *args[] = {"sh", "-c", "sbreload", NULL};
	posix_spawn(&pid, ROOT_PATH("/bin/sh"), NULL, NULL, (char *const *)args, NULL);
}
@end
