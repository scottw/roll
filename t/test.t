#-*- mode: cperl -*-#
use Test::More tests => 11;

chdir 't' if -d 't';
my $pwd = `pwd`; chomp $pwd;

system('rm', '-r', 'all-tests') if -e 'all-tests';
mkdir 'all-tests';
chdir 'all-tests' or die "Could not run tests: $!\n";

my $roll = "../../roll";
unless (-x $roll) {
    die "Could not run $roll; does not exist or is not executable.\n";
}

## simple file
system('touch', 'roll-test-1');
runit($roll, 'roll-test-1');
ok(-f 'roll-test-1.1', "roll file");

## directory
mkdir "roll-test-2";
runit($roll, 'roll-test-2', 2);
ok(-d 'roll-test-2.1', "roll directory");
system('touch', 'roll-test-2/a');

runit($roll, 'roll-test-2', 2);
ok(-d 'roll-test-2.2', "roll directory");
ok(-f 'roll-test-2.1/a', "file rolled");
ok(!-f 'roll-test-2.2/a', "first directory");

## symlink
symlink('roll-test-2', 'roll-test-3');
ok(-l "roll-test-3", "pre-test check");
runit($roll, 'roll-test-3');
ok(-l 'roll-test-3.1', "roll symlink");
ok(-d 'roll-test-2', "directory intact");

## symlink again
runit($roll, 'roll-test-3', 2);
ok(-l 'roll-test-3.2', "roll symlink");
ok(-d 'roll-test-2', "directory intact");

## symlink again
runit($roll, 'roll-test-3', '--separator', '-');
ok(-l 'roll-test-3-1', "roll symlink");

exit;

END {
    chdir $pwd;
    system('rm', '-r', 'all-tests') unless $ENV{NO_CLEAN};
}

sub runit {
    my $cmd = shift;
    my @args = @_;

    if ($ENV{DEBUG}) {
        push @args, '--debug';
    }

    system($cmd, @args);
}
