package com.auroratide.mockit;

@:forward abstract Arguments(Array<Argument>) from Array<Argument> {

    public inline function new() {
        this = new Array<Argument>();
    }

    public function toArray():Array<Dynamic> {
        var arr = new Array<Dynamic>();
        for(arg in this) {
            switch(arg) {
                case Is(v): arr.push(v);
                case Contains(v): arr.push([v]);
                case Any: arr.push(null);
            }
        }

        return arr;
    }

    @:arrayAccess public inline function get(key:Int) {
        return this[key];
    }

    @:arrayAccess public inline function arrayWrite(k:Int, v:Argument):Argument {
        this[k] = v;
        return v;
    }

    @:op(A == B) public static function equals(lhs:Arguments, rhs:Arguments):Bool {
        if(lhs.length != rhs.length)
            return false;

        for(i in 0...lhs.length)
            if(lhs[i] != rhs[i])
                return false;

        return true;
    }

    @:op(A != B) public static function nequals(lhs:Arguments, rhs:Arguments):Bool {
        return !(lhs == rhs);
    }

}

abstract Argument(ArgumentType) from ArgumentType to ArgumentType {

    @:from public static function fromDynamic(obj:Dynamic):Argument {
        return Is(obj);
    }

    @:op(A == B)
    public static function equals(lhs:Argument, rhs:Argument):Bool {
        switch(lhs) {
            case Any: return true;
            case Contains(l):
                switch(rhs) {
                    case Any: return true;
                    case Contains(r): return false;
                    case Is(r): return Lambda.has(r, l);
                }
            case Is(l):
                switch(rhs) {
                    case Any: return true;
                    case Contains(r): return Lambda.has(l, r);
                    case Is(r): return l == r;
                }
        }
    }

    @:op(A != B)
    public static function nequals(lhs:Argument, rhs:Argument):Bool {
        return !(lhs == rhs);
    }

}

enum ArgumentType {
    Is(value:Dynamic);
    Contains(value:Dynamic);
    Any;
}