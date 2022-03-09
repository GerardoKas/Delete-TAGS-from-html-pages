use strict;
use warnings;
use XML::LibXML;
use v5.10;
use File::Copy;
use Data::Dumper;

#use XML::LibXML::Node;
use Encode qw( encode decode );
use utf8;

#use XML::LibXML::Document ;
my $log = "errores_RemoveTgs.log";

#unlink $log;

mEcho("\nInicio ...");

my $file_save   = shift;
my $file_backup = "$file_save.bak";
mEcho("Haciendo .bak $file_backup");
copy( "$file_save", "$file_backup" ) or die "Copy failed: $!";

#system("title $file_save");

my @XPaths = (
    '//*[@id="content-header"]',          '//*[@id="footer-interactive"]',
    '//*[@id="recommendations-section"]', '//*[@id="footer"]',
    '//*[@id="action-panel"]',            '//*[@id="cookie-consent-holder"]',
    '//*[@id="disclaimer-holder"]',       '//*[@id="action-panel"]',
    '//script'

      #,    '//meta'

);
my @SingleXPath = (
    '/html/body/div',
    '/html/body/section', '/html/body/div[1]'
);

mEcho("Parsing ... \n");
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

my $dom = $parser->parse_html_file($file_save);

#$dom->setEncoding('UTF-8');
my $root = $dom->documentElement();
#print Dumper $root;
mEcho("Yenndo ....");
getXpathNodes();
getXpathSingleNode();
#eliminaEspacios();

mEcho("GRadando...");
codificar($dom);
open( SAVE, ">$file_save" );
binmode( SAVE, ":utf8" );
print SAVE $root;
close SAVE;
mEcho("TErminado.");

exit;

sub codificar {
    mEcho("Codificando..");
    my $decoded = decode( 'UTF-8', $dom );    # <-- This was missing.
    $dom = encode( 'cp1252', $decoded );
}

sub getXpathNodes {
    for my $i (@XPaths) {
        my @style_node = $dom->findnodes($i);
        my $node       = "";
        for $node (@style_node) {
            mEcho("Multi XPath...$i");
            $node->parentNode()->removeChild($node);
        }
    }
}

sub getXpathSingleNode {
    for my $i (@SingleXPath) {
      my  $nodo=$dom->find($i);
     # Dumper($nodo);

      $root->$dom->removeChild($nodo);
            #Dumper($nodo);
    }
}

sub mEcho {
    my $e = shift;
    open( ER, ">>$log" );
    print ER "$e\n$!\n";
    close ER;
    say $e;
}

sub eliminaEspacios {
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



ERRORES


#         if ($nodo){
#        mEcho( Dumper($nodo))    ;
#         mEcho("Single XPath...$i");
#         };
#         #my $nedo = $dom->findnodes($i);
#         #  $dom->find($i)->removeChild  () ;
#       #  
#        # mEcho(Dumper ($i));
#  #. $nodo->to_literal() . " to be deleted\n";
#   #  my $name = $nodo->to_literal();
    
#        mEcho( Dumper($name))   ;
#     my $parent = $name-> parentNode();
#     say $parent-> removeChild($i)
