package Lacuna::DB::Building::Espionage;

use Moose;
extends 'Lacuna::DB::Building';

around 'build_tags' => sub {
    my ($orig, $class) = @_;
    return ($orig->($class), qw(Infrastructure Intelligence Ships));
};

use constant controller_class => 'Lacuna::Building::Espionage';

use constant max_instances_per_planet => 1;

use constant building_prereq => {'Lacuna::DB::Building::Intelligence'=>1};

use constant image => 'espionage';

use constant name => 'Espionage Ministry';

use constant food_to_build => 78;

use constant energy_to_build => 77;

use constant ore_to_build => 77;

use constant water_to_build => 78;

use constant waste_to_build => 50;

use constant time_to_build => 300;

use constant food_consumption => 7;

use constant energy_consumption => 10;

use constant ore_consumption => 2;

use constant water_consumption => 7;

use constant waste_production => 1;

after finish_upgrade => sub {
    my $self = shift;
    my $offense = $self->level + $self->empire->species->deception_affinity;
    $self->simpledb->domain('spies')->search(where => {from_body_id => $self->body_id})->update({offense=>$offense});
};



no Moose;
__PACKAGE__->meta->make_immutable;
