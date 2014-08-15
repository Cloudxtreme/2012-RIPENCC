#!/usr/bin/perl
#
#
# 
# Matthijs Astley 2012

$res = $ARGV[0] ;

if( scalar(@ARGV) < 1 ){

	print "Usage: ./getrelated_email.pl 'resource'\n" ;
exit ;
}


if($res =~ /^AS/i){
@addies = `whois -B  $res | egrep "e-mail|changed|notify|upd-to"| grep -v "ripe.net"` ; 
}else{
@addies = `whois -r -G -B -d -x $res | egrep "e-mail|changed|notify|upd-to"| grep -v "ripe.net"` ; 
}

#
#
# Get maintainers/admin-c/tech-c  related to resource
@mntby = `whois -B -T aut-num,inetnum $res | egrep "^mnt-by|admin-c|tech-c"| grep -v "RIPE-NCC-END-MNT"|cut -d: -f2` ; 

foreach(@mntby){
$_ =~ s/^\s+//;
$_ =~ s/\s+$//;
push(@mntby2, $_) ;
}

# Unique maintainer handles
    my %mnts   = map { $_, 1 } @mntby2;
    my @unique_mnts = keys %mnts;

foreach $mnt (@unique_mnts){

	@mnt_related = `whois -B $mnt` ; 
	getmnte(@mnt_related) ;
}



@caddies = () ;

foreach $i (@addies){
	$i =~ s/\D+:\s+//g; 
	$i =~ s/\s\d{8}$//g ;
	chomp $i ;
	push(@caddies, $i) ;
}
    my %addies   = map { $_, 1 } @caddies;
    my @unique_addies = keys %addies;

ret_e() ;


#
#
# Print unique addresses in To: line 

sub ret_e {

print "To: " ;

foreach $j ( @unique_addies ){ 
	push(@all,$j) ;
	}
}

#
#
# Pull email addresses from related maintainers
sub getmnte {
@caddies2 = () ;

foreach $m (@mnt_related){ 
#get email addresses from mnt
if($m =~ /(^e-mail|^changed|^notify|^upd-to)/ && $m !~ /ripe.net/){
	push(@addies2,$m) ;
	}
}

#strip addresses
foreach $i (@addies2){
	$i =~ s/\D+:\s+//g; 
	$i =~ s/\s\d{8}$//g ;
	chomp $i ;
	push(@caddies2, $i) ;
}

#make addresses unique
    my %addies2   = map { $_, 1 } @caddies2;
    my @unique_addies2 = keys %addies2;

foreach $j ( @unique_addies2 ){
	push(@all, $j) ;

        }
}

    my %all   = map { $_, 1 } @all;
    my @all2 = keys %all;

foreach(@all2){
print "$_,\n" ;
}
print "\n" ;
