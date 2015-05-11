require File.expand_path "../place_bid", __FILE__
# a nalazim se u istom direktorijumu!

class AuctionSocket
    
    def initialize app
    
        @app = app
        
    end
    
    def call env 
        # ovo je ENV koja prolazi kroz midleware
        @env = env
        if socket_request?
            socket = spawn_socket
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
        service.execute
        # sad kao sve se zavrsi u redu, i saljemo bidok poruku
        socket.send "bidok"
    end
    
    def socket_request?
        Faye::WebSocket.websocket? env 
        # proveravamo da li je request tipa websocket
    end
end