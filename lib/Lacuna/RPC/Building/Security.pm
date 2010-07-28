package Lacuna::RPC::Building::Security;

use Moose;
extends 'Lacuna::RPC::Building';

sub app_url {
    return '/security';
}

sub model_class {
    return 'Lacuna::DB::Result::Building::Security';
}

sub view_foreign_spies {
    my ($self, $session_id, $building_id, $page_number) = @_;
    my $empire = $self->get_empire_by_session($session_id);
    my $building = $self->get_building($empire, $building_id);
    $page_number ||= 1;
    my @out;
    my $spies = $building->foreign_spies->search(
        {
            rows        => 25,
            page        => $page_number,
            order_by    => 'available_on',
        }
    );
    while (my $spy = $spies->next) {
        my $available_on = $spy->format_available_on;
        push @out, {
            name                => $spy->name,
            level               => $spy->level,
            next_mission        => $spy->available_on_formatted,
        };
    }
    return {
        status                  => $self->format_status($empire, $building->body),
        spies                   => \@out,
        spy_count               => $spies->pager->total_entries,
    };
}

sub view_prisoners {
    my ($self, $session_id, $building_id, $page_number) = @_;
    my $empire = $self->get_empire_by_session($session_id);
    my $building = $self->get_building($empire, $building_id);
    $page_number ||= 1;
    my @out;
    my $spies = $building->prisoners->search(undef,
        {
            rows        => 25,
            page        => $page_number,
            order_by    => 'available_on',
        }
    );
    while (my $spy = $spies->next) {
        my $available_on = $spy->format_available_on;
        push @out, {
            id                  => $spy->id,
            name                => $spy->name,
            sentence_expires    => $available_on,
        };
    }
    return {
        status                  => $self->format_status($empire, $building->body),
        prisoners               => \@out,
        captured_count          => $spies->pager->total_entries,
    };
}

__PACKAGE__->register_rpc_method_names(qw(view_prisoners));



no Moose;
__PACKAGE__->meta->make_immutable;

