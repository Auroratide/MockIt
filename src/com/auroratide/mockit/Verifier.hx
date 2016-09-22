package com.auroratide.mockit;

class Verifier {

    private var methods:Map<String, Array<Arguments>>;

    public function new() {
        methods = new Map<String, Array<Arguments>>();
    }

    public function called(method:String, args:Arguments):Int {
        if(!methods.exists(method))
            return 0;

        return Lambda.count(methods.get(method), Arguments.equals.bind(args));
    }

    public function call(method:String, args:Arguments):Void {
        if(!methods.exists(method))
            methods.set(method, new Array<Arguments>());

        methods.get(method).push(args);
    }

}
