/*
 * cfg.stream_specific.js
 * Configures the app - only the items which are likely to need configuring
 * by a stream leader. This helps roll out core cfg changes without people
 * having to modify.
 *
 * Author: Jack Preston (github.com/unwitting)
 */

module.exports = {
  port: 40002,       // Port to run the server on as JS number
  jiraAuth: {
    user: 'stephen.hazleton@openbet.com',     // Jira username (your OB email) as JS string
    pass: '2VqXARVO'      // Jira pass as JS string
  },
  streamName: 'Bad Change Tickets', // Human-nice name for your stream eg 'Payments' as string
  streamLeaders: ['Stephen.Hazleton@openbet.com', 'Andrew.Raines@openbet.com'] // Array of stream leaders' emails as strings
};
