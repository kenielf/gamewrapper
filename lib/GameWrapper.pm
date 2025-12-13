package GameWrapper;

use warnings;
use strict;

our $VERSION = '1.00';

require Exporter;
our @EXPORT_OK = qw($Platform $GameID DetectPlatform GetGameID);
our @ISA       = qw(Exporter);

our $Platform = 'Unknown';
our $GameID   = 'Unknown';

sub import {

    # Initialize the values of $Platform and $GameID
    $GameWrapper::Platform = DetectPlatform();
    $GameWrapper::GameID   = GetGameID();

    # Export package contents when `import` is called
    __PACKAGE__->export_to_level( 1, @_ );
}

sub DetectPlatform {

    # Skip detection when $Platform is already known
    unless ( $Platform eq 'Unknown' ) { return $Platform }

    # Use ENV vars to detect when it's a Steam game
    use Env qw($STEAM_COMPAT_APP_ID $SteamGameId $SteamAppId);
    if (   defined $STEAM_COMPAT_APP_ID
        or defined $SteamGameId
        or defined $SteamAppId )
    {
        return 'Steam';
    }

    # Otherwise return 'Unknown' (fallback value)
    return 'Unknown';
}

sub GetGameID {

    # Skip detection when $GameID is already known
    unless ( $GameID eq 'Unknown' ) { return $GameID }

    # Try to GameID from Steam ENV vars
    if ( $Platform eq 'Steam' ) {

        if    ( defined $SteamAppId )          { return $SteamAppId }
        elsif ( defined $SteamGameId )         { return $SteamGameId }
        elsif ( defined $STEAM_COMPAT_APP_ID ) { return $STEAM_COMPAT_APP_ID }
        else                                   { return '0' }

        # See also:
        # - https://github.com/ValveSoftware/steam-runtime/issues/741
        # - https://github.com/ValveSoftware/steam-runtime/issues/287
    }

    # Otherwise return 'Unknown' (fallback value)
    return 'Unknown';
}
