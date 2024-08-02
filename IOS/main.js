//-----------------------------------------
// MARK - PUSH NOTIFICATIONS
//-----------------------------------------

// iOS PUSH NOTIFICATION
Parse.Cloud.define("pushiOS", (request) => {
   var user = request.user;
   var params = request.params;
   var userObjectID = params.userObjectID
   var data = params.data

   var recipientUser = new Parse.User();
   recipientUser.id = userObjectID;

   var pushQuery = new Parse.Query(Parse.Installation);
   pushQuery.equalTo("userID", userObjectID);

   Parse.Push.send({
      where: pushQuery,
      data: data
   }, { success: function() {
   }, error: function(error) {
   }, useMasterKey: true});
   return('success');
});


// ANDROID PUSH NOTIFICATION
Parse.Cloud.define("pushAndroid", (request) => {
   var user = request.user;
   var params = request.params;
   var userObjectID = params.userObjectID;
   var data = params.data;

   var recipientUser = new Parse.User();
   recipientUser.id = userObjectID;

   var pushQuery = new Parse.Query(Parse.Installation);
   pushQuery.equalTo("userID", userObjectID);

   Parse.Push.send({
      where: pushQuery,
      data: { alert: data }
   }, { success: function() {
   }, error: function(error) {
   }, useMasterKey: true});
   return('success');
});


// SET DEVICE TOKEN -> FOR ANDROID PUSH NOTIFICATIONS
Parse.Cloud.define("setDeviceToken", (request) => {
   var installationId = request.params.installationId;
   var deviceToken = request.params.deviceToken;

   var query = new Parse.Query(Parse.Installation);
   query.get(installationId, {useMasterKey: true}).then(function(installation) {
      installation.set("deviceToken", deviceToken);
      installation.save(null, {useMasterKey: true}).then(function() { return(true);
      }, function(error) { return(error); })
   }, function (error) { console.log(error); })
});



//-----------------------------------------
// MARK - OTHER UTILITY FUNCTIONS
//-----------------------------------------

// REPORT A USER  
Parse.Cloud.define("reportUser", (request) => {
   var userId = request.params.userId;
   var reportedBy = request.params.reportedBy;

   var User = Parse.Object.extend('_User'),
   user = new User({ objectId: userId });
   user.set('reportedBy', reportedBy);

   Parse.Cloud.useMasterKey();
   user.save(null, { useMasterKey: true } ).then(function(user) { return(user);
   }, function(error) { return(error); });
});


// FAVORITE A USER
Parse.Cloud.define("favoriteUser", (request) => {
   var userId = request.params.userId;
   var favoritedBy = request.params.favoritedBy;

   var User = Parse.Object.extend('_User'),
   user = new User({ objectId: userId });
   user.set('favoritedBy', favoritedBy);

   Parse.Cloud.useMasterKey();
   user.save(null, { useMasterKey: true } ).then(function(user) { return(user);
   }, function(error) { return(error); });
});


// FOLLOW/UNFOLLOW A USER
Parse.Cloud.define("followUnfollowUser", (request) => {
   var userId = request.params.userId;
   var followedBy = request.params.followedBy;

   var User = Parse.Object.extend('_User'),
   user = new User({ objectId: userId });
   user.set('followedBy', followedBy);

   Parse.Cloud.useMasterKey();
   user.save(null, { useMasterKey: true } ).then(function(user) { return(user);
   }, function(error) { return(error); });
});


// BLOCK/UNBLOCK A USER  
Parse.Cloud.define("blockUnblockUser", (request) => {
   var userId = request.params.userId;
   var blockedBy = request.params.blockedBy;

   var User = Parse.Object.extend('_User'),
   user = new User({ objectId: userId });
   user.set('blockedBy', blockedBy);

   Parse.Cloud.useMasterKey();
   user.save(null, { useMasterKey: true } ).then(function(user) { return(user);
   }, function(error) { return(error); });
});


// MUTE/UNMUTE A USER 
Parse.Cloud.define("muteUnmuteUser", (request) => {
   var userId = request.params.userId;
   var mutedBy = request.params.mutedBy;

   var User = Parse.Object.extend('_User'),
   user = new User({ objectId: userId });
   user.set('mutedBy', mutedBy);

   Parse.Cloud.useMasterKey();
   user.save(null, { useMasterKey: true } ).then(function(user) { return(user);
   }, function(error) { return(error); });
});


// ADD/REMOVE COLLECTION FORM USER
Parse.Cloud.define("addRemoveCollection", (request) => {
   var userId = request.params.userId;
   var inCollections = request.params.inCollections;

   var User = Parse.Object.extend('_User'),
   user = new User({ objectId: userId });
   user.set('inCollections', inCollections);

   Parse.Cloud.useMasterKey();
   user.save(null, { useMasterKey: true } ).then(function(user) { return(user);
   }, function(error) { return(error); });
});


// ADD STAMP
Parse.Cloud.define("addStamp", (request) => {
   var userId = request.params.userId;
   var stamps = request.params.stamps;

   var User = Parse.Object.extend('_User'),
   user = new User({ objectId: userId });
   user.set('stamps', stamps);

   Parse.Cloud.useMasterKey();
   user.save(null, { useMasterKey: true } ).then(function(user) { return(user);
    }, function(error) { return(error); });
});


// ADD/REMOVE FRIEND
Parse.Cloud.define("addRemoveFriend", (request) => {
   var userId = request.params.userId;
   var isFriendWith = request.params.isFriendWith;

   var User = Parse.Object.extend('_User'),
   user = new User({ objectId: userId });
   user.set('isFriendWith', isFriendWith);

   Parse.Cloud.useMasterKey();
   user.save(null, { useMasterKey: true } ).then(function(user) { return(user);
    }, function(error) { return(error); });
});


// SET REMOVED BY
Parse.Cloud.define("setRemovedBy", (request) => {
   var userId = request.params.userId;
   var removedBy = request.params.removedBy;

   var User = Parse.Object.extend('_User'),
   user = new User({ objectId: userId });
   user.set('removedBy', removedBy);

   Parse.Cloud.useMasterKey();
   user.save(null, { useMasterKey: true } ).then(function(user) { return(user);
    }, function(error) { return(error); });
});


// SET USER AS NOT INTERESTING
Parse.Cloud.define("setUserNotInteresting", (request) => {
   var userId = request.params.userId;
   var notInterestingFor = request.params.notInterestingFor;

   var User = Parse.Object.extend('_User'),
   user = new User({ objectId: userId });
   user.set('notInterestingFor', notInterestingFor);

   Parse.Cloud.useMasterKey();
   user.save(null, { useMasterKey: true } ).then(function(user) { return(user);
   }, function(error) { return(error); });
});


// SAVE STARS AND RATINGS FOR A USER
Parse.Cloud.define("saveRatingStars", (request) => {
   var userId = request.params.userId;
   var totalStars = request.params.totalStars;
   var ratedBy = request.params.ratedBy;

   var User = Parse.Object.extend('_User'),
   user = new User({ objectId: userId });
   user.set('totalStars', totalStars);
   user.set('ratedBy', ratedBy);

   Parse.Cloud.useMasterKey();
   user.save(null, { useMasterKey: true } ).then(function(user) { return(user);
   }, function(error) { return(error); });
});




//--------------------------------------------------
// MARK - BACKGROUND JOBS
//--------------------------------------------------

// REMOVE A MOMENT VIDEO AFTER 24 HOURS
Parse.Cloud.job("removeMoments", async function(request) {
   const logger = require('parse-server').logger;
   
   let date = new Date();
   let timeNow = date.getTime();
   let intervalOfTime =  1*24*60*60*1000;  // 24 hours in milliseconds
   let timeThen = timeNow - intervalOfTime;
   // Limit date
   let queryDate = new Date();
   queryDate.setTime(timeThen);

   // Query
   const query = new Parse.Query("Moments");
   query.lessThanOrEqualTo("createdAt", queryDate);
   const results = await query.find();
   // execute query
   for (let i=0; i<results.length; ++i) {
      results[i].destroy({ useMasterKey: true });
   }// ./ For

   return 'job started';
});



// DELIVER A LETTER
Parse.Cloud.job("deliverLetter", async function(request) {
   const logger = require('parse-server').logger;

   // Query
   const query = new Parse.Query("Letters");
   query.equalTo("isDelivered", false);
   query.equalTo("isDraft", false);
   
   let date = new Date();
   query.lessThanOrEqualTo("deliveryDate", date);

   const results = await query.find();
   // execute query
   for (let i=0; i<results.length; ++i) {
      const promises = results.map(async (obj) => {
         obj.set("isDelivered", true);
         await obj.save();
      });
      await Promise.all(promises);
   }// ./ For

   return 'job started';
});



// REMOVE CHAT MESSAGES AFTER 24 HOURS
Parse.Cloud.job("removeMessages", async function(request) {
   const logger = require('parse-server').logger;

   let date = new Date();
   let timeNow = date.getTime();
   let intervalOfTime = 1*24*60*60*1000;  // 24 hours in milliseconds
   let timeThen = timeNow - intervalOfTime;
   // Limit date
   let queryDate = new Date();
   queryDate.setTime(timeThen);

   // Query
   const query = new Parse.Query("Messages");
   query.lessThanOrEqualTo("createdAt", queryDate);
   const results = await query.find();
   // execute query
   for (let i=0; i<results.length; ++i) {
      results[i].destroy({ useMasterKey: true });
   }// ./ For
   return 'job started';
});



// REMOVE A PASSED EVENT
Parse.Cloud.job("removePassedEvents", async function(request) {
   const logger = require('parse-server').logger;

   let date = new Date();
   let timeNow = date.getTime();
   // Limit date
   let queryDate = new Date();
   queryDate.setTime(timeNow);

   // Query
   const query = new Parse.Query("Events");
   query.lessThanOrEqualTo("startDate", queryDate);
   const results = await query.find();
   // execute query
   for (let i=0; i<results.length; ++i) {
      results[i].destroy({ useMasterKey: true });
    }// ./ For

 return "job started"
});