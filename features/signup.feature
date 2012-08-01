Feature: Signing up

Scenario: Failure
  Given a user visits the signup page
  When user submits invalid signup information
  Then he should see an error message

Scenario: Success
  Given a user visits the signup page
  And the user submits valid login information
  Then he should see a welcome message
  And he should see a signout link