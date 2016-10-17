require 'gcm'
require 'grocer'
class PushWorker
  include Sidekiq::Worker
  # sidekiq_options  :retry => false
  def perform(user_id,alert,id,nt,name,activity_id)
    user = User.find(user_id)
    user.devices.each do |device|

      @activity = Activity.find(activity_id) unless activity_id == 0
      if @activity
        user.notifications.create(notification_type: @activity.activity_type, user_id: @activity.item_id, content: @activity.message )       
      end
      if @activity and (@activity.activity_type == "friend_request")
        nt = "friend_request"
      end

      p"=====user_id========#{user_id.inspect}================="
      p"=========nt====#{nt.inspect}================="
      p"=====activity_id========#{activity_id.inspect}================="

      p "device_id: #{device.device_id}===========device_type: #{device.device_type}"
      if (device.device_type == 'iOS')
         p "device_id: #{device.device_id}===========device_type: #{device.device_type}"
        pusher = Grocer.pusher(
          certificate: Rails.root.join('MobiloitteDevelopment.pem'),    
          passphrase:  "Mobiloitte1",                               
          gateway:     "gateway.sandbox.push.apple.com", 
          #gateway:     "gateway.push.apple.com", 
          port:        2195,                    
          retries:     3                        
        )

        notification = Grocer::Notification.new(
          :device_token => device.device_id.to_s,
          :alert => alert,
          custom: {:Notification_id => id, :Notification_type => nt,name: name,activity_id: activity_id},
          :badge => 1,
          :sound => "siren.aiff",        
          :expiry => Time.now + 60*60,     
          :identifier => 1234,                 
          :content_available => true              
          )
         push = pusher.push(notification)
      elsif (device.device_type == 'android')
        p "deviceandroid_id: #{device.device_id}===========device_type: #{device.device_type}"
        gcm = GCM.new("AIzaSyAigkMoPSiWg2vq-CQJZNYM5Hvh3-Qu9MQ")
        registration_ids= ["#{device.device_id}"]
        options = {
          'data' => {
            'message' =>['alert' => alert,'badge' => 1,'Notification_id' => id,'Notification_type' => nt,'name' => name, 'activity_id' => activity_id]
          },
          "time_to_live" => 108,
          "delay_while_idle" => true,
          "collapse_key" => 'updated_state'
        }
        response = gcm.send_notification(registration_ids,options)
        logger.info"====================#{response}++++++++++++++++"
      end
    end
  end
end