const express = require('express');
const cors = require('cors');
const multer = require('multer');
const { v4: uuidv4 } = require('uuid');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files for downloads
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Configure multer for file uploads
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        const uploadDir = 'uploads';
        if (!fs.existsSync(uploadDir)) {
            fs.mkdirSync(uploadDir);
        }
        cb(null, uploadDir);
    },
    filename: (req, file, cb) => {
        cb(null, `${Date.now()}-${file.originalname}`);
    }
});

const upload = multer({
    storage,
    limits: {
        fileSize: 10 * 1024 * 1024, // 10MB limit
    }
});

// Mock database
let users = [
    {
        id: 1,
        name: "Leanne Graham",
        username: "Bret",
        email: "Sincere@april.biz",
        address: {
            street: "Kulas Light",
            suite: "Apt. 556",
            city: "Gwenborough",
            zipcode: "92998-3874",
            geo: {
                lat: "-37.3159",
                lng: "81.1496"
            }
        },
        phone: "1-770-736-8031 x56442",
        website: "hildegard.org",
        company: {
            name: "Romaguera-Crona",
            catchPhrase: "Multi-layered client-server neural-net",
            bs: "harness real-time e-markets"
        }
    },
    {
        id: 2,
        name: "Ervin Howell",
        username: "Antonette",
        email: "Shanna@melissa.tv",
        address: {
            street: "Victor Plains",
            suite: "Suite 879",
            city: "Wisokyburgh",
            zipcode: "90566-7771",
            geo: {
                lat: "-43.9509",
                lng: "-34.4618"
            }
        },
        phone: "010-692-6593 x09125",
        website: "anastasia.net",
        company: {
            name: "Deckow-Crist",
            catchPhrase: "Proactive didactic contingency",
            bs: "synergize scalable supply-chains"
        }
    }
];

let posts = [
    {
        userId: 1,
        id: 1,
        title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
        body: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
    },
    {
        userId: 1,
        id: 2,
        title: "qui est esse",
        body: "est rerum tempore vitae\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\nqui aperiam non debitis possimus qui neque nisi nulla"
    },
    {
        userId: 2,
        id: 3,
        title: "ea molestias quasi exercitationem repellat qui ipsa sit aut",
        body: "et iusto sed quo iure\nvoluptatem occaecati omnis eligendi aut ad\nvoluptatem doloribus vel accusantium quis pariatur\nmolestiae porro eius odio et labore et velit aut"
    }
];

let nextUserId = 3;
let nextPostId = 4;

// Utility functions
const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms));

const simulateLatency = async (req, res, next) => {
    const latency = Math.random() * 1000 + 200; // 200-1200ms
    await delay(latency);
    next();
};

const validateUser = (user) => {
    if (!user.name || !user.email || !user.username) {
        return { valid: false, error: 'Name, email, and username are required' };
    }
    if (user.email && !user.email.includes('@')) {
        return { valid: false, error: 'Invalid email format' };
    }
    return { valid: true };
};

// Routes

// Health check
app.get('/', (req, res) => {
    res.json({
        success: true,
        message: 'Flutter Test Server is running!',
        timestamp: new Date().toISOString(),
        endpoints: {
            users: 'GET /users, GET /users/:id, POST /users, PUT /users/:id, DELETE /users/:id',
            posts: 'GET /posts, GET /posts/:id, POST /posts, PUT /posts/:id, DELETE /posts/:id',
            auth: 'POST /login, POST /register',
            files: 'POST /upload, GET /download/:filename',
            errors: 'GET /errors/:code'
        }
    });
});

// USERS ENDPOINTS

// Get all users with optional query parameters
app.get('/users', simulateLatency, (req, res) => {

    const { page, limit, search } = req.query;
    console.log('req.query', req.query);
    let filteredUsers = [...users];

    // Search filter
    if (search) {
        filteredUsers = filteredUsers.filter(user =>
            user.name.toLowerCase().includes(search.toLowerCase()) ||
            user.email.toLowerCase().includes(search.toLowerCase())
        );
    }

    // Pagination
    const pageNum = parseInt(page) || 1;
    const limitNum = parseInt(limit) || 10;
    const startIndex = (pageNum - 1) * limitNum;
    const endIndex = startIndex + limitNum;

    const paginatedUsers = filteredUsers.slice(startIndex, endIndex);

    res.json({
        success: true,
        data: paginatedUsers,
        message: 'Users retrieved successfully',
        meta: {
            currentPage: pageNum,
            totalPages: Math.ceil(filteredUsers.length / limitNum),
            totalItems: filteredUsers.length,
            itemsPerPage: limitNum
        }
    });
});

// Get user by ID
app.get('/users/:id', simulateLatency, (req, res) => {
    const userId = parseInt(req.params.id);
    const user = users.find(u => u.id === userId);

    if (!user) {
        return res.status(404).json({
            success: false,
            message: 'User not found',
            error: `User with ID ${userId} does not exist`
        });
    }

    res.json({
        success: true,
        data: user,
        message: 'User retrieved successfully'
    });
});

// Create new user
app.post('/users', simulateLatency, (req, res) => {
    const validation = validateUser(req.body);
    if (!validation.valid) {
        return res.status(400).json({
            success: false,
            message: 'Validation failed',
            error: validation.error
        });
    }

    // Check if email already exists
    const existingUser = users.find(u => u.email === req.body.email);
    if (existingUser) {
        return res.status(409).json({
            success: false,
            message: 'User already exists',
            error: 'A user with this email already exists'
        });
    }

    const newUser = {
        id: nextUserId++,
        ...req.body,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
    };

    users.push(newUser);

    res.status(201).json({
        success: true,
        data: newUser,
        message: 'User created successfully'
    });
});

// Update user
app.put('/users/:id', simulateLatency, (req, res) => {
    const userId = parseInt(req.params.id);
    const userIndex = users.findIndex(u => u.id === userId);

    if (userIndex === -1) {
        return res.status(404).json({
            success: false,
            message: 'User not found',
            error: `User with ID ${userId} does not exist`
        });
    }

    const validation = validateUser(req.body);
    if (!validation.valid) {
        return res.status(400).json({
            success: false,
            message: 'Validation failed',
            error: validation.error
        });
    }

    // Check if email is taken by another user
    const emailExists = users.some(u => u.id !== userId && u.email === req.body.email);
    if (emailExists) {
        return res.status(409).json({
            success: false,
            message: 'Email already taken',
            error: 'This email is already registered to another user'
        });
    }

    users[userIndex] = {
        ...users[userIndex],
        ...req.body,
        updatedAt: new Date().toISOString()
    };

    res.json({
        success: true,
        data: users[userIndex],
        message: 'User updated successfully'
    });
});

// Delete user
app.delete('/users/:id', simulateLatency, (req, res) => {
    const userId = parseInt(req.params.id);
    const userIndex = users.findIndex(u => u.id === userId);

    if (userIndex === -1) {
        return res.status(404).json({
            success: false,
            message: 'User not found',
            error: `User with ID ${userId} does not exist`
        });
    }

    // Also delete user's posts
    posts = posts.filter(post => post.userId !== userId);

    const deletedUser = users.splice(userIndex, 1)[0];

    res.json({
        success: true,
        data: deletedUser,
        message: 'User deleted successfully'
    });
});

// POSTS ENDPOINTS

// Get all posts with optional filtering
app.get('/posts', simulateLatency, (req, res) => {
    const { userId, page, limit } = req.query;
    let filteredPosts = [...posts];

    // Filter by user ID
    if (userId) {
        filteredPosts = filteredPosts.filter(post => post.userId === parseInt(userId));
    }

    // Pagination
    const pageNum = parseInt(page) || 1;
    const limitNum = parseInt(limit) || 10;
    const startIndex = (pageNum - 1) * limitNum;
    const endIndex = startIndex + limitNum;

    const paginatedPosts = filteredPosts.slice(startIndex, endIndex);

    res.json({
        success: true,
        data: paginatedPosts,
        message: 'Posts retrieved successfully',
        meta: {
            currentPage: pageNum,
            totalPages: Math.ceil(filteredPosts.length / limitNum),
            totalItems: filteredPosts.length,
            itemsPerPage: limitNum
        }
    });
});

// Get post by ID
app.get('/posts/:id', simulateLatency, (req, res) => {
    const postId = parseInt(req.params.id);
    const post = posts.find(p => p.id === postId);

    if (!post) {
        return res.status(404).json({
            success: false,
            message: 'Post not found',
            error: `Post with ID ${postId} does not exist`
        });
    }

    res.json({
        success: true,
        data: post,
        message: 'Post retrieved successfully'
    });
});

// Create new post
app.post('/posts', simulateLatency, (req, res) => {
    const { title, body, userId } = req.body;

    if (!title || !body || !userId) {
        return res.status(400).json({
            success: false,
            message: 'Validation failed',
            error: 'Title, body, and userId are required'
        });
    }

    // Check if user exists
    const userExists = users.some(u => u.id === parseInt(userId));
    if (!userExists) {
        return res.status(400).json({
            success: false,
            message: 'Invalid user',
            error: `User with ID ${userId} does not exist`
        });
    }

    const newPost = {
        id: nextPostId++,
        title,
        body,
        userId: parseInt(userId),
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
    };

    posts.push(newPost);

    res.status(201).json({
        success: true,
        data: newPost,
        message: 'Post created successfully'
    });
});

// Update post
app.put('/posts/:id', simulateLatency, (req, res) => {
    const postId = parseInt(req.params.id);
    const postIndex = posts.findIndex(p => p.id === postId);

    if (postIndex === -1) {
        return res.status(404).json({
            success: false,
            message: 'Post not found',
            error: `Post with ID ${postId} does not exist`
        });
    }

    const { title, body } = req.body;

    if (!title || !body) {
        return res.status(400).json({
            success: false,
            message: 'Validation failed',
            error: 'Title and body are required'
        });
    }

    posts[postIndex] = {
        ...posts[postIndex],
        title,
        body,
        updatedAt: new Date().toISOString()
    };

    res.json({
        success: true,
        data: posts[postIndex],
        message: 'Post updated successfully'
    });
});

// Patch post (partial update)
app.patch('/posts/:id', simulateLatency, (req, res) => {
    const postId = parseInt(req.params.id);
    const postIndex = posts.findIndex(p => p.id === postId);

    if (postIndex === -1) {
        return res.status(404).json({
            success: false,
            message: 'Post not found',
            error: `Post with ID ${postId} does not exist`
        });
    }

    posts[postIndex] = {
        ...posts[postIndex],
        ...req.body,
        updatedAt: new Date().toISOString()
    };

    res.json({
        success: true,
        data: posts[postIndex],
        message: 'Post updated successfully'
    });
});

// Delete post
app.delete('/posts/:id', simulateLatency, (req, res) => {
    const postId = parseInt(req.params.id);
    const postIndex = posts.findIndex(p => p.id === postId);

    if (postIndex === -1) {
        return res.status(404).json({
            success: false,
            message: 'Post not found',
            error: `Post with ID ${postId} does not exist`
        });
    }

    const deletedPost = posts.splice(postIndex, 1)[0];

    res.json({
        success: true,
        data: deletedPost,
        message: 'Post deleted successfully'
    });
});

// AUTH ENDPOINTS

// Login
app.post('/login', simulateLatency, (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({
            success: false,
            message: 'Validation failed',
            error: 'Email and password are required'
        });
    }

    // Mock authentication
    const user = users.find(u => u.email === email);

    if (!user || password !== 'password123') { // Simple mock password
        return res.status(401).json({
            success: false,
            message: 'Authentication failed',
            error: 'Invalid email or password'
        });
    }

    // Mock token
    const token = `mock-jwt-token-${uuidv4()}`;

    res.json({
        success: true,
        data: {
            user,
            token,
            expiresIn: '24h'
        },
        message: 'Login successful'
    });
});

// Register
app.post('/register', simulateLatency, (req, res) => {
    const validation = validateUser(req.body);
    if (!validation.valid) {
        return res.status(400).json({
            success: false,
            message: 'Validation failed',
            error: validation.error
        });
    }

    // Check if user already exists
    const existingUser = users.find(u => u.email === req.body.email);
    if (existingUser) {
        return res.status(409).json({
            success: false,
            message: 'User already exists',
            error: 'A user with this email already exists'
        });
    }

    const newUser = {
        id: nextUserId++,
        ...req.body,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
    };

    users.push(newUser);

    // Generate token
    const token = `mock-jwt-token-${uuidv4()}`;

    res.status(201).json({
        success: true,
        data: {
            user: newUser,
            token,
            expiresIn: '24h'
        },
        message: 'User registered successfully'
    });
});

// FILE UPLOAD ENDPOINTS

// Upload file
app.post('/upload', upload.array('files', 5), (req, res) => {
    if (!req.files || req.files.length === 0) {
        return res.status(400).json({
            success: false,
            message: 'No files uploaded',
            error: 'Please select at least one file to upload'
        });
    }

    const fileUrls = req.files.map(file => ({
        filename: file.filename,
        originalName: file.originalname,
        size: file.size,
        mimetype: file.mimetype,
        url: `http://localhost:${PORT}/uploads/${file.filename}`
    }));

    res.json({
        success: true,
        data: fileUrls,
        message: `Successfully uploaded ${fileUrls.length} file(s)`
    });
});

// Download file
app.get('/download/:filename', (req, res) => {
    const filename = req.params.filename;
    const filePath = path.join(__dirname, 'uploads', filename);

    if (!fs.existsSync(filePath)) {
        return res.status(404).json({
            success: false,
            message: 'File not found',
            error: `File ${filename} does not exist`
        });
    }

    res.download(filePath);
});

// ERROR TESTING ENDPOINTS

// Test different error responses
app.get('/errors/:code', (req, res) => {
    const errorCode = parseInt(req.params.code);

    const errorMessages = {
        400: 'Bad Request - The server cannot process the request',
        401: 'Unauthorized - Authentication is required',
        403: 'Forbidden - You do not have permission',
        404: 'Not Found - The requested resource was not found',
        409: 'Conflict - Resource conflict occurred',
        422: 'Unprocessable Entity - Validation failed',
        429: 'Too Many Requests - Rate limit exceeded',
        500: 'Internal Server Error - Something went wrong',
        502: 'Bad Gateway - Invalid response from upstream server',
        503: 'Service Unavailable - Server is temporarily unavailable'
    };

    const message = errorMessages[errorCode] || 'Unknown error';

    res.status(errorCode).json({
        success: false,
        message: `Error ${errorCode}`,
        error: message,
        timestamp: new Date().toISOString()
    });
});

// Simulate timeout
app.get('/timeout', async (req, res) => {
    await delay(5000); // 5 second delay
    res.json({
        success: true,
        message: 'This response was delayed by 5 seconds'
    });
});

// // 404 handler for undefined routes
// app.use('*', (req, res) => {
//     res.status(404).json({
//         success: false,
//         message: 'Endpoint not found',
//         error: `The route ${req.originalUrl} does not exist on this server`
//     });
// });

// Error handling middleware
app.use((err, req, res, next) => {
    console.error('Server Error:', err);

    if (err instanceof multer.MulterError) {
        if (err.code === 'LIMIT_FILE_SIZE') {
            return res.status(413).json({
                success: false,
                message: 'File too large',
                error: 'The uploaded file exceeds the size limit'
            });
        }
    }

    res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: process.env.NODE_ENV === 'development' ? err.message : 'Something went wrong'
    });
});

// Start server
app.listen(PORT, () => {
    console.log(`🚀 Flutter Test Server running on http://localhost:${PORT}`);
    console.log(`📚 API Documentation available at http://localhost:${PORT}`);
    console.log(`⏰ Simulated latency: 200-1200ms`);
    console.log(`📁 File uploads directory: ./uploads`);
});

module.exports = app;