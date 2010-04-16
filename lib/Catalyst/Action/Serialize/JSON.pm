package Catalyst::Action::Serialize::JSON;

use Moose;
use namespace::autoclean;

extends 'Catalyst::Action';
use JSON ();

our $VERSION = '0.83';
$VERSION = eval $VERSION;

has encoder => (
   is => 'ro',
   lazy_build => 1,
);

sub _build_encoder {
   my $self = shift;
   my $args = $self->{_sarg} || {};

   map { $args->{$_}=1 unless defined($args->{$_}) } qw/utf8 convert_blessed/;

   my $enc = JSON->new;
   foreach my $flag (keys %$args) { $enc->$flag($args->{$flag}) }
   return $enc;
}

sub execute {
    my $self = shift;
    my ( $controller, $c, $sarg ) = @_;
    $self->{_sarg} = $sarg;

    my $stash_key = (
            $controller->{'serialize'} ?
                $controller->{'serialize'}->{'stash_key'} :
                $controller->{'stash_key'}
        ) || 'rest';
    my $output = $self->serialize( $c->stash->{$stash_key} );
    $c->response->output( $output );
    return 1;
}

sub serialize {
    my $self = shift;
    my $data = shift;
    $self->encoder->encode( $data );
}

1;
