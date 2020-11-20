function snackbar_s() {
    var x = document.getElementById("snackbar-s");
    x.className = "show";
    setTimeout(function(){ x.className = x.className.replace("show", ""); }, 3000);
  }
  function snackbar_e() {
    var x = document.getElementById("snackbar-e");
    x.className = "show";
    setTimeout(function(){ x.className = x.className.replace("show", ""); }, 3000);
  }
  function snackbar_w() {
    var x = document.getElementById("snackbar-w");
    x.className = "show";
    setTimeout(function(){ x.className = x.className.replace("show", ""); }, 3000);
  }
  
  function deleteCat(id,url){
    var check = confirm("Are you sure, you want to delete this category?");
    if(check){
      $.ajax({
        type: "post",
        url: url,
        data: {
          "id":id,
        },
        success: function (response) {
          console.log(response);
          if(response == "success"){
            window.location.reload();
          }
        }
      });
    }
  }
  
  function deleteProd(id,url){
    var check = confirm("Are you sure, you want to delete this product?");
    if(check){
      $.ajax({
        type: "post",
        url: url,
        data: {
          "id":id,
        },
        success: function (response) {
          console.log(response);
          window.location.reload();
        }
      }).fail((responseData)=>{
        console.log(responseData);
        // result = JSON.parse(response);
        //     console.log(result);
            // snackbar_e();
            // $("#snackbar-e").html("Something Went Wrong Please Try Again.");
      });
    }
  }
  
  function deleteUser(id,url){
    console.log(id);
    var check = confirm("Are you sure, you want to delete this user?");
    if(check){
      $.ajax({
        type: "post",
        url: url,
        data: {
          "id":id,
        },
        success: function (response) {
          console.log(response);
          if(response == "success"){
            window.location.reload();
          }
        }
      });
    }
  }
  
  function deleteBestSelling(id,url){
    var check = confirm("Are you sure, you want to delete this product?");
    if(check){
      $.ajax({
        type: "post",
        url: url,
        data: {
          "id":id,
        },
        success: function (response) {
          console.log(response);
            window.location.reload();
        }
      });
    }
  }
  
  function addBestSelling(id,url){
    console.log(id);
    $.ajax({
      type: "post",
      url: url,
      data: {
        "id":id,
      },
      success: function (response) {
        console.log(response);
        if(response == "success"){
          $("#snackbar-s").html("Added to best selling Successfully!");
          snackbar_s();
        }else if(response == "failed"){
          $("#snackbar-w").html("This product is already added.");
          snackbar_w();
        }
      }
    });
  }
  
  function deleteFeatured(id,url){
    var check = confirm("Are you sure, you want to delete this product?");
    if(check){
      $.ajax({
        type: "post",
        url: url,
        data: {
          "id":id,
        },
        success: function (response) {
          console.log(response);
            window.location.reload();
        }
      });
    }
  }
  
  function addFeatured(id,url){
    console.log(id);
    $.ajax({
      type: "post",
      url: url,
      data: {
        "id":id,
      },
      success: function (response) {
        console.log(response);
        if(response == "success"){
          $("#snackbar-s").html("Added to featured Successfully!");
          snackbar_s();
        }else if(response == "failed"){
          $("#snackbar-w").html("This product is already added.");
          snackbar_w();
        }
      }
    });
  }
  
  function deleteSlider(id,url){
    var check = confirm("Are you sure, you want to delete this Slider?");
    if(check){
      $.ajax({
        type: "post",
        url: url,
        data: {
          "id":id,
        },
        success: function (response) {
          console.log(response);
            window.location.reload();
        }
      });
    }
  }
  
  function deleteNotification(id,url){
    var check = confirm("Are you sure, you want to delete this Notification?");
    if(check){
      $.ajax({
        type: "post",
        url: url,
        data: {
          "id":id,
        },
        success: function (response) {
          console.log(response);
            window.location.reload();
        }
      });
    }
  }
  
    function addBanner(id, url) {
    console.log(id);
    $.ajax({
      type: "post",
      url: url,
      data: {
        "id": id,
      },
      success: function (response) {
        console.log(response);
        if (response == "success") {
          $("#snackbar-s").html("Added Banner Image Successfully!");
          snackbar_s();
        } else if (response == "failed") {
          $("#snackbar-w").html("This product is already added.");
          snackbar_w();
        }
      }
    });
  }
  
    let orderCount = 0;
    $(document).ready(function () {
    
      setInterval(notificationCount, 5000);
    
      $.ajax({
        type: "post",
        url: "http://hrfruitech.tk/Projects/oceanfish/Api/getStoreStatus",
        success: function (response) {
          console.log("Store State :"+response);
          if(response == "on"){
            $('#rbtn').bootstrapToggle('on');
          }else if(response == "off"){
            $('#rbtn').bootstrapToggle('off');
          }
        }
      });
    
      $('#rbtn').change(function () {
        var val;
        if (this.checked) {
          // var returnVal = confirm("Are you sure?");
          // $(this).prop("checked", returnVal);
          // $('#rbtn').bootstrapToggle('on');
          val = "on";
          $.ajax({
            type: "post",
            url: "http://hrfruitech.tk/Projects/oceanfish/Api/statusModify",
            data: {
              "state":val,
            },
            success: function (response) {
              console.log(response);
              console.log("on");
            }
          });
    
        }else{
          // $('#rbtn').bootstrapToggle('off');
          val = "off";
          $.ajax({
            type: "post",
            url: "http://hrfruitech.tk/Projects/oceanfish/Api/statusModify",
            data: {
              "state":val,
            },
            success: function (response) {
              console.log(response);
              console.log("off");
            }
          });
    
        }
        // $('#textbox1').val(this.checked);
      });
    });
    
    function notificationCount() {
      $.ajax({
        type: "post",
        url: "http://hrfruitech.tk/Projects/oceanfish/Order/getOrders",
        success: function (response) {
          var result = JSON.parse(response);
          console.log(result["result"][0]["count"]);
          var count = result["result"][0]["count"];
          if (orderCount == 0) {
            orderCount = count;
            console.log("first cond");
            console.log(orderCount);
          } else if (orderCount > 0 && count > orderCount) {
            // $(".sidebar > .nav > .nav-item:not(.nav-profile) > #OrderLink.nav-link:before").css("border-color","red");
    
            document.getElementById("myAudiobtn").click();
    
    
            // x.play();
            orderCount = count;
            console.log("second cond");
            $("#OrderLink").addClass("notify");
          }
          $("#myAudiobtn").click(function () {
            var x = document.getElementById("myAudio");
            x.play();
    
          });
        }
      });
    
    }
    
    
    
    // $("#rbtn").change(function (e) {
    //   e.preventDefault();
    //   var val;
    //   if ($('input[name="rbtn"]').is(':checked')) {
    //     // checked
    //     console.log("on");
    //     val = "on";
    //   } else {
    //     // unchecked
    //     console.log("off");
    //     val = "off";
    //   }
    
    // });