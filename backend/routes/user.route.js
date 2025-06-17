const express = require('express');
const router = express.Router();
const User = require('../models/user.model'); 

//////////////////////////////////
/////////Signup Route/////////////
//////////////////////////////////

router.post('/signup', async (req, res) => {
    try {
        
        const {name,address, email, profilePic, mobileNumber, password } = req.body;

        
        if (!name || !email || !mobileNumber || !password) {
            return res.status(400).json({ message: "Please provide name, email, mobile number, and password." });
        }
        
        const existingUser = await User.findOne({ $or: [{ email }, { mobileNumber }] });

        if (existingUser) {
            let message = "User already exists.";
            if (existingUser.email === email) {
                message = "Email is already registered.";
            } else if (existingUser.mobileNumber === mobileNumber) {
                message = "Mobile number is already registered.";
            }
            return res.status(409).json({ message }); 
        }

        
        const newUser = new User({
            name,
            address: address || '', 
            email,
            profilePic: profilePic || '', 
            mobileNumber,
            password 
        });

        await newUser.save();

        
        const userResponse = newUser.toObject(); 
        delete userResponse.password; 
        delete userResponse.__v;     

        res.status(201).json({ message: "User registered successfully", user: userResponse });

    } catch (error) {
        console.error("Signup error:", error);
        
        if (error.code === 11000) { 
            return res.status(409).json({ message: "A user with this email or mobile number already exists." });
        }
        res.status(500).json({ message: "Server error during signup", error: error.message });
    }
});


/////////////////////////////////////////////////
////////////////Signin Route////////////////////
////////////////////////////////////////////////

router.post('/signin', async (req, res) => {
    try {
        const { email, password } = req.body;

        
        if (!email || !password) {
            return res.status(400).json({ message: "Please provide email and password." });
        }

        const user = await User.findOne({ email: email.toLowerCase().trim() }); 

        if (!user) {
            return res.status(404).json({ message: "Invalid email or password." }); 
        }

        if (password !== user.password) {
            return res.status(401).json({ message: "Invalid email or password." });
        }

        
        const userResponse = user.toObject();
        delete userResponse.password;
        delete userResponse.__v;

        res.status(200).json({ message: "Login successful", user: userResponse });

    } catch (error) {
        console.error("Signin error:", error);
        res.status(500).json({ message: "Server error during signin", error: error.message });
    }
});

module.exports = router;
