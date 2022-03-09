use strict;
use warnings;
use XML::LibXML qw( );
use v5.10;
use File::Copy;
use File::Find;
use File::Basename;

use Encode qw( encode decode );
use utf8;

my $log = "ErrorFase_1_2.log";

unlink $log;
my @XPaths = (

    '//*[@id="content-header"]',
    '//*[@id="footer-interactive"]',
    '//*[@id="recommendations-section"]',
    '//*[@id="footer"]',
    '//*[@id="action-panel"]',
    '//*[@id="cookie-consent-holder"]',
    '//*[@id="disclaimer-holder"]',
    '//*[@id="action-panel"]',
    '//script',
    '//meta',
    '//*[@id="footer"]',

);
my @SingleXPath = (
    '/html/body/div/a/html/body/div/a',
     '/html/body/div/section',
    '/html/body/div/a'
 
);
mEcho("\nInicio ...");
my $dir  = shift or die("No hay directorio de enetradaa");
my $dom  = "";
my $root = "";

my $file_save = "";
my $numFiles  = 0;
find( \&wanted, $dir );
mEcho("Total Files: $numFiles");
mEcho("FINITO--");


mEcho("ECHO".@XPaths);

exit;

sub wanted {
    my $f=$_;
    $file_save = $File::Find::name;
    #mEcho("$f\n");
    if ( $file_save =~ /\.html?$/i ) {
        $numFiles++;
        $file_save =~ s|\\|\/|g;
        mEcho("\n\nThisOne:($numFiles)($f)");
        createBak();
        getParser();
        getXpathNodes($dom);
        getXpathSingleNode($dom);
        codificar();
      #  eliminaEspacios();
        &saveTheThing();
    }

}



sub getXpathNodes {
   # mEcho( "HAY - @XPaths ");
    for my $c (@XPaths) {
     #   mEcho("PATH.$c");
        my @style_node = $dom->findnodes($c);

        for my $node (@style_node) {
            mEcho("Multi XPath...$c");
            $node->parentNode()->removeChild($node);
        }
    }
}

sub getXpathSingleNode {
    mEcho( "HAY - @SingleXPath");
    for my $c (@SingleXPath) {
        mEcho("getXPathSingleNod.$c");
        if ( my @nodo = $root->findnodes($c) ) {
            mEcho("Exsteel nodo. $c");
            my $parent = $nodo[0]->parentNode();
            $parent->removeChild( $nodo[0] );
        }
        if ( $root->findnodes($c) ) {
            mEcho("Aun existe");
        }  
    }

}


sub createBak {
    mEcho("BakingUp...");
    my $file_backup = "$file_save.bak";
    copy( "$file_save", "$file_backup" ) or die "Copy failed: $!";
}

sub getParser {
    mEcho("Parse...");
    my $parser = XML::LibXML->new();
    $parser->set_options(
        {
            recover           => 2,
            validation        => 0,
            suppress_errors   => 1,
            suppress_warnings => 1,
            pedantic_parser   => 0,
            load_ext_dtd      => 0,
        }
    );

    $dom = $parser->parse_html_file($file_save);
$root = $dom->getDocumentElement();
}

sub saveTheThing {
    mEcho("SAve The Tginhg...");
    open( SV, ">$file_save" );
    binmode( SV, ":utf8" );
    print SV $dom;
    close SV;
}

sub codificar {
    mEcho("Codificando..");
    my $decoded = decode( 'UTF-8', $dom );    # <-- This was missing.
    $dom = encode( 'cp1252', $decoded );
}
sub mEcho {
    my $e =shift;   
    open( ER, ">>$log" );
    print ER "$e\n[$!]\n";
    close ER;
    say "$e";
}

sub eliminaEspacios {
    mEcho("Elimina espacios");
    my $count = $dom =~ s/(^(\s+)$)/ /gm;
    mEcho("$count espacioseliminados");
}

__END__




 my @perlMaven= (
#     '//*[@id="sites"]',
#     '/html/body/div[1]/div[1]/div/nav/div/div[1]',
#     '//*[@id="navbar"]/ul[2]',
#      '//script'
    # '//*[@id="navbar"]/ul',
    # '//*[@id="left-column"]'
    # '/html/body/div[1]/div[2]/div[3]',
    # '/html/body/div[1]/div[2]/div[2]',
    # '/html/body/div[1]/div[1]/div/nav'
    # #,    '//*[@id="show_content"]/div[4]'
);
