package GameWrapper::Preset;
use warnings;
use strict;

our $VERSION = '1.00';

#//require Exporter;
#//our @EXPORT = qw(%FeatureFlags %GamescopeConfig &PatchEnv &PatchCmdLine);
#//our @ISA = qw(Exporter);

use FindBin qw($RealBin);

our $fallbackPreset = "$RealBin/Presets/Default.pm";

sub import { require( GetPath() ) }

sub GetPath {
    use Env         qw($GW_PRESETS $GW_PRESET);
    use GameWrapper qw($Platform $GameID);

    # Returns $GW_PRESET if it's already set while pointing to a valid file
    if ( defined $GW_PRESET and length $GW_PRESET and -f $GW_PRESET ) {
        return $GW_PRESET;
    }

    # Sets a default "Preset Dir" unless it's already set
    unless ( defined $GW_PRESETS and length $GW_PRESETS ) {
        $GW_PRESETS = "$RealBin/Presets";
    }

    # Sets $GW_PRESET and return it if pointing to a valid file
    $GW_PRESET = "$GW_PRESETS/$Platform/$GameID.pm";
    if ( -f $GW_PRESET ) { return $GW_PRESET }

    # Otherwise set to the Fallback Preset
    $GW_PRESET = $fallbackPreset;
    return $GW_PRESET;

}

#! The following subroutine is indeed giving a Warn, i don't know how to fix (yet), but it works just fine (by now)
sub IsUsing {

    # Return the "Feature Flag" value;
    return %GameWrapper::Preset::FeatureFlags{@_};
}
