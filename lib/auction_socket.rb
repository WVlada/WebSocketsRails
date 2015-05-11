class AuctionSocket
    
    def initialize app
    
        @app = app
        
    end
    
    def call env 
        # ovo je ENV koja prolazi kroz midleware
        @env = env
        if socket_request?
            socket = Faye::WebSocket.new env
            # meni ne pravi gresku bez obzira sto nisam imao env kao parametar
            # reseno: nije mi pravio gresku verovatno jer nisam ni bio povezan za websocketom
            # jer mi nije ni akctivan sve vreme ovaj middleware
            # zato i nemam Hello poruku na stranici....
            
            socket.on :open do ||
                    socket.send "Hello"
            end
            
            return socket.rack_response
            
        else
            @app.call env
        end
    end
    
    private
    
    attr_reader :env
    
    def socket_request?
    
        Faye::WebSocket.websocket? env 
        # proveravamo da li je request tipa websocket
    
    end
end