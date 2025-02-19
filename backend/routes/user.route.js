const express = require('express');
const router = express.Router();
const User = require('../models/user.model'); 

router.post('/signup', async (req, res) => {
    try {
        const { email, password } = req.body;
        const existingUser = await User.findOne({ email });

        if (existingUser) {
            return res.status(400).json({ message: "Email is not available." });
        }

        const newUser = new User({ email, password });
        await newUser.save();

        res.status(201).json({ message: "User registered successfully", user: newUser });

    } catch (error) {
        console.error("Signup error:", error);
        res.status(500).json({ message: "Server error", error });
    }
});





router.post('/signin', async (req, res) => {
    try {
        const { email, password } = req.body;
        const user = await User.findOne({ email });

        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        
        if (password!==user.password) {
            return res.status(401).json({ message: "Invalid email or password" });
        }

        res.status(200).json({ message: "Login successful", user });

    } catch (error) {
        console.error("Signin error:", error);
        res.status(500).json({ message: "Server error", error });
    }
});

module.exports= router;