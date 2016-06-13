$(document).ready(function(){

 var check_name = /^([a-zA-Z ]){2,30}$/;
 var check_email = /^[a-zA-Z0-9_\.\-]+(\.[_a-z0-9]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$/;
 var check_phone_number = /^([0-9]){7,15}$/;
 var check_password = /^(?!\s)([a-zA-Z0-9@_]){8,15}$/;
 var decimal=  /^[0-9]+\.[0-9]+$/;
 var decimal1 = /^(?!0\d)\d*(\.\d+)?$/mg ;
// while editig profile admin
$('#edit_admin_user').submit(function(e){
  var email = $('#admin_user_email').val().trim();
  var pass  = $('#admin_user_password').val().trim();
  var pass_conf  = $('#admin_user_password_confirmation').val().trim();
  var email_error = "";
  var pass_error = "";
  var pass_conf_error = "";
  pass_check= "";
  email_check = "";
  pass_conf_check = "";

  count = 1;

    $("#admin_user_email").parent().find('.admin-errorrr1').remove();
    $("#admin_user_email").parent().find('.admin-errorrr2').remove();
    $("#admin_user_password").parent().find('.admin-errorrr3').remove();
    $("#admin_user_password").parent().find('.admin-errorrr4').remove();
    $("#admin_user_password_confirmation").parent().find('.admin-errorrr5').remove();
    $("#admin_user_password_confirmation").parent().find('.admin-errorrr6').remove();
    $("#admin_user_password_confirmation").parent().find('.admin-errorrr7').remove();

    if (email == '') {
    count+= 1;
    email_check = "1";
    $("#admin_user_email").after("<span class= 'admin-errorrr1' style='color:red;padding-left:20%;'></span>");
    email_error = "Email can't be blank";
    } else if (!check_email.test(email) ) {
    count+= 1;

      email_check = "2"

      $("#admin_user_email").after("<span class= 'admin-errorrr2' style='color:red;padding-left:20%;'></span>");
      email_error = "Should be in a valid format";
    }

    if (pass == '') {
    count+= 1;
    pass_check = "1"
    $("#admin_user_password").after("<span class= 'admin-errorrr3' style='color:red;padding-left:20%;'></span>");
    pass_error = "Password can't be blank";
   } else if (!check_password.test(pass) ) {
    count+= 1;

      // alert("12")
      pass_check= "2"
     $("#admin_user_password").after("<span class= 'admin-errorrr4' style='color:red;padding-left:20%;'></span>");
     pass_error = "Please enter Alphanumeric value between 8 to 15 digits.";
  }

  if (pass_conf == '') {
    // alert('in pass conf empty');
    count+= 1;
    pass_conf_check = "1"
    $("#admin_user_password_confirmation").after("<span class= 'admin-errorrr5' style='color:red;padding-left:20%;'></span>");
    pass_conf_error = "Password can't be blank";
   } else if (!check_password.test(pass_conf) ) {
    count+= 1;
    // alert("pass conf numeric issue")
    pass_conf_check= "2"
     $("#admin_user_password_confirmation").after("<span class= 'admin-errorrr6' style='color:red;padding-left:20%;'></span>");
     pass_conf_error = "Please enter Alphanumeric value between 8 to 15 digits.";
  }else if ( pass !=pass_conf)  {
    count+= 1;
   // alert("pass conf not match  issue")
     pass_conf_check= "3"
     $("#admin_user_password_confirmation").after("<span class= 'admin-errorrr7' style='color:red;padding-left:20%;'></span>");
     pass_conf_error = "Password and password confirmation didn't match.";

  }



// alert(email_error)
// alert(pass_error)
    if(email_error != ""){
         // alert("1")
        if (email_check ==="1"){
        document.getElementsByClassName("admin-errorrr1")[0].innerHTML = email_error;
        }
        else if (email_check ==="2"){
        document.getElementsByClassName("admin-errorrr2")[0].innerHTML = email_error;
          }
    }
    if(pass_error != ""){
      // alert("14")
      if (pass_check ==="1"){
      document.getElementsByClassName("admin-errorrr3")[0].innerHTML = pass_error;
      }
      else if (pass_check ==="2"){
      document.getElementsByClassName("admin-errorrr4")[0].innerHTML = pass_error;
      }

    }

    if(pass_conf_error != ""){
      // alert("15")
      if (pass_conf_check ==="1"){
      document.getElementsByClassName("admin-errorrr5")[0].innerHTML = pass_conf_error;
      }
      else if (pass_conf_check ==="2"){
      document.getElementsByClassName("admin-errorrr6")[0].innerHTML = pass_conf_error;
      }else if (pass_conf_check ==="3"){
      document.getElementsByClassName("admin-errorrr7")[0].innerHTML = pass_conf_error;
      }

    }


    if(count > 1) {
      e.preventDefault();
      }
    else{
      // $('#session_new').submit();
      }












});

// while forget password
$('#new_admin_user').submit(function(e){
  $("#admin_user_email_input").find('.admin-error-email5').remove();
  $("#admin_user_email_input").find('.admin-error-email6').remove();
  $("#admin_user_email_input").find('.admin-error-email7').remove();
  var email = $('#admin_user_email').val().trim();
  var email_error = "";
  var email_check = "";
  count = 1;
  if (email == '') {
     count+= 1;
     email_check = "1";
     $("#admin_user_email_input").append("<span class= 'admin-error-email5' style='color:red;padding-left:90px;'></span>");
     email_error = "Email can't be blank";
  } else if (!check_email.test(email) ) {
    count+= 1;
    email_check = "2"
    $("#admin_user_email_input").append("<span class= 'admin-error-email6' style='color:red;padding-left:90px;'></span>");
    email_error = "Should be in a valid format";
  } else {
      $.ajax({
        type: "GET",
        async: false,
        url: "/check_admin_email",
        data:{ email: email},
        dataType: "json",
        success:function(data){
             if(data == true){
              count+=1  ;
              email_check = "3"

               $("#admin_user_email_input").append("<span class= 'admin-error-email7' style='color:red;padding-left:90px;'></span>");
               email_error = "Email not exist";
             }
        }
      });
      }

    // alert(email_check);

   if(email_error != ""){
         // alert("1")
        if (email_check ==="1"){
        document.getElementsByClassName("admin-error-email5")[0].innerHTML = email_error;
        }
        else if (email_check ==="2"){
        document.getElementsByClassName("admin-error-email6")[0].innerHTML = email_error;
          } else if (email_check ==="3"){
        document.getElementsByClassName("admin-error-email7")[0].innerHTML = email_error;
          }
    }

    if(count > 1) {
      e.preventDefault();
      }
    else{
    }



});








// while signin admin user
$('#session_new').submit(function(e){
  // e.preventDefault();

  var email = $('#admin_user_email').val().trim();
  var pass  = $('#admin_user_password').val().trim();
  var email_error = "";
  var pass_error = "";
  var email_check = "";
  count = 1;
  var pass_check = "";

    $("#admin_user_email_input").find('.admin-error1').remove();
    $("#admin_user_email_input").find('.admin-error2').remove();
    $("#admin_user_password_input").find('.admin-error3').remove();
    $("#admin_user_password_input").find('.admin-error4').remove();

    if (email == '') {
    count+= 1;

      email_check = "1";
    $("#admin_user_email_input").append("<span class= 'admin-error1' style='color:red;padding-left:90px;'></span>");
    email_error = "Email can't be blank";
    } else if (!check_email.test(email) ) {
    count+= 1;

      email_check = "2"

      $("#admin_user_email_input").append("<span class= 'admin-error2' style='color:red;padding-left:90px;'></span>");
      email_error = "Should be in a valid format";
    }

    if (pass == '') {
    count+= 1;

      // alert("1")
      pass_check = "1"
     $("#admin_user_password_input").append("<span class= 'admin-error3' style='color:red;padding-left:90px;'></span>");
     pass_error = "Password can't be blank";
   } else if (!check_password.test(pass) ) {
  count+= 1;

      // alert("12")
      pass_check= "2"
     $("#admin_user_password_input").append("<span class= 'admin-error4' style='color:red;padding-left:90px;'></span>");
     pass_error = "Please enter numeric value between 8 to 15 digits.";
  }



// alert(email_error)
// alert(pass_error)
    if(email_error != ""){
         // alert("1")
        if (email_check ==="1"){
        document.getElementsByClassName("admin-error1")[0].innerHTML = email_error;
        }
        else if (email_check ==="2"){
        document.getElementsByClassName("admin-error2")[0].innerHTML = email_error;
          }
    }
    if(pass_error != ""){
      // alert("1")
      if (pass_check ==="1"){
      document.getElementsByClassName("admin-error3")[0].innerHTML = pass_error;
      }
      else if (pass_check ==="2"){
      document.getElementsByClassName("admin-error4")[0].innerHTML = pass_error;
      }

    }


    if(count > 1) {
      e.preventDefault();
      }
    else{
      // $('#session_new').submit();
      }




});




// $("#new_admin_user").submit(function(e){

// });




  // var check_name = /^([a-zA-Z ]){2,30}$/;
  // var check_email = /^[a-zA-Z0-9_\.\-]+(\.[_a-z0-9]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$/;
  // var check_phone_number = /^([0-9]){7,15}$/;
  // var check_password = /^(?!\s)([a-zA-Z0-9@_]){8,15}$/;
  // var check_password = /^(?!\s)([a-zA-Z0-9@_]){8,15}$/;
  // var check_int = /^(?:[1-9]\d*|0)?(?:\.\d+)?$/ ;

// $('.vehicle').submit(function(e){
//     alert("k");
//     // e.preventDefault();
//     $("#vehicle_make").value = $("#vehicle_make").val().trim();
//     $("#vehicle_model").value = $("#vehicle_model").val().trim();
//     $("#vehicle_year").value = $("#vehicle_year").val().trim();
//     return true;
// });



$('.validate_surge_price').submit(function(e){
  var check_price = "";
  console.log("jjjj");
  status = false;
  var vv = $('#surge_by_date').is(":visible");
  if ($('#surge_surge_price').val().trim() == ''){
   status = true;
  }else if  (!decimal1.test($('#surge_surge_price').val().trim()) ) {
    // alert('not decimal');
   // check_price = "show";
   // status = true;
    alert("Price should be in digits only!");
    return false;
  }

  if ($('#surge_by_date').is(":visible") == true){
    if ($('#surge_by_date').val().trim() == ''){
     status = true;
    }
  }
 var x = document.getElementsByClassName("start_time_validate").length;
  if (x== 0)
  {
    alert("Time is mendatory");
    return false;

  }


  if ($('.start_time_validate').val().trim() == ''){
   status = true;
  }


  if ($('.end_time_validate').val().trim() == ''){
  status = true;
  }

  if (  $('.start_time_validate').val().trim() >  $('.end_time_validate').val().trim() ){
    status = true;
    alert("Start time can't be grater than end time");
    return false;

  }
  // if ($('.start_time_validate').val().trim() == ''){
  //  status = true;
  // }

  // if ($('.end_time_validate').val().trim() == ''){
  // status = true;
  // }
  if (status == "true"){
     // if (check_price === "show"){
     //    alert("All fields are mandatory and price should be in digits only!");
     //  return false;

     // }else{
      alert("All fields are mandatory");
      return false;
     // }

  }
  else {
    return true;
  }
});






  $('#book_laters').find('a').html('Book Later');
  $('#q_created_at_gteq').attr('placeholder', 'From');
  $('#q_created_at_lteq').attr('placeholder', 'To');


  $("#promocode_select_criteria").on("change", function() {
    var value;
    value = $(this).val();
    $.ajax({
      type: "GET",
      url: "/filter_user",
      data: {
        selected_criteria: value
      },
      dataType: "json",
      success: function(data) {
        var html;
        html = "";
        $.each(data, function(i, value) {
          if (value) {
          html += "<option value=" + value.id + ">" + value.first_name + " " + value.last_name + "</option>";
        }
        });
        $("#promocode_user_id").html(html);
        //$("#promocode_user_id").select2({width: "20%"}).select2("val",$('#connection_friend_id option:eq(0)').val());
      }
    });
  });

    $("#notification_select_criteria").on("change", function() {
    var value;
    value = $(this).val();
    $.ajax({
      type: "GET",
      url: "/filter_user",
      data: {
        selected_criteria: value
      },
      dataType: "json",
      success: function(data) {
        var html;
        html = "";
        $.each(data, function(i, value) {
          if (value) {
          html += "<option value=" + value.id + ">" + value.first_name + " " + value.last_name + "</option>";
        }
        });
        $("#notification_user_ids").html(html);
        //$("#promocode_user_id").select2({width: "20%"}).select2("val",$('#connection_friend_id option:eq(0)').val());
      }
    });
  });




// while new notification
$('#new_notificationzz').submit(function(e){
    // e.preventDefault();
  $("#notification_user_ids").parents().eq(1).find('.admin-error-noti1').remove();
  $("#notification_message").parents().eq(2).find('.admin-error-noti2').remove();

  var noti_error1 = "";
  var noti_error2 = "";
  count = 1;


    // alert('click new notification');
    var select_crieteria = document.getElementById("notification_select_criteria");
    var s_crit = select_crieteria.options[select_crieteria.selectedIndex].text;
    var s_user = $("#notification_user_ids :selected").text()
    var noti_text=$('#notification_message').val().trim();
    if(s_user == ''){
      count +=1;
      // alert('no selected 1')
      $("#notification_user_ids").parents().eq(0).after("<span class= 'admin-error-noti1' style='color:red;padding-left:20%;'></span>");
      noti_error1 = "Please select atleast one user";
    } if(noti_text == ''){
      // alert('no value')
      count+=1;
      $("#notification_message").parents().eq(1).after("<span class= 'admin-error-noti2' style='color:red;padding-left:20%;'></span>");
      noti_error2 = "Please enter notification message";

    }

    if(noti_error1 != ""){
      // alert("1")
      document.getElementsByClassName("admin-error-noti1")[0].innerHTML = noti_error1;
    }
     if(noti_error2 != ""){
      // alert("1")
      document.getElementsByClassName("admin-error-noti2")[0].innerHTML = noti_error2;
    }


    if(count > 1) {
      e.preventDefault();
      }
    else{
      // $('#session_new').submit();
      }



});


// while edit notification?
$('#edit_notificationzz').submit(function(e){
    // e.preventDefault();
  $("#notification_user_ids").parents().eq(1).find('.admin-error-noti1').remove();
  $("#notification_message").parents().eq(2).find('.admin-error-noti2').remove();

  var noti_error1 = "";
  var noti_error2 = "";
  count = 1;


    // alert('click new notification');
    var select_crieteria = document.getElementById("notification_select_criteria");
    var s_crit = select_crieteria.options[select_crieteria.selectedIndex].text;
    var s_user = $("#notification_user_ids :selected").text()
    var noti_text=$('#notification_message').val().trim();
    if(s_user == ''){
      count +=1;
      // alert('no selected 1')
      $("#notification_user_ids").parents().eq(0).after("<span class= 'admin-error-noti1' style='color:red;padding-left:20%;'></span>");
      noti_error1 = "Please select atleast one user";
    } if(noti_text == ''){
      // alert('no value')
      count+=1;
      $("#notification_message").parents().eq(1).after("<span class= 'admin-error-noti2' style='color:red;padding-left:20%;'></span>");
      noti_error2 = "Please enter notification message";

    }

    if(noti_error1 != ""){
      // alert("1")
      document.getElementsByClassName("admin-error-noti1")[0].innerHTML = noti_error1;
    }
     if(noti_error2 != ""){
      // alert("1")
      document.getElementsByClassName("admin-error-noti2")[0].innerHTML = noti_error2;
    }


    if(count > 1) {
      e.preventDefault();
      }
    else{
      // $('#session_new').submit();
      }



});


$('#edit_formulazz').submit(function(e){
alert("jkjkjk")
    e.preventDefault();


  var taxi_type = $('#formula_taxi_type').val().trim();
  var cancel_charge = $('#formula_cancellation_charge').val().trim();
  var base_fare = $('#formula_base_fare').val().trim();
  var per_mile_charge = $('#formula_per_mile_charge').val().trim();
  var per_minute_charge = $('#formula_per_minute_charge').val().trim();
  var vidality_charge = $('#formula_vidality_charge').val().trim();
  var safe_ride_charge = $('#formula_safe_ride_charge').val().trim();
  var initialization_charge = $('#formula_initailization_fee').val().trim();

  var taxi_type_error = "";
  var cancel_charge_error = "";
  var base_fare_error = "";
  var per_mile_charge_error = "";
  var per_minute_charge_error = "";
  var vidality_charge_error = "";
  var safe_ride_charge_error = "";
  var initialization_charge_error = "";

  var taxi_type_check ="";
  var cancel_charge_check ="";
  var base_fare_check ="";
  var per_mile_charge_check ="";
  var per_minute_charge_check ="";
  var vidality_charge_check ="";
  var safe_ride_charge_check ="";
  var initialization_charge_check ="";

  count = 1;

  $("#formula_taxi_type").parent().find('.admin-error1').remove();
  $("#formula_taxi_type").parent().find('.admin-error2').remove();

  $("#formula_cancellation_charge").parent().find('.admin-error3').remove();
  $("#formula_cancellation_charge").parent().find('.admin-error4').remove();

  $("#formula_base_fare").parent().find('.admin-error5').remove();
  $("#formula_base_fare").parent().find('.admin-error6').remove();

  $("#formula_per_mile_charge").parent().find('.admin-error7').remove();
  $("#formula_per_mile_charge").parent().find('.admin-error8').remove();

  $("#formula_per_minute_charge").parent().find('.admin-error8').remove();
  $("#formula_per_minute_charge").parent().find('.admin-error10').remove();

  $("#formula_vidality_charge").parent().find('.admin-error11').remove();
  $("#formula_vidality_charge").parent().find('.admin-error12').remove();

  $("#formula_safe_ride_charge").parent().find('.admin-error13').remove();
  $("#formula_safe_ride_charge").parent().find('.admin-error14').remove();

  $("#formula_initailization_fee").parent().find('.admin-error15').remove();
  $("#formula_initailization_fee").parent().find('.admin-error16').remove();

  if (taxi_type === ''){
  count+=1;
  taxi_type_check = '1'
  $("#formula_taxi_type").after("<span class= 'admin-error1' style='color:red;padding-left:20%;'></span>");
  taxi_type_error = "Cancellation charge can't be blank";
  }else if  (!decimal1.test(taxi_type) ) {
  count+=1;
  taxi_type_check = '2'
  $("#formula_taxi_type").after("<span class= 'admin-error2' style='color:red;padding-left:20%;'></span>");
  taxi_type_error = "should be in digits only!";
  }

  if (cancel_charge === ''){
  count+=1;
  cancel_charge_check ='1'
  $("#formula_cancellation_charge").after("<span class= 'admin-error3' style='color:red;padding-left:20%;'></span>");
  cancel_charge_error = "Base fee can't be blank";
  }else if  (!decimal1.test(cancel_charge) ) {
  count+=1;
  cancel_charge_check ='2'
  $("#formula_cancellation_charge").after("<span class= 'admin-error4' style='color:red;padding-left:20%;'></span>");
  cancel_charge_error = "should be in digits only!";
  }

  if (base_fare === ''){
  count+=1;
  base_fare_check= '1';
  $("#formula_base_fare").after("<span class= 'admin-error5' style='color:red;padding-left:20%;'></span>");
  base_fare_error = "Base fare can't be blank";
  }else if  (!decimal1.test(base_fare) ) {
  base_fare_check= '2';
  count+=1;
  $("#formula_base_fare").after("<span class= 'admin-error6' style='color:red;padding-left:20%;'></span>");
  base_fare_error = "should be in digits only!";
  }

  if (per_mile_charge === ''){
  per_mile_charge_check ='1';
  count+=1;
  $("#formula_per_mile_charge").after("<span class= 'admin-error7' style='color:red;padding-left:20%;'></span>");
  per_mile_charge_error = "Per mile charge can't be blank";
  }else if  (!decimal1.test(per_mile_charge) ) {
  count+=1;
  per_mile_charge_check ='2';
  $("#formula_per_mile_charge").after("<span class= 'admin-error8' style='color:red;padding-left:20%;'></span>");
  per_mile_charge_error = "should be in digits only!";
  }

  if (per_minute_charge === ''){
  count+=1;
  per_minute_charge_check='1';
  $("#formula_per_minute_charge").after("<span class= 'admin-error9' style='color:red;padding-left:20%;'></span>");
  per_minute_charge_check = "Per minute charge can't be blank";
  }else if  (!decimal1.test(per_minute_charge) ) {
  count+=1;
  per_minute_charge_check='2';
  $("#formula_per_minute_charge").after("<span class= 'admin-error10' style='color:red;padding-left:20%;'></span>");
  per_minute_charge_check = "should be in digits only!";
  }

  if (vidality_charge_check === ''){
  count+=1;
  vidality_charge_error='1';
  $("#formula_vidality_charge").after("<span class= 'admin-error11' style='color:red;padding-left:20%;'></span>");
  vidality_charge = "Vidality charge can't be blank";
  }else if  (!decimal1.test(vidality_charge_check) ) {
  count+=1;
  vidality_charge_error='2';
  $("#formula_vidality_charge").after("<span class= 'admin-error12' style='color:red;padding-left:20%;'></span>");
  vidality_charge = "should be in digits only!";
  }

  if (safe_ride_charge_error === ''){
  count+=1;
  safe_ride_charge_error='1';
  $("#formula_safe_ride_charge").after("<span class= 'admin-error13' style='color:red;padding-left:20%;'></span>");
  safe_ride_charge_error = "Safe ride charge can't be blank";
  }else if  (!decimal1.test(safe_ride_charge_error) ) {
  count+=1;
  safe_ride_charge_error='2';
  $("#formula_safe_ride_charge").after("<span class= 'admin-error14' style='color:red;padding-left:20%;'></span>");
  safe_ride_charge_error = "should be in digits only!";
  }

  // if (initialization_charge === ''){
  // count+=1;
  // initialization_charge_check='1';
  // $("#formula_initailization_fee").after("<span class= 'admin-error15' style='color:red;padding-left:20%;'></span>");
  // initialization_charge_error = "Initialization fee can't be blank";
  // }else if  (!decimal1.test(initialization_charge) ) {
  // count+=1;
  // initialization_charge_check='2';
  // $("#formula_initailization_fee").after("<span class= 'admin-error16' style='color:red;padding-left:20%;'></span>");
  // initialization_charge_error = "should be in digits only!";
  // }



  if(taxi_type_error != ""){
    if (taxi_type_check ==="1"){
    document.getElementsByClassName("admin-error1")[0].innerHTML = taxi_type_error;
    }
    else if (taxi_type_check ==="2"){
    document.getElementsByClassName("admin-error2")[0].innerHTML = taxi_type_error;
      }
  }

  if(cancel_charge_error != ""){
    if (cancel_charge_check ==="1"){
    document.getElementsByClassName("admin-error3")[0].innerHTML = cancel_charge_error;
    }
    else if (cancel_charge_check ==="2"){
    document.getElementsByClassName("admin-error4")[0].innerHTML = cancel_charge_error;
      }
  }

  if(base_fare_error != ""){
    if (base_fare_check ==="1"){
    document.getElementsByClassName("admin-error5")[0].innerHTML = base_fare_error;
    }
    else if (base_fare_check ==="2"){
    document.getElementsByClassName("admin-error6")[0].innerHTML = base_fare_error;
      }
  }

  if(per_mile_charge_error != ""){
    if (per_mile_charge_check ==="1"){
    document.getElementsByClassName("admin-error7")[0].innerHTML = per_mile_charge_error;
    }
    else if (per_mile_charge_check ==="2"){
    document.getElementsByClassName("admin-error8")[0].innerHTML = per_mile_charge_error;
      }
  }

  if(per_minute_charge_error != ""){
    alert('per minute')
    if (per_minute_charge_check ==="1"){
    document.getElementsByClassName("admin-error9")[0].innerHTML = per_minute_charge_error;
    }
    else if (per_minute_charge_check ==="2"){
    document.getElementsByClassName("admin-error10")[0].innerHTML = per_minute_charge_error;
      }
  }

  if(vidality_charge_error != ""){
    alert("vidality")
    if (vidality_charge_check ==="1"){
    document.getElementsByClassName("admin-error11")[0].innerHTML = vidality_charge_error;
    }
    else if (vidality_charge_check ==="2"){
    document.getElementsByClassName("admin-error12")[0].innerHTML = vidality_charge_error;
      }
  }

  if(safe_ride_charge_error != ""){
    alert('safe')
    if (safe_ride_charge_check ==="1"){
    document.getElementsByClassName("admin-error12")[0].innerHTML = safe_ride_charge_error;
    }
    else if (safe_ride_charge_check ==="2"){
    document.getElementsByClassName("admin-error14")[0].innerHTML = safe_ride_charge_error;
      }
  }

  // if(initialization_charge_error != ""){
  //   if (initialization_charge_check ==="1"){
  //   document.getElementsByClassName("admin-error15")[0].innerHTML = initialization_charge_error;
  //   }
  //   else if (initialization_charge_check ==="2"){
  //   document.getElementsByClassName("admin-error16")[0].innerHTML = initialization_charge_error;
  //     }
  // }




  if(count> 1){
    e.preventDefault();
  }



 });





});
