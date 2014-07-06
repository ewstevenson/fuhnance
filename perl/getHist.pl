#!/usr/bin/perl

use Finance::QuoteHist;
use Time::Local;
use Finance::TickerSymbols;
#use DBI;
#use DBD::mysql;


#@symbols = ('^DJT', '^DJI', '^DJA', '^DJU', '^NYA', '^NIN', '^NUS', '^NTM', '^NBI', 
#'^IXIC', '^IXK', '^IXF', '^IXID', '^IXIS', '^IXFN', '^IXUT', '^IXTR', '^NDX', '^MID', '^SPSUPX', '^SML',
#'^RUI', '^RUT', '^RUA', '^TNX', '^IRX', '^TYX', '^FVX', '^DJ52', 'GIH10.CME', '^XAU', 'DJH10.CBT',);
foreach my $symbol ( symbols_list( 'all' ) ) {
#foreach my $symbol ( @symbols ) {

	$q = Finance::QuoteHist->new
		(
    	symbols    => $symbol,
			start_date => '2014-01-01',
			end_date   => 'today',
		);

	foreach $row ($q->quotes()) {
		($symbol, $date, $open, $high, $low, $close, $volume) = @$row;
		$date =~ s/\//-/g;
		$date =~ s/\s+/ /g;      # Squash whitespace
            	$date =~ s/^ //;         # Strip leading space
            	$date =~ s/ $//;         # Strip trailing space

		recordTransaction($symbol, $date, $open, $high, $low, $close, $volume);
#		print "$symbol $date $close \n";
	}
}

sub recordTransaction {
	my $symbol = shift;
	my $date = shift;
	my $open = shift;
	my $high = shift;
	my $low = shift;
	my $close = shift;
	my $volume = shift;
	print "$symbol, $date, $open, $high, $low, $close, $volume \n";
#  $dbh = DBI->connect("DBI:mysql:database=stockview;host=localhost",root, $password, {RaiseError => 1});
#  my $query = "INSERT INTO activity (aSymbol, aDate, aOpen, aHigh, aLow, aClose, aVolume) VALUES ( \'$symbol\', \'$date\', \'$open\', \'$high\', \'$low\', \'$close\', \'$volume\')"; 
#	print "inserting $query \n";
#	$dbh->do($query);

}

