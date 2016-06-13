module DevisesHelper
  def devise_error_messages!
    messages_array= ["Email Record not found","Email can't be blank" ]
    result_array= ["The email address you entered could not be found. Please try again ." , "Please enter email address" ]
    # resource.errors.full_messages.map { |msg| msg == "Email Record not found" ? 'The email address you entered could not be found. Please try again with other email.' : msg  }.join('<br/>')
    resource.errors.full_messages.map { |msg| (messages_array.include? msg) ? (result_array[messages_array.index(msg)]) : "msg"  }.join('<br/>')
 end
end