#!/usr/bin/perl

# INCLUDES
use DBI;
use DBD::mysql;

## HOW QUICKLY AND HOW FAR DOES THE PRICE OF A STOCK MOVE ONCE IT HITS BEGIN_TARGET DOLLARS?

# GRAB THE DATE AND TICKER OF ANY STOCK THAT CLOSES BETWEEN BEGIN_TARGET AND END_TARGET.






# DECLARE VARIABLES 
@dyn_sql = ();
my %a = {};
%list = {};
$BEGIN_TARGET = 5;
$END_TARGET = 6;
$MAX_DAYS_HOLD = 9999;

# GET ALL MARKET HISTORY AND ORDER BY DATE
my $sql = "SELECT * FROM activity WHERE 1 ORDER BY aSymbol, aDate ASC;";

# RUN SQL
$a = runQuery($sql);

while (@row = $a->fetchrow()) {

## LOOP THROUGH EACH STOCK, SAVE THE DATE THE STOCK FIRST HIT PRICE TARGET, INCREMENT DAYS HOLD UNTIL MAX DAYS HOLD OR MAX_PRICE REACHED, PRINT DAYS HELD AND TICKER

	# EXPLODE ROW INTO VARIABLES
	($aId, $aSymbol, $aDate, $aOpen, $aClose, $aVolume, $ahigh, $aLow) = @row;

	# WHEN SYMBOL REACHS BEGIN_TARGET FOR THE FIRST TIME, RECORD THE DATE;
       if ( 
	# IF CLOSE PRICE IS GREATER THAN OR EQUAL TO BEGIN_TARGET
	($aClose >= $BEGIN_TARGET) &&
	# AND PRICE IS LESS THAN END_TARGET
	($aClose < $END_TARGET) && 
	# AND THE PRICE HAS NOT YET BEEN REACHED BEFORE
	(!$list{$aSymbol}{'REACHED_BEGIN_TARGET'})) {
		# THEN SAVE THE DATE THE BEGIN PRICE TARGET WAS FIRST REACHED
		$list{$aSymbol}{'REACHED_BEGIN_TARGET'} = $aDate;
		$DAYS_HELD = 0;
		$PERIOD_HIGH = 0;
#		print "$aSymbol hit $BEGIN_TARGET on $aDate \n";

	} elsif (
	  # OTHERWISE, IF PRICE TARGET HAS BEEN SET
	  ($list{$aSymbol}{'REACHED_BEGIN_TARGET'}) && 
	  # AND THE END TARGET HAS NOT BEEN SET
	  (!$list{$aSymbol}{'REACHED_END_TARGET'}) &&
          # AND PRICE IS LESS THAN END_TARGET
          ($aClose < $END_TARGET) &&
	  # AND WE HAVE NOT HIT OUR MAX DAYS TO HOLD 
	  ($DAYS_HELD < $MAX_DAYS_HOLD)) {
		# THEN INCREMENT THE DAYS HELD
		$DAYS_HELD++;
#		print "$DAYS_HELD days since $aSymbol reached $BEGIN_TARGET \n";
		# CHECK IF WE HAVE HIT A NEW PERIOD HIGH
		$PERIOD_HIGH = $aClose if ($aClose > $PERIOD_HIGH);
	} elsif  (
		# PRICE HAS REACHED END TARGET FOR THE FIRST TIME
		# CHECK THAT BEGIN TARGET IS SET
		($list{$aSymbol}{'REACHED_BEGIN_TARGET'}) &&
		# AND THE END TARGET HAS NOT BEEN SET
		(!$list{$aSymbol}{'REACHED_END_TARGET'}) &&
		# AND DAYS HELD IS GREATER THAN 0
		($DAYS_HELD > 0) &&
		# AND THE PRICE IS AT OR ABOVE END_TARGET
		($aClose >= $END_TARGET)) {
			$list{$aSymbol}{'REACHED_END_TARGET'}  = $aDate;

	               # if ($DAYS_HELD < 3) { 
		print "$aSymbol,$list{$aSymbol}{'REACHED_BEGIN_TARGET'},$list{$aSymbol}{'REACHED_END_TARGET'},$BEGIN_TARGET,$END_TARGET,$DAYS_HELD,$MAX_DAYS_HOLD \n";
			#}

	# IF WE HIT MAX HOLDING DAYS
	} elsif (
		($DAYS_HELD == $MAX_DAYS_HOLD) &&
		(!$list{$aSymbol}{'REACHED_END_TARGET'}) &&
		($list{$aSymbol}{'REACHED_BEGIN_TARGET'}) 	
	) {
	#	print "$aSymbol, $PERIOD_HIGH, $DAYS_HELD \n";
		$DAYS_HELD = $MAX_DAYS_HOLD + 1;
	}
}

sub runQuery{
        my $q = shift;
        $dbh = DBI->connect("DBI:mysql:database=stockview;host=localhost",root, $password, {RaiseError => 1});
        my $sth = $dbh->prepare("$q");
        $sth->execute;
        #$dbh->disconnect;
        return $sth;
}

