package KA::DB::Result::Map::Body;

use Moose;
use utf8;
use List::Util qw(max sum);
use Scalar::Util qw(weaken);

no warnings qw(uninitialized);
extends 'KA::DB::Result::Map';

__PACKAGE__->load_components('DynamicSubclass');
__PACKAGE__->table('body');
__PACKAGE__->add_columns(
    star_id                         => { data_type => 'int', is_nullable => 0 },
    alliance_id                     => { data_type => 'int', is_nullable => 1 },
    orbit                           => { data_type => 'int', default_value => 0 },
    class                           => { data_type => 'varchar', size => 255, is_nullable => 0 },
    size                            => { data_type => 'int', default_value => 0 },
    usable_as_starter               => { data_type => 'int',  default_value => 0 },
    usable_as_starter_enabled       => { data_type => 'tinyint', default_value => 0 },
    empire_id                       => { data_type => 'int', is_nullable => 1 },
    last_tick                       => { data_type => 'datetime', is_nullable => 0, set_on_create => 1 },
    boost_enabled                   => { data_type => 'tinyint', default_value => 0 },
    needs_recalc                    => { data_type => 'tinyint', default_value => 0 },
    needs_surface_refresh           => { data_type => 'tinyint', default_value => 0 },
    restrict_coverage               => { data_type => 'tinyint', default_value => 0 },
    plots_available                 => { data_type => 'tinyint', default_value => 0 },    
    surface_version                 => { data_type => 'tinyint', default_value => 0 },
    max_berth                       => { data_type => 'tinyint', default_value => 1 },
    unhappy_date                    => { data_type => 'datetime', is_nullable => 0, set_on_create => 1 },
    unhappy                         => { data_type => 'tinyint', default_value => 0 },
    propaganda_boost                => { data_type => 'int',  default_value => 0 },
    neutral_entry                   => { data_type => 'datetime', is_nullable => 0, set_on_create => 1 },
    notes                           => { data_type => 'text', is_nullable => 1 },
);

after 'sqlt_deploy_hook' => sub {
    my ($self, $sqlt_table) = @_;
    $sqlt_table->add_index(name => 'idx_class', fields => ['class']);
    $sqlt_table->add_index(name => 'idx_usable_as_starter', fields => ['usable_as_starter']);
    $sqlt_table->add_index(name => 'idx_usable_as_starter_enabled', fields => ['usable_as_starter_enabled']);
    $sqlt_table->add_index(name => 'idx_planet_search', fields => ['usable_as_starter_enabled','usable_as_starter']);
};

{
  local *ensure_class_loaded = sub {}; # graham's crazy fix for circular dependency, may break if DynamicSubclass gets upgraded
  __PACKAGE__->typecast_map(class => {
    'KA::DB::Result::Map::Body::Asteroid::A1' => 'KA::DB::Result::Map::Body::Asteroid::A1',
    'KA::DB::Result::Map::Body::Asteroid::A2' => 'KA::DB::Result::Map::Body::Asteroid::A2',
    'KA::DB::Result::Map::Body::Asteroid::A3' => 'KA::DB::Result::Map::Body::Asteroid::A3',
    'KA::DB::Result::Map::Body::Asteroid::A4' => 'KA::DB::Result::Map::Body::Asteroid::A4',
    'KA::DB::Result::Map::Body::Asteroid::A5' => 'KA::DB::Result::Map::Body::Asteroid::A5',
    'KA::DB::Result::Map::Body::Asteroid::A6' => 'KA::DB::Result::Map::Body::Asteroid::A6',
    'KA::DB::Result::Map::Body::Asteroid::A7' => 'KA::DB::Result::Map::Body::Asteroid::A7',
    'KA::DB::Result::Map::Body::Asteroid::A8' => 'KA::DB::Result::Map::Body::Asteroid::A8',
    'KA::DB::Result::Map::Body::Asteroid::A9' => 'KA::DB::Result::Map::Body::Asteroid::A9',
    'KA::DB::Result::Map::Body::Asteroid::A10' => 'KA::DB::Result::Map::Body::Asteroid::A10',
    'KA::DB::Result::Map::Body::Asteroid::A11' => 'KA::DB::Result::Map::Body::Asteroid::A11',
    'KA::DB::Result::Map::Body::Asteroid::A12' => 'KA::DB::Result::Map::Body::Asteroid::A12',
    'KA::DB::Result::Map::Body::Asteroid::A13' => 'KA::DB::Result::Map::Body::Asteroid::A13',
    'KA::DB::Result::Map::Body::Asteroid::A14' => 'KA::DB::Result::Map::Body::Asteroid::A14',
    'KA::DB::Result::Map::Body::Asteroid::A15' => 'KA::DB::Result::Map::Body::Asteroid::A15',
    'KA::DB::Result::Map::Body::Asteroid::A16' => 'KA::DB::Result::Map::Body::Asteroid::A16',
    'KA::DB::Result::Map::Body::Asteroid::A17' => 'KA::DB::Result::Map::Body::Asteroid::A17',
    'KA::DB::Result::Map::Body::Asteroid::A18' => 'KA::DB::Result::Map::Body::Asteroid::A18',
    'KA::DB::Result::Map::Body::Asteroid::A19' => 'KA::DB::Result::Map::Body::Asteroid::A19',
    'KA::DB::Result::Map::Body::Asteroid::A20' => 'KA::DB::Result::Map::Body::Asteroid::A20',
    'KA::DB::Result::Map::Body::Asteroid::A21' => 'KA::DB::Result::Map::Body::Asteroid::A21',
    'KA::DB::Result::Map::Body::Asteroid::A22' => 'KA::DB::Result::Map::Body::Asteroid::A22',
    'KA::DB::Result::Map::Body::Asteroid::A23' => 'KA::DB::Result::Map::Body::Asteroid::A23',
    'KA::DB::Result::Map::Body::Asteroid::A24' => 'KA::DB::Result::Map::Body::Asteroid::A24',
    'KA::DB::Result::Map::Body::Asteroid::A25' => 'KA::DB::Result::Map::Body::Asteroid::A25',
    'KA::DB::Result::Map::Body::Asteroid::A26' => 'KA::DB::Result::Map::Body::Asteroid::A26',
    'KA::DB::Result::Map::Body::Planet::P1' => 'KA::DB::Result::Map::Body::Planet::P1',
    'KA::DB::Result::Map::Body::Planet::P2' => 'KA::DB::Result::Map::Body::Planet::P2',
    'KA::DB::Result::Map::Body::Planet::P3' => 'KA::DB::Result::Map::Body::Planet::P3',
    'KA::DB::Result::Map::Body::Planet::P4' => 'KA::DB::Result::Map::Body::Planet::P4',
    'KA::DB::Result::Map::Body::Planet::P5' => 'KA::DB::Result::Map::Body::Planet::P5',
    'KA::DB::Result::Map::Body::Planet::P6' => 'KA::DB::Result::Map::Body::Planet::P6',
    'KA::DB::Result::Map::Body::Planet::P7' => 'KA::DB::Result::Map::Body::Planet::P7',
    'KA::DB::Result::Map::Body::Planet::P8' => 'KA::DB::Result::Map::Body::Planet::P8',
    'KA::DB::Result::Map::Body::Planet::P9' => 'KA::DB::Result::Map::Body::Planet::P9',
    'KA::DB::Result::Map::Body::Planet::P10' => 'KA::DB::Result::Map::Body::Planet::P10',
    'KA::DB::Result::Map::Body::Planet::P11' => 'KA::DB::Result::Map::Body::Planet::P11',
    'KA::DB::Result::Map::Body::Planet::P12' => 'KA::DB::Result::Map::Body::Planet::P12',
    'KA::DB::Result::Map::Body::Planet::P13' => 'KA::DB::Result::Map::Body::Planet::P13',
    'KA::DB::Result::Map::Body::Planet::P14' => 'KA::DB::Result::Map::Body::Planet::P14',
    'KA::DB::Result::Map::Body::Planet::P15' => 'KA::DB::Result::Map::Body::Planet::P15',
    'KA::DB::Result::Map::Body::Planet::P16' => 'KA::DB::Result::Map::Body::Planet::P16',
    'KA::DB::Result::Map::Body::Planet::P17' => 'KA::DB::Result::Map::Body::Planet::P17',
    'KA::DB::Result::Map::Body::Planet::P18' => 'KA::DB::Result::Map::Body::Planet::P18',
    'KA::DB::Result::Map::Body::Planet::P19' => 'KA::DB::Result::Map::Body::Planet::P19',
    'KA::DB::Result::Map::Body::Planet::P20' => 'KA::DB::Result::Map::Body::Planet::P20',
    'KA::DB::Result::Map::Body::Planet::P21' => 'KA::DB::Result::Map::Body::Planet::P21',
    'KA::DB::Result::Map::Body::Planet::P22' => 'KA::DB::Result::Map::Body::Planet::P22',
    'KA::DB::Result::Map::Body::Planet::P23' => 'KA::DB::Result::Map::Body::Planet::P23',
    'KA::DB::Result::Map::Body::Planet::P24' => 'KA::DB::Result::Map::Body::Planet::P24',
    'KA::DB::Result::Map::Body::Planet::P25' => 'KA::DB::Result::Map::Body::Planet::P25',
    'KA::DB::Result::Map::Body::Planet::P26' => 'KA::DB::Result::Map::Body::Planet::P26',
    'KA::DB::Result::Map::Body::Planet::P27' => 'KA::DB::Result::Map::Body::Planet::P27',
    'KA::DB::Result::Map::Body::Planet::P28' => 'KA::DB::Result::Map::Body::Planet::P28',
    'KA::DB::Result::Map::Body::Planet::P29' => 'KA::DB::Result::Map::Body::Planet::P29',
    'KA::DB::Result::Map::Body::Planet::P30' => 'KA::DB::Result::Map::Body::Planet::P30',
    'KA::DB::Result::Map::Body::Planet::P31' => 'KA::DB::Result::Map::Body::Planet::P31',
    'KA::DB::Result::Map::Body::Planet::P32' => 'KA::DB::Result::Map::Body::Planet::P32',
    'KA::DB::Result::Map::Body::Planet::P33' => 'KA::DB::Result::Map::Body::Planet::P33',
    'KA::DB::Result::Map::Body::Planet::P34' => 'KA::DB::Result::Map::Body::Planet::P34',
    'KA::DB::Result::Map::Body::Planet::P35' => 'KA::DB::Result::Map::Body::Planet::P35',
    'KA::DB::Result::Map::Body::Planet::P36' => 'KA::DB::Result::Map::Body::Planet::P36',
    'KA::DB::Result::Map::Body::Planet::P37' => 'KA::DB::Result::Map::Body::Planet::P37',
    'KA::DB::Result::Map::Body::Planet::P38' => 'KA::DB::Result::Map::Body::Planet::P38',
    'KA::DB::Result::Map::Body::Planet::P39' => 'KA::DB::Result::Map::Body::Planet::P39',
    'KA::DB::Result::Map::Body::Planet::P40' => 'KA::DB::Result::Map::Body::Planet::P40',
    'KA::DB::Result::Map::Body::Planet::GasGiant::G1' => 'KA::DB::Result::Map::Body::Planet::GasGiant::G1',
    'KA::DB::Result::Map::Body::Planet::GasGiant::G2' => 'KA::DB::Result::Map::Body::Planet::GasGiant::G2',
    'KA::DB::Result::Map::Body::Planet::GasGiant::G3' => 'KA::DB::Result::Map::Body::Planet::GasGiant::G3',
    'KA::DB::Result::Map::Body::Planet::GasGiant::G4' => 'KA::DB::Result::Map::Body::Planet::GasGiant::G4',
    'KA::DB::Result::Map::Body::Planet::GasGiant::G5' => 'KA::DB::Result::Map::Body::Planet::GasGiant::G5',
    'KA::DB::Result::Map::Body::Planet::Station' => 'KA::DB::Result::Map::Body::Planet::Station',
  });
}
sub asteroid_types {return 26;}
sub planet_types {return 40;}
sub gas_giant_types {return 5;};

# RELATIONSHIPS

__PACKAGE__->belongs_to('star', 'KA::DB::Result::Map::Star', 'star_id');
__PACKAGE__->belongs_to('alliance', 'KA::DB::Result::Alliance', 'alliance_id', { join_type => 'left', on_delete => 'set null' });
__PACKAGE__->belongs_to('empire', 'KA::DB::Result::Empire', 'empire_id', {join_type => 'left'});
__PACKAGE__->has_many('_buildings','KA::DB::Result::Building','body_id');
__PACKAGE__->has_many('foreign_fleets','KA::DB::Result::Fleet','foreign_body_id');

has building_cache => (
    is      => 'rw',
    lazy    => 1,
#    weak_ref => 1,
    builder => '_build_building_cache',
    clearer => 'clear_building_cache',
);

sub _build_building_cache {
    my ($self) = @_;
    my $buildings = [];
    my $bld_rs = $self->_buildings->search({});
    while (my $building = $bld_rs->next) {
        $building->body($self);
        weaken($building->{_relationship_data}{body});
        push @$buildings,$building;
    }
    return $buildings;
}

sub building_max_level {
    my ($self) = @_;

    if (scalar @{$self->building_cache}) {
        return max map {$_->level} @{$self->building_cache};
    }
    return 0;
}

sub building_avg_level {
    my ($self) = @_;

    if (scalar @{$self->building_cache}) {
        my $sum = sum map {$_->level} @{$self->building_cache};
        return $sum / @{$self->building_cache};
    }
    return 0;
}

sub abandon {
    my $self = shift;
}

sub lock {
    my $self = shift;
    return KA->cache->set('planet_contention_lock', $self->id, 1, 15); # lock it
}

sub is_locked {
    my $self = shift;
    return KA->cache->get('planet_contention_lock', $self->id);
}

sub image {
    confess "override me";
}

sub image_name {
    my $self = shift;
    return $self->image.'-'.$self->orbit;
}

sub get_type {
    my ($self) = @_;
    my $type = 'habitable planet';
    if ($self->isa('KA::DB::Result::Map::Body::Planet::GasGiant')) {
        $type = 'gas giant';
    }
    elsif ($self->isa('KA::DB::Result::Map::Body::Asteroid')) {
        $type = 'asteroid';
    }
    elsif ($self->isa('KA::DB::Result::Map::Body::Planet::Station')) {
        $type = 'space station';
    }
    return $type;
}

sub prereq_buildings {
    my ($self, $class, $level) = @_;

    my @buildings = grep { $_->class eq $class and $_->level >= $level } @{$self->building_cache};
    return \@buildings;
}

sub get_a_building {
    my ($self,$class) = @_;

    my ($building) = grep { $_->class eq "KA::DB::Result::Building::$class" } @{$self->building_cache};
    return $building;
}

sub get_status_lite {
    my ($self) = @_;

    my %out = (
        name            => $self->name,
        image           => $self->image_name,
        x               => $self->x,
        y               => $self->y,
        orbit           => $self->orbit,
        size            => $self->size,
        id              => $self->id,
        type            => $self->get_type,
    );
    return \%out;
}

sub get_status {
    my ($self) = @_;
    my %out = (
        name            => $self->name,
        image           => $self->image_name,
        x               => $self->x,
        y               => $self->y,
        orbit           => $self->orbit,
        size            => $self->size,
        type            => $self->get_type,
        star_id         => $self->star_id,
        star_name       => $self->star->name,
        zone            => $self->zone,
        id              => $self->id,
        notes           => $self->notes,
    );
    if ($self->star->station_id) {
        my $station = $self->star->station;
        $out{station} = {
            id      => $station->id,
            x       => $station->x,
            y       => $station->y,
            name    => $station->name,
        };
    }
    return \%out;
}

sub get_last_attacked_by {
    my $self = shift;
    my $attacker_body_id = KA->cache->get('last_attacked_by',$self->id);
    return undef unless defined $attacker_body_id;
    my $attacker_body = KA->db->resultset('Map::Body')->find($attacker_body_id);
    return undef unless defined $attacker_body;
    return undef unless $attacker_body->empire_id;
    return $attacker_body;
}

sub set_last_attacked_by {
    my ($self, $attacker_body_id) = @_;
    KA->cache->set('last_attacked_by',$self->id, $attacker_body_id, 60 * 60 * 24 * 30);
}

sub delete_last_attacked_by {
    my $self = shift;
    KA->cache->delete('last_attacked_by',$self->id);
}

sub is_bhg_neutralized {
    my ($check) = @_;
    my $tstar; my $tname;
    if ($check->isa('KA::DB::Result::Map::Star')) {
        $tstar = $check;
        $tname = $check->name;
    }
    else {
        $tstar = $check->star;
        $tname = $check->name;
    }
    my $sname = $tstar->name;
    if ($tstar->station_id) {
        if ($tstar->station->laws->search({type => 'BHGNeutralized'})->count) {
            return 1;
        }
    }
    return 0;
}

sub add_to_neutral_entry {
    my ($self, $seconds) = @_;

    my $now = DateTime->now;
    if ($self->neutral_entry < $now) {
        $self->neutral_entry($now->add(seconds => $seconds));
    }
    else {
        $self->neutral_entry($self->neutral_entry->add(seconds => $seconds));
        my $day_30 = $now->add(days => 30);
        $self->neutral_entry($day_30) if ($self->neutral_entry > $day_30);
    }
    $self->update;
    return 1;
}

sub subtract_from_neutral_entry {
    my ($self, $seconds) = @_;

    my $day = DateTime->now->add(hours => 24 * 7);
    return 1 if ($self->neutral_entry < $day);

    my $time_ends = $self->neutral_entry->clone->subtract(seconds => $seconds);
    if ($time_ends > $day) {
        $self->neutral_entry($time_ends);
    }
    else {
        $self->neutral_entry($day);
    }
    $self->update;
    return 1;
}

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);
