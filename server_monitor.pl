#!/usr/bin/perl

use warnings;
use strict;
use Text::ASCIITable;
use Sys::Hostname;
use Filesys::DiskSpace;
use Socket;


my $title = ` banner server_mon `;
my $table = Text::ASCIITable->new({ headingText => $title });
my $ping = `ping -c 1 google.com &> /dev/null && echo "Internet:  Connected" || echo  "Internet: Disconnected" `;
my $os =  `uname -o`;
my $arc = `uname -m`;
my $kern = `uname -r`;
chomp(my ($short_hostname) = `hostname | cut -f 1 -d.`);
my $addr = inet_ntoa((gethostbyname(hostname))[4]);
my $ipE = `curl -s ipecho.net/plain;echo`;
my $dns = `cat /etc/resolv.conf | sed '1 d'|  awk '{print \$2}'`;
my $cpu = `mpstat | tail -n +2`;
my $user = $ENV{LOGNAME} || $ENV{USER} || getpwuid($<);
my $ram = `free -m `;
my $rom = `df -h  `;
my $serviceN =`systemctl status nginx | head -n 3`;
my $serviceA =`systemctl status apache2 | head -n 3`;
my $up = `uptime | awk '{print \$3,\$4}' | cut -f1 -d,`;
my $time = `date "+\%F \%k:\%M:\%S \%Z"`;


my $dir = "/home";
my $warning_level=10;
my ($fs_type, $fs_desc, $used, $avail, $fused, $favail) = df $dir;


$table->setCols('Ping', 'OS Type', 'Architecture', 'Kernel');

$table->addRow( $ping , $os, $arc, $kern,);

$table->addRowLine();

$table->addRow( 'Services');

$table->addRowLine();

$table->addRow( $serviceN );

$table->addRow($serviceA );

$table->addRowLine();

$table->addRow('DNS','Internal IP','External IP', 'Report Time');

$table->addRowLine();

$table->addRow( $dns, $addr, $ipE, $time );

$table->addRowLine();

$table->addRow('Cpu Usage','Up Time','User','Hostname');

$table->addRowLine();

$table->addRow( $cpu,$up,$user, $short_hostname ); 

$table->addRowLine();

$table->addRow('Memory Usage');

$table->addRowLine();

$table->addRow( $ram, );

$table->addRowLine();

$table->addRow('Disk Usage', 'size used (in Kb)', 'size available (in Kb).' );

$table->addRowLine();

$table->addRow( $rom , $used, $avail);

$table->addRowLine();

print $table;

my $filename = 'report.txt';
open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
print $fh "$table";
close $fh;

print "done\n";

my $df_free = (($avail) / ($avail+$used)) * 100.0;
 
if ($df_free < $warning_level) { system("/bin/bash ./mail2.sh");
print "done\n";};




