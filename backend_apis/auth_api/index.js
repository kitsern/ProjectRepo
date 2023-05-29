const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const users = [{
    username:'ernesto',
    password: '123456',
    name:"Kitutu Ernest",
    gender:"M",
    telno:"+256 789884748"
}]
var corsOptions = {
    origin: 'http://localhost:8089',
    optionsSuccessStatus: 200 // some legacy browsers (IE11, various SmartTVs) choke on 204
  }
const app = express();
app.use(cors(corsOptions));
app.use(bodyParser.json({ limit: '50mb'}));

app.post('/auth/login',(req,res,next)=>{
        var body = req.body;
        console.log(body);
        if(body.username!==users[0].username){
            res.json({
                success:false,
                error:"Un Known Username or Password"
            });
            return;
        }
        if(body.password!== users[0].password){
            res.json({
                success:false,
                error:"Un Known Username or Password"
            });
            return;
        }

        res.json({
            success:true,
            data:users[0]
        });
})

app.listen(4050);
console.log('Server is listening at port 4050');