/**
 * This sample demonstrates a simple skill built with the Amazon Alexa Skills
 * nodejs skill development kit.  It's intended to be used at an MLH Localhost
 * Workshop.
 *
 * The Intent Schema, Custom Slots and Sample Utterances for this skill, as well
 * as testing instructions are located at https://github.com/mlh/mlh-localhost-hacking-with-alexa
 **/

 //arn:aws:lambda:us-east-1:019127766437:function:StuyOpenSource-Skill

'use strict';

// TODO: replace with facts about yourself
const FACTS = [
  "StuyOpenSource is a programming club based in Stuyvesant HS",
  "StuyOpenSource was created last year",
  "StuyOpenSource has over 300 members",
  "The members of StuyOS are really cool",
  "StuyOpenSource hosted an Amazon Alexa workshop on 10/18/2017",
  "Other schools wish they has a club as cool as StuyOpenSource",
  "This skill may or may not be propaganda for the club"
];

var handlers = {
  'LaunchRequest': function () { this.emit('GetFact'); },
  'GetNewFactIntent': function () { this.emit('GetFact'); },
  'GetFact': function() {
    // Randomly select a fact from the array
    const factIndex = Math.floor(Math.random() * FACTS.length);
    const randomFact = FACTS[factIndex];

    // Create speech output
    const speechOutput = "Here's your fact: " + randomFact;
    this.emit(':tellWithCard', speechOutput, "Major League Hacking (MLH) Facts", randomFact);
  }
};

// This is the function that AWS Lambda calls every time Alexa uses your skill.
exports.handler = function(event, context, callback) {
  // Include the AWS Alexa Library.
  const Alexa = require("alexa-sdk");

  // Create an instance of the Alexa library and pass it the requested command.
  var alexa = Alexa.handler(event, context);

  // Give our Alexa instance instructions for handling commands and execute the request.
  alexa.registerHandlers(handlers);
  alexa.execute();
};
