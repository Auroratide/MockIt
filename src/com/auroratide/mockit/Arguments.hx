package com.auroratide.mockit;

@:forward abstract Arguments(Array<Argument>) from Array<Argument> {

    public inline function new() {
        this = new Array<Argument>();
    }

    @:arrayAccess public inline function get(key:Int) {
        return this[key];
    }

    @:arrayAccess public inline function arrayWrite(k:Int, v:Argument):Argument {
        this[k] = v;
        return v;
    }

    @:op(A == B) public static function equals(lhs:Arguments, rhs:Array<Dynamic>):Bool {
        if(lhs.length != rhs.length)
            return false;

        for(i in 0...lhs.length)
            if(lhs[i] != rhs[i])
                return false;

        return true;
    }

    @:op(A != B) public static function nequals(lhs:Arguments, rhs:Array<Dynamic>):Bool {
        return !(lhs == rhs);
    }

}

abstract Argument(ArgumentType) from ArgumentType to ArgumentType {

    @:from public static function fromDynamic(obj:Dynamic):Argument {
        return Is(obj);
    }

    @:op(A == B) public static function equals(lhs:Argument, rhs:Dynamic):Bool {
        switch(lhs) {
            case Is(l):       return l == rhs;
            case IsNull:      return rhs == null;
            case IsNotNull:   return rhs != null;
            case Contains(l): return Lambda.has(rhs, l);
            case Matches(r):  return r.match(rhs);
            case ArgThat(f):  return f(rhs);
            case Any:         return true;
        }
    }

    @:op(A != B) public static function nequals(lhs:Argument, rhs:Dynamic):Bool {
        return !(lhs == rhs);
    }

}

enum ArgumentType {
    Is(value:Dynamic);
    IsNull;
    IsNotNull;
    Contains(value:Dynamic);
    Matches(regex:EReg);
    ArgThat(pred:Dynamic->Bool);
    Any;
}