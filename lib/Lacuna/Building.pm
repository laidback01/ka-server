package Lacuna::Building;

use Moose;
extends 'JSON::RPC::Dispatcher::App';

has simpledb => (
    is      => 'ro',
    required=> 1,
);

with 'Lacuna::Role::Sessionable';

sub model_domain {
    return 'building';
}

sub model_class {
    confess "you need to override me";
}

sub has_resources_to_operate {
    my ($self, $building) = @_;
    my $after = $building->stats_after_upgrade;
    foreach my $resource (qw(food energy ore water)) {
        my $method = $resource.'_hour';
        if (($after->{$method} - $building->$method) < 0) {
            confess [1012, "Not enough resources being produced to build this.", $resource];
        }
    }
    return 1;
}

sub has_resources_to_build {
    my ($self, $building, $body, $cost) = @_;
    $cost ||= $building->cost_to_upgrade;
    foreach my $resource (qw(food energy ore water)) {
        my $stored = $resource.'_stored';
        if ($body->$stored >= $cost->{$resource}) {
            confess [1011, "Not enough resources in storage to build this.", $resource];
        }
    }
    return 1;
}

sub has_met_upgrade_prereqs {
    return 1;
}

sub has_met_build_prereqs {
    return 1;
}

sub can_upgrade {
    my ($self, $building, $body, $cost) = @_;
    return $self->has_resources_to_build($building, $body, $cost)
        && $self->has_resources_to_operate($building)
        && $self->has_met_upgrade_prereqs($building, $body);
}

sub get_body {
    my ($self, $building, $body) = @_;
    if ($body) {
        return $body;
    }
    else {
        return $building->body;
    }
}

sub get_building {
    my ($self, $building_id) = @_;
    if ($building_id->isa('Lacuna::DB::Building')) {
        return $building_id;
    }
    else {
        my $building = $self->simpledb->domain($self->model_domain)->find($building_id);
        if (defined $building) {
            return $building;
        }
        else {
            confess [1002, 'Building does not exist.', $building_id];
        }
    }
}

sub upgrade {
    my ($self, $session_id, $building_id) = @_;
    my $building = $self->get_building($building_id);
    my $empire = $self->get_empire_by_session($session_id);
    unless ($building->empire_id eq $empire->id) {
        confess [1010, "Can't upgrade a building that you don't own.", $building_id];
    }
    my $body = $building->body;

    # can upgrade?
    my $cost = $building->cost_to_upgrade;
    $body->recalc_stats;
    $self->can_upgrade($building, $body, $cost);

    # spend resources
    $body->spend_water($cost->{water});
    $body->spend_energy($cost->{energy});
    $body->spend_food($cost->{food});
    $body->spend_ore($cost->{ore});
    $body->add_waste($cost->{waste});

    # add upgrade to queue

    return { success=>1, status=>$empire->get_status};
}

sub view {
    my ($self, $session_id, $building_id) = @_;
    my $building = $self->get_building($building_id);
    my $empire = $self->get_empire_by_session($session_id);
    if ($building->empire_id eq $empire->id) {
        my $cost = $building->cost_to_upgrade;
        return { 
            building    => {
                name            => $building->name,
                image           => $building->image,
                x               => $building->x,
                y               => $building->y,
                level           => $building->level,
                food_hour       => $building->food_hour,
                ore_hour        => $building->ore_hour,
                water_hour      => $building->water_hour,
                waste_hour      => $building->waste_hour,
                energy_hour     => $building->energy_hour,
                happiness_hour  => $building->happiness_hour,
                upgrade         => {
                    can         => (eval{$self->can_upgrade($building, undef, $cost} ? 1 : 0),
                    cost        => $cost,
                    production  => $building->stats_after_upgrade,
                },
            },
            status      => $empire->get_status,
        };
    }
    else {
        confess [1010, "Can't view a building that you don't own.", $building_id];
    }
}

sub build {
    my ($self, $session_id, $body_id, $x, $y) = @_;

    # have to build on the grid
    if ($x < 5 || $x > -5 || $y > 5 || $y < -5) {
        confess [1009, "That's not a valid space for a building.", [$x, $y]];
    }

    my $body = $self->get_body($body_id);
    my $empire = $self->get_empire_by_session($session_id);

    # make sure is owner
    unless ($body->empire_id eq $empire->id) {
        confess [1010, "Can't add a building to a planet that you don't occupy.", $body_id];
    }

    # can't be over limit
    if ($body->building_count >= $body->size) {
        confess [1009, "You've already reached the maximum number of buildings for this planet.", $body->size];
    }

    # make sure space is available
    unless ($body->is_space_free($x, $y)) {
        confess [1009, "That space is already occupied.", [$x,$y]]; 
    }

    # create dummy building
    my $building = $self->model_class->new(
        simpledb    => $self->simpledb,
        attributes  => {
            x               => $x,
            y               => $y,
            level           => 0,
            body_id         => $body->id,
            empire_id       => $empire->id,
            date_created    => DateTime->now,
            class           => $self->model_class,
        },
    );

    # check available resources
    $body->recalc_stats;
    $self->has_resources_to_build($building, $body);

    # adjust resources
    $body->spend_food($building->food_to_build);
    $body->spend_water($building->water_to_build);
    $body->add_waste($building->waste_to_build);
    $body->spend_ore($building->ore_to_build);
    $body->spend_energy($building->energy_to_build);

    # add building placeholder to planet
    $building->put;

    # add to build queue

    return { success=>1, status=>$empire->get_status};
}


__PACKAGE__->register_rpc_method_names(qw(upgrade));

no Moose;
__PACKAGE__->meta->make_immutable;

