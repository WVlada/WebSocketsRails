require File.expand_path "../place_bid", __FILE__
# a nalazim se u istom direktorijumu!

class AuctionSocket
    
    def initialize app
    
        @app = app
        @clients = []
        #lista klijenata, u koju cemo ubacivati sockete kako se otvaraju
    end
    
    def call env 
        # ovo je ENV koja prolazi kroz midleware
        @env = env
        if socket_request?
            socket = spawn_socket
            @clients << socket
            return socket.rack_response
        else
            @app.call env
        end
    end
    
    private
    
    attr_reader :env
    
    def spawn_socket
        socket = Faye::WebSocket.new env
        socket.on :open do || # ovo :open je naziv EVENTA
            socket.send "Hello"
        end
        
        socket.on :message do |event|
            socket.send event.data # ovo ce poslati - 3 2 113. 113 sam uneo kao cenu, 3 je proizvod a 2 je user. "bid" je komanda
            begin
                tokens = event.data.split " "
                operation = tokens.delete_at 0
                case operation
                when "bid"
                    bid socket, tokens
                end
            rescue Exception => e
                p e
                p e.backtrace
            end
        end
        
        return socket
    end
    
    def bid socket, tokens
        service = PlaceBid.new(auction_id: tokens[0], user_id: tokens[1], value: tokens[2] ) 
        
        if service.execute
            socket.send "bidok"
            notify_outbids socket, tokens[2] # socket ubacujemo kao argument, da bi smo njega izfiltrilari, a ostale obavestili
        else
            socket.send "underbid #{service.auction.current_bid}" #ovo je njegov workaround. ali ne mogu istu foru da uradim za bidok!
            # i moramo da obezbedimo da je auction dostupan
        end
    end

    def notify_outbids socket, value 
        @clients.reject {|client| client == socket}.each do |client|
        client.send "outbid #{value}"
        end
    end

    def socket_request?
        Faye::WebSocket.websocket? env 
        # proveravamo da li je request tipa websocket
    end
end