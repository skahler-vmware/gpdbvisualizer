# if you want to see what happens in more detail
#SOURCEY_VERBOSE=1

# if you want to force sourcey to rebuild everything
SOURCEY_REBUILD=1

# the old version of perl works for this app may need
# to build a later one as it gets more fancy
#buildPerl 5.20.2

# build perl modules
# this calles cpanm internally ... 
buildPerlModule Mojolicious Digest::SHA1 JSON Clone HOP::Lexer

# Copy the GP::Explain pieces over as part of the delivered package
# until it is submitted and intergrated as a CPAN module
cd $WORK_DIR
cp -r $BUILD_DIR/GP /home/vcap/sourcey/lib/perl5/
