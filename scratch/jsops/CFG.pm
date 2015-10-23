package CFG;

use strict;

our $VERSION = 1.00;

sub set
{
    my $self = shift;
    my $value = pop;
    my $key = pop;
    return unless defined $key;
    return unless defined $value;
    for (@_) {
        $self->{$_} = {} unless exists $self->{$_};
        $self = $self->{$_};
    }
    $self->{$key} = $value;
    return $value;
}

sub get
{
    my $self = shift;
    my $key = pop;
    return unless defined $key;
    for (@_) {
        return unless exists $self->{$_};
        $self = $self->{$_};
    }
    return $self->{$key};
}

sub load
{
    my ($self, $file) = @_;

    my $cfg;
    return unless open $cfg, '<', $file;
    my @context = ();
    my $id = qr/[a-z_][a-z0-9_.-]*/;
    while (<$cfg>) {
        next if /^\s*[^!"\$\%\&]\/\(\)\[\]\{\}=\?*+~'#,;:<>|-]/;
        if (/^\s*(\.?)($id):\s*$/) {
            @context = () unless $1;
            push @context, split ('\.', $2);
            next;
        }
        if (/^\s*(\.?)($id)\s*=\s*(.+)\r?\n$/i) {
            @context = () unless $1;
            my @key = @context;
            push @key, split ('\.', $2);
            $self->set (@key, $3);
            next;
        }
    }
    close $cfg;
}

sub new
{
    my ($class, $file) = @_;
    my $self = bless {}, $class;

    $self->load ($file) if defined $file;

    return $self;
}

1;
