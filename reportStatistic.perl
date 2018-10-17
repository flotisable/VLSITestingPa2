#!/usr/bin/perl

use strict;
use warnings;

my $stdin = "true"; # default read from stdin
my $fh;

sub getline;

# if there are arguments, read from file
if( @ARGV )
{
  $stdin = "false";

  open $fh, "<", $ARGV[0];
}

# variables to store the statistics
my $circuitName;
my $gatesNum;
my $faultNum;
my $detectedFaultNum;
my $undetectedFaultNum;
my $faultCoverage;
my $testVectorNum;
my $runtime;
# end variables to store the statistics

# main procedure
while( my $line = getline() )
{
  if( $line =~ /cputime for test pattern generation (?:[^\/]+\/)*([^\/:]+)\.[^\/]+: (\d+\.\d+s)/ )
  {
    $circuitName  = $1;
    $runtime      = $2;
  }
  if( $line =~ /number of gates =\s*(\d+)/ )
  {
    $gatesNum = $1;
  }
  if( $line =~ /total number of gate faults =\s*(\d+)/ )
  {
    $faultNum = $1;
  }
  if( $line =~ /total number of detected faults =\s*(\d+)/ )
  {
    $detectedFaultNum = $1;
  }
  if( $line =~ /total gate fault coverage =\s*(\d+\.\d+%)/ )
  {
    $faultCoverage = $1;
  }
  if( $line =~ /test vectors =\s*(\d+)/ )
  {
    $testVectorNum = $1;
  }
}
close $fh if( @ARGV );

$undetectedFaultNum = $faultNum - $detectedFaultNum;

print "$circuitName\t$gatesNum\t$faultNum\t$detectedFaultNum\t$undetectedFaultNum\t$faultCoverage\t$testVectorNum\t$runtime\n";
# end main procedure

# interface of reading
sub getline
{
  return <STDIN> if $stdin eq "true";
  return <$fh>;
}
