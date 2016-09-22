package com.auroratide.mockit;

class Stubber {

    var methods:Map<String, MethodStub<Dynamic>>;

    public function new() {
        this.methods = new Map<String, MethodStub<Dynamic>>();
    }

    public function when<T>(method:String):MethodStub<T> {
        var stub = new MethodStub<T>();
        methods.set(method, stub);
        return stub;
    }

    public function next<T>(method:String, args:Array<Dynamic>):T {
        if(!methods.exists(method))
            return null;
        return methods.get(method).next(args);
    }

}
