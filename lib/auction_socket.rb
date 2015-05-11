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
        end
        
        return socket
    end
    
    def socket_request?
        Faye::WebSocket.websocket? env 
        # proveravamo da li je request tipa websocket
    end
end