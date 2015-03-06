Feature: Locate SMS file
  As a user
  I can have the application find my SMS file
  So I don't have to remember the strange name

  Scenario Outline: Find backup when there's only one
    Given the following iOS backups exist:
      | name   |
      | <name> |
    When I click "Find SMS database"
    Then I should see "<name>" within the current backup name

    Examples:
      | name            |
      | 1234567890      |
      | 987654321abcdef |
