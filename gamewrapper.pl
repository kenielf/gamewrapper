#!/usr/bin/env perl
BEGIN {
    use FindBin qw($RealBin);
    use lib "$RealBin/lib";
}

use constant DEBUG => 0;

use warnings;
use strict;

use Env qw($GAMESCOPE $MANGOHUD $ZINK);

my @cmdLine = (@ARGV);

# Load preset
use GameWrapper::Preset;

# Patch the cmdLine according to the preset instructions
@cmdLine = GameWrapper::Preset::PatchCmdLine(@cmdLine);

# Run Gamescope if the preset asks and it's ENV flag isn't 0
if ( not( defined $GAMESCOPE and $GAMESCOPE == 0 )
    and GameWrapper::Preset::IsUsing('Gamescope') )
{
    use Gamescope;
    Gamescope::SetConfig(%GameWrapper::Preset::GamescopeConfig);
    @cmdLine = ( Gamescope::GetCommandLine, @cmdLine );
}

# Load MangoHud if the preset asks and it's ENV flag isn't 0
if ( not( defined $MANGOHUD and $MANGOHUD == 0 )
    and GameWrapper::Preset::IsUsing('MangoHud') )
{
    use MangoHud;
}

# Use Zink if the preset asks and it's ENV flag isn't 0
if ( not( defined $ZINK and $ZINK == 0 )
    and GameWrapper::Preset::IsUsing('Zink') )
{
    use Zink;
}

# If either the DEBUG constant or the ENV flag is set to 1, print `@cmdLine` instead running it
if ( DEBUG or ( defined $ENV{'DEBUG'} and $ENV{'DEBUG'} == 1 ) ) {
    use GameWrapper qw($Platform $GameID);
    my $Preset = GameWrapper::Preset::GetPath();
    print "[Game]\n"
      . "Platform=$Platform\n"
      . "GameID=$GameID\n"
      . "\n[Wrapper]\n"
      . "Preset=$Preset\n"
      . "\n[Output]\n"
      . "cmdLine="
      . join( " ", @cmdLine ) . "\n";

    #sleep(86400);
    exit;
}

# equivalent to POSIX C's `execve(cmdLine[0], cmdLine, ENV);`
exec { $cmdLine[0] } @cmdLine;    # safe even with one-arg list
