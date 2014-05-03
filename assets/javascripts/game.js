var gameFsm = new machina.Fsm({
  initialState: "startGame",
  states: {
    "startGame" : {
    },

    "intro1" : {
    }
  }
});

(function($) {
  $(function() {
   var console1 = $("#console1");
   var controller1 = console1.console({
     promptLabel: '> ',
     commandValidate:function(line){
       if (line == "") return false;
       else return true;
     },
     commandHandle:function(line){
         return [{msg:"=> [12,42]",
                  className:"jquery-console-message-value"},
                 {msg:":: [a]",
                  className:"jquery-console-message-type"}]
     },
     autofocus:true,
     animateScroll:true,
     promptHistory:true,
     charInsertTrigger:function(keycode,line){
        // Let you type until you press a-z
        // Never allow zero.
        return !line.match(/[a-z]+/) && keycode != '0'.charCodeAt(0);
     }
   });
  });
})(jQuery);
