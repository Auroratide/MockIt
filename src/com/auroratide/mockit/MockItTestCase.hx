package com.auroratide.mockit;

import haxe.PosInfos;
import haxe.unit.TestCase;

class MockItTestCase extends TestCase {

    function verify(mock:Mock, method:String, ?args:Arguments, ?times:Times, ?c:PosInfos):Void {
        if(args == null)
            args = new Arguments();
        if(times == null)
            times = Exactly(1);
        currentTest.done = true;

        var timesInvoked = mock.mockit.verifier.called(method, args);
        if(!switch(times) {
            case Zero: 0 == timesInvoked;
            case Exactly(n): n == timesInvoked;
            case AtLeast(n): n <= timesInvoked;
            case AtMost(n): n >= timesInvoked;
        }) {
            currentTest.success = false;
            currentTest.error = 'expected $times invocations of $method, but got $timesInvoked';
            currentTest.posInfos = c;
            throw currentTest;
        }
    }

    function when<T>(mock:Mock, method:String, ?args:Arguments):MethodStub<T> {
        if(args == null)
            args = [];
        return mock.mockit.stubber.when(method).with(args);
    }

}

enum Times {
    Zero;
    Exactly(n:Int);
    AtLeast(n:Int);
    AtMost(n:Int);
}

private typedef Mock = {
    var mockit:MockIt;
}