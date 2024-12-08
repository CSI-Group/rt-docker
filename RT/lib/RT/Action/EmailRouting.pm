package RT::Action::EmailRouting;

use strict;
use warnings;
use base 'RT::Action';

 sub Prepare {
        my $self = shift;

        # Your code here

        return 1; # True if Commit should run, false if not
}

sub Commit {
    my $self = shift;

    my $domains = {};

    my %domain_map = (
                        '\@trust\.ru'   => "TRUST",
                        'lkorokh\@gmail\.com'   => "TRUST",
                    );
    my $ra = $self->TicketObj->RequestorAddresses;
    RT::Logger->info("Routing ticket for $ra");

    #Check each of our defined domains for a match
    foreach my $domainKey (keys %domain_map ){
        RT::Logger->info("Matching $ra with $domainKey");

        if($self->TicketObj->RequestorAddresses =~ /^.*?${domainKey}/) {
            RT::Logger->info("Matching $ra with $domainKey");
            # Domain matches - move to the right queue
            $self->TicketObj->SetQueue($domain_map{$domainKey});
        }
    }
    return 1; # True if action was successful
}

1;