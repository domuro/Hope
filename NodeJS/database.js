var pg = require('pg');
var bodyParser = require('body-parser');
var jsend = require('express-jsend');

exports.welcome = function(request, response) {
  response.send("Hello World...");
}

// Get a list of all users--test function
exports.list = function(request, response) {
  pg.connect('process.env.postgres://qlusuogtuojhmo:Ll1O-5n9gVOVQGCraQ2vWO-DTi@ec2-54-83-201-96.compute-1.amazonaws.com:5432/d14m1vprr5jrqf', function(err, client, done) {
    client.query('SELECT * FROM "public"."User"', function(err, result) {
      done();
      if (err)
        { console.error(err); response.send("Error " + err); }
      else
        { response.send(result.rows); }
    })
  })
}

// Give userID, get a userName back--test function
exports.getName = function(request, response) {
  pg.connect('process.env.postgres://qlusuogtuojhmo:Ll1O-5n9gVOVQGCraQ2vWO-DTi@ec2-54-83-201-96.compute-1.amazonaws.com:5432/d14m1vprr5jrqf', function(err, client, done) {
    var userID = request.query.userID;
    client.query('SELECT "UserName" FROM "User" WHERE "UserID" = $1', [userID], function(err, result) {
      done();
      if (err)
        { console.error(err); response.send("Error " + err); }
      else
        { response.send(result.rows); }
    })
  })
}

// Give a userID, get a story back (for demo: 2 hard-coded stories and 1 most recent)
exports.getStory = function(request, response) {
  pg.connect('process.env.postgres://qlusuogtuojhmo:Ll1O-5n9gVOVQGCraQ2vWO-DTi@ec2-54-83-201-96.compute-1.amazonaws.com:5432/d14m1vprr5jrqf', function(err, client, done) {
    var userID = request.query.userID;
    client.query('SELECT * FROM "Story" WHERE "StoryID" = 1', function(err, result) { // decide what kind of story comes up
      done();
      if (err)
        { console.error(err); response.send("Error " + err); }
      else
        { response.send(result.rows); }
    })
  })
}

// Get the latest story (that's unread and not the user's own story)
exports.getNewStory = function(request, response) {
  pg.connect('process.env.postgres://qlusuogtuojhmo:Ll1O-5n9gVOVQGCraQ2vWO-DTi@ec2-54-83-201-96.compute-1.amazonaws.com:5432/d14m1vprr5jrqf', function(err, client, done) {
    var userID = request.query.userID;
    client.query('SELECT * FROM "Story" WHERE "UserID" != $1 ORDER BY "CreatedAt" DESC LIMIT 1;', [userID], function(err, result1) { // grabs most recent story
      done();
      if (err)
        { console.error(err); response.send("Error " + err); }
      else
      {
        console.log("result1.rows: " + result1.rows);
        if (result1.rows.length == 0) {
          response.jerror("No new story"); 
        }
        else {
          pg.connect('process.env.postgres://qlusuogtuojhmo:Ll1O-5n9gVOVQGCraQ2vWO-DTi@ec2-54-83-201-96.compute-1.amazonaws.com:5432/d14m1vprr5jrqf', function(err, client, done) {
            client.query('SELECT m."Hash", m."MediaType", s."StoryID", s."UserID", s."Message", s."CreatedAt" FROM "Media" m, "Story" s WHERE m."MediaID" = $1 AND m."MediaID" = s."MediaID" ORDER BY "CreatedAt" DESC LIMIT 1;', [result1.rows[0].MediaID] ,function(err, result3) { // decide what kind of story comes up
              done();
              if (err)
                { console.error(err); response.send("Error " + err); }
              else
                { response.jsend(result3.rows); }
            })
          })
        }
      }
    })
  })
}

// Gets 20 most recent messages between two users
exports.getMessages20 = function(request, response) {
  pg.connect('process.env.postgres://qlusuogtuojhmo:Ll1O-5n9gVOVQGCraQ2vWO-DTi@ec2-54-83-201-96.compute-1.amazonaws.com:5432/d14m1vprr5jrqf', function(err, client, done) {
    var userID1 = request.query.userID1;
    var userID2 = request.query.userID2;
    client.query('SELECT * FROM "Message" WHERE (("UserIDTo" = $1 AND "UserIDFrom" = $2) OR ("UserIDTo" = $2 AND "UserIDFrom" = $1)) ORDER BY "CreatedAt" DESC LIMIT 20;', [userID1, userID2], function(err, result) {
      done();
      if (err)
        { console.error(err); response.send("Error " + err); }
      else
        { response.jsend(result.rows); }
    })
  })
}