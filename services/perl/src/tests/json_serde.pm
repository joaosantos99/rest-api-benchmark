package Tests::JsonSerde;

use strict;
use warnings;
use JSON;
use Digest::MD5;
use POSIX qw(strftime);

sub print_hash {
    my ($data, $label) = @_;
    $label = '' unless defined $label;

    my $json = JSON->new->utf8->encode($data);
    my $hash = Digest::MD5::md5_hex($json);

    return ($label ? "$label " : '') . "MD5 Hash: $hash";
}

sub json_serde {
    my $sample_data = {
        users => [
            { id => 1, name => 'Alice', email => 'alice@example.com', active => JSON::true },
            { id => 2, name => 'Bob', email => 'bob@example.com', active => JSON::false },
            { id => 3, name => 'Charlie', email => 'charlie@example.com', active => JSON::true }
        ],
        metadata => {
            version => '1.0.0',
            timestamp => strftime('%Y-%m-%dT%H:%M:%SZ', gmtime),
            settings => {
                theme => 'dark',
                notifications => JSON::true,
                language => 'en'
            }
        },
        statistics => {
            totalUsers => 3,
            activeUsers => 2,
            averageAge => 28.5,
            tags => ['javascript', 'nodejs', 'benchmark', 'json', 'serialization']
        }
    };

    my $n = 100; # Number of serialization/deserialization cycles

    my $json = JSON->new->utf8;
    my $json_str = $json->encode($sample_data);
    my $parsed = $json->decode($json_str);
    my $original_hash = print_hash($parsed, 'Original');

    my @results;
    for my $i (1..$n) {
        my $serialized = $json->encode($parsed);
        my $deserialized = $json->decode($serialized);
        push @results, $deserialized;
    }

    my $final_hash = print_hash(\@results, "x$n Cycles");

    return join("\n",
        $original_hash,
        $final_hash,
        "Performed $n serialization/deserialization cycles",
        "Original data size: " . length($json_str) . " bytes",
        "Final array size: " . scalar(@results) . " objects"
    );
}

1;

