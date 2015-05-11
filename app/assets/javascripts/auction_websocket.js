// bid user)id auction_id value
var AuctionSocket = function(user_id, auction_id, form) {
    this.user_id = user_id;
    this.auction_id = auction_id;
    this.form = $(form);
    // ovim $ koristimo Jquery
    
    // uzima url socketa kao argument
    this.socket = new WebSocket(App.websocket_url + "auctions/"  + this.auction_id);
    this.initBinds();
};
AuctionSocket.prototype.initBinds = function(){
    var _this = this;
    this.form.submit(function(e){
        e.preventDefault();
        _this.sendBid($("#bid_value").val());
        }
    );
    
    this.socket.onmessage = function(e) {
        var tokens = e.data.split(" ");
        
        switch(tokens[0]) {
            case "bidok":
                _this.bid(tokens[1]);
                break;
            case "underbid":
                _this.underbid(tokens[1]);
                break;
            case "outbid":
                _this.outbid(tokens[1]);
                break;
            case "won":
                _this.won();
                break;
            case "lost":
                _this.lost();
                break;
        }
        console.log(e);
        // logujemo poruku da bismo videli sta smo dobili od servera
    };
};

// ova funkcija ce slati serveru poruku
// prototype znaci da se poruke salje preko instance klase, a ne preko klase
AuctionSocket.prototype.sendBid = function(value) {
    var template = "bid {{auction_id}} {{user_id}} {{value}}";
    this.socket.send(Mustache.render(template, {
        user_id: this.user_id,
        auction_id: this.auction_id,
        value: value
    }));
};
// .message <div> sa strong tagom
// a sada odgovori:
AuctionSocket.prototype.bid = function() {
    this.form.find(".message strong").html(
        "Your bid: " + this.value
        );
};

AuctionSocket.prototype.underbid = function(value) {
    this.form.find(".message strong").html(
        "Your bid is under " + value + "."
        );
};

AuctionSocket.prototype.underbid = function(value) {
    this.form.find(".message strong").html(
        "Your were outbid. It is now " + value + "."
        );
};

// bidok
// outbid
// underbid
// won
// lost