#!/usr/bin/env perl

use strict;
use warnings;
use Plack::Request;
use Plack::Response;
use Plack::Builder;
use HTTP::Server::PSGI;

# Load modules directly
require './tests/hello_world.pm';
require './tests/n_body.pm';
require './tests/json_serde.pm';
require './tests/regex_redux.pm';

my $app = sub {
    my $env = shift;
    my $req = Plack::Request->new($env);
    my $path = $req->path_info;

    my $res = Plack::Response->new(200);
    $res->header('Access-Control-Allow-Origin' => '*');
    $res->header('Access-Control-Allow-Methods' => 'GET, POST, OPTIONS');
    $res->header('Access-Control-Allow-Headers' => 'Content-Type');
    $res->header('Content-Type' => 'text/plain');

    if ($path eq '/api/hello-world') {
        my $response = Tests::HelloWorld::hello_world();
        $res->body($response);
    }
    elsif ($path eq '/api/n-body') {
        my $response = Tests::NBody::n_body();
        $res->body($response);
    }
    elsif ($path eq '/api/json-serde') {
        my $response = Tests::JsonSerde::json_serde();
        $res->body($response);
    }
    elsif ($path eq '/api/regex-redux') {
        my $response = Tests::RegexRedux::regex_redux();
        $res->body($response);
    }
    else {
        $res->status(404);
        $res->body('Not found');
    }

    return $res->finalize;
};

# Add CORS handling for OPTIONS requests
$app = builder {
    enable sub {
        my $app = shift;
        sub {
            my $env = shift;
            if ($env->{REQUEST_METHOD} eq 'OPTIONS') {
                return [
                    200,
                    [
                        'Access-Control-Allow-Origin' => '*',
                        'Access-Control-Allow-Methods' => 'GET, POST, OPTIONS',
                        'Access-Control-Allow-Headers' => 'Content-Type',
                        'Content-Type' => 'text/plain'
                    ],
                    []
                ];
            }
            return $app->($env);
        };
    };
    $app;
};

my $port = $ARGV[0] || 8080;
my $server = HTTP::Server::PSGI->new(port => $port);

print "Server running at http://localhost:$port (Perl $^V)\n";
$server->run($app);
