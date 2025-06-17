const mongoose = require('mongoose');
const Schema = mongoose.Schema;


const userSchema = new Schema(
    {
        name: {
            type: String,
            required: true
        },
        address: {
            type: String,
            default: ''
        },
        email: {
            type: String,
            required: true,
            unique: true, 
            lowercase: true, 
            trim: true 
        },
        profilePic: { 
            type: String,
            default: '' 
        },
        mobileNumber: {
            type: String,
            required: true,
            unique: true 
        },
        password: {
            type: String,
            required: true
        }
    },
    {
        timestamps: true 
    }
);

module.exports = mongoose.model('User', userSchema);