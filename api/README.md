# API usage of QSEoK

There is a little NodeJS app in this folder, <a href="createjwt.js">createjwt.js</a>
which creates a JWT token, puts the user in as signs the token with the file *private.key* which was generated during the vagrant provisioning (shell script <a href="../sh/2_uservagrant.sh">2_vagrantuser.sh</a>)
```
nodejs createjwt.js [userid]
```
This token can be used in API calls as http header Bearer Authentication like this:
```
curl --insecure -s https://192.168.56.234/api/v1/users -H "Authorization: Bearer ######"
```
