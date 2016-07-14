package KA::RPC::Building::GasGiantPlatform;

use Moose;
use utf8;
no warnings qw(uninitialized);
extends 'KA::RPC::Building';

sub app_url {
    return '/gasgiantplatform';
}

sub model_class {
    return 'KA::DB::Result::Building::Permanent::GasGiantPlatform';
}

no Moose;
__PACKAGE__->meta->make_immutable;
