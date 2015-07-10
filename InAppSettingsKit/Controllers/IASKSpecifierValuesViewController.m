//
//  IASKSpecifierValuesViewController.m
//  http://www.inappsettingskit.com
//
//  Copyright (c) 2009:
//  Luc Vandal, Edovia Inc., http://www.edovia.com
//  Ortwin Gentz, FutureTap GmbH, http://www.futuretap.com
//  All rights reserved.
// 
//  It is appreciated but not required that you give credit to Luc Vandal and Ortwin Gentz, 
//  as the original authors of this code. You can give credit in a blog post, a tweet or on 
//  a info page of your app. Also, the original authors appreciate letting them know if you use this code.
//
//  This code is licensed under the BSD license that is available at: http://www.opensource.org/licenses/bsd-license.php
//

#import "IASKSpecifierValuesViewController.h"
#import "IASKSpecifier.h"
#import "IASKSettingsReader.h"
#import "IASKMultipleValueSelection.h"
#import "IAKTableViewCell.h"

#define kCellValue      @"kCellValue"

@implementation IASKSpecifierValuesViewController

@synthesize tableView=_tableView;
@synthesize currentSpecifier=_currentSpecifier;
@synthesize settingsReader = _settingsReader;
@synthesize settingsStore = _settingsStore;
@synthesize delegate = _delegate;

- (void)setSettingsStore:(id <IASKSettingsStore>)settingsStore {
    _settingsStore = settingsStore;
    _selection.settingsStore = settingsStore;
}

- (void)loadView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    self.view = _tableView;

    _selection = [IASKMultipleValueSelection new];
    _selection.tableView = _tableView;
    _selection.settingsStore = _settingsStore;
}

- (void)viewWillAppear:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(settingsViewController:backgroundViewForableView:)]) {
      self.tableView.backgroundView = [self.delegate settingsViewController:self backgroundViewForableView:self.tableView];
    }
    
    if (_currentSpecifier) {
        [self setTitle:[_currentSpecifier title]];
        _selection.specifier = _currentSpecifier;
    }
    
    if (_tableView) {
        [_tableView reloadData];

		// Make sure the currently checked item is visible
        [_tableView scrollToRowAtIndexPath:_selection.checkedItem
                          atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[_tableView flashScrollIndicators];
	[super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    _selection.tableView = nil;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark UITableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_currentSpecifier multipleValuesCount];
}

- (NSString *)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(settingsViewController:tableView:viewForHeaderForSection:)]) {
        return [self.delegate settingsViewController:self tableView:tableView viewForHeaderForSection:section];
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView viewForHeaderInSection:section] && [self.delegate respondsToSelector:@selector(settingsViewController:tableView:heightForHeaderForSection:)]) {
        CGFloat result = [self.delegate settingsViewController:self tableView:tableView heightForHeaderForSection:section];
        
        if (result != 0) {
            return result;
        }
        
    }
    NSString *title;
    if ((title = [self tableView:tableView titleForHeaderInSection:section])) {
        CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:[UIFont labelFontSize]]
                        constrainedToSize:CGSizeMake(tableView.frame.size.width - 2*kIASKHorizontalPaddingGroupTitles, INFINITY)
                            lineBreakMode:NSLineBreakByWordWrapping];
        return size.height+kIASKVerticalPaddingGroupTitles;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [_currentSpecifier footerText];
}

- (UIView *)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(settingsViewController:tableView:viewForFooterForSection:)]) {
        return [self.delegate settingsViewController:self tableView:tableView viewForFooterForSection:section];
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    if ([self tableView:tableView viewForFooterInSection:section] && [self.delegate respondsToSelector:@selector(settingsViewController:tableView:heightForFooterForSection:)]) {
        CGFloat result = [self.delegate settingsViewController:self tableView:tableView heightForFooterForSection:section];
        
        if (result > 0) {
            return result;
        }
        
    }
    NSString *title;
    if ((title = [self tableView:tableView titleForFooterInSection:section])) {
        CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:[UIFont labelFontSize]]
                        constrainedToSize:CGSizeMake(tableView.frame.size.width - 2*kIASKHorizontalPaddingGroupTitles, INFINITY)
                            lineBreakMode:NSLineBreakByWordWrapping];
        return size.height+kIASKVerticalPaddingGroupTitles;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IAKTableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:kCellValue];
    NSArray *titles         = [_currentSpecifier multipleTitles];
	
    if (!cell) {
        cell = [[IAKTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellValue];
    }

    [_selection updateSelectionInCell:cell indexPath:indexPath];

    @try {
		[[cell textLabel] setText:[self.settingsReader titleForStringId:[titles objectAtIndex:indexPath.row]]];
	}
	@catch (NSException * e) {}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_selection selectRowAtIndexPath:indexPath];
}

- (CGSize)contentSizeForViewInPopover {
    return [[self view] sizeThatFits:CGSizeMake(320, 2000)];
}

@end
