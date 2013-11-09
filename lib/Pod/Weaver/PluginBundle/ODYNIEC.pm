use strict;
use warnings;

package Pod::Weaver::PluginBundle::ODYNIEC;
# VERSION

use Pod::Weaver 4; # he played knick-knack on my door
use Pod::Weaver::Config::Assembler;

# Dependencies
use Pod::Weaver::Plugin::WikiDoc  ();
use Pod::Elemental::Transformer::List 0.101620 ();
use Pod::Weaver::Section::Support 1.001        ();
use Pod::Weaver::Section::Contributors 0.001   ();

sub _exp { Pod::Weaver::Config::Assembler->expand_package( $_[0] ) }

my $repo_intro = <<'END';
This is open source software.  The code repository is available for
public review and contribution under the terms of the license.
END

my $bugtracker_content = <<'END';
Please report any bugs or feature requests through the issue tracker
at {WEB}.
You will be notified automatically of any progress on your issue.
END

sub mvp_bundle_config {
    my @plugins;
    push @plugins, (
        [ '@ODYNIEC/SingleEncoding', _exp('-SingleEncoding'), {} ],
        [ '@ODYNIEC/WikiDoc',        _exp('-WikiDoc'),        {} ],
        [ '@ODYNIEC/CorePrep',       _exp('@CorePrep'),       {} ],
        [ '@ODYNIEC/Name',           _exp('Name'),            {} ],
        [ '@ODYNIEC/Version',        _exp('Version'),         {} ],

        [ '@ODYNIEC/Prelude',     _exp('Region'),  { region_name => 'prelude' } ],
        [ '@ODYNIEC/Synopsis',    _exp('Generic'), { header      => 'SYNOPSIS' } ],
        [ '@ODYNIEC/Description', _exp('Generic'), { header      => 'DESCRIPTION' } ],
        [ '@ODYNIEC/Usage',       _exp('Generic'), { header      => 'USAGE' } ],
        [ '@ODYNIEC/Overview',    _exp('Generic'), { header      => 'OVERVIEW' } ],
        [ '@ODYNIEC/Stability',   _exp('Generic'), { header      => 'STABILITY' } ],
    );

    for my $plugin (
        [ 'Requirements', _exp('Collect'), { command => 'requires' } ],
        [ 'Attributes',   _exp('Collect'), { command => 'attr' } ],
        [ 'Constructors', _exp('Collect'), { command => 'construct' } ],
        [ 'Methods',      _exp('Collect'), { command => 'method' } ],
        [ 'Functions',    _exp('Collect'), { command => 'func' } ],
      )
    {
        $plugin->[2]{header} = uc $plugin->[0];
        push @plugins, $plugin;
    }

    push @plugins,
      (
        [ '@ODYNIEC/Leftovers', _exp('Leftovers'), {} ],
        [ '@ODYNIEC/postlude', _exp('Region'), { region_name => 'postlude' } ],
        [
            '@ODYNIEC/Support',
            _exp('Support'),
            {
                perldoc            => 0,
                websites           => 'none',
                bugs               => 'metadata',
                bugs_content       => $bugtracker_content,
                repository_link    => 'both',
                repository_content => $repo_intro
            }
        ],
        [ '@ODYNIEC/Authors',      _exp('Authors'),      {} ],
        [ '@ODYNIEC/Contributors', _exp('Contributors'), {} ],
        [ '@ODYNIEC/Legal',        _exp('Legal'),        {} ],
        [ '@ODYNIEC/List', _exp('-Transformer'), { 'transformer' => 'List' } ],
      );

    return @plugins;
}

# ABSTRACT: ODYNIEC's default Pod::Weaver config
# COPYRIGHT

1;

=for Pod::Coverage mvp_bundle_config

=head1 DESCRIPTION

This is a L<Pod::Weaver> PluginBundle.  It is roughly equivalent to the
following weaver.ini:

  [-WikiDoc]

  [@Default]

  [Support]
  perldoc = 0
  websites = none
  bugs = metadata
  bugs_content = ... stuff (web only, email omitted) ...
  repository_link = both
  repository_content = ... stuff ...

  [Contributors]

  [-Transformer]
  transformer = List

=head1 USAGE

This PluginBundle is used automatically with the C<@ODYNIEC> L<Dist::Zilla>
plugin bundle.

It also has region collectors for:

=for :list
* requires
* construct
* attr
* method
* func

=head1 SEE ALSO

=for :list
* L<Pod::Weaver>
* L<Pod::Weaver::Plugin::WikiDoc>
* L<Pod::Elemental::Transformer::List>
* L<Pod::Weaver::Section::Contributors>
* L<Pod::Weaver::Section::Support>
* L<Dist::Zilla::Plugin::PodWeaver>

=cut
