#!/usr/bin/env perl

use warnings;
use strict;
use Data::Dumper;
use utf8;

binmode STDIN, ":utf8"; 
binmode STDOUT, ":utf8"; 

my $dir = shift;

opendir (DIR, $dir) || die "Close $dir";

my @resources = grep {$_=~/\.txt/} readdir(DIR);

closedir(DIR);

my %person;

foreach my $resource (@resources) {


	open (FILE,  "<:utf8", $dir."/".$resource);

	my $string = "";	

	while (<FILE>) {

		$string.=$_;
	}

	close(FILE);
	

	my $i = 0;
	chomp($string);
	my $res = $resource;
	$res =~  s/\.txt//;

	my ($email, $department, $description, $url, $order, $name);

	my @lines = split("@@ ", $string);
	foreach my $line (@lines) {
	
		chomp($line);
		if ($line eq '') {next;}

		if ($i == 1) { $email = $line; }
		elsif ($i == 2) { $department = $line; }
		elsif ($i == 3) { $description = $line; }
		elsif ($i == 4) { $url = $line; }
		elsif ($i == 5) { $order = $line; }
		else { $name = $line; }

		$i++;
	}
	
	$person{$order}{'res'} = $res;
	$person{$order}{'name'} = $name;
	$person{$order}{'email'} = $email;
	$person{$order}{'department'} = $department;
	$person{$order}{'description'} = $description;
	$person{$order}{'url'} = $url;
	$person{$order}{'order'} = $order;
}


foreach my $person (sort(keys %person)) {

	print "<li><a href='#".$person{$person}{'res'}."'>".$person{$person}{'name'}."</a></li>\n";

}

foreach my $person (sort(keys %person)) {

	print "<section><a name='".$person{$person}{'res'}."'></a>\n";
	print "\t<h2><a href='".$person{$person}{'url'}."'>".$person{$person}{'name'}."</a></h2>\n";
	print "\t<p class='email'>".processemail($person{$person}{'email'})."</p>\n";
	print "\t<figure>\n";
	print "\t\t<img src='img/faces/".$person{$person}{'res'}.".jpg' alt='".$person{$person}{'name'}."'>\n";
	print "\t</figure>\n";
 	print "\t<div class='desc'>\n";
	print "\t\t<p class='place'><a href='".$person{$person}{'url'}."'>".$person{$person}{'department'}."</a></p>\n";
	print "\t\t<p class='text'>".processtext($person{$person}{'description'})."</p>\n";		
	print "\t</div>\n";
	print "</section>\n";

}

sub processemail {
	my $email = shift;

	$email=~s/\@/ - at - /g;

	return($email);

}

sub processtext {

	my $text = shift;
	my $val = 50;
	my $out = "";

	my @array = split(/\s+/, $text);

 	if ($array[$val+1]) {

		print STDERR "* Sel\t$val\n";

		my (@prearray) = @array[0..$val];	
		print STDERR "->", @prearray, "\n";
		my $post = $val+1;		
		my $end = $#array;

		my (@postarray) = @array[$post..$end];
		print STDERR "->",@postarray, "\n";		

		$out = join(" ", @prearray);
		$out = $out." <span class='moretxt'>".join(" ", @postarray)."</span>";
	}

	else {
		$out = join(" ", @array);
	}

	return $out;

}


