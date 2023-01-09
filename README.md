# MCommunity LDAP Demo

A demo of MCommunity LDAP in ruby

## Requirements
* docker
* docker compose

## Instructions

1. Clone the repository. `cd` into it.
2. Run the setup script
```
./init.sh
```
3. Update the `.env` file with the appropriate values. This is optional since several of the examples don't require authentication.
4. Uncomment an appropriate line in `ldap_demo.rb`. For example, the line with `ldap_search(one_user("ststv"))` can be uncommented. 
5. Run the script in the terminal
```
docker-compose run --rm web bundle exec ruby ./ldap_demo.rb
```
