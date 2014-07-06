#!/usr/bin/perl

use DBI;
use DBD::mysql;



$s = shift;
my $sql = "SELECT * FROM activity WHERE aSymbol = '" . $s . "' ORDER BY aDate";
my %a = {};

# RUN SQL
$a = runQuery($sql);

while (@row = $a->fetchrow()) {
         ($aId, $aSymbol, $aDate, $aOpen, $aClose, $aVolume, $ahigh, $aLow) = @row;
	print "$aId $aSymbol $aDate $aOpen $aClose $aVolume $ahigh $aLow \n"; 
}


sub runQuery{
        my $q = shift;
        $dbh = DBI->connect("DBI:mysql:database=stockview;host=localhost",root, $password, {RaiseError => 1});
        my $sth = $dbh->prepare("$q");
        $sth->execute;
        #$dbh->disconnect;
        return $sth;
}

