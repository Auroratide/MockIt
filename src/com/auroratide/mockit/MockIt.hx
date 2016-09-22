package com.auroratide.mockit;

class MockIt {

    public var verifier(default, null):Verifier;
    public var stubber(default, null):Stubber;

    public function new() {
        this.verifier = new Verifier();
        this.stubber = new Stubber();
    }

    public inline function called(method:String, args:Arguments):Int {
        return verifier.called(method, args);
    }

    public function call<T>(method:String, args:Array<Dynamic>, ?defaultValue:T):T {
        verifier.call(method, args);
        var returnValue = stubber.next(method, args);
        return returnValue == null ? defaultValue : returnValue;
    }

}
