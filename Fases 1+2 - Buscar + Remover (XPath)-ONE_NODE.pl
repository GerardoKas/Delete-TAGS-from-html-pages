# Version: 1.0
use warnings;
use strict;
use XML::LibXML qw();
use strict;
use v5.10;
use File::Copy;
use File::Find;
use File::Basename;

use Encode qw( encode decode );
use utf8;

my $log = "ErrorFase_1_2.log";
unlink $log;


my @XPaths = (
'//script',
'//meta');

my @SingleXPath = (
    '/html/body/div[2]/div/section/div/div[1]/main/div[3]/div[1]'
);

my $xpath_to_copy ='//*[@class="content "]';

mEcho("\nInicio ...");
my $dir = shift or die("No hay directorio de enetradaa");
my $dom  = "";
my $root = "";
my $dom_string = "";
my $file_save = "";
my $numFiles  = 0;

find( \&wanted, $dir );
mEcho("Total Files: $numFiles");
mEcho("FINITO--");


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
        getXpathNodes();
        copyNode();
        eliminaEspacios();
        codificar();
        saveTheThing();
    }

}
sub copyNode {
    mEcho("Copying node...");
    mEcho("Replacing body children with a node having class 'content '...");

    # 1. Encontrar el nodo 'body'
    my @body_nodes = $dom->findnodes('/html/body');
    unless ($body_nodes[0]) {
        mEcho("Error: Nodo 'body' no encontrado.");
        return;
    }
    my $body = $body_nodes[0];
    mEcho("Nodo 'body' encontrado.");

    # 2. Encontrar el nodo con la clase "content " (con el espacio)
    my @nodes_to_copy = $dom->findnodes('.//*[@class="content "]');
    mEcho("Se encontraron " . scalar(@nodes_to_copy) . " nodos con la clase 'content '.");

    if ($nodes_to_copy[0]) {
        my $node_to_copy = $nodes_to_copy[0];
        my $copied_node = $node_to_copy->cloneNode(1);
        mEcho("Nodo con clase 'content ' encontrado y clonado: " . $copied_node->getName());

        # 3. Vaciar el 'body' eliminando todos sus hijos
        my $children_removed = 0;
        while ($body->firstChild) {
            $body->removeChild($body->firstChild);
            $children_removed++;
        }
        mEcho("Se eliminaron " . $children_removed . " hijos del nodo 'body'.");

        # 4. Añadir el nodo copiado al 'body'
        $body->appendChild($copied_node);
        mEcho("Nodo copiado (clase 'content ') añadido al 'body': " . $copied_node->getName());

    } else {
        mEcho("Error: No se encontró ningún nodo con la clase 'content ' en el documento.");
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
    $dom=~ s/&#13;//g;	
    my $count = $dom =~ s/^\s+$//gm;
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


my @XPaths = (
'//*[@id="navbar"]',
'//script',
'//meta',
'//section',
'//*[@id="footer"]',
'//footer',
'//header',
'//link',
'//style',
'//noscript',
'//aside');
