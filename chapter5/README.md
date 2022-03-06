# Adding your own users to the ConfigMap  
  
The included Apache DS container includes a few users that are used throughout the exercises, but you can also add your own users for any "extra" testing you may be interested in.  
  
## Adding a user to the ConfigMap  
  
To add a new user, or users, you can edit the ConfigMap called test-users in the activedirectory namespace.   In the example below, we are adding a new user called Scott Surovich with a password of password1234.
  
## test-users  
  
```
apiVersion: v1
data:
  data.ldif: |-
    dn: DC=domain,DC=com
    objectClass: domain
    dc: domain

    dn: ou=Users,DC=domain,DC=com
    objectClass: organizationalUnit
    ou: users


    dn: ou=Groups,DC=domain,DC=com
    objectClass: organizationalUnit
    ou: Groups


    dn: cn=ou_svc_account,ou=Users,DC=domain,DC=com
    objectClass: user
    cn: ou_svc_account
    givenName: ou
    sn: svc
    samAccountName: ou_svc_account
    userPassword: start123

    dn: cn=pipeline_svc_account,ou=Users,DC=domain,DC=com
    objectClass: user
    cn: pipeline_svc_account
    givenName: pipeline
    sn: svc
    samAccountName: pipeline_svc_account
    userPassword: start123

    dn: cn=mmosley,ou=Users,DC=domain,DC=com
    objectClass: user
    cn: mmosley
    givenName: Matt
    sn: Mosley
    samAccountName: mmosley
    mail: mmosley@tremolo.dev
    title: Tester
    telephoneNumber: 123-456-7890
    userPassword: start123

    dn: cn=surovich,ou=Users,DC=domain,DC=com
    objectClass: user
    cn: surovich
    givenName: Scott
    sn: Surovich
    samAccountName: surovich
    mail: surovich@nowhere.com
    title: Main Account
    telephoneNumber: 123-456-7890
    userPassword: password1234
```
  
You can any number of users by adding the same block with the user information you want to add.  Simply change the XXXX values listed below with your desired information.  
  
```
    dn: cn=XXXX,ou=Users,DC=domain,DC=com
    objectClass: user
    cn: XXXX
    givenName: XXXX
    sn: XXXX
    samAccountName: XXXX
    mail: XXXX@nowhere.com
    title: Main Account
    telephoneNumber: 123-456-7890
    userPassword: password1234
 ```
