//= require active_admin/base
//= require custom
//= require heatmap
//= require gmaps-heatmap
// $(document).ready(function(){


//     $("#admin_user_password_confirmation_input").find('label').text('Password Confirmation*');
//     $("#user_password_confirmation_input").find('label').text('Password Confirmation*');
//     $("#admin_user_email_input").append("<span class= 'email-error' style='color:red;padding-left:90px;'></span>");
//     $("#admin_user_password_input").append("<span class= 'pass-error' style='color:red;padding-left:90px;'></span>");
//     $(".flash_alert, .inline-errors").css({"color":"red","font-weight":"normal"});
//     $(".flash_notice").css({"color":"green"});
//     $("#error_explanation > h2").css({"display":"none"});
//     $("#error_explanation > ul > li").css({"display":"none"});

//     $("#login > h2").text("Forgot Your Password");
   
//     var reg = /^[a-zA-Z0-9_\.\-]+(\.[_a-z0-9]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$/;   
   
//     $('#session_new > .actions > ol > li > input[type="submit"]').click(function(e){
//         e.preventDefault();
    
//         var a = validateForm();
//         if(a){ $('#session_new').submit();}    
//     });
    
//     function validateForm(){
//         var email = $('#admin_user_email').val().trim();
//         var pass  = $('#admin_user_password').val().trim();
//         var email_error = "";
//         var pass_error = "";

//         var email_check = reg.test(email);

//         if(email == ""){email_error = "Email Can't be blank";}

//         else if(!email_check)
//             {
//                 email_error = "Invalid email format";
//             }          
//         else if(pass  == "" )
//             {pass_error = "Password Can't be blank";}

//          else 
//          {
//             if(pass.length>10)
//             {pass_error="Password should not exceed 20 characters.";}

//          }        
//         {document.getElementsByClassName("email-error")[0].innerHTML = email_error;
        
//         }
//         {document.getElementsByClassName("pass-error")[0].innerHTML = pass_error;
      
//         }

//         if((email_error == "" )&&(pass_error == "")){return true;}

//         return false;
//     }


//     $('#new_admin_user > .actions > ol > li > input[type="submit"]').click(function(e){
//         $("#admin_user_email").append("<span class= 'email-error' style='color:red;padding-left:90px;'></span>");
//         e.preventDefault();
//         var a = validateForgetForm();
//         if(a){$('#new_admin_user').submit();}    
//     });
    
//     function validateForgetForm()
//     {
//         var email = $('#admin_user_email').val().trim();
//         var email_error = "";
        
//         var email_check = reg.test(email);

//         if(email == "")
//         { email_error = "Email Can't be blank";}
//         else
//             {if(!email_check)
//                     {email_error = "Invalid email format";}
//             }          
        
//         {
//             $(".email-error").text(email_error);
//             $(".inline-errors").text("");
//         }

//         if(email_error == "" )
//             {
//                 return true;
//             }

//         return false;
//     }

// });