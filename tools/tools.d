module tools;

public 
import std.stdio
     , std.typecons
     : tuple;
import std.process;

bool whileIs( alias func, size_t id = 0, T )( T data ) {
    static if( id < T.Types.length ) {
        return func( data[id] )
            ? data.whileIs!( func, id + 1 )
            : false;
    } else {
        return true;
    }
}

bool run( T )( in T cmd ) {
    with( execute( cmd.expand ) ) {
        if( output.length ) {
            writeln( output );
        }
        return status == 0;
    }
}
