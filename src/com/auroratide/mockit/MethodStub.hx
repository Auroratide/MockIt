package com.auroratide.mockit;

import haxe.Constraints.IMap;

class MethodStub<T> {

    private var args:Arguments;
    private var returns:ArgumentsMap<T>;

    public function new() {
        this.args = new Arguments();
        this.returns = new ArgumentsMap<T>();
    }

    public function with(args:Arguments):MethodStub<T> {
        this.args = args;
        returns.create(args);
        return this;
    }

    public function then(value:T):MethodStub<T> {
        returns.get(args).push(Value(value));
        return this;
    }

    public function error(error:Dynamic):MethodStub<T> {
        returns.get(args).push(Error(error));
        return this;
    }

    public function execute(f:Array<Dynamic>->T):MethodStub<T> {
        returns.get(args).push(Action(f));
        return this;
    }

    public function always():Void {
        var returnArray = returns.get(args);
        returnArray.push(Always(returnArray[returnArray.length - 1]));
    }

    public function next(args:Arguments):T {
        if(!returns.exists(args) || returns.get(args).length <= 0)
            return null;

        var returnArray = returns.get(args);
        switch(returnArray[0]) {
            case Value(v): returnArray.shift(); return v;
            case Error(e): returnArray.shift(); throw e;
            case Action(f): returnArray.shift(); return f(args.toArray());
            case Always(Value(v)): return v;
            case Always(Error(e)): throw e;
            case Always(Action(f)): return f(args.toArray());
            case Always(Always(_)): return null;
        }
    }

}

private enum ReturnType<T> {
    Value(v:T);
    Error(e:Dynamic);
    Action(f:Array<Dynamic>->T);
    Always(r:ReturnType<T>);
}

private class ArgumentsMap<T> implements IMap<Arguments, Array<ReturnType<T>>> {

    private var keys_:Array<Arguments>;
    private var values_:Array<Array<ReturnType<T>>>;

    public function new() {
        keys_ = new Array<Arguments>();
        values_ = new Array<Array<ReturnType<T>>>();
    }

    public function get(k:Arguments):Null<Array<ReturnType<T>>> {
        return values_[find(k)];
    }

    public function create(k:Arguments):Void {
        set(k, new Array<ReturnType<T>>());
    }

    public function set(k:Arguments, v:Array<ReturnType<T>>):Void {
        var index = keys_.indexOf(k);
        if(index < 0) {
            keys_.push(k);
            values_.push(v);
        }
        else {
            keys_[index] = k;
            values_[index] = v;
        }
    }

    public function exists(k:Arguments):Bool {
        return find(k) >= 0;
    }

    public function remove(k:Arguments):Bool {
        var success = true;
        success = success && values_.remove(get(k));
        return keys_.remove(k) && success;
    }

    public function keys():Iterator<Arguments> {
        return keys_.iterator();
    }

    public function iterator():Iterator<Array<ReturnType<T>>> {
        return values_.iterator();
    }

    public function toString():String {
        return "{ArrayMap}";
    }

    private function find(k:Arguments):Int {
        var index = 0;
        for(key in keys()) {
            if(k == key)
                return index;
            ++index;
        }
        return -1;
    }

}