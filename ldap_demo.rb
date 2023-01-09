require "net/ldap"

HOST = "ldap.umich.edu"
USERNAME = ENV.fetch("LDAP_USERNAME")
PASSWORD = ENV.fetch("LDAP_PASSWORD")

def authenticated_ldap
  Net::LDAP.new(host: HOST, auth: {method: :simple, username: USERNAME, password: PASSWORD})
end

def unauthenticated_ldap
  Net::LDAP.new(host: HOST)
end

def ldap_search(params, ldap = unauthenticated_ldap)
  ldap.search(**params) do |entry|
    puts "DN: #{entry.dn}"
    entry.each do |attr, values|
      puts "#{attr}:"
      values.each do |value|
        puts "  #{value}"
      end
    end
  end
end

######################
# USERS
# ####################

####################
##### One user #####
####################
def one_user(uniqname)
  {
    base: "ou=People,dc=umich,dc=edu",
    objectclass: "*",
    filter: "uid=#{uniqname}"
  }
end

# ldap_search(one_user("ststv")) #not authenticated; shows less info
# ldap_search(one_user("ststv"), authenticated_ldap) #authenticated; shows more info

############################
##### One 8-digit umid #####
############################
def one_umid(umid)
  {
    base: "ou=People,dc=umich,dc=edu",
    objectclass: "*",
    filter: "entityid=#{umid}"
  }
end

# ldap_search(one_umid("75280540"), authenticated_ldap) #this only works with authenticated

############################
# Users who work in a particular department
# ###########################

def users_in_a_department(department)
  # partitions by first letter in uniqname to deal with
  # ldap results limits
  ("a".."z").each do |letter|
    params = {
      base: "ou=People,dc=umich,dc=edu",
      filter: "(&(uid=#{letter}*)(umichhr=*deptGroup\\3d#{department}*))"
    }
    ldap_search(params, authenticated_ldap)
  end
end

# users_in_a_department("UNIV_LIBRARY")

##########################
# GROUPS
# ########################

###############################################
##### Mcommunity Group with a known name #####
###############################################
def known_group(group)
  {
    base: "ou=Groups,dc=umich,dc=edu",
    filter: "(cn=#{group})"
  }
end

# ldap_search(known_group("lit-developers"))

######################################################
##### Mcommunity Groups with a Particular Member #####
######################################################
def groups_with_particular_member(uniqname)
  {
    base: "ou=Groups,dc=umich,dc=edu",
    filter: "(member=uid=#{uniqname},ou=People,dc=umich,dc=edu)"
  }
end

# replace with a uniqname you know
# this is a bit slow
# ldap_search(groups_with_particular_member("UNIQNAME"))
