use v6;
use Test;

plan 1;

# https://github.com/rakudo/rakudo/issues/1651
subtest 'No drift when roundtripping Num -> Str -> Num -> Str' => {
    # In this test, it's fine if the original .Str gives the string that
    # doesn't match what the user has entered (since it may be a number that
    # doesn't have exact representation in a double). However, .Num.Str
    # roundtripping *that* string must produce the first string. i.e. there
    # shouldn't be drift after we figure out what the representable number is

    my @ranges := (
        (^30 .map: { 10**($_*10)}),  (^30 .map: {-10**($_*10)}),
        (^30 .map: { 10**($_*-10)}), (^30 .map: {-10**($_*-10)}),
        3e-324, 3e-320, 3e307
    );

    plan @ranges * my \iters = 1000;
    for @ranges -> \r {
        for ^iters {
            my \n  := r.rand;
            my \n1 := n.Str.Num; # get first correct num
            my \n2 := n.Str.Num.Str.Num.Str.Num.Str.Num; # second
            cmp-ok n1, '===', n2, "{n} roundtrippage is stable";
        }
    }
}

# vim: ft=perl6
