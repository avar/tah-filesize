use feature ':5.10';
use Data::Dump 'dump';
say dump heatmap(shift);

# From http://google.com/codesearch/p?hl=en#v85D9_xn8lk/viewcvs.py/gmod/graphbrowse/cgi/graphbrowse%3Frev%3D1.10&q=heat map rgb lang:perl
sub heatmap {
    my($v)=@_;

    die "Heatmap input out of range: $v" if $v < 0 || $v > 1;

    my @rgb;

    foreach $offset (-0.25,0,0.25) {
        my $x = $v + $offset;
        my $y;
        if ($x <= .125) {
            $y = 0;
        } elsif ($x <= .375) {
            $y = ($x-.125)/.25;
        } elsif ($x <= .625) {
            $y = 1;
        } elsif ($x <= .875) {
            $y = (.875 - $x )/.25;
        } else {
            $y = 0;
        }
        push @rgb => $y * 255;
    }
    map { int } @rgb;
}

sub dec2hex {
    my($x,$ndigits)=@_;
    say $x;
    say $ndigits;
    my $h = sprintf("%lx",  $x);
    if(defined($ndigits)){
        die "$x too large for $ndigits hex digits!" if length($h)>$ndigits;
        while(length($h)<$ndigits){ $h = "0$h"; }}
    return $h;
}
