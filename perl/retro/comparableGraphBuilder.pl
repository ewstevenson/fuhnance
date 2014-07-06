#!/usr/bin/perl

###
#
#  THIS NEED TO BE UPDATED TO READ FROM A DB
#


# INCLUDES
use GD::Graph::lines;
use List::Util qw[min max];

# TAKE FILENAME AS ARGUMENT
#$file = shift;


@f = `ls output/`;

foreach $file (@f) {
$file = "output/$file";
open(FIL, $file) || die "couldnt open $file";
@lines = <FIL>;
close FIL;

# INITIALIZE VARIABLES
$PRICE_BASE = 5;
$i = 0;
@X_LABEL = ();
@X_VALUES = ();
@X_CONSTANT_LINE = ();

# LOOP THROUGH EACH LINE IN THE FILE
foreach $l (@lines) {

	# EXPLODE ROW INTO PARTS
	($aId, $aSymbol, $aDate, $aOpen, $aClose, $aVolume, $aHigh, $aLow) = split /\s+/, $l;
	
	# CALCULATE PERCENT CHANGE USING PRICE_BASE CONSTANT AS BASE PRICE
	$percent_change = ($aClose - $PRICE_BASE) / $PRICE_BASE;

	# PRINT LINE NUMBER (DAYS AFTER HIT PRICE BASE) AND PERCENT CHANGE FROM PRICE BASE
	#print "$i,$percent_change \n";

	# STUFF DAY AFTER AND PERCENT CHANGE INTO ARRAY FOR CONSUMPTION BY GD::GRAPH
	$X_LABEL[$i] = $i;
	$Y_VALUES[$i] =  $percent_change;

	# USING 0 BECAUSE IT IS BASELINE FOR PERCENT CHANGE, FOR NOMINAL CHARTS USE $PRICE_BASE
	$X_CONSTANT_LINE[$i] = 0;
	$i++;
}

# GET THE MAX Y VALUE FOR CONSUMPTION BY GD::GRAPH
$Y_MAX = max(@Y_VALUES);

# BUILD DATA OBJECT X_LABEL, X_CONSTANT_LINE (PRICE_BASE), Y_VALUES
@data = ([@X_LABEL], [@X_CONSTANT_LINE], [@Y_VALUES]);

# CREATE NEW GD
my $graph = GD::Graph::lines->new(400, 300);

# SET GD VALUES
$graph->set(
      x_label           => 'Days After',
      y_label           => 'Percent Change',
      title             => "$aSymbol",
      y_max_value       => "$Y_MAX",
      y_tick_number     => .02,
      y_label_skip      => 1,
      transparent	=> 0,
  ) or die $graph->error;

# BUILD PLOT
my $gd = $graph->plot(\@data) or die $graph->error;
}

# OPEN FILE HANDLE
open(IMG, ">charts/bigchart.png") or die $!;
binmode IMG;

# PRINT IT TO DISK
print IMG $gd->png;
