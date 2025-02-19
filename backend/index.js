const express =require('express');
const app=express();
const port =8000|| process.env;
const cors=require('cors');
const bodyParser=require('body-parser');
const mongoose=require('mongoose');

mongoose.connect("mongodb+srv://mohammadyaksafu:mqyjp90UDYt8RQGV@cluster0.hbv6y.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0")


app.use(cors());
app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json())
app.use('/',require('./routes/user.route'));

app.listen(port,()=>{
    console.log('Port running on '+port)

});