require "em-websocket"
require 'active_record'
require 'httparty'
require 'json'

# LOCAL
ActiveRecord::Base.establish_connection(
  :adapter => "postgresql",
  :encoding => "unicode",
  :host => "localhost",
  :database => "world_fax_development",
  :username => "postgres",
  :password => "postgres",
  :pool => 5 )



class Message < ActiveRecord::Base
   
end

class User < ActiveRecord::Base
  has_one :status, :dependent=>:destroy
  has_many :notifications, :as => :notifiable, :dependent => :destroy
end

class Status < ActiveRecord::Base
  belongs_to :user
end

class Notification < ActiveRecord::Base
  belongs_to :user
end



def hit_api(str_path, str_data)
  p "-----------------#{str_path}================#{str_data}"
  @str_url = "http://localhost:3000/messages"

  response = HTTParty.post(@str_url+str_path,
          :body => str_data.to_json,
          :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
        )
end



EventMachine.run do
  puts "-------------i am in eventmachine"
  @clients = {}
 
  EM::WebSocket.start(:host => '0.0.0.0', :port => '9292') do |ws|
    puts "---#{ws.inspect}---------i am in WebSocket"
    
    ws.onopen do |handshake|
      user_id = handshake.query_string.split("&")[0].split("=")[1]
      @clients[user_id.to_s] = ws
      ws.send "Connected to #{handshake.path}."
    end
    
    ws.onclose do
      ws.send "Closed."
      @clients.delete ws
      
    end

    ws.onmessage do |msg|
      puts "Received Message: #{msg.inspect}"
      data = JSON.parse(msg)
      str_data = {:assoc_id => data["assoc_id"], :sender_id => data["sender_id"] , :body => data["body"], :upload_type => data["upload_type"] , :is_group => data["is_group"] , :created_timestamp =>  DateTime.now.to_i.to_s}
 
      if data["type"]=="Joined"
        user = User.find_by(:id => data["sender_id"])
        user.status.present? ? user.status.update_attributes(:last_seen => Time.current.to_i.to_s,:current_status => "online") : user.create_status(:last_seen => Time.current.to_i.to_s,:current_status => "online") 
      end
     
      if data["type"]=="Closed"
        @clients.delete(data["sender_id"].to_s)
      end

      hit_api("/notify_user",str_data) if data["body"].present? or data["image"].present? 


      if data["upload_type"] == "Recieved"
        unless data["lastMsg"] == false
          message =  Message.find_by(id: data["msg_id"])
          if message  
            read_by = message.read_by
            read_by << data["sender_id"].to_s unless read_by.include?(data["sender_id"].to_s)
            if data["is_group"] == true
              puts "===========#{read_by.inspect}================MESSAGE/#{data["assoc_id"].to_i}/#{data["sender_id"].to_i}/false================="
              notification =  Notification.where("receiver_id IN (?) and (noti_type LIKE ? or noti_type LIKE ?)" , read_by ,"MESSAGE/#{data["assoc_id"].to_i}/#{data["sender_id"].to_i}/true%" , "MESSAGE/#{data["sender_id"].to_i}/#{data["assoc_id"].to_i}/true")
              p " ==========NOTIFICATION==========================#{notification.last.inspect}==============="
              notification.destroy_all if notification.present?
            else
              puts "===========#{read_by.inspect}================MESSAGE/#{data["assoc_id"].to_i}/#{data["sender_id"].to_i}/false================="
              notification =  Notification.where("receiver_id IN (?) and (noti_type LIKE ? or noti_type LIKE ?)" , read_by ,"MESSAGE/#{data["assoc_id"].to_i}/#{data["sender_id"].to_i}/false%","MESSAGE/#{data["sender_id"].to_i}/#{data["assoc_id"].to_i}/false%")
              p " ==========NOTIFICATION==========================#{notification.last.inspect}==============="
              notification.last.destroy if notification.present?
            end
            message_u = message.update(read_by: read_by)
          end
        end
      end




      if data["upload_type"]==""
        @message = Message.create(:created_timestamp =>  DateTime.now.to_i.to_s,:assoc_id => data["assoc_id"],:sender_id => data["sender_id"],:is_group => data["is_group"],:body => data["body"], :room_id => data["room_id"], :upload_type => data["upload_type"] , :read_by =>  [data["sender_id"]]) 
        data = data.merge!(:id => @message.id , :upload_type => @message.upload_type , :room_id => @message.room_id , :username => User.find_by(id: @message.sender_id).username , :created_timestamp =>  DateTime.now.to_i.to_s )
        puts "=================#{data.inspect}==============="
      end
      
      #Image Uploader From Chat Box
      if data["upload_type"] == "image"
         puts "+++++++++++++++++++++++++++++++IMAGE METHOD+++++++++++++++++++#{@message.inspect}++++++++++++"
     #   @message = Message.create(:tstamp => data["createdTimeStamp"],:assoc_id => data["assoc_id"],:sender_id => data["sender_id"],:body => data["body"],:upload_type => data["upload_type"],:room_id => data["room_Id"]) 
         data = data.merge!(:id => @message.id , :upload_type => "image" ,:room_id => @message.room_id , :username => User.find_by(id: @message.sender_id).username ,  :created_timestamp =>  DateTime.now.to_i.to_s)

         puts "+++++++++++++++++++++++++++++++#{data.inspect}+++++++++++++++++++++++++++++"
      end

     #  if data["upload_type"] == "video"
     #     puts "+++++++++++++++++++++++++++++++Video METHOD+++++++++++++++++++#{@message.inspect}++++++++++++"
     # #   @message = Message.create(:tstamp => data["createdTimeStamp"],:assoc_id => data["assoc_id"],:sender_id => data["sender_id"],:body => data["body"],:upload_type => data["upload_type"],:room_id => data["room_Id"]) 
     #     data = data.merge!(:id => @message.id , :upload_type => "video" ,:room_id => @message.room_id , :username => User.find_by(id: @message.sender_id).username ,  :created_timestamp =>  DateTime.now.to_i.to_s)

     #     puts "+++++++++++++++++++++++++++++++#{data.inspect}+++++++++++++++++++++++++++++"
     #  end
       
     #  if data["upload_type"] == "audio"
     #     puts "+++++++++++++++++++++++++++++++Audio METHOD+++++++++++++++++++#{@message.inspect}++++++++++++"
     # #   @message = Message.create(:tstamp => data["createdTimeStamp"],:assoc_id => data["assoc_id"],:sender_id => data["sender_id"],:body => data["body"],:upload_type => data["upload_type"],:room_id => data["room_Id"]) 
     #     data = data.merge!(:id => @message.id , :upload_type => "audio" ,:room_id => @message.room_id , :username => User.find_by(id: @message.sender_id).username ,  :created_timestamp =>  DateTime.now.to_i.to_s)

     #     puts "+++++++++++++++++++++++++++++++#{data.inspect}+++++++++++++++++++++++++++++"
     #  end

      # p "-----------reciever_id----#{ @clients[data["reciever_id"].to_s]}===sender_id====#{@clients[data["sender_id"].to_s]}=============="
      unless data["upload_type"]=="Recieved"
          if data["is_group"] == true
              data["group_member_ids"].uniq.each do |reciever_id|
              @clients[reciever_id.to_s].send data.to_json  if @clients[reciever_id.to_s]
              puts "====Group=========================#{@clients[reciever_id.to_s].inspect}=============================================="
              end
              # @clients[data["sender_id"].to_s].send data.to_json  if @clients[data["sender_id"].to_s]
          else 
               
              @clients[data["assoc_id"].to_s].send data.to_json  if @clients[data["assoc_id"].to_s]
              @clients[data["sender_id"].to_s].send data.to_json  if @clients[data["sender_id"].to_s]
          end
      end
  
    end
  end
end









