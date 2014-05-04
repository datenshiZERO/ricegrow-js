(function(){
  $(function() {
    var gameFsm = new machina.Fsm({
      initialState: "startGame",
      data: {
      },
      states: {
        "startGame" : {
          "input" : function(line) {
            this.message = "Please answer YES or NO."
          }
        },
        "intro1": {
        }
      }
    });
    var console1 = $("#console1");
    var controller1 = console1.console({
      promptLabel: '> ',
      commandValidate: function() { return true; },
      commandHandle:function(line){
         gameFsm.handle("input", line);
         return gameFsm.message;
      },
      autofocus:true,
      animateScroll:true,
      promptHistory:true,
      welcomeMessage: "    ARE YOU FAMILIAR ENOUGH WITH THE PROGRAM TO WISH TO SKIP\n    ALL PRELIMINARIES? "
    });
  });
})(jQuery);
