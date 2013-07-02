#!/usr/bin/perl

###############################################################################
#                                                                             #
# Writen by: g33k                                                             #
# Contacts:  g33k@seznam.cz                                                   #
#            g33k@jabber.org                                                  #
# Date:      26.6.2007                                                         #
#                                                                             #
# This program is free software; you can redistribute it and/or               #
# modify it under the terms of the GNU General Public License                 #
# as published by the Free Software Foundation; either version 2              #
# of the License, or (at your option) any later version.                      #
#                                                                             #
# For bug reports and suggestions or if you just want to talk to me please    #
# contact me at g33k@seznam.cz                                                #
#                                                                             #
###############################################################################

use Getopt::Long;

sub usage {
    print "
---------------------------------------------
      $NAME $VERSION
---------------------------------------------
usage:

$NAME [--border] [--csv FILENAME] [--html FILENAME] [--separator CHARACTER]
[--help] [--version] 

--csv <input file> - path to file you want process.  
--html <output file> - path to output file.
--border - if you want to see borders of the table in your browser.
--separator character - you can specifi own separation character, like ; or : 
                        because ,(comma) is used mostly in windows envinment.          
--version - print version
--help - print short help (you exactly looking at those help)         
\n";
}

#csv2html
#--------
#Input parametr(s): global variable @lines
#Output: modified global variable @lines
#Modifi @lines from form comma separated to html table.
sub csv2html {
  foreach $line (@lines) {
    $line =~ s/\n//g;
    $line =~ s/$SP$//g;
    $line =~ s/>/&gt/ig;
    $line =~ s/</&lt/ig;
    $line =~ s/$SP/<\/td><td>/g;
    $line =~ s/<td><\/td>/<td>&nbsp;<\/td>/ig;
    #you it seems to be nonsens to have it defacto twice, but $SP could be also ";"
    #if someone have better idea how to handle this, it's wellcome.
    $line =~ s/&gt/&gt;/ig; 
    $line =~ s/&lt/&lt;/ig;
    $line = "<tr><td>$line</td></tr>\n";
  }
}

#MAIN PROGRAM

$NAME="csv2html";
$VERSION="1.0";
$html_file=undef;
$csv_file=undef;
#SP=separator
$SP=",";
$table_begin="<table>\n";

$HTMLHEADER="<html>\n  <head>\n    <meta http-equiv=\"content-type\" content=\"text/html;\">\n    <title></title>\n  </head>\n  <body>\n";
$HTLMEND="  </body>\n</html>";
  
# Parse and process options
if (!GetOptions(\%optctl,
	'html=s', 'csv=s', 'separator=s',
  'help', 'version', 'border'
	)
	|| $optctl{help} == 1 || $optctl{version} == 1 )
{
    if ($optctl{version} == 1)
    {
		  print "$NAME version $VERSION (csv to html)\n\t writen by g33k\@jabber.org\n\n";
      exit;
    }
    elsif ($optctl{help} == 1) {
      &usage();
      exit;
    }     
}

#Handel input/outputfiles check them and if something is wrong end with error message
if (defined($optctl{'html'})) { $html_file = $optctl{'html'}; }
if (defined($optctl{'csv'})) { $csv_file = $optctl{'csv'}; }
if (defined($optctl{'separator'})) { $SP = $optctl{'separator'}; }
#&ControlParametrs($html_file,$csv_file);
if ($optctl{border} == 1) {
  $table_begin="<table border=1>\n";
}

#check if input is standard or file
if (defined($csv_file)) {
  open(CSVFILE, $csv_file);
  @lines=<CSVFILE>;
  close(CSVFILE);
}
else {
  @lines=<STDIN>;
}

&csv2html();

push (@output,$HTMLHAEDER,$table_begin,@lines,"</table>",$HTMLEND);

#check if output is standar or file
if (defined($html_file)) {
  open(OUTPUT, ">$html_file");
  print OUTPUT @output;
  close(OUTPUT);
}
else {
  print @output;
}
