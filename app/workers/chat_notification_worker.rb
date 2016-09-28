require 'gcm'
require 'grocer'
class ChatNotificationWorker
  include Sidekiq::Worker

  def perform(device_id,device_type,subject,content,receiver,sender,is_group) 
    content = "MESSAGECHAT"+"-"+receiver.to_s+"-"+sender.to_s+"-"+is_group.to_s
    if ( device_type == 'iOS')
      pusher = Grocer.pusher(
      certificate: Rails.root.join('MobiloitteEnterprise.pem'),      # required
      passphrase:  "Mobiloitte1",                       # optional
      gateway:     "gateway.push.apple.com", # optional; See note below.
      port:        2195,                     # optional
      retries:     3                         # optional
      )

      notification = Grocer::Notification.new(
      device_token:      device_id,
      alert:             subject ,  
      custom: {:NT => content },
      # badge:             42,
      sound:             "siren.aiff",         # optional
      expiry:            Time.now + 60*60,     # optional; 0 is default, meaning the message is not stored
      identifier:        1234,                 # optional
      content_available: true                  # optional; any truthy value will set 'content-available' to 1
      )


      response =  pusher.push(notification)
    elsif ( device_type == 'android') 
      gcm = GCM.new("AIzaSyAVoQ8TcQ3zWn3zxbovYEpdd4Jhua_Sryo")
      registration_ids= ["#{device_id}"] 
       options = {
      'data' => {
         'message' =>  subject,
         'NT' => content 
         # 'RE'=> receiver, 
         # 'SE' => sender,
         #  'IG' => is_group

      },
      "time_to_live" => 108,
      "delay_while_idle" => true,
      "collapse_key" => 'updated_state'
      }
      response = gcm.send_notification(registration_ids,options)
    end      
  end
end

