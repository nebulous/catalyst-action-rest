package Catalyst::Action::Serialize::YAML;

use Moose;
use namespace::autoclean;

extends 'Catalyst::Action';
use YAML::Syck;

our $VERSION = '0.83';
$VERSION = eval $VERSION;

sub execute {
    my $self = shift;
    my ( $controller, $c, $sarg ) = @_;
    $sarg||={};
    foreach my $arg (keys %$sarg) {
      eval '$YAML::Syck::'.$arg.' = $sarg->{$arg};';
    }

    my $stash_key = (
            $controller->{'serialize'} ?
                $controller->{'serialize'}->{'stash_key'} :
                $controller->{'stash_key'} 
        ) || 'rest';
    my $output = $self->serialize($c->stash->{$stash_key});
    $c->response->output( $output );
    return 1;
}

sub serialize {
    my $self = shift;
    my $data = shift;
    Dump($data);
}

1;
