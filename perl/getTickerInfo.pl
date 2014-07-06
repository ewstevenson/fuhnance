#!/usr/bin/perl

use Finance::TickerSymbols;
use Finance::YahooQuote ;
use Finance::QuoteHist;
useExtendedQueryFormat();


open(FIL, 'lists/ticker.list');
@TICKERS = <FIL>;

print "symbol, ticker, lastPrice, marketcap, pe, avgdailyvol \n";
foreach $symbol (@TICKERS) {
my @q = getonequote $symbol;
($ticker, $coName, $lastPrice, $lastTradeDate, $lastTradeTime, $dollarChange,
        $percentChange, $vol, $avgdailyvol, $bid, $ask, $prevclose, $todayopen, $dayrange,
        $yrrange, $pe, $divpaydate, $divpershare, $divyield, $marketcap, $exchange,
        $shortratio, $yeartarget, $epsestcurrentyr, $epsnextyr, $epsestnextquart, $priceestnextyr,
        $peg, $bookvalue, $pricetobook, $pricetosales, $ebitda, $fiftydayavg, $twohundreddayavg,
        $rtask, $rtbid, $rtpercentchange, $lasttradetime, $bidchange, $rtintraday, $rtmarketcap ) = @q;


print "$ticker, $lastPrice, $shortratio \n";


}
## QUOTE ARRAY

#    0 Symbol
#    1 Company Name
#    2 Last Price
#    3 Last Trade Date
#    4 Last Trade Time
#    5 Change
#    6 Percent Change
#    7 Volume
#    8 Average Daily Vol
#    9 Bid
#    10 Ask
#    11 Previous Close
#    12 Today's Open
#    13 Day's Range
#    14 52-Week Range
#    15 Earnings per Share
#    16 P/E Ratio
#    17 Dividend Pay Date
#    18 Dividend per Share
#    19 Dividend Yield
#    20 Market Capitalization
#    21 Stock Exchange
#    22 Short ratio
#    23 1yr Target Price
#    24 EPS Est. Current Yr
#    25 EPS Est. Next Year
#    26 EPS Est. Next Quarter
#    27 Price/EPS Est. Current Yr
#    28 Price/EPS Est. Next Yr
#    29 PEG Ratio
#    30 Book Value
#    31 Price/Book
#    32 Price/Sales
#    33 EBITDA
#    34 50-day Moving Avg
#    35 200-day Moving Avg
#    36 Ask (real-time)
#    37 Bid (real-time)
#    38 Change in Percent (real-time)
#    39 Last trade with time (real-time)
#    40 Change (real-time)
#    41 Day range (real-time)
#    42 Market-cap (real-time)
