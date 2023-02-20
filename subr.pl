#!/usr/bin/perl
use strict;
use warnings;

my @episodes = glob(qq(*.mkv *.mp4 *.webm *.m4p *.m4v *.MTS *.M2TS *.TS *.ogg *.ogv));
my @subtitles = glob(qq(*.aqt *.gsub *.jss *.sub *.ttxt *.pjs *.psb *.rt *.smi *.ssf *.srt *.ssa *.ass *.sbv *.usf *.idx *.vtt));

die qq(FATAL: No episodes found\n) if scalar(@episodes) == 0;
die qq(FATAL: No subtitles found\n) if scalar(@subtitles) == 0;

for (my $i = 0, my $c = 1; $i < scalar(@episodes);){
    if (grep {$_ == $c} @ARGV){
        splice(@episodes,$i,1);
    } else {
        print qq($c: Found episode $episodes[$i]\n);
        $i++;
    }
    $c++;
}
my $episodeCount = @episodes;
print qq(>>> Found $episodeCount episodes\n);

for (my $i = 0; $i < scalar(@subtitles); $i++){
    print $i+1, qq(: Found subtitle $subtitles[$i]\n);
}
my $subtitleCount = @subtitles;
print qq(>>> Found $subtitleCount subtitles\n);

if ($episodeCount == $subtitleCount){
    print qq(>>> Episode count matches subtitle count, matching linearly\n);
} else {
    die qq(FATAL: Episode count does not match subtitle count. Please use the arguments to exclude extra video files\n)
}

print qq(>>> Renaming subtitles\n);
for (my $i = 0; $i < scalar(@episodes); $i++){
    $episodes[$i] =~ /^(.+)\.\w+$/;
    my $episodeName = $1;
    $subtitles[$i] =~ /(\.[^.]+)$/;
    my $subtitleSuffix = $1;

    rename $subtitles[$i], $episodeName . $subtitleSuffix or die qq(FATAL: Could not rename $subtitles[$i]: $!\n);
}
print qq(SUCCESS: Completed renaming of subtitles\n);
1
