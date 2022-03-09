
#perl
use strict;
use warnings;
use autodie;
use v5.10;
use File::Find;
use File::Basename;

# my $log = "errores_RemoveTgs.txt";
# unlink $log;

my $numFiles;
my $dirname = dirname($0);

my $script = "$dirname\\Fase 2 - Remover.pl";

my $dir = shift or die("No hay directorio de enetradaa");

#say $script;
find( \&wanted, $dir );

say "Ya no ha y mas ficheros";

sub wanted {
    my $file = $File::Find::name;
    if ( $file =~ /\.html?$/i ) {

        $numFiles++;
        say "Going to It:: --> $file";
        #say ("Ejecutando Script perl...");
        # system("perl.exe \"".$script."\" \"$file\"");
        my $exec = "perl.exe \"" . $script . "\" \"$file\"";
        system($exec);
    }

}

 __END__
        # Do something...
        # Some useful variables:
        # say "\$_ - ". $_;                   # File name in each directory
        # say "\$File::Find::dir - ". $File::Find::dir;     # the current directory name
        # say "\$File::Find::name  - ".$File::Find::name;    # the complete pathname to the file
    

