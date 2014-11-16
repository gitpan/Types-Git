#!/usr/bin/env perl
use strictures 1;

use Test::More;

BEGIN { use_ok('Types::Git', '-types') }

subtest 'GitRef' => sub{
    my @bad_refs = (
        # 1
        qw(
            refs.lock/heads/master
            refs/heads.lock/master
            refs/heads/master.lock
            .refs/heads/master
            refs/.heads/master
            refs/heads/.master
        ),
        # 2
        qw(
            master
        ),
        # 3
        qw(
            refs/heads/ma..ster
        ),
        # 4
        "refs/heads/ma\040ster",
        "refs/heads/ma\000ster",
        "refs/heads/ma\177ster",
        "refs/heads/ma ster",
        qw(
            refs/heads/ma~ster
            refs/heads/ma^ster
            refs/heads/ma:ster
        ),
        # 5
        qw(
            refs/heads/ma?ster
            refs/heads/ma*ster
            refs/heads/ma[ster
        ),
        # 6
        qw(
            /refs/heads/master
            refs/heads/master/
            refs/heads//master
        ),
        # 7
        qw(
            refs/heads/master.
        ),
        # 8
        qw(
            refs/heads/ma@{ster
        ),
        # 9
        qw(
            @
        ),
        # 10
        qw(
            refs/heads/ma\ster
        ),
    );

    my @good_refs = qw(
        refs/heads/master
    );

    ok( (! GitRef->check($_)), "$_ is not a GitRef" ) for @bad_refs;

    ok( GitRef->check($_), "$_ is a GitRef" ) for @good_refs;
};

done_testing;
