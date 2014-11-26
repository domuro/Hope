var express = require('express')
var app = express();
var database = require('./database');
var pg = require('pg');
var bodyParser = require('body-parser');
var jsend = require('express-jsend');

app.use(bodyParser.urlencoded({extended:true}));
app.use(bodyParser.json());

app.set('port', (process.env.PORT || 5000))
//app.use(express.static(__dirname + '/public'))



// Home
app.get('/', database.welcome);

// Get all the users in the database--test function
app.get('/db/all', database.list);

// Give a UserID, get back a story
app.get('/user/story', database.getStory);

// Get the newest story
app.get('/user/story/new', database.getNewStory);

// Get messages between 2 users
app.get('/user/messages', database.getMessages20);

// Get a user's name give their userID--test function
app.get('/db/Name', database.getName);

// Post a story--change this to post in database.js
app.post('/postStory', function(request, response) {
  var params = JSON.parse(request.body.params); // given: userID, hash, message, 
  var userID = params.userID;
  var hash = params.hash; // use this to find the media--might not always be here because user could post just-text
  var message = params.message;

  if (!hash) {
    pg.connect('process.env.postgres://qlusuogtuojhmo:Ll1O-5n9gVOVQGCraQ2vWO-DTi@ec2-54-83-201-96.compute-1.amazonaws.com:5432/d14m1vprr5jrqf', function(err, client, done) {
      client.query('INSERT INTO "Story" ("UserID", "Message", "CreatedAt") Values ($1, $2, now())', [userID, message], function(err, result) {
        done();
        if (err)
          { console.error(err); response.send("Error " + err); }
        else { 
          return response.jsend(userID);
        }
      })
    })
  }
  else { // user is uploading a story with media
    pg.connect('process.env.postgres://qlusuogtuojhmo:Ll1O-5n9gVOVQGCraQ2vWO-DTi@ec2-54-83-201-96.compute-1.amazonaws.com:5432/d14m1vprr5jrqf', function(err, client, done) {
      client.query('SELECT "MediaID" FROM "Media" WHERE "Hash" = $1', [hash], function(err, rowsMediaID) {
        done();
        if (err)
          { console.error(err); response.send("Error " + err); }
        else { 
          pg.connect('process.env.postgres://qlusuogtuojhmo:Ll1O-5n9gVOVQGCraQ2vWO-DTi@ec2-54-83-201-96.compute-1.amazonaws.com:5432/d14m1vprr5jrqf', function(err, client, done) {
            client.query('INSERT INTO "Story" ("UserID", "MediaID", "Message", "CreatedAt") Values ($1, $2, $3, now())', [userID, rowsMediaID.rows[0].MediaID, message], function(err, result) {
              done();
              if (err)
                { console.error(err); response.send("Error " + err); }
              else { 
                response.jsend(userID);
              }
            })
          })
        }
      })
    })
  }
})

// Create a user
app.post('/db/createUser', function(request, response) {
  var params = JSON.parse(request.body.params); // given: email, password, profilePic, username
  var email = params.email;
  var password = params.password;
  var userName = params.userName;
  console.log("email: " + email);
  console.log("password: " + password);
  console.log("userName: " + userName);
  pg.connect('process.env.postgres://qlusuogtuojhmo:Ll1O-5n9gVOVQGCraQ2vWO-DTi@ec2-54-83-201-96.compute-1.amazonaws.com:5432/d14m1vprr5jrqf', function(err, client, done) {
    client.query('INSERT INTO "User" ("Email", "Password", "UserName") Values ($1, $2, $3);', [email, password, userName], function(err, result) {
    done();
    if (err)
      { console.error(err); response.jsend("Error " + err); }
    else
      { 
        pg.connect('process.env.postgres://qlusuogtuojhmo:Ll1O-5n9gVOVQGCraQ2vWO-DTi@ec2-54-83-201-96.compute-1.amazonaws.com:5432/d14m1vprr5jrqf', function(err, client, done) {
          client.query('SELECT "UserID" FROM "User" WHERE "UserName" = $1', [userName], function(err, result) {
            done();
            if (err)
              { console.error(err); response.send("Error " + err); }
            else
              { response.send(result.rows); }
          })
        })
      }
    })
  })
})

// Checks if a hash exists, true = doesn't exist--you can use the hash. False = it's taken, get a new hash from Tai
app.post('/check/hash', function(request, response) {
  var params = JSON.parse(request.body.params);
  var hash = params.hash;
  pg.connect('process.env.postgres://qlusuogtuojhmo:Ll1O-5n9gVOVQGCraQ2vWO-DTi@ec2-54-83-201-96.compute-1.amazonaws.com:5432/d14m1vprr5jrqf', function(err, client, done) {
    client.query('SELECT * FROM "Media" WHERE "Hash" = $1', [hash], function(err, result) {
    done();
    if (err)
      { console.error(err); response.send("Error " + err); }
    else {
        if (result.rows.length == 0) {
          response.jsend(true); // you can use this hash
        }
        else { return response.jsend(false) } // you cannot use this hash--it's taken
      }
    })
  })
})

app.post('/createMedia', function(request, response) {
  var params = JSON.parse(request.body.params);
  var hash = params.hash;
  var mediaType = params.mediaType;
  pg.connect('process.env.postgres://qlusuogtuojhmo:Ll1O-5n9gVOVQGCraQ2vWO-DTi@ec2-54-83-201-96.compute-1.amazonaws.com:5432/d14m1vprr5jrqf', function(err, client, done) {
    client.query('INSERT INTO "Media" ("CreatedAt", "Hash", "MediaType") VALUES (now(), $1, $2)', [hash, mediaType], function(err, result) {
      done();
      if (err)
        { console.error(err); response.send("Error " + err); }
      else {
        pg.connect('process.env.postgres://qlusuogtuojhmo:Ll1O-5n9gVOVQGCraQ2vWO-DTi@ec2-54-83-201-96.compute-1.amazonaws.com:5432/d14m1vprr5jrqf', function(err, client, done) {
          client.query('SELECT "Hash", "MediaID" FROM "Media" WHERE "Hash" = $1 AND "MediaType" = $2', [hash, mediaType], function(err, result) {
            done();
            if (err)
              { console.error(err); response.send("Error " + err); }
            else {
                response.jsend(result.rows);
            }
          })
        })
      }
    })
  })
})

// Send a message
app.post('/message/send', function(request, response) {
  var params = JSON.parse(request.body.params);
  var userIDTo = params.userIDTo;
  var userIDFrom = params.userIDFrom;
  var message = params.message;
  var hash = params.hash; // optional: only for messages with media
  if (!hash) {
    pg.connect('process.env.postgres://qlusuogtuojhmo:Ll1O-5n9gVOVQGCraQ2vWO-DTi@ec2-54-83-201-96.compute-1.amazonaws.com:5432/d14m1vprr5jrqf', function(err, client, done) {
      client.query('INSERT INTO "Message" ("CreatedAt", "Message", "UserIDTo", "UserIDFrom") VALUES (now(), $1, $2, $3)', [message, userIDTo, userIDFrom], function(err, result) {
        done();
        if (err)
          { console.error(err); response.send("Error " + err); }
        else {
          response.jsend("Message sent successfully");
        }
      })
    })
  }
  else { // if there's a multimedia component of the message
    pg.connect('process.env.postgres://qlusuogtuojhmo:Ll1O-5n9gVOVQGCraQ2vWO-DTi@ec2-54-83-201-96.compute-1.amazonaws.com:5432/d14m1vprr5jrqf', function(err, client, done) {
      client.query('SELECT "MediaID" FROM "Media" WHERE "Hash" = $1', [hash], function(err, rowsMediaID) {
        done();
        if (err)
          { console.error(err); response.send("Error1 " + err); }
        else { 
          pg.connect('process.env.postgres://qlusuogtuojhmo:Ll1O-5n9gVOVQGCraQ2vWO-DTi@ec2-54-83-201-96.compute-1.amazonaws.com:5432/d14m1vprr5jrqf', function(err, client, done) {
            client.query('INSERT INTO "Message" ("CreatedAt", "Message", "UserIDTo", "UserIDFrom", "MediaID") Values (now(), $1, $2, $3, $4)', [message, userIDTo, userIDFrom, rowsMediaID.rows[0].MediaID], function(err, result) {
              done();
              if (err)
                { console.error(err); response.send("Error2 " + err); }
              else { 
                response.jsend("Message with media sent successfully");
              }
            })
          })
        }
      })
    })
  }
})

// Puts a story in "UserReadStory" for a User
app.post('/story/read', function(request, response) {
  var params = JSON.parse(request.body.params); // given: userID, storyID, 
  var userID = params.userID;
  var storyID = params.storyID;
  pg.connect('process.env.postgres://qlusuogtuojhmo:Ll1O-5n9gVOVQGCraQ2vWO-DTi@ec2-54-83-201-96.compute-1.amazonaws.com:5432/d14m1vprr5jrqf', function(err, client, done) {
    client.query('INSERT INTO "UserReadStory" ("UserID", "StoryID") VALUES ($1, $2)', [userID, storyID], function(err, result) {
      done();
      if (err)
        { console.error(err); response.send("Error " + err); }
      else {
          response.jsend("Recorded that User " + userID + " read Story " + storyID);
      }
    })
  })
})

app.listen(app.get('port'), function() {
  console.log("Node app is running at localhost:" + app.get('port'))
})
