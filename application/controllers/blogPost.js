const axios = require('axios');
const Blog = require('../models/BlogPost');

const API_URL = 'http://localhost:8080/api/blog-post';

// CREATE: Show form
exports.showNewBlogPost = async (req, res) => {
  res.render('blogPost/new', { title: 'New Blog Post' });
};

// CREATE: Handle form submission
exports.newBlogPost = async (req, res) => {
  try {
    const {
      title,
      content,
      author
    } = req.body;
    const blog = new Blog({
      title,
      content,
      author
    });
    await blog.save();
    res.status(201)
      .send(blog);
  } catch (err) {
    res.status(500)
      .send('Error creating blog post');
  }
};

// READ: List all blog posts
exports.showListBlogPost = async (req, res, next) => {
  axios.get(`${API_URL}`)
    .then((response) => {
      const posts = response.data;
      res.render('blogPost/index', {
        title: 'List of blog post',
        posts
      });
    })
    .catch((error) => {
      next(error);
    });
};

// READ: Handle list all blog posts
exports.listBlogPost = async (req, res) => {
  const blogs = await Blog.find()
    .sort({ createdAt: -1 });
  res.status(200)
    .send(blogs);
};

// READ: View a single blog post
exports.showBlogPost = async (req, res, next) => {
  const postId = req.params.id;

  axios.get(`${API_URL}/${postId}`)
    .then((response) => {
      const post = response.data;
      res.render('blogPost/show', {
        title: 'Get info of blog post',
        post
      });
    })
    .catch((error) => {
      next(error);
    });
};

// READ: View a single blog post
exports.getBlogPost = async (req, res, next) => {
  const blog = await Blog.findById(req.params.id);
  res.status(200)
    .send(blog);
};

// UPDATE: Show edit form
exports.showUpdateBlogPost = async (req, res, next) => {
  const postId = req.params.id;
  axios.get(`${API_URL}/${postId}`)
    .then((response) => {
      const post = response.data;
      res.render('blogPost/edit', {
        title: 'Update info of blog post',
        post
      });
    })
    .catch((error) => {
      next(error);
    });
};

// UPDATE: Handle updates
exports.updateBlogPost = async (req, res) => {
  const postId = req.params.id;
  console.log('Received CSRF Token:', req.headers['x-csrf-token']);
  try {
    const {
      title,
      content,
      author
    } = req.body;
    await Blog.findByIdAndUpdate(postId, {
      title,
      content,
      author
    });
    res.status(200)
      .send(`Post with ID ${postId} updated.`);
  } catch (err) {
    res.status(500)
      .send('Error updating blog post');
  }
};

exports.deleteBlogPost = async (req, res) => {
  const postId = req.params.id;
  try {
    await Blog.findByIdAndDelete(postId);
    console.log('postId: ', postId);
    res.status(200)
      .end();
  } catch (err) {
    res.status(500)
      .send('Error deleting blog post');
  }
};
