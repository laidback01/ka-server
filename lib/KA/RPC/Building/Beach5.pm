package KA::RPC::Building::Beach5;

use Moose;
use utf8;
no warnings qw(uninitialized);
extends 'KA::RPC::Building';

sub app_url {
    return '/beach5';
}

sub model_class {
    return 'KA::DB::Result::Building::Permanent::Beach5';
}

no Moose;
__PACKAGE__->meta->make_immutable;

