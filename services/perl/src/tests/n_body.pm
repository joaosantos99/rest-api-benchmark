package Tests::NBody;

use strict;
use warnings;
use POSIX;

my $PI = 3.141592653589793238462643383279502884197;
my $SOLAR_MASS = 4 * $PI * $PI;
my $DAYS_PER_YEAR = 365.24;
my $STEPS = 1000;  # fixed; request params are ignored

sub jupiter {
    return {
        x => 4.84143144246472090e+00,
        y => -1.16032004402742839e+00,
        z => -1.03622044471123109e-01,
        vx => 1.66007664274403694e-03 * $DAYS_PER_YEAR,
        vy => 7.69901118419740425e-03 * $DAYS_PER_YEAR,
        vz => -6.90460016972063023e-05 * $DAYS_PER_YEAR,
        mass => 9.54791938424326609e-04 * $SOLAR_MASS
    };
}

sub saturn {
    return {
        x => 8.34336671824457987e+00,
        y => 4.12479856412430479e+00,
        z => -4.03523417114321381e-01,
        vx => -2.76742510726862411e-03 * $DAYS_PER_YEAR,
        vy => 4.99852801234917238e-03 * $DAYS_PER_YEAR,
        vz => 2.30417297573763929e-05 * $DAYS_PER_YEAR,
        mass => 2.85885980666130812e-04 * $SOLAR_MASS
    };
}

sub uranus {
    return {
        x => 1.28943695621391310e+01,
        y => -1.51111514016986312e+01,
        z => -2.23307578892655734e-01,
        vx => 2.96460137564761618e-03 * $DAYS_PER_YEAR,
        vy => 2.37847173959480950e-03 * $DAYS_PER_YEAR,
        vz => -2.96589568540237556e-05 * $DAYS_PER_YEAR,
        mass => 4.36624404335156298e-05 * $SOLAR_MASS
    };
}

sub neptune {
    return {
        x => 1.53796971148509165e+01,
        y => -2.59193146099879641e+01,
        z => 1.79258772950371181e-01,
        vx => 2.68067772490389322e-03 * $DAYS_PER_YEAR,
        vy => 1.62824170038242295e-03 * $DAYS_PER_YEAR,
        vz => -9.51592254519715870e-05 * $DAYS_PER_YEAR,
        mass => 5.15138902046611451e-05 * $SOLAR_MASS
    };
}

sub sun {
    return {
        x => 0, y => 0, z => 0, vx => 0, vy => 0, vz => 0, mass => $SOLAR_MASS
    };
}

sub offset_momentum {
    my ($bodies) = @_;
    my ($px, $py, $pz) = (0, 0, 0);

    for my $body (@$bodies) {
        die "Body is not assigned" unless defined $body;
        $px += $body->{vx} * $body->{mass};
        $py += $body->{vy} * $body->{mass};
        $pz += $body->{vz} * $body->{mass};
    }

    my $sun = $bodies->[0];
    die "Sun is not assigned" unless defined $sun;

    $sun->{vx} = -$px / $SOLAR_MASS;
    $sun->{vy} = -$py / $SOLAR_MASS;
    $sun->{vz} = -$pz / $SOLAR_MASS;
}

sub advance {
    my ($bodies, $dt) = @_;
    my $n = scalar @$bodies;

    for my $i (0..$n-1) {
        my $bi = $bodies->[$i];
        die "Body is not assigned" unless defined $bi;

        my ($vxi, $vyi, $vzi) = ($bi->{vx}, $bi->{vy}, $bi->{vz});

        for my $j ($i+1..$n-1) {
            my $bj = $bodies->[$j];
            die "Body is not assigned" unless defined $bj;

            my $dx = $bi->{x} - $bj->{x};
            my $dy = $bi->{y} - $bj->{y};
            my $dz = $bi->{z} - $bj->{z};
            my $d2 = $dx*$dx + $dy*$dy + $dz*$dz;
            my $mag = $dt / ($d2 * sqrt($d2));

            $vxi -= $dx * $bj->{mass} * $mag;
            $vyi -= $dy * $bj->{mass} * $mag;
            $vzi -= $dz * $bj->{mass} * $mag;

            $bj->{vx} += $dx * $bi->{mass} * $mag;
            $bj->{vy} += $dy * $bi->{mass} * $mag;
            $bj->{vz} += $dz * $bi->{mass} * $mag;
        }

        $bi->{vx} = $vxi;
        $bi->{vy} = $vyi;
        $bi->{vz} = $vzi;
        $bi->{x} += $dt * $vxi;
        $bi->{y} += $dt * $vyi;
        $bi->{z} += $dt * $vzi;
    }
}

sub energy {
    my ($bodies) = @_;
    my $e = 0;
    my $n = scalar @$bodies;

    for my $i (0..$n-1) {
        my $bi = $bodies->[$i];
        die "Body is not assigned" unless defined $bi;

        $e += 0.5 * $bi->{mass} * ($bi->{vx}*$bi->{vx} + $bi->{vy}*$bi->{vy} + $bi->{vz}*$bi->{vz});

        for my $j ($i+1..$n-1) {
            my $bj = $bodies->[$j];
            die "Body is not assigned" unless defined $bj;

            my $dx = $bi->{x} - $bj->{x};
            my $dy = $bi->{y} - $bj->{y};
            my $dz = $bi->{z} - $bj->{z};
            my $dist = sqrt($dx*$dx + $dy*$dy + $dz*$dz);
            $e -= ($bi->{mass} * $bj->{mass}) / $dist;
        }
    }

    return $e;
}

sub n_body {
    # Build a fresh system per request (no shared mutable state)
    my @bodies = (sun(), jupiter(), saturn(), uranus(), neptune());
    offset_momentum(\@bodies);

    my $initial = sprintf("%.9f", energy(\@bodies));

    for (1..$STEPS) {
        advance(\@bodies, 0.01);
    }

    my $final = sprintf("%.9f", energy(\@bodies));

    return "$initial\n$final\n";
}

1;
