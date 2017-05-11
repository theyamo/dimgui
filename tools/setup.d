#!/usr/bin/env rdmd

import tools;

void main() {
    import std.process : Config;
    immutable string process  = "`dimgui` setup"
                   , buildDir = "build";
    immutable string[string] env;
    writeln( "Perform " ~ process );
    tuple( 
        tuple( ["git", "submodule", "init"  ] ),
        tuple( ["git", "submodule", "update"] ),
        tuple( ["mkdir", "-p", buildDir] )      ,
        tuple( ["cmake", ".."], env
             , Config.none
             , size_t.max
             , buildDir ),
        tuple( ["make"], env
             , Config.none
             , size_t.max
             , buildDir )
    ).whileIs!run
    ? writeln( process ~ ": SUCCESS" )
    : writeln( process ~ ": FAILURE" );
}
