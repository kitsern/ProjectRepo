const express = require('express')
const app = express();
const bodyparser = require('body-parser');
const port = 8089;
app.use(bodyparser.json({limit:'50mb'}));
app.use('/',express.static('frontend_apps'))
app.listen(port);
console.log(`Listening at port ${port}`);