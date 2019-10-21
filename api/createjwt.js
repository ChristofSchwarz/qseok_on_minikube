var sub = process.argv[2];
var jwt = require('jsonwebtoken');
var fs = require('fs');
var privkey= fs.readFileSync('private.key');
var jwt_payload = {
    iss: "https://qlik.api.internal",
    aud: "qlik.api",
    sub: sub,
    groups : ["Everyone"],
    name: "Qlik API",
    exp: 1800000000
};
console.log(jwt.sign(jwt_payload, privkey, {
   algorithm:'RS256',
   noTimestamp:true,
   header:{"kid":"my-key-identifier"}
}));
