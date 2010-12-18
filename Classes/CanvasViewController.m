    //
//  CanvasViewController.m
//  CanvasKit
//
//  Created by JM on 15/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CanvasViewController.h"


@interface CanvasViewController()
- (void) addRandomTileDictionaries;
@end

@implementation CanvasViewController

@synthesize canvasView = canvasView_;
@synthesize tileDictionaries = tileDictionaries_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
	{
		tileDictionaries_ = [[NSMutableArray alloc] init];
		[self addRandomTileDictionaries];
    }
    return self;
}

- (void) addRandomTileDictionaries;
{
	for (int i=0; i<7; i++)
	{
		int tileIndex = [self.tileDictionaries count];
		NSDictionary * tileDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
											[NSString stringWithFormat:@"%d", tileIndex], @"ident",
											[NSNumber numberWithInt:tileIndex], @"tileIndex",
											nil
										 ];
		[self.tileDictionaries addObject:tileDictionary];
	}
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	[super loadView];
	canvasView_ = [[CanvasView alloc] initWithFrame:CGRectZero withDataSource:self];
	canvasView_.canvasControlDelegate = self;
	canvasView_.autoresizesSubviews = YES;
	[self.view addSubview:canvasView_];
	canvasView_.frame = self.view.bounds;

}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[self.canvasView setNeedsLayout];			
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.canvasView = nil;
}


- (void)dealloc {
	self.canvasView = nil;
	self.tileDictionaries = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark CanvasViewDelegate

- (void) canvasViewDidScrollPrevious:(CanvasView *) canvasView;
{
	NSLog(@"canvasViewDidScrollPrevious");
}

- (void) canvasViewDidScrollNext:(CanvasView *) canvasView;
{
	NSLog(@"canvasViewDidScrollNext");
}

- (void) canvasViewDidScrollToLastPage:(CanvasView *) canvasView;
{
	NSLog(@"canvasViewDidScrollToLastPage");
	[self addRandomTileDictionaries];
	[canvasView refreshTiles];
}


#pragma mark -
#pragma mark Canvas Data Source

- (NSArray *) tileDictionariesInRange:(NSRange) range;
{

	if (isnan(range.location) || isnan(range.length) || range.length == 0 || range.location < 0 || range.location >= [self.tileDictionaries count])
	{
		return nil;
	}
	
	if (range.location + range.length >= [self.tileDictionaries count])
	{
		range.length = [self.tileDictionaries count] - range.location;
	}

	
	NSLog(@"Requested tiles: %d -> %d (of %d)", range.location, range.location + range.length, [self.tileDictionaries count]);	
	return [self.tileDictionaries subarrayWithRange:range];
}

- (long) totalNumberOfTiles
{
	return [self.tileDictionaries count];
}

- (CGSize) pageMargin;
{
	return CGSizeMake(0., 0.);	
}

- (CGSize) tileDimensions;
{
	return CGSizeMake(120., 100.);
}


@end
