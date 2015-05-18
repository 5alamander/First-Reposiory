

A = {
	_name : "a",
	_age : 1,
	set name(name){this._name = name},
	get name(){return this._name},
	set age(age) {this._age = age},
	get age() {return this._age},
}

A.name = "b"
console.log(A.name)

var context = (function(){
	var welcomeScene = "a";
	function Context() {
		this.welcomeScene = "b";
	}
	Context.prototype = {
		get welcomeScene() {
			return this.welcomeScene;
		}
	}
	return Context;
}());


console.log(context);