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

  Scenario Outline: Use latest backup when there's more than one
    Given the following iOS backups exist:
      | name       | modified   |
      | 1234567890 | 2015-01-01 |
      | <latest>   | 2015-03-01 |
      | 9876543210 | 1980-12-25 |
    When I click "Find SMS database"
    Then I should see "<latest>" within the current backup name

    Examples:
      | latest       |
      | abcdefgh1234 |
