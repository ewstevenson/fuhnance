#!/usr/bin/perl

use GD::Graph::lines;

##             X LABEL                CONST PRICE LINE           SUBSEQUENT PRICES
@data = ( [1, 2, 3, 4, 5, 6, 7, 8], [5,5,5,5,5,5,5,5], [5, 6, 4, 6, 7, 8, 6, 5, 5.7]);

my $graph = GD::Graph::lines->new(400, 300);

$graph->set( 
      x_label           => 'X Label',
      y_label           => 'Y label',
      title             => 'Some simple graph',
      y_max_value       => 8,
      y_tick_number     => 8,
      y_label_skip      => 2 
  ) or die $graph->error;


my $gd = $graph->plot(\@data) or die $graph->error;


open(IMG, '>file.png') or die $!;
binmode IMG;
print IMG $gd->png;



